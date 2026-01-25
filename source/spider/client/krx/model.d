module spider.client.krx.model;

import std.datetime: DateTime;

import spider.common.util.str: Str;

import asdf: serdeKeys, Asdf;

/// 전종목시세 요청결과
struct KrxBldAttendantResponse {
    /// 조회날짜
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    /// 종목별 거래정보
    @serdeKeys("OutBlock_1") OutBlock[] blocks;

    /// 조회날짜 취득 By DateTime
    public DateTime getCurDT() {
        return DateTime.fromISOString(Str.toKrxCurDtToISOString(currentDatetime));
    }

    /// 조회날짜 취득 By String
    public string getStrOfCurDT() {
        return Str.toKrxCurDtToISOString(currentDatetime);
    }
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
        return Str.numbericToUlong(this.mktCap);
    }

    /// 고가
    @property uint highPrice() {
        return Str.numbericToUint(this.tddHgprc);
    }

    /// 저가
    @property uint lowPrice() {
        return Str.numbericToUint(this.tddLwprc);
    }

    /// 시가
    @property uint openPrice() {
        return Str.numbericToUint(this.tddOpnprc);
    }

    /// 종가
    @property uint closePrice() {
        return Str.numbericToUint(this.tddClsprc);
    }

    /// 유통주식수 = 상장 주식 수
    @property ulong listShared() {
        return Str.numbericToUlong(this.listShrs);
    }
}

struct KindCorpListRequest {
    private string method = "searchCorpList";
    private string comAbbrv = "";
    private string beginIndex = "";
    private string orderStat= "D";
    private string isurCd = "";
    private string repIsuSrtCd = "";
    private string searchCodeType = "";
    private string industry = "";
    private string comAbbrvTmp = "";
    public int pageIndex = 1;
    public int currentPageSize = 15;
    public string orderMode = 3;
    public string marketType= "stockMkt";
    public int searchType = 13;
    public string fiscalYearEnd = "all";
    public string location = "all";

    public static toStr() {
        return format(`method=%s&pageIndex=%d&currentPageSize=%d&comAbbrv=%s&beginIndex=%s&orderMode=%d&orderStat=%s&isurCd=%s&repIsuSrtCd=%s&searchCodeType=%s&marketType=%s&searchType=%d&industry=%s&fiscalYearEnd=%s&comAbbrvTmp=%s&location=%s`, // @suppress(dscanner.style.long_line)
            method,
            pageIndex,
            currentPageSize,
            comAbbrv,
            beginIndex,
            orderMode,
            orderStat,
            isurCd,
            repIsuSrtCd,
            searchCodeType,
            marketType,
            searchType,
            industry,
            fiscalYearEnd,
            comAbbrvTmp,
            location
        );
    }
}