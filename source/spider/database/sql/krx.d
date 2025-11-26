module spider.database.sql.krx;

import std.format: format;

import spider.database.model.row_krx: RowKRX;

enum SQL_TB_KRX {
    /// 생성문
    CREATE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS krx (
    baseYMD CHAR(8) NOT NULL
,   mktId CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL
,   corpNm CHAR(15) NOT NULL
,   cap BIGINT NOT NULL DEFAULT 0
,   shares INT NOT NULL DEFAULT 0
,   close INT NOT NULL DEFAULT 0
,   dumpYMS DATETIME NOT NULL

,   PRIMARY KEY (baseYMD, mktId, corpCd)
)`,

    INSERT = `
INSERT INTO krx (
    baseYMD,
    mktId,
    corpCd,
    corpNm,
    cap,
    shares,
    close,
    dumpYMS
) VALUES (
    '%s',
    '%s',
    '%s',
    '%s',
    %d,
    %d,
    %d,
    '%s'
)`
}

struct KRXSQL {
    public static string ofInsert(RowKRX row) {
        return format(SQL_TB_KRX.INSERT,
            row.baseYMD,
            row.mktId,
            row.corpCd,
            row.corpNm,
            row.marketCap,
            row.shares,
            row.close,
            row.dumpYMS
        );
    }
}