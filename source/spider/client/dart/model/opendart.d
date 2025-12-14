module spider.client.dart.model.opendart;

import std.string: format;

import spider.client.dart.enums.to: ParseAs;
import spider.client.dart.enums.report: ReportFileType, Period;

/** 
 * dart 보고서파일 다운로드 URL
 */
struct ReportFileUrl {
    /** 기준연도 */
    public string ymd;
    /** 보고서파일구분 */
    public ReportFileType rptFileType;
    /** N분기 */
    public Period period;
    /** 식별일시 */
    public string idYMS;

    /** 
     * Factory
     * Params:
     *   ymd = 기준연도
     *   rptFileType = 보고서구분
     *   period = N분기
     *   idYMS = 식별일시
     * Returns: ReportFileUrl
     */
    public static ReportFileUrl parse(string ymd, string rptFileType, string period, string idYMS) {
        ReportFileUrl o = ReportFileUrl();
        o.ymd = ymd;
        o.rptFileType = ParseAs.reportFileType(rptFileType);
        o.period = ParseAs.period(period);
        o.idYMS = idYMS;
        return o;
    }

    /** 다운로드 URL 취득 */
    public string get() {
        return "https://opendart.fss.or.kr/cmm/downloadFnlttZip.do?fl_nm=%s_%s_%s_%s.zip"
            .format(
                this.ymd, this.period, this.rptFileType, this.idYMS
        );
    }

    /** Zip파일이름 취득 */
    public string getZipFileName() {
        return format("%s_%s_%s_%s.zip",
            this.ymd, this.period, this.rptFileType, this.idYMS
        );
    }
}

/** 
 * 보고서 파일다운로드 결과
 * Params:
 *   ymd = 
 *   rptFileType = 
 *   period = 
 *   false = 
 */
struct ReportFileDownloadResult {
    public string ymd;
    public ReportFileType rptFileType = ReportFileType.NONE;
    public Period period = Period.NONE;
    public bool doneYN = false;
    public string zipFilePath;

    /** 
     * 생성자
     * Params:
     *   ymd = 연도
     *   rptFileType = 보고서파일유형
     *   period = 분기
     */
    this(string ymd,
        ReportFileType rptFileType,
        Period period,
        bool doneYN=false,
        string zipFilePath=""
    ) {
        this.rptFileType = rptFileType;
        this.period = period;
        this.doneYN = doneYN;
        this.zipFilePath = zipFilePath;
    }
}