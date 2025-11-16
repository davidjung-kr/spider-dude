module spider.client.krx.data_krx;

import std.conv: to;
import curl = std.net.curl; //std.net.curl.download;
import std.stdio: File;
import std.datetime.date: Date;

import spider.client.krx.model.bld_attendant;
import spider.client.krx.model.outblock;

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
    public static KrxBldAttendantResponse getKrxCapAll(Date date) {
        curl.HTTP hh = curl.HTTP("https://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd");
        hh.addRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        hh.addRequestHeader("Accept", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        hh.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        hh.addRequestHeader("Host", "data.krx.co.kr");
        hh.addRequestHeader("Origin", "https://data.krx.co.kr");
        hh.addRequestHeader("Referer", "https://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020101");
        hh.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        auto content = curl.post("https://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd", [
            "bld":"dbms/MDC/STAT/standard/MDCSTAT01501",
            "mktId":"ALL",
            "locale":"ko_KR",
            "trdDd":date.toISOString(),
            "share":"1",
            "money":"1",
            "csvxls_isNo":"false",
        ], hh);
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
        KrxBldAttendantResponse res = getKrxCapAll(date);
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
    public static ulong fetchKrxCapAll(Date date) {
        KrxBldAttendantResponse res = getKrxCapAll(date);
        File f = File("KRX_"~date.toISOString()~".dump", "w");
        f.writeln(res.currentDatetime);
        foreach(block; res.blocks) {
            f.writeln(block);
        }
        f.close();
        return res.blocks.length;
    }
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