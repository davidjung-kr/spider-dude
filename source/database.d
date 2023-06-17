module com.davidjung.spider.database;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.format;
import std.conv:to;
import std.stdio:writef;
import std.datetime: Date, Clock, SysTime;
import std.file:exists, remove, isFile;
import ddbc;
import com.davidjung.spider.parser;
import com.davidjung.spider.report;
import com.davidjung.spider.types;
import com.davidjung.spider.downloader;

/** 한국거래소 가격데이터 행 */
struct RowKrx {
    /** 기준년월일 */
    string baseYmd;
    /** 시장구분 */
    string mktId;
    /** 종목코드 */
    string corpCd;
    /** 종목명 */
    string corpNm;
    /** 시가총액 */
    ulong marketCap;
    /** 상장주식수 */
    ulong shares;
    /** 종가 */
    uint close;
    /** 처리년월일 */
    string dumpYms = "";
    
    this(SysTime sysdate) {
        this.dumpYms = sysdate.toISOString();
    }

    /** 
     * 행 문자열 취득
     *  baseYmd = 기준년월일
     *  mktId = 시장구분
     *  corpCd = 종목코드
     *  corpNm = 종목명
     *  marketCap = 시가총액
     *  shares = 상장주식수
     *  close = 종가
     */
    public string str() {
        return format("'%s', '%s', '%s', '%s', %d, %d, %d, '%s'",
            baseYmd, mktId, corpCd, corpNm, marketCap, shares, close, dumpYms);
    }
}


/** 포괄손익계산서 행 */
struct RowCis {
    /** 사업연도 */
    string baseYear;
    /** 보고서 분기 */
    string basePeriod;
    /** 보고서 유형 (연결/개별) */
    string reportType;
    /** 종목코드 */
    string corpCd;
    /** 당기순이익 */
    long fullProfitloss;
    /** 법인세차감전순이익 */
	long fullProfitLossBeforeTax;
    /** 지배기업 소유주지분 순이익 */
	long fullProfitLossAttributableToOwnersOfParent;
    /** 영업이익 */
	long operatingIncomeLoss;
    /** 매출총이익 */
	long fullGrossProfit;
    /** 처리년월일 */
    string dumpYms = "";
    
    this(SysTime sysdate) {
        this.dumpYms = sysdate.toISOString();
    }

    /** 
     * 행 문자열 취득
     *  baseYear = 사업연도
     *  basePeriod = 보고서 분기
     *  reportType = 보고서 유형 (연결/개별)
     *  corpCd = 종목코드
     *  fullProfitloss = 당기순이익
     *  fullProfitLossBeforeTax = 법인세차감전순이익
     *  fullProfitLossAttributableToOwnersOfParent = 지배기업 소유주지분 순이익
     *  operatingIncomeLoss = 영업이익
     *  fullGrossProfit = 매출총이익
     *  dumpYms = 처리년월일
     */
    public string str() {
        return format("'%s', '%s', '%s', '%s', %d, %d, %d, %d, %d, '%s'",
            baseYear, basePeriod, reportType, corpCd,
            fullProfitloss, fullProfitLossBeforeTax, fullProfitLossAttributableToOwnersOfParent,
            operatingIncomeLoss, fullGrossProfit,
            dumpYms);
    }
}




class DataDump {
    /** DB file path */
    private string pathName;
    /** DB connect url */
    private string connectUrl;
    /** DB session */
    private Connection con;

    this(string pathName) {
        this.pathName = pathName;
        this.connectUrl =  format("sqlite:%s", this.pathName);

        // 중복파일이면 지운다
        if( exists(this.pathName) && isFile(this.pathName) ) {
            remove(this.pathName);
        }

        // 커넥션 생성
        con = createConnection(this.connectUrl);
        //scope(exit) con.close();

        createNewKrxTable();
        createNewBalanceStatementTable();
        createNewComprehensiveIncomeStatementTable();
    }

    /** 한국거래소 가격테이블 생성 */
    private void createNewKrxTable() {
        Statement tx = con.createStatement();
        tx.executeUpdate(`CREATE TABLE krx (
              baseYmd CHAR(8) NOT NULL
            , mktId CHAR(3) NOT NULL
            , corpCd CHAR(6) NOT NULL
            , corpNm CHAR(15) NOT NULL
            , cap BIGINT NOT NULL DEFAULT 0
            , shares INT NOT NULL DEFAULT 0
            , close INT NOT NULL DEFAULT 0
            , dumpYms DATETIME NOT NULL

            , PRIMARY KEY (baseYmd, mktId, corpCd)
        )`);
    }

