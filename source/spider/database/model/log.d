module spider.database.model.log;

import std.datetime: SysTime;

import spider.common.util.str: Str;
import spider.common.util.tick: Tick;
import spider.common.util.uuid: newUUID;

struct RowLog {
    public string txYMS;
    public string txNm;
    public int txSeq;
    public string txUUID;
    public string txCtnt;

    public static RowLog by(SysTime txYMS, string txNm, int txSeq, string txUUID, string txCtnt) {
        RowLog e = RowLog();
        e.txYMS = Str.ofTimestamp(txYMS);
        e.txNm = txNm;
        e.txSeq = txSeq;
        e.txUUID = txUUID;
        e.txCtnt = txCtnt;
        return e;
    }

    public static RowLog byNew(string txNm, string txCtnt) {
        return by(Tick.getKoreaYMS(), txNm, 100, newUUID(), txCtnt);
    }

    public RowLog byUpdate(string txCtnt) {
        RowLog af = this;
        af.txYMS = Str.ofTimestamp(Tick.getKoreaYMS());
        af.txSeq = 200;
        af.txCtnt = txCtnt;
        return af;
    }
}