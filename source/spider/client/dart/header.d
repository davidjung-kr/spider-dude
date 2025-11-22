module spider.client.dart.header;

import cURL = std.net.curl;

import spider.common.enums.header: UserAgent;

struct OpenDartHeader {
    /**See_Also: https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do */
    public static cURL.HTTP ofFnlttDwldMain(UserAgent ua = UserAgent.W64_10_MS_EDGE) {
        cURL.HTTP h = cURL.HTTP();
        h.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        h.addRequestHeader("Accept", "text/html, */*; q=0.01");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        h.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        h.addRequestHeader("Origin", "https://opendart.fss.or.kr");
        h.addRequestHeader("Referer", "https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do");
        h.addRequestHeader("Sec-Fetch-Dest", "empty");
        h.addRequestHeader("Sec-Fetch-Mode", "cors");
        h.addRequestHeader("Sec-Fetch-Site", "same-origin");
        h.addRequestHeader("User-Agent", ua);
        return h;
    }

    public static cURL.HTTP ofDownloadFnlttZip(UserAgent ua = UserAgent.W64_10_MS_EDGE) {
        cURL.HTTP h = cURL.HTTP();
        h.addRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        h.addRequestHeader("Connection", "keep-alive");
        h.addRequestHeader("Host", "opendart.fss.or.kr");
        h.addRequestHeader("Priority", "u=0, i");
        h.addRequestHeader("Referer", "https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do");
        h.addRequestHeader("Sec-Fetch-Dest", "document");
        h.addRequestHeader("Sec-Fetch-Mode", "navigate");
        h.addRequestHeader("Sec-Fetch-Site", "same-origin");
        h.addRequestHeader("Sec-Fetch-User", "?1");
        h.addRequestHeader("Upgrade-Insecure-Requests", "1");
        h.addRequestHeader("User-Agent", ua);
        return h;
    }
}