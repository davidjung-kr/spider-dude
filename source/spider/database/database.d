module spider.database.database;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.string: format;
import std.conv:to;
import std.stdio:writef;
import std.datetime: Date, Clock, SysTime;
import std.file:exists, remove, isFile;

import spider.report;
import spider.importer.dart_file;
import spider.loader.report_loader;
import spider.client.dart.consts;
import spider.client.dart.enums.to;
import spider.client.dart.enums.period;
import spider.client.dart.enums.report_type;
import spider.client.dart.enums.accounts;
import spider.client.dart.enums.statement;
import spider.client.dart.model.bs;
import spider.client.dart.model.cis;
import spider.client.krx.datakrx;
import spider.client.krx.model.outblock;
import spider.database.model.row_krx;
import spider.database.model.row_dart;
import spider.database.sql.krx: SQL_TB_KRX;
import spider.database.sql.bs: SQL_TB_BS;

import ddbc;

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
        tx.executeUpdate(SQL_TB_KRX.CREATE_IF_NOT_EXISTS);
    }

    /** 재무제표 테이블 생성 */
    private void createNewBalanceStatementTable() {
        Statement tx = con.createStatement();
        tx.executeUpdate(SQL_TB_BS.CREATE_IF_NOT_EXISTS);
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
    private void insertKrxTable(RowKRX row) {
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
    private void insertComprehensiveIncomeStatementTable(RowDartCIS row) {
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
        OutBlock[string] krxPriceData = DataKrx.getKrxCapAllByBlock(baseYmd);
        auto getDt = Clock.currTime();
        beginTran();
        foreach(string corpCd ; krxPriceData.keys) {
            RowKRX row = RowKRX(Clock.currTime());
            row.baseYMD = toYmd(baseYmd);
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
		DartFileImporter sheet = new DartFileImporter(baseYear.to!string, period, type, StatementDART.BS);
		sheet.read(bs);
        DartBS[string] bsData = bs.getBalanceStatementAll();
        beginTran();
        foreach(string corpCd ; bsData.keys) {
            insertBalanceStatementTable(baseYear
                , EnumTo.period(period)
                , EnumTo.reportType(type)
                , corpCd

                , bsData[corpCd].getCurrentTerm(AccountIFRS.FULL_ASSETS)
                , bsData[corpCd].getCurrentTerm(AccountIFRS.FULL_CURRENTASSETS)
                , bsData[corpCd].getCurrentTerm(AccountIFRS.FULL_CASH_AND_CASH_EQUIVALENTS)
                , bsData[corpCd].getCurrentTerm(AccountIFRS.FULL_LIABILITIES)
                , bsData[corpCd].getCurrentTerm(AccountIFRS.FULL_CURRENT_LIABILITIES)
            );
        }
        endTran();
    }

    /** 포괄손익계산서 데이터 로드 */
    public void loadComprehensiveIncomeStatementData(int baseYear, Period period, ReportType type) {
        Report cis = new Report();
		DartFileImporter sheet = new DartFileImporter(baseYear.to!string, period, type, StatementDART.CIS);
		sheet.read(cis);
        DartCIS[string] csData = cis.getComprehensiveIncomeStatementAll();
        beginTran();
        foreach(string corpCd ; csData.keys) {
            RowDartCIS row = RowDartCIS(Clock.currTime());
            row.baseYear = baseYear.to!string;
            row.basePeriod = EnumTo.period(period);
            row.reportType = EnumTo.reportType(type);
            row.corpCd = corpCd;
            row.fullProfitloss = csData[corpCd].getCurrentTerm(EnumTo.ifrsCode(AccountIFRS.FULL_PROFITLOSS));
            row.fullProfitLossBeforeTax = csData[corpCd].getCurrentTerm(EnumTo.ifrsCode(AccountIFRS.FULL_PROFIT_LOSS_BEFORE_TAX));
            row.fullProfitLossAttributableToOwnersOfParent = csData[corpCd].getCurrentTerm(EnumTo.ifrsCode(AccountIFRS.FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT));
            row.operatingIncomeLoss = csData[corpCd].getCurrentTerm(EnumTo.dartCode(AccountDART.OPERATING_INCOME_LOSS));
            row.fullGrossProfit = csData[corpCd].getCurrentTerm(EnumTo.ifrsCode(AccountIFRS.FULL_GROSSPROFIT));
            insertComprehensiveIncomeStatementTable(row);
        }
        endTran();
    }
}

string toYmd(Date dt) {
    return format("%04d%02d%02d", dt.year(), dt.month(), dt.day());
}

unittest {
    // DataDump client = new DataDump("unittest.sqlite");
    // client.loadKrxData(Date(2023, 6, 16));
    
    // client.loadBalanceStatementData(2022, Period.Q1, ReportType.CFS);
    // client.loadBalanceStatementData(2022, Period.Q1, ReportType.OFS);
    // client.loadComprehensiveIncomeStatementData(2022, Period.Q1, ReportType.CFS);
    // client.loadComprehensiveIncomeStatementData(2022, Period.Q1, ReportType.OFS);
    // client.loadBalanceStatementData(2022, Period.Q4, ReportType.CFS);
    // client.loadBalanceStatementData(2022, Period.Q4, ReportType.OFS);
    // client.loadComprehensiveIncomeStatementData(2022, Period.Q4, ReportType.CFS);
    // client.loadComprehensiveIncomeStatementData(2022, Period.Q4, ReportType.OFS);

    // client.loadBalanceStatementData(2023, Period.Q1, ReportType.CFS);
    // client.loadBalanceStatementData(2023, Period.Q1, ReportType.OFS);
    // client.loadComprehensiveIncomeStatementData(2023, Period.Q1, ReportType.CFS);
    // client.loadComprehensiveIncomeStatementData(2023, Period.Q1, ReportType.OFS);
}

// 유틸리티 클래스
unittest {
    //assert(toYmd(Date(2023, 1, 1)) == "20230101");
}