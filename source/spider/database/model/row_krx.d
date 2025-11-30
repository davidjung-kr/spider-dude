module spider.database.model.row_krx;

import std.string: format;
import std.datetime: Clock, SysTime;

import spider.client.krx.model.outblock: OutBlock;

/** 한국거래소 가격데이터 행 */
struct RowKRX {
    /** 기준년월일 */
    public string baseYMD;
    /** 시장구분 */
    public string mktId;
    /** 종목코드 */
    public string corpCd;
    /** 종목명 */
    public string corpNm;
    /** 시가총액 */
    public ulong marketCap;
    /** 상장주식수 */
    public ulong shares;
    /** 시가 */
    public uint open;
    /** 고가 */
    public uint high;
    /** 저가 */
    public uint low;
    /** 종가 */
    public uint close;
    /** 처리년월일 */
    public string dumpYMS;

    public static RowKRX from(string baseYMD, OutBlock block) {
        RowKRX e  = RowKRX();
        e.baseYMD = baseYMD;
        e.mktId = block.mktId;
        e.corpCd = block.isuSrtCd;
        e.corpNm = block.name;
        e.marketCap = block.marketCap();
        e.shares = block.listShared();
        e.open = block.openPrice;
        e.high = block.highPrice;
        e.low = block.lowPrice;
        e.close = block.closePrice;
        e.dumpYMS = Clock.currTime().toISOString();
        return e;
    }
}