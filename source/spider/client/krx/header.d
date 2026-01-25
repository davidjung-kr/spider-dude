module spider.client.krx.header;

import cURL = std.net.curl;

import spider.common.enums.header: UserAgent;

struct DataKrxHeader {
    public static cURL.HTTP ofBldAttendant(UserAgent ua = UserAgent.W64_10_MS_EDGE_144) {
        cURL.HTTP h = cURL.HTTP();
        h.addRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        h.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        h.addRequestHeader("Host", "data.krx.co.kr");
        h.addRequestHeader("Origin", "https://data.krx.co.kr");
        h.addRequestHeader("Referer",
            "https://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020101");
        h.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        h.addRequestHeader("User-Agent", ua);
        return h;
    }
    
    public static cURL.HTTP ofBldAttendantGz(UserAgent ua = UserAgent.W64_10_MS_EDGE_144) {
        cURL.HTTP h = cURL.HTTP("https://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd");
        h.method = cURL.HTTP.Method.post;
        h.addRequestHeader("Accept", "application/json, text/javascript, */*; q=0.01");
        h.addRequestHeader("Accept-Encoding", "gzip");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        h.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        h.addRequestHeader("Host", "data.krx.co.kr");
        h.addRequestHeader("Origin", "https://data.krx.co.kr");
        h.addRequestHeader("Referer",
            "https://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020101");
        h.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        h.addRequestHeader("User-Agent", ua);
        return h;
    }
}

struct KindKrxHeader {
    public static cURL.HTTP corpList(UserAgent ua = UserAgent.W64_10_MS_EDGE_144) {
        cURL.HTTP h = cURL.HTTP("https://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd");
        h.method = cURL.HTTP.Method.post;
        h.addRequestHeader("Accept", "text/html, */*; q=0.01");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7");
        h.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        h.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        h.addRequestHeader("Origin", "https://kind.krx.co.kr");
        h.addRequestHeader("Connection", "keep-alive");
        h.addRequestHeader("Referer", "https://kind.krx.co.kr/corpgeneral/corpList.do?method=loadInitPage");
        h.addRequestHeader("Sec-Fetch-Dest", "empty");
        h.addRequestHeader("Sec-Fetch-Mode", "cors");
        h.addRequestHeader("Sec-Fetch-Site", "same-origin");
        h.addRequestHeader("Priority", "u=0");
        h.addRequestHeader("TE", "trailers");
        h.addRequestHeader("User-Agent", ua);
        return h;
    }
}