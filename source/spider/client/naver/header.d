module spider.client.naver.header;

import std.string: format;
import cURL = std.net.curl;

import spider.common.enums.header: UserAgent;

struct StockNaverHeader {
    public static cURL.HTTP day(string corpCd, bool domesticYN, UserAgent ua = UserAgent.W64_10_MS_EDGE_144) {
        cURL.HTTP h = cURL.HTTP();
        h.addRequestHeader("Accept", "*/*");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7");
        h.addRequestHeader("Origin", "https://m.stock.naver.com");
        h.addRequestHeader("Connection", "keep-alive");
        h.addRequestHeader("Sec-Fetch-Dest", "empty");
        h.addRequestHeader("Sec-Fetch-Mode", "cors");
        h.addRequestHeader("Sec-Fetch-Site", "same-site");
        h.addRequestHeader("TE", "trailers");
        h.addRequestHeader("User-Agent", ua);
        h.addRequestHeader("Referer", format("https://m.stock.naver.com/fchart/%s/stock/%s",
            domesticYN ? "domestic":"foreign", corpCd));
        return h;
    }
}