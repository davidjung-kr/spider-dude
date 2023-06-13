module com.davidjung.spider.downloader;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.stdio:File;
import std.conv:to;
import std.datetime.date;
import std.net.curl;
import std.string;
import std.algorithm;
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
     *
     * 한국거래소의 전종목 시세, 시가총액, 종가 등을 가져옵니다.
     *
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
     *
     * Params:
     *  date = 조회기준일
     *  rpt = 보고서
     */
    void readKrxCapAllByBlock(Date date, ref Report rpt) {
        rpt.blocks = getKrxCapAllByBlock(date);
        rpt.refreshCorpCode();
    }

    /**
     * 한국거래소 전종목 시세 정보 취득
     *
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

    /**
     * 한국거래소 전종목 시세 정보 저장
     *
     * 한국거래소 전종목 시세 정보를 파일로 저장 합니다.
     * 파일명은 `KRX_<입력받은_조회년월일>.dump` 입니다.
     * Params:
     *  date = 조회기준일
     * Returns: 조회된 종목 개수
     */
    ulong fetchKrxCapAll(Date date) {
        KrxCapRes res = getKrxCapAll(date);
        File f = File("KRX_"~date.toISOString()~".dump", "w");
        f.writeln(res.currentDatetime);
        foreach(block; res.blocks) {
            f.writeln(block);
        }
        f.close();
        return res.blocks.length;
    }


    public void getKofiaBondYield() {
        auto content = post("https://www.kofiabond.or.kr/proframeWeb/XMLSERVICES/", 
            `<?xml version="1.0" encoding="utf-8"?><message><proframeHeader>
    <pfmAppName>BIS-KOFIABOND</pfmAppName>
    <pfmSvcName>BISBndSrtPrcSrchSO</pfmSvcName>
    <pfmFnName>getHeadList</pfmFnName>
  </proframeHeader>
  <systemHeader></systemHeader>
    <BISBndSrtPrcDayDTO>
    <standardDt>20220401</standardDt>
    <applyGbCd>C02</applyGbCd>
</BISBndSrtPrcDayDTO>
</message>`
        );
    }
}

/** Dart 재무제표 공시 일괄데이터 다운로드 URL */
struct DartUrl {
    public string get(string year, Period p, StatementType st) {
        return format(
            "https://opendart.fss.or.kr/cmm/downloadFnlttZip.do?fl_nm=%s_%s_%s_20230516040109.zip"
            , year, GetCodeFrom.period(p), GetCodeFrom.statementType(st));
    }
}

/// 전종목시세 요청결과
struct KrxCapRes {
    /// 조회날짜
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    /// 종목별 거래정보
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
        return numbericToUlong(this.mktCap);
    }

    /// 고가
    @property uint highPrice() {
        return numbericToUint(this.tddHgprc);
    }

    /// 저가
    @property uint lowPrice() {
        return numbericToUint(this.tddLwprc);
    }

    /// 시가
    @property uint openPrice() {
        return numbericToUint(this.tddOpnprc);
    }

    /// 종가
    @property uint closePrice() {
        return numbericToUint(this.tddClsprc);
    }

    /// 유통주식수 = 상장 주식 수
    @property ulong listShared() {
        return numbericToUlong(this.listShrs);
    }

    /**
     * 숫자데이터 클랜징
     *
     * 0~9까지의 숫자만 차례대로 담어 문자열로 리턴 합니다.
     * 만약 파라메터 문자열에 숫자가 없을 경우 0으로 리턴 합니다.
     *
     * Params:
     *  numberic = 숫자가 포함된 어떤 문자열
     * Return: 0~9만 걸러내진 문자열
     */
    private string cleansingForNumeric(string numberic) {
        // string to char[] and filtering... ASCII로 변환해 0~9만 획득
        string result = numberic.dup.filter!(x => cast(int)x >= 48 && cast(int)x <= 57).to!string; 
        return result.length <= 0 ? "0":result;
    }

    /// 문자열을 숫자로
    private ulong numbericToUlong(string numberic) {
        return cleansingForNumeric(numberic).to!ulong;
    }

    /// 문자열을 숫자로
    private uint numbericToUint(string numberic) {
        return cleansingForNumeric(numberic).to!uint;
    }
}

/// 유닛테스트
unittest {
    // import std.stdio;
    // Downloader client = new Downloader();
    // Date dt = Date(2022, 03, 21);

    // KrxCapRes capInfo = client.getKrxCapAll(dt);
    // assert(capInfo.currentDatetime != "");
    // assert(capInfo.blocks[0].name != "");
    // assert(capInfo.blocks[0].listShared > 0);

    // immutable string kbFinanceCode = "105560"; // 종목코드: KB금융
    // OutBlock[string] capInfoByBlocks = client.getKrxCapAllByBlock(dt);
    // assert(capInfoByBlocks[kbFinanceCode].name == "KB금융");
    // assert(capInfoByBlocks[kbFinanceCode].closePrice == 57_400); // KB금융 종가: KRW 57,400

    // ulong stockCount = client.fetchKrxCapAll(dt);
    // assert(stockCount > 0);

    // OutBlock funcTestBlock = OutBlock();
    // string dirtyString = "AX#0(,Q@(*XNCNVDI#(";
    // assert("0" == funcTestBlock.cleansingForNumeric(dirtyString));
    // assert(0 == funcTestBlock.numbericToUlong(dirtyString));
    // assert(0 == funcTestBlock.numbericToUint(dirtyString));

    // client.getKofiaBondYield();
}