module com.davidjung.spider.downloader;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv:to;
import std.datetime.date;
import std.net.curl;
import std.string;
import asdf;
import com.davidjung.spider.report;
import com.davidjung.spider.types;

/** 
 * 외부 데이터 다운로더 :: 한국거래소, DART공시 사이트 연계
 * 
 * 메서드를 호출할 때 마다 네트워크 접속과 문자열 파싱을 시도하므로,
 * 여러번 호출할 경우 리소스를 많이 사용할 수 있습니다.
 * 가능하면 요청 결과 값을 저장해 사용합니다.
 */
class Downloader {
    /**
     * 한국거래소 전종목 시세 정보 취득
     * Params:
     *  date = 조회기준일
     * Returns: 전종목 시세정보 [KrxCapRes]
     */
    public KrxCapRes getKrxCapAll(Date date) {
        auto content = post("http://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd", [
            "bld":"dbms/MDC/STAT/standard/MDCSTAT01501",
            "mktId":"ALL",
            "locale":"ko_KR",
            "trdDd":date.toISOString(),
            "share":"1",
            "money":"1",
            "csvxls_isNo":"false",
        ]);
        string jsonText = content.to!string;
        return jsonText.deserialize!KrxCapRes;
    }

    /**
     * 한국거래소 전종목 시세 정보 적재
     * Params:
     *  date = 조회기준일
     *  rpt = 보고서
     */
    void readKrxCapAllByBlock(Date date, ref Report rpt) {
        rpt.blocks = getKrxCapAllByBlock(date);
    }

    /**
     * 한국거래소 전종목 시세 정보 취득
     * Params:
     *  date = 조회기준일
     * Returns: 종목코드 기준 시세정보 [OutBlock[string]]
     */
    OutBlock[string] getKrxCapAllByBlock(Date date) {
        OutBlock[string] result;
        KrxCapRes res = getKrxCapAll(date);
        foreach(b; res.blocks) {
            result[b.isuSrtCd] = b;
        }
        return result;
    }
}

struct DartUrl {
    private string baseUrl = "https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do#download_";
    private string[string] urlMap;
    private string key;

    this(string year, Period p, StatementType st) {
        this.key = year~GetCodeFrom.period(p)~GetCodeFrom.statementType(st);
        this.urlMap["20211QBS"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_BS";
        this.urlMap["20211QIS"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_PL";
        this.urlMap["20211QCF"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CF";
        this.urlMap["20211QSCE"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CE";
        this.urlMap["20212QBS"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_BS";
        this.urlMap["20212QIS"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_PL";
        this.urlMap["20212QCF"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CF";
        this.urlMap["20212QSCE"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CE";

    }

    public bool have() { 
        if(this.key in this.urlMap)
            return true;
        else
            return false;
    }

    string get() {
        return this.baseUrl ~ this.urlMap[this.key];
    }
}

/// 전종목시세 요청결과
struct KrxCapRes {
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    @serdeKeys("OutBlock_1") OutBlock[] blocks;
}

struct OutBlock {
    /// 거래대금 [Numberic String]
    @serdeKeys("ACC_TRDVAL") string accTrdval;
    /// 거래량 [Numberic String]
    @serdeKeys("ACC_TRDVOL") string accTrdvol;
    /// 대비 [Numberic String] 
    @serdeKeys("CMPPREVDD_PRC") string cmpprevddPrc;
    /// 등락률 [Floating String]
    @serdeKeys("FLUC_RT") string flucRt;
    /// ???
    @serdeKeys("FLUC_TP_CD") string flucTpCd;
    /// 종목명 [String]
    @serdeKeys("ISU_ABBRV") string name;
    /// 종목코드 [String]
    @serdeKeys("ISU_SRT_CD") string isuSrtCd;
    /// 상장주식수 [Numberic String]
    @serdeKeys("LIST_SHRS") string listShrs;
    /// 시가총액 [Numberic String]
    @serdeKeys("MKTCAP") string mktCap;
    /// 시장구분ID [String]
    @serdeKeys("MKT_ID") string mktId;
    /// 시장구분명 [String]
    @serdeKeys("MKT_NM") string mktNm;
    /// 소속부명 [String]
    @serdeKeys("SECT_TP_NM") string sectTpNm;
    /// 종가 [Numberic String]
    @serdeKeys("TDD_CLSPRC") string tddClsprc; 
    /// 고가 [Numberic String]
    @serdeKeys("TDD_HGPRC") string tddHgprc;
    /// 저가 [Numberic String]
    @serdeKeys("TDD_LWPRC") string tddLwprc;
    /// 시가 [Numberic String]
    @serdeKeys("TDD_OPNPRC") string tddOpnprc;

    /// 시가총액
    @property ulong marketCap() {
        return this.mktCap.replace(",", "").to!ulong;
    }

    /// 종가
    @property uint closePrice() {
        return this.tddClsprc.replace(",", "").to!uint;
    }

    /// 유통주식수
    @property ulong listShared() {
        return this.listShrs.replace(",", "").to!long;
    }
}

/// 유닛테스트
unittest {
    import std.stdio;
    Downloader client = new Downloader();
    Date dt = Date(2022, 03, 21);

    KrxCapRes capInfo = client.getKrxCapAll(dt);
    assert(capInfo.currentDatetime != "");
    assert(capInfo.blocks[0].name != "");
    assert(capInfo.blocks[0].listShared > 0);

    immutable string kbFinanceCode = "105560"; // 종목코드: KB금융
    OutBlock[string] capInfoByBlocks = client.getKrxCapAllByBlock(dt);
    assert(capInfoByBlocks[kbFinanceCode].name == "KB금융");
    assert(capInfoByBlocks[kbFinanceCode].closePrice == 57_400); // KB금융 종가: KRW 57,400
}