module spider.database.sql.dart;

enum SQL_TB_BS {
    /// 생성문
    CREATE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS bs (
    baseYear CHAR(4) NOT NULL
,   rptType  CHAR(3) NOT NULL
,   period   CHAR(2) NOT NULL
,   corpCd   CHAR(6) NOT NULL

,   fAsst INT NOT NULL DEFAULT 0 -- fullAssets
,   fCurAsst INT NOT NULL DEFAULT 0 -- fullCurrentAssets
,   fCash INT NOT NULL DEFAULT 0 -- fullCashAndCashEquivalents
,   fLibl INT NOT NULL DEFAULT 0 -- fullLiabilities
,   fCurLibl INT NOT NULL DEFAULT 0 -- fullCurrentLiabilities

,   dumpYMS TIMESTAMP NOT NULL

,   PRIMARY KEY (baseYear, rptType, period, corpCd)
)`,

    CREATE_INDEX_PK_IF_NOT_EXISTS = `
CREATE INDEX IF NOT EXISTS bs_idx_pk ON bs (baseYear, rptType, period, corpCd);`,

    INSERT = `
INSERT INTO bs VALUES(
    '%s' -- baseYear
,   UPPER('%s') -- rptType
,   '%s' -- period
,   '%s' -- corpCd

,   %d   -- fullAssets
,   %d   -- fullCurrentAssets
,   %d   -- fullCashAndCashEquivalents
,   %d   -- fullLiabilities
,   %d   -- fullCurrentLiabilities
,   '%s' -- dumpYMS
)`
}

enum SQL_TB_SI {
    CREATE_TABLE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS si (
    baseYear CHAR(4) NOT NULL
,   rptType  CHAR(3) NOT NULL -- CFS/OFS
,   period   CHAR(2) NOT NULL
,   sciYN    CHAR(1) NOT NULL -- SCI(포괄손익)/CSI(손익)
,   corpCd   CHAR(6) NOT NULL

,   fPflss     INT NOT NULL DEFAULT 0 -- FULL_PROFITLOSS
,   fPrftBfTax INT NOT NULL DEFAULT 0 -- FULL_PROFIT_LOSS_BEFORE_TAX
,   fPrft2Own  INT NOT NULL DEFAULT 0 -- FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT
,   oprtIcmLss INT NOT NULL DEFAULT 0 -- OPERATING_INCOME_LOSS
,   fGrft      INT NOT NULL DEFAULT 0 -- FULL_GROSSPROFIT

,   dumpYMS    DATETIME NOT NULL

,   PRIMARY KEY (baseYear, rptType, period, sciYN, corpCd)
)`,

    CREATE_INDEX_PK = `CREATE INDEX IF NOT EXISTS si_idx_pk ON si (baseYear, rptType, period, sciYN, corpCd);`,

    INSERT = `INSERT INTO si (
    baseYear,
    rptType,
    period,
    sciYN,
    corpCd,
    fPflss,
    fPrftBfTax,
    fPrft2Own,
    oprtIcmLss,
    fGrft,
    dumpYMS
) VALUES (
    '%s',
    '%s',
    '%s',
    '%s',
    '%s',
    %d,
    %d,
    %d,
    %d,
    %d,
    '%s'
)`
}