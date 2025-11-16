module spider.client.dart.model.report_file_url;

import std.string: format;

struct DartReportFileUrl {
    /** 기준연도 */
    public string ymd;
    /** 보고서파일구분 */
    public string reportFileType;
    /** N분기 */
    public string period;
    /** 식별일시 */
    public string idYMS;

    /** 
     * Factory
     * Params:
     *   ymd = 기준연도
     *   st = 보고서구분
     *   period = N분기
     *   idYMS = 식별일시
     * Returns: DartReportFileUrl
     */
    public static DartReportFileUrl parse(string ymd, string reportFileType, string period, string idYMS) {
        DartReportFileUrl o = DartReportFileUrl();
        o.ymd = ymd;
        o.reportFileType = reportFileType;
        o.period = period;
        o.idYMS = idYMS;
        return o;
    }

    /** 다운로드 URL 취득 */
    public string get() {
        return "https://opendart.fss.or.kr/cmm/downloadFnlttZip.do?fl_nm=%s_%s_%s_%s.zip"
            .format(
                this.ymd, this.period, this.reportFileType, this.idYMS
        );
    }

    /** Zip파일이름 취득 */
    public string getZipFileName() {
        return format("%s_%s_%s_%s.zip",
            this.ymd, this.period, this.reportFileType, this.idYMS);
    }
}