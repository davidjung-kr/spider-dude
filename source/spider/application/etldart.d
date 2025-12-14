module spider.application.etldart;

import std.stdio: writef;
import std.conv: to;

import spider.application.parent: IApplicationContext, ETLApplicateObject;
import spider.client.dart.model.reportinfo: ReportInfo;
import spider.client.dart.opendart: OpenDart;
import spider.client.dart.model.opendart: ReportFileUrl, ReportFileDownloadResult;
import spider.database.table.object: SQLite3TableObject;
import spider.database.table.dart: TableDartBS, TableDartSI;

class ETLOpenDartApplication : ETLApplicateObject {
    private ETLOpenDartApplicationContext context;
    this(ETLOpenDartApplicationContext context) {
        super("ETLOpenDartApplication");
        this.context = context;
    }

    public override void main() {
        foreach(ReportFileUrl url; OpenDart.getUrls()) {
            ReportFileDownloadResult result = OpenDart.downloadByUrl(url);
            if (false==result.doneYN) {
                writef("\tDownload Fail : [%s]\n", to!string(result));
                continue;
            }
            writef("\tDownload Sucess: [%s] and unzip ... ", to!string(result));
            OpenDart.unzip(result, true);
            writef("DONE!\n");
        }
    }
}

class ETLOpenDartApplicationContext : IApplicationContext {
    private TableDartBS tbDartBS;
    private TableDartSI tbDartSI;
    private ReportInfo[] inqReportInfo;
    private int sleepMsecs;

    /** 
     * 생성자
     * Params:
     *  tbDartBS = 다트 재무제표 테이블
     *  tbDartSI = 다트 포괄손익계산서 테이블
     *  inqReportInfo = 조회할 재무제표 정보
     *  sleepMsecs = 슬립시간
     */
    this(TableDartBS tbDartBS, TableDartSI tbDartSI,
        ReportInfo[] inqReportInfo, int sleepMsecs=3000) {
        this.tbDartBS = tbDartBS;
        this.tbDartSI = tbDartSI;
        this.inqReportInfo = inqReportInfo;
        this.sleepMsecs = sleepMsecs;
    }

    public SQLite3TableObject getTable(SQLite3TableObject tbo) {
        if (is(typeof(tbo)==TableDartBS)) {
            return this.tbDartBS;
        } else if (is(typeof(tbo)==TableDartSI)) {
            return this.tbDartSI;
        } else {
            throw new Exception("Wrong type");
        }
        return null;
    }

    public ReportInfo[] getInquiryReportInfo() {
        return this.inqReportInfo;
    }
    
    public int getSleepMsecs() {
        return this.sleepMsecs;
    }
}