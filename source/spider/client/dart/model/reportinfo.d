module spider.client.dart.model.reportinfo;

import spider.client.dart.enums.report;

struct ReportInfo {
    private int year;
    private ReportFileType fileType;
    private ReportType reportType;
    private Period period;

    public int getYear() { return this.year; }
    public ReportFileType getFileType() { return this.fileType; }
    public ReportType getReportType() { return this.reportType; }
    public Period getPeriod() { return this.period; }
    
    /** 
     * 생성자
     * Params:
     *   year = 연도
     *   reportType = 연결/개별
     *   fileType = 보고서유형(BS, CS)
     *   period = 분기
     */
    this(int year, ReportType reportType, ReportFileType fileType, Period period) {
        this.year = year;
        this.reportType = reportType;
        this.fileType = fileType;
        this.period = period;
    }
}