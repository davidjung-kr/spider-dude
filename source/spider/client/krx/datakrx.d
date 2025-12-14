module spider.client.krx.datakrx;

import std.string: format;
import std.stdio: File;
import std.conv: to;
import std.datetime.date: Date;
import std.zlib;
import cURL = std.net.curl;

import spider.common.enums.path: Path;
import spider.common.util.mkdir: Mkdir;
import spider.client.krx.enums.mktid: MktId;
import spider.client.krx.header: DataKrxHeader;
import spider.client.krx.model;

import asdf: deserialize;

struct DataKrx {
    /**
     * 한국거래소 전종목 시세 정보 취득
     *
     * 한국거래소의 전종목 시세, 시가총액, 종가 등을 가져옵니다.
     *
     * Params:
     *  date = 조회기준일
     * Returns: 전종목 시세정보 [KrxBldAttendantResponse]
     */
    public static KrxBldAttendantResponse getBldAttendant(Date date, MktId mktId = MktId.ALL) {
        cURL.HTTP header = DataKrxHeader.ofBldAttendant();
        auto content = cURL.post("https://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd", [
            "bld":"dbms/MDC/STAT/standard/MDCSTAT01501",
            "mktId":mktId,
            "locale":"ko_KR",
            "trdDd":date.toISOString(),
            "share":"1",
            "money":"1",
            "csvxls_isNo":"false",
        ], header);
        string jsonText = content.to!string;
        return jsonText.deserialize!KrxBldAttendantResponse;
    }

    /**
     * 한국거래소 전종목 시세 정보 취득
     *
     * Params:
     *  date = 조회기준일
     * Returns: 종목코드 기준 시세정보 [OutBlock[string]]
     */
    public static OutBlock[string] getKrxCapAllByBlock(Date date) {
        OutBlock[string] result;
        KrxBldAttendantResponse res = getBldAttendant(date);
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
    public static ulong getBldAttendantAndFetchToFile(Date date) {
        KrxBldAttendantResponse res = getBldAttendant(date);
        Mkdir.byDotPath(Path.KRX_DATA_WITH_DOT);
        File f = File(
            Path.KRX_DATA_WITH_DOT~"/KRX"~date.toISOString()~"_"~res.getCurDT().toISOString()~".outblocks", "w");
        scope(exit) f.close();
        f.writeln(res.currentDatetime);
        foreach(block; res.blocks) {
            f.writeln(block);
        }
        return res.blocks.length;
    }
}

unittest {
    //DataKrx.getKrxCapAll(Date(2025, 11, 21));
    //DataKrx.getBldAttendant(Date(2025, 11, 21));
}

//     public void getKofiaBondYield() {
//         auto content = post("https://www.kofiabond.or.kr/proframeWeb/XMLSERVICES/", 
//             `<?xml version="1.0" encoding="utf-8"?><message><proframeHeader>
//     <pfmAppName>BIS-KOFIABOND</pfmAppName>
//     <pfmSvcName>BISBndSrtPrcSrchSO</pfmSvcName>
//     <pfmFnName>getHeadList</pfmFnName>
//   </proframeHeader>
//   <systemHeader></systemHeader>
//     <BISBndSrtPrcDayDTO>
//     <standardDt>20220401</standardDt>
//     <applyGbCd>C02</applyGbCd>
// </BISBndSrtPrcDayDTO>
// </message>`
//         );
//     }