module spider.database.sql.log;

import std.string: format;

import spider.database.model.row_log: RowLog;

enum SQL_TB_LOG {
    /// 생성문
    CREATE_TABLE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS log (
    id INTEGER PRIMARY KEY AUTOINCREMENT
,   txYMS TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
,   txNm CHAR(32) NOT NULL
,   txSeq INT NOT NULL
,   txUUID CHAR(32) NOT NULL
,   txCtnt TEXT NOT NULL DEFAULT ''
)`,

    CREATE_INDEX_PK = `
CREATE INDEX IF NOT EXISTS log_idx_pk ON log (id);`,

    CREATE_INDEX_1 = `
CREATE INDEX IF NOT EXISTS log_idx_1 ON log (txYMS, txNm);`,

    CREATE_INDEX_2 = `
CREATE INDEX IF NOT EXISTS log_idx_2 ON log (txYMS, txUUID);`,

    INSERT = `INSERT INTO log (txYMS, txNm, txSeq, txUUID, txCtnt) VALUES('%s', '%s', %d, '%s', '%s')`
}

struct SQLMapperLog {
    public static string ofInsert(RowLog row) {
        return format(SQL_TB_LOG.INSERT,
            row.txYMS, row.txNm, row.txSeq, row.txUUID, row.txCtnt
        );
    }
}