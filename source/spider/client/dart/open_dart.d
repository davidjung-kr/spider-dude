module spider.client.dart.open_dart;

import std.file: read, remove;
import std.array: appender;
import curl = std.net.curl;
import std.conv: to;
import std.regex: regex, matchAll, RegexMatch;
import std.zip: ZipArchive;
import std.windows.charset;

import spider.common.enums.path: Path;
import spider.common.util.mkdir: Mkdir;
import spider.common.util.korean: CP949;
import spider.client.dart.enums.to;
import spider.client.dart.enums.period;
import spider.client.dart.enums.report_file_type;
import spider.client.dart.model.opendart: DownloadResult;
import spider.client.dart.model.report_file_url;
import spider.client.dart.consts: DART_FILE_URL, DART_FILE_URL_RX;
import spider.client.dart.header;


/**
 * opendart 클라이언트
 * See_Also: https://opendart.fss.or.kr
 */
class OpenDart {
    private static string getHTML() {
        return curl.post(
            DART_FILE_URL, ["":""],
            OpenDartHeader.ofFnlttDwldMain()
        ).to!string;
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
    public static DownloadResult download(string ymd, ReportFileType reportFileType, Period period) {
        DownloadResult result = DownloadResult(ymd, reportFileType, period);
        
        string _reportFileType = EnumTo.reportFileType(reportFileType);
        string _period = EnumTo.period(period);
        Mkdir.dartdata();
        foreach(DartReportFileUrl url ; getUrls()) {
            if (url.ymd==ymd && url.reportFileType==_reportFileType && url.period==_period) {
                result.zipFilePath = Path.DART_DATA_WITH_DOT~"/"~url.getZipFileName();
                curl.download(
                    url.get(),
                    result.zipFilePath,
                    OpenDartHeader.ofDownloadFnlttZip());
                result.doneYN = true;
                return result;
            }
        }
        result.doneYN = false;
        return result;
    }

    public static void unzip(DownloadResult input, bool rmZipFile=false) {
        auto zip = new ZipArchive(read(input.zipFilePath));
        import std.stdio: writefln, File;
        foreach (name, meber; zip.directory) {
            //writefln("%10s  %08x  %s", meber.expandedSize, meber.crc32, name);
            //assert(meber.expandedData.length == 0);
            
            string nameUTF8 = CP949.conv(cast(const(ubyte)[])name);
            zip.expand(meber);
            string bodyUTF8 = CP949.conv(meber.expandedData);

            File f = File(Path.DART_DATA_WITH_DOT~"/"~nameUTF8, "wb");
            scope(exit) f.close();
            f.rawWrite(bodyUTF8);
        }
        if (rmZipFile) {
            remove(input.zipFilePath);
        }
    }
}

unittest {
    //Dart.getUrls();
    //OpenDart.download("2024", ReportFileType.BS, Period.Q1);

    DownloadResult result;
    result.ymd = "2024";
    result.reportFileType = ReportFileType.BS;
    result.period = Period.Q1;
    result.zipFilePath = Path.DART_DATA_WITH_DOT~"/2024_1Q_BS_20250221162310.zip";
    result.doneYN = true;

    OpenDart.unzip(result, true);
}