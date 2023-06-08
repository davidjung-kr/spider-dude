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
import std.datetime: Date, Clock;
import std.file:exists, remove, isFile;
import ddbc;
import com.davidjung.spider.parser;
import com.davidjung.spider.report;
import com.davidjung.spider.types;
import com.davidjung.spider.downloader;

class DataDump {
    private string pathName;
    private string connectUrl;
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

    /**
     * 한국거래소 가격데이터 추가
     * Params:
     *  baseYmd = 기준일
     *  mktId = 시장구분
     *  corpCd = 종목코드
     *  corpNm = 종목명
     *  cap = 시가총액
     *  shares = 상장주식수
     *  close = 종가
     */
    protected void insertKrxTable(string baseYmd, string mktId, string corpCd, string corpNm, ulong cap, ulong shares, uint close) {
        auto sysdate = Clock.currTime();
        Statement tx = con.createStatement();
        tx.executeUpdate(format(`INSERT INTO krx VALUES(
              '%s' -- baseYmd
            , '%s' -- mktId
            , '%s' -- corpCd
            , '%s' -- corpNm
            , %d   -- cap
            , %d   -- shares
            , %d   -- close
            , '%s' -- dumpYms
        )`, baseYmd, mktId, corpCd, corpNm, cap, shares, close, sysdate.toISOString()
        ));
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
    protected void insertBalanceStatementTable(int baseYear, string basePeriod, string reportType, string corpCd,
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

    /** 한국거래소 가격데이터 로드 */
    private void loadKrxData(Date baseYmd) {
        Downloader krx = new Downloader();
        OutBlock[string] krxPriceData = krx.getKrxCapAllByBlock(baseYmd);

        foreach(string corpCd ; krxPriceData.keys) {
            insertKrxTable(toYmd(baseYmd)
                , krxPriceData[corpCd].mktId
                , corpCd
                , krxPriceData[corpCd].name
                , krxPriceData[corpCd].marketCap
                , krxPriceData[corpCd].listShared
                , krxPriceData[corpCd].closePrice
            );
        }
    }

    /** 재무제표 데이터 로드 */
    private void loadBalanceStatementData(int baseYear, Period period, ReportType type) {
        Report bs = new Report();
		Parser sheet = new Parser(baseYear.to!string, period, type, StatementType.BS);
		sheet.read(bs);
        Bs[string] bsData = bs.getBalanceStatementAll();
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
    }
}

string toYmd(Date dt) {
    return format("%04d%02d%02d", dt.year(), dt.month(), dt.day());
}

unittest {
    DataDump client = new DataDump("unittest.sqlite");
    client.loadKrxData(Date(2023, 6, 8));
    client.loadBalanceStatementData(2023, Period.Q1, ReportType.CFS);
}

// 유틸리티 클래스
unittest {
    assert(toYmd(Date(2023, 1, 1)) == "20230101");
}