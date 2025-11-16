module spider.client.dart.open_dart;

import std.array: appender;
import curl = std.net.curl;
import std.conv: to;
import std.regex: regex, matchAll, RegexMatch;

import spider.client.dart.enums.to;
import spider.client.dart.enums.period;
import spider.client.dart.enums.report_file_type;
import spider.client.dart.model.report_file_url;
import spider.client.dart.consts: DART_FILE_URL, DART_FILE_URL_RX;

class OpenDart {
    private static string getHTML() {
        curl.HTTP h = curl.HTTP();
        h.addRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
        h.addRequestHeader("Accept", "text/html, */*; q=0.01");
        h.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        h.addRequestHeader("X-Requested-With", "XMLHttpRequest");
        h.addRequestHeader("Origin", "https://opendart.fss.or.kr");
        h.addRequestHeader("Referer", "https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do");
        h.addRequestHeader("Sec-Fetch-Dest", "empty");
        h.addRequestHeader("Sec-Fetch-Mode", "cors");
        h.addRequestHeader("Sec-Fetch-Site", "same-origin");
        h.addRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0");
        return curl.post(DART_FILE_URL, ["":""], h).to!string;
    }

    public static DartReportFileUrl[] getUrls() {
        string html = getHTML();
        auto rsult = matchAll(html, DART_FILE_URL_RX);
        if (rsult.empty) {
            return new DartReportFileUrl[0];
        }

        DartReportFileUrl[] x;
        auto arr = appender(x);
        arr.reserve(256);

        while(!rsult.empty) {
            arr.put(DartReportFileUrl.parse(rsult.front[1], rsult.front[3], rsult.front[2], rsult.front[4]));
            rsult.popFront();
        }
        return arr.data();
    }

    /** 
     * 파일 다운로드
     * Params:
     *   ymd = 기준일자
     *   reportFileType = 보고서파일종류
     *   period = N분기
     */
    public static bool download(string ymd, ReportFileType reportFileType, Period period) {
        curl.HTTP h = curl.HTTP();
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
        h.addRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:145.0) Gecko/20100101 Firefox/145.0");
        string _reportFileType = EnumTo.reportFileType(reportFileType);
        string _period = EnumTo.period(period);
        foreach(DartReportFileUrl url ; getUrls()) {
            if (url.ymd==ymd && url.reportFileType==_reportFileType && url.period==_period) {
                curl.download(url.get(), "./dartdata/"~url.getZipFileName(), h);
                return true;
            }
        }
        return false;
    }
}

unittest {
    //Dart.getUrls();
    OpenDart.download("2024", ReportFileType.BS, Period.Q1);
}