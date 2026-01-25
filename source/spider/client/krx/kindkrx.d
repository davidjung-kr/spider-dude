module spider.client.krx.kindkrx;

import std.regex: ctRegex;

private immutable RX = ctRegex!(`companysummary_open\('([\dA-z]{5,6})'\); return false;" title='([&;A-z가-힣0-9 ]+);`);

struct KindKrx {
    private static void parse(string html, int defaultSize=100) {
        // POST @ https://kind.krx.co.kr/corpgeneral/corpList.do
        matchFirst(html, RX);
    }
}