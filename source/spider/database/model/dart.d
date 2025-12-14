module spider.database.model.dart;

import std.string: format;
import std.datetime: SysTime;

import spider.client.dart.enums.report: ReportType, Period;
import spider.common.util.str: Str;

struct RowDartBS {
    public string baseYear;
    public string rptType;
    public string period;
    public string corpCd;

    /// fullAssets
    public long fAsst; 
    /// fullCurrentAssets
    public long fCurAsst; 
    /// fullCashAndCashEquivalents
    public long fCash; 
    /// fullLiabilities
    public long fLibl; 
    /// fullCurrentLiabilities
    public long fCurLibl; 

    public string dumpYMS;

    /** 
     * 
     * Params:
     *   baseYear = 기준년도
     *   rptType = 보고서유형
     *   period = 분기
     *   corpCd = 종목코드
     *   fPflss = 
     *   fPrftBfTax = 
     *   fPrft2Own = 
     *   oprtIcmLss = 
     *   fGrft = 
     *   dumpYMS = 
     * Returns: 
     */
    public static RowDartBS by(
        string baseYear,
        ReportType rptType,
        Period period,
        string corpCd,
        long fAsst,
        long fCurAsst,
        long fCash,
        long fLibl,
        long fCurLibl,
        SysTime dumpYMS
    ) {
        RowDartBS e = RowDartBS();
        e.baseYear = baseYear;
        e.rptType = rptType;
        e.period = period;
        e.corpCd = corpCd;
        e.fAsst = fAsst;
        e.fCurAsst = fCurAsst;
        e.fCash = fCash;
        e.fLibl = fLibl;
        e.fCurLibl = fCurLibl;
        e.dumpYMS = Str.ofTimestamp(dumpYMS);
        return e;
    }
}

struct RowDartSI {
    public string baseYear;
    public string rptType;
    public string period;
    /// 포괄손익계산서 여부
    private char _sciYN;
    public string corpCd;

    /// Setter 포괄손익계산서 여부
    @property
    public void sciYN(bool sciYN) {
        this._sciYN = sciYN ? '1':'0';
    }

    /// Getter 포괄손익계산서 여부
    @property
    public char sciYN() {
        return this._sciYN;
    }

    /// FULL_PROFITLOSS
    public long fPflss;
    /// FULL_PROFIT_LOSS_BEFORE_TAX
    public long fPrftBfTax;
    /// FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT
    public long fPrft2Own ;
    /// OPERATING_INCOME_LOSS
    public long oprtIcmLss;
    /// FULL_GROSSPROFIT
    public long fGrft;

    public string dumpYMS;

    /** 
     * 
     * Params:
     *   baseYear = 기준년도
     *   rptType = 보고서유형
     *   period = 분기
     *   sciYN = 포괄손익계산서여부
     *   corpCd = 종목코드
     *   fPflss = 
     *   fPrftBfTax = 
     *   fPrft2Own = 
     *   oprtIcmLss = 
     *   fGrft = 
     *   dumpYMS = 
     * Returns: RowDartSI
     */
    public static RowDartSI by(
        string baseYear,
        ReportType rptType,
        Period period,
        bool sciYN,
        string corpCd,
        long fPflss,
        long fPrftBfTax,
        long fPrft2Own, 
        long oprtIcmLss,
        long fGrft,
        SysTime dumpYMS
    ) {
        RowDartSI e = RowDartSI();
        e.baseYear = baseYear;
        e.rptType = rptType;
        e.period = period;
        e.sciYN = sciYN;
        e.corpCd = corpCd;
        e.fPflss = fPflss;
        e.fPrftBfTax = fPrftBfTax;
        e.fPrft2Own = fPrft2Own;
        e.oprtIcmLss = oprtIcmLss;
        e.fGrft = fGrft;
        e.dumpYMS = Str.ofTimestamp(dumpYMS);
        return e;
    }

}