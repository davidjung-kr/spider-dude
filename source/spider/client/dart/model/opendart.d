module spider.client.dart.model.opendart;

import spider.client.dart.enums.report_file_type: ReportFileType;
import spider.client.dart.enums.period: Period;

struct DownloadResult {
    public string ymd;
    public ReportFileType reportFileType = ReportFileType.NONE;
    public Period period = Period.NONE;
    public bool doneYN = false;
    public string zipFilePath;

    this(string ymd,
        ReportFileType reportFileType,
        Period period,
        bool doneYN=false,
        string zipFilePath=""
    ) {
        this.reportFileType = reportFileType;
        this.period = period;
        this.doneYN = doneYN;
        this.zipFilePath = zipFilePath;
    }
}