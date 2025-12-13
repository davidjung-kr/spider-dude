module spider.database.model.krx;

struct RowKRX {
    public string baseYMD;
    public string mktID;
    public string corpCd;
    public string corpNm;
    public long cap;
    public long shares;
    public long open;
    public long high;
    public long low;
    public long close;
    public string dumpYMS;

    public static RowKRX by(
        string baseYMD,
        string mktID,
        string corpCd,
        string corpNm,
        long cap,
        long shares,
        long open,
        long high,
        long low,
        long close,
        string dumpYMS
    ) {
        RowKRX row = RowKRX();
        row.baseYMD = baseYMD;
        row.mktID = mktID;
        row.corpCd = corpCd;
        row.corpNm = corpNm;
        row.cap = cap;
        row.shares = shares;
        row.open = open;
        row.high = high;
        row.low = low;
        row.close = close;
        row.dumpYMS = dumpYMS;
        return row;
    }
}