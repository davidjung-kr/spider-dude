module spider.database.model.row_krx;

import std.string: format;
import std.datetime: SysTime;

/** 한국거래소 가격데이터 행 */
struct RowKRX {
    /** 기준년월일 */
    string baseYMD;
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
    string dumpYMS = "";
    
    this(SysTime sysdate) {
        this.dumpYMS = sysdate.toISOString();
    }

    /** 
     * 행 문자열 취득
     *  baseYMD = 기준년월일
     *  mktId = 시장구분
     *  corpCd = 종목코드
     *  corpNm = 종목명
     *  marketCap = 시가총액
     *  shares = 상장주식수
     *  close = 종가
     */
    public string str() {
        return format("'%s', '%s', '%s', '%s', %d, %d, %d, '%s'",
            baseYMD, mktId, corpCd, corpNm, marketCap, shares, close, dumpYMS);
    }
}