    /** 재무제표 테이블 생성 */
    private void createNewBalanceStatementTable() {
        Statement tx = con.createStatement();
        tx.executeUpdate(`CREATE TABLE bs (
              baseYear CHAR(4) NOT NULL
            , basePeriod CHAR(2) NOT NULL
            , reportType CHAR(3) NOT NULL
            , corpCd CHAR(6) NOT NULL

            , fullAssets INT NOT NULL DEFAULT 0
            , fullCurrentAssets INT NOT NULL DEFAULT 0
            , fullCashAndCashEquivalents INT NOT NULL DEFAULT 0
            , fullLiabilities INT NOT NULL DEFAULT 0
            , fullCurrentLiabilities INT NOT NULL DEFAULT 0

            , dumpYms DATETIME NOT NULL

            , PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
        )`);
    }

    /** 포괄손익계산서 테이블 생성 */
    private void createNewComprehensiveIncomeStatementTable() {
        Statement tx = con.createStatement();
        tx.executeUpdate(`CREATE TABLE cis (
              baseYear CHAR(4) NOT NULL
            , basePeriod CHAR(2) NOT NULL
            , reportType CHAR(3) NOT NULL
            , corpCd CHAR(6) NOT NULL

            , fullProfitloss INT NOT NULL DEFAULT 0
            , fullProfitLossBeforeTax INT NOT NULL DEFAULT 0
            , fullProfitLossAttributableToOwnersOfParent INT NOT NULL DEFAULT 0
            , operatingIncomeLoss INT NOT NULL DEFAULT 0
            , fullGrossProfit INT NOT NULL DEFAULT 0

            , dumpYms DATETIME NOT NULL

            , PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
        )`);
    }

    /** 한국거래소 가격데이터 추가 */
    private void insertKrxTable(RowKrx row) {
        Statement tx = con.createStatement();
        tx.executeUpdate(
            format(`INSERT INTO krx VALUES(%s)`, row.str() ));
    }

    /**
     * 재무제표 데이터 추가
     * Params:
     *  baseYear = 사업연도
     *  basePeriod = 보고서 분기
     *  reportType = 보고서 유형 (연결/개별)
     *  corpCd = 종목코드
     *  fullAssets = 총자산
     *  fullCurrentAssets = 유동자산
     *  fullCashAndCashEquivalents = 현금성자산
     *  fullLiabilities = 총부채
     *  fullCurrentLiabilities = 유동부채
     */
    private void insertBalanceStatementTable(int baseYear, string basePeriod, string reportType, string corpCd,
        ulong fullAssets, ulong fullCurrentAssets, ulong fullCashAndCashEquivalents,
        ulong fullLiabilities, ulong fullCurrentLiabilities) {

        auto sysdate = Clock.currTime();
        Statement tx = con.createStatement();
        tx.executeUpdate(format(`INSERT INTO bs VALUES(
              '%s' -- baseYear
            , '%s' -- basePeriod
            , UPPER('%s') -- reportType
            , '%s' -- corpCd

            , %d   -- fullAssets
            , %d   -- fullCurrentAssets
            , %d   -- fullCashAndCashEquivalents
            , %d   -- fullLiabilities
            , %d   -- fullCurrentLiabilities

            , '%s' -- dumpYms
        )`,
              baseYear.to!string
            , basePeriod.to!string
            , reportType
            , corpCd

            , fullAssets
            , fullCurrentAssets
            , fullCashAndCashEquivalents
            , fullLiabilities
            , fullCurrentLiabilities 
            
            , sysdate.toISOString()
        ));
    }

    /** 포괄손익계산서 데이터 추가 */
    private void insertComprehensiveIncomeStatementTable(RowCis row) {
        Statement tx = con.createStatement();
        tx.executeUpdate(format(`INSERT INTO cis VALUES(%s)`, row.str() ));
    }
    
    private void beginTran() {
        Statement tx = con.createStatement();
        tx.executeUpdate("BEGIN TRANSACTION");
    }

    private void endTran() {
        Statement tx = con.createStatement();
        tx.executeUpdate("END TRANSACTION");
    }

    /** 한국거래소 가격데이터 로드 */
    public void loadKrxData(Date baseYmd) {
        auto stDt = Clock.currTime();
        Downloader krx = new Downloader();
        OutBlock[string] krxPriceData = krx.getKrxCapAllByBlock(baseYmd);
        auto getDt = Clock.currTime();
        beginTran();
        foreach(string corpCd ; krxPriceData.keys) {
            RowKrx row = RowKrx(Clock.currTime());
            row.baseYmd = toYmd(baseYmd);
            row.corpCd = corpCd;
            row.mktId = krxPriceData[corpCd].mktId;
            row.corpNm = krxPriceData[corpCd].name;
            row.marketCap = krxPriceData[corpCd].marketCap;
            row.shares = krxPriceData[corpCd].listShared;
            row.close = krxPriceData[corpCd].closePrice;
            insertKrxTable(row);
        }
        endTran();
        auto edDt = Clock.currTime();
        debug  {
            writef("loadKrxData :: [%s] Start\n",
                stDt.toSimpleString());
            writef("loadKrxData :: [%s] KRX get (%s sec)\n",
                getDt.toSimpleString(), (getDt - stDt));
            writef("loadKrxData :: [%s] End (%s sec)\n",
                edDt.toSimpleString(), (edDt - getDt));
        }
    }

    /** 재무제표 데이터 로드 */
    public void loadBalanceStatementData(int baseYear, Period period, ReportType type) {
        Report bs = new Report();
		Parser sheet = new Parser(baseYear.to!string, period, type, StatementType.BS);
		sheet.read(bs);
        Bs[string] bsData = bs.getBalanceStatementAll();
        beginTran();
        foreach(string corpCd ; bsData.keys) {
            insertBalanceStatementTable(baseYear
                , GetCodeFrom.period(period)
                , GetCodeFrom.reportType(type)
                , corpCd

                , bsData[corpCd].getCurrentTerm(IfrsCode.FULL_ASSETS)
                , bsData[corpCd].getCurrentTerm(IfrsCode.FULL_CURRENTASSETS)
                , bsData[corpCd].getCurrentTerm(IfrsCode.FULL_CASH_AND_CASH_EQUIVALENTS)
                , bsData[corpCd].getCurrentTerm(IfrsCode.FULL_LIABILITIES)
                , bsData[corpCd].getCurrentTerm(IfrsCode.FULL_CURRENT_LIABILITIES)
            );
        }
        endTran();
    }

    /** 포괄손익계산서 데이터 로드 */
    public void loadComprehensiveIncomeStatementData(int baseYear, Period period, ReportType type) {
        Report cis = new Report();
		Parser sheet = new Parser(baseYear.to!string, period, type, StatementType.CIS);
		sheet.read(cis);
        Cis[string] csData = cis.getComprehensiveIncomeStatementAll();
        beginTran();
        foreach(string corpCd ; csData.keys) {
            RowCis row = RowCis(Clock.currTime());
            row.baseYear = baseYear.to!string;
            row.basePeriod = GetCodeFrom.period(period);
            row.reportType = GetCodeFrom.reportType(type);
            row.corpCd = corpCd;
            row.fullProfitloss = csData[corpCd].getCurrentTerm(GetCodeFrom.ifrsCode(IfrsCode.FULL_PROFITLOSS));
            row.fullProfitLossBeforeTax = csData[corpCd].getCurrentTerm(GetCodeFrom.ifrsCode(IfrsCode.FULL_PROFIT_LOSS_BEFORE_TAX));
            row.fullProfitLossAttributableToOwnersOfParent = csData[corpCd].getCurrentTerm(GetCodeFrom.ifrsCode(IfrsCode.FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT));
            row.operatingIncomeLoss = csData[corpCd].getCurrentTerm(GetCodeFrom.dartCode(DartCode.OPERATING_INCOME_LOSS));
            row.fullGrossProfit = csData[corpCd].getCurrentTerm(GetCodeFrom.ifrsCode(IfrsCode.FULL_GROSSPROFIT));
            insertComprehensiveIncomeStatementTable(row);
        }
        endTran();
    }
}

string toYmd(Date dt) {
    return format("%04d%02d%02d", dt.year(), dt.month(), dt.day());
}

unittest {
    DataDump client = new DataDump("unittest.sqlite");
    client.loadKrxData(Date(2023, 6, 16));
    
    client.loadBalanceStatementData(2022, Period.Q1, ReportType.CFS);
    client.loadBalanceStatementData(2022, Period.Q1, ReportType.OFS);
    client.loadComprehensiveIncomeStatementData(2022, Period.Q1, ReportType.CFS);
    client.loadComprehensiveIncomeStatementData(2022, Period.Q1, ReportType.OFS);
    client.loadBalanceStatementData(2022, Period.Q4, ReportType.CFS);
    client.loadBalanceStatementData(2022, Period.Q4, ReportType.OFS);
    client.loadComprehensiveIncomeStatementData(2022, Period.Q4, ReportType.CFS);
    client.loadComprehensiveIncomeStatementData(2022, Period.Q4, ReportType.OFS);

    client.loadBalanceStatementData(2023, Period.Q1, ReportType.CFS);
    client.loadBalanceStatementData(2023, Period.Q1, ReportType.OFS);
    client.loadComprehensiveIncomeStatementData(2023, Period.Q1, ReportType.CFS);
    client.loadComprehensiveIncomeStatementData(2023, Period.Q1, ReportType.OFS);
}

// 유틸리티 클래스
unittest {
    assert(toYmd(Date(2023, 1, 1)) == "20230101");
}