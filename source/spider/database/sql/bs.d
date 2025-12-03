module spider.database.sql.bs;

import std.string: format;

import spider.database.model.dart: RowDartBS;

enum SQL_TB_BS {
    /// 생성문
    CREATE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS bs (
    baseYear CHAR(4) NOT NULL
,   basePeriod CHAR(2) NOT NULL
,   reportType CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL

,   fAsst INT NOT NULL DEFAULT 0 -- fullAssets
,   fCurAsst INT NOT NULL DEFAULT 0 -- fullCurrentAssets
,   fCash INT NOT NULL DEFAULT 0 -- fullCashAndCashEquivalents
,   fLibl INT NOT NULL DEFAULT 0 -- fullLiabilities
,   fCurLibl INT NOT NULL DEFAULT 0 -- fullCurrentLiabilities

,   dumpYMS TIMESTAMP NOT NULL

,   PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
)`,

    CREATE_INDEX_PK_IF_NOT_EXISTS = `
CREATE INDEX IF NOT EXISTS bs_idx_pk ON krx (baseYear, basePeriod, reportType, corpCd);`,

    INSERT = `
INSERT INTO bs VALUES(
    '%s' -- baseYear
,   '%s' -- basePeriod
,   UPPER('%s') -- reportType
,   '%s' -- corpCd
,   %d   -- fullAssets
,   %d   -- fullCurrentAssets
,   %d   -- fullCashAndCashEquivalents
,   %d   -- fullLiabilities
,   %d   -- fullCurrentLiabilities
,   '%s' -- dumpYMS
)`
}

struct SQLMapperBS {
    public static string ofInsert(RowDartBS row) {
        return format(SQL_TB_BS.CREATE_INDEX_PK_IF_NOT_EXISTS,
            row.baseYear,
            row.basePeriod,
            row.reportType,
            row.corpCd,
            row.fAsst,
            row.fCurAsst,
            row.fCash,
            row.fLibl,
            row.fCurLibl,
            row.dumpYMS
        );
    }
}