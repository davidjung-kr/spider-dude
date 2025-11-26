module spider.database.sql.bs;

enum SQL_TB_BS {
    /// 생성문
    CREATE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS bs (
    baseYear CHAR(4) NOT NULL
,   basePeriod CHAR(2) NOT NULL
,   reportType CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL

,   fullAssets INT NOT NULL DEFAULT 0
,   fullCurrentAssets INT NOT NULL DEFAULT 0
,   fullCashAndCashEquivalents INT NOT NULL DEFAULT 0
,   fullLiabilities INT NOT NULL DEFAULT 0
,   fullCurrentLiabilities INT NOT NULL DEFAULT 0

,   dumpYms DATETIME NOT NULL

,   PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
)`
}