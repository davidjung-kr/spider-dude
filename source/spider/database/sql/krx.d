module spider.database.sql.krx;

import std.format: format;

import spider.database.model.krx: RowKRX;

enum SQL_TB_KRX {
    /// 생성문
    CREATE_TABLE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS krx (
    baseYMD CHAR(8) NOT NULL
,   mktID CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL
,   corpNm CHAR(15) NOT NULL
,   cap BIGINT NOT NULL DEFAULT 0
,   shares INT NOT NULL DEFAULT 0
,   open INT NOT NULL DEFAULT 0
,   high INT NOT NULL DEFAULT 0
,   low INT NOT NULL DEFAULT 0
,   close INT NOT NULL DEFAULT 0
,   dumpYMS DATETIME NOT NULL

,   PRIMARY KEY (baseYMD, mktID, corpCd)
)`,

    CREATE_INDEX_PK = `
CREATE INDEX IF NOT EXISTS krx_idx_pk ON krx (baseYMD, mktID, corpCd);`,

    INSERT = `
INSERT INTO krx (
    baseYMD,
    mktId,
    corpCd,
    corpNm,
    cap,
    shares,
    open,
    high,
    low,
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
    %d,
    %d,
    %d,
    '%s'
)`,

   SELECT_EXIST_BY_BASEYMD = `
SELECT CASE WHEN COUNT(baseYMD) > 0 THEN 1 ELSE 0 END AS existYN
FROM krx WHERE baseYMD='%s' GROUP BY baseYMD`
}