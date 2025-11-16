module spider.database.model.row_dart;

import std.string: format;
import std.datetime: SysTime;

/** 포괄손익계산서 행 */
struct RowDartCIS {
    /** 사업연도 */
    string baseYear;
    /** 보고서 분기 */
    string basePeriod;
    /** 보고서 유형 (연결/개별) */
    string reportType;
    /** 종목코드 */
    string corpCd;
    /** 당기순이익 */
    long fullProfitloss;
    /** 법인세차감전순이익 */
	long fullProfitLossBeforeTax;
    /** 지배기업 소유주지분 순이익 */
	long fullProfitLossAttributableToOwnersOfParent;
    /** 영업이익 */
	long operatingIncomeLoss;
    /** 매출총이익 */
	long fullGrossProfit;
    /** 처리년월일 */
    string dumpYms = "";
    
    this(SysTime sysdate) {
        this.dumpYms = sysdate.toISOString();
    }

    /** 
     * 행 문자열 취득
     *  baseYear = 사업연도
     *  basePeriod = 보고서 분기
     *  reportType = 보고서 유형 (연결/개별)
     *  corpCd = 종목코드
     *  fullProfitloss = 당기순이익
     *  fullProfitLossBeforeTax = 법인세차감전순이익
     *  fullProfitLossAttributableToOwnersOfParent = 지배기업 소유주지분 순이익
     *  operatingIncomeLoss = 영업이익
     *  fullGrossProfit = 매출총이익
     *  dumpYms = 처리년월일
     */
    public string str() {
        return format("'%s', '%s', '%s', '%s', %d, %d, %d, %d, %d, '%s'",
            baseYear, basePeriod, reportType, corpCd,
            fullProfitloss, fullProfitLossBeforeTax, fullProfitLossAttributableToOwnersOfParent,
            operatingIncomeLoss, fullGrossProfit,
            dumpYms);
    }
}