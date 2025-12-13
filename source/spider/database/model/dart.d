module spider.database.model.dart;


import std.string: format;
import std.datetime: SysTime;

import spider.client.dart.enums.report: ReportType;
import spider.common.util.str: Str;

struct RowDartBS {
    public string baseYear;
    public string basePeriod;
    public string reportType;
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

    public static RowDartBS by(
        string baseYear,
        string basePeriod,
        ReportType reportType,
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
        e.basePeriod = basePeriod;
        e.reportType = reportType;
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


struct RowDartCIS {
    public string baseYear;
    public string basePeriod;
    public string reportType;
    public string corpCd;

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

    public static RowDartCIS by(
        string baseYear,
        string basePeriod,
        ReportType reportType,
        string corpCd,
        long fPflss,
        long fPrftBfTax,
        long fPrft2Own, 
        long oprtIcmLss,
        long fGrft,
        SysTime dumpYMS
    ) {
        RowDartCIS e = RowDartCIS();
        e.baseYear = baseYear;
        e.basePeriod = basePeriod;
        e.reportType = reportType;
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