module spider.database.model.row_krx;

import std.string: format;
import std.datetime: SysTime;

/** 한국거래소 가격데이터 행 */
struct RowKRX {
    /** 기준년월일 */
    string baseYmd;
    /** 시장구분 */
    string mktId;
    /** 종목코드 */
    string corpCd;
    /** 종목명 */
    string corpNm;
    /** 시가총액 */
    ulong marketCap;
    /** 상장주식수 */
    ulong shares;
    /** 종가 */
    uint close;
    /** 처리년월일 */
    string dumpYms = "";
    
    this(SysTime sysdate) {
        this.dumpYms = sysdate.toISOString();
    }

    /** 
     * 행 문자열 취득
     *  baseYmd = 기준년월일
     *  mktId = 시장구분
     *  corpCd = 종목코드
     *  corpNm = 종목명
     *  marketCap = 시가총액
     *  shares = 상장주식수
     *  close = 종가
     */
    public string str() {
        return format("'%s', '%s', '%s', '%s', %d, %d, %d, '%s'",
            baseYmd, mktId, corpCd, corpNm, marketCap, shares, close, dumpYms);
    }
}