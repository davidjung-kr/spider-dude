module spider.client.naver.stocknaver;

import std.conv: to;
import std.string: format;
import std.datetime.date: Date;
import cURL = std.net.curl;

import spider.common.util.str: Str;
import spider.client.naver.header: StockNaverHeader;
import spider.client.naver.model: StockNaverResponse, StockNaverCandleItem;

import asdf: deserialize;

struct StockNaver {
    /** 
     * 한국시장 주가 취득
     * Params:
     *   corpCd = 종목코드
     *   stDate = 조회시작일
     *   edDate = 조회종료일
     * Returns: StockNaverCandleItem[]
     */
    public static StockNaverCandleItem[] getDayFromKR(string corpCd, Date stDate, Date edDate) {
        string jsonText = curlGetDomestic(corpCd, stDate, edDate);
        StockNaverResponse response = parse(jsonText);
        return response.list;
    }

    /** 
     * 호치민주식거래소 주가
     * Params:
     *   ticker = 종목코드
     *   stDate = 조회시작일
     *   edDate = 조회종료일
     * Returns: StockNaverCandleItem[]
     */
    public static StockNaverCandleItem[] getDayFromHsxVN(string ticker, Date stDate, Date edDate) {
        string jsonText = curlGetForeign(format("%s.HM", ticker), stDate, edDate);
        StockNaverResponse response = parse(jsonText);
        return response.list;
    }

    /** 
     * 하노이주식거래소 주가
     * Params:
     *   ticker = 종목코드
     *   stDate = 조회시작일
     *   edDate = 조회종료일
     * Returns: StockNaverCandleItem[]
     */
    public static StockNaverCandleItem[] getDayFromHnxVN(string ticker, Date stDate, Date edDate) {
        string jsonText = curlGetForeign(format("%s.HN", ticker), stDate, edDate);
        StockNaverResponse response = parse(jsonText);
        return response.list;
    }

    /** 국내주식 주가 GET 요청 */
    private static string curlGetDomestic(string corpCd, Date stDate, Date edDate) {
        string targetUrl = format(
            "https://api.stock.naver.com/chart/domestic/item/%s/day?startDateTime=%s0000&endDateTime=%s0000",
                corpCd, Str.toYMD(stDate), Str.toYMD(edDate));
        cURL.HTTP header = StockNaverHeader.day(corpCd, true);
        auto content = cURL.get(targetUrl, header);
        return content.to!string;
    }

    /** 해외주식 주가 GET 요청 */
    private static string curlGetForeign(string corpCd, Date stDate, Date edDate) {
        string targetUrl = format(
            "https://api.stock.naver.com/chart/foreign/item/%s/day?startDateTime=%s0000&endDateTime=%s0000",
                corpCd, Str.toYMD(stDate), Str.toYMD(edDate));
        cURL.HTTP header = StockNaverHeader.day(corpCd, false);
        auto content = cURL.get(targetUrl, header);
        return content.to!string;
    }

    /** JSON 파싱 */
    private static StockNaverResponse parse(string jsonText) {
        if ('['==jsonText.dup[0]) {
            jsonText = format(`{"list":%s}`, jsonText);
        }
        return jsonText.deserialize!StockNaverResponse;
    }
}

// unittest {
//     string orinonCorpCd = "271560";
//     Date stDt271560 = Date(2025, 1, 1);
//     Date edDt271560 = Date(2025, 12, 31);
//     StockNaverCandleItem[] candles271560 = StockNaver.getDayFromKR(orinonCorpCd, stDt271560, edDt271560);
//     assert(candles271560.length==16, candles271560.length.to!string);

//     string dsnCorpCd = "DSN";
//     Date stDtDSN = Date(2026, 1, 1);
//     Date edDtDSN = Date(2026, 1, 24);
//     StockNaverCandleItem[] candlesDSN = StockNaver.getDayFromHsxVN(dsnCorpCd, stDtDSN, edDtDSN);
//     assert(candlesDSN.length==15, candlesDSN.length.to!string);
// }

unittest {
    import std.stdio;
    import std.array: appender;
    File f271560 = File("testdata/stocknaver_day_271560.json", "r");
    scope(exit) f271560.close();
    auto apF271560 = appender!string;
    while(!f271560.eof()) {
        apF271560.put(f271560.readln());
    }
    assert(StockNaver.parse(apF271560.data).list.length==16);
}

unittest {
    import std.stdio;
    import std.array: appender;
    File fDSN_HM = File("testdata/stocknaver_day_DSN.HM.json", "r");
    scope(exit) fDSN_HM.close();
    auto apFDSN_HM = appender!string;
    while(!fDSN_HM.eof()) {
        apFDSN_HM.put(fDSN_HM.readln());
    }
    StockNaverResponse res = StockNaver.parse(apFDSN_HM.data);
    assert(res.list.length==15, res.list.length.to!string);
}