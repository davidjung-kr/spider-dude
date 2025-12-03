module spider.database.sql.cis;

enum SQL_TB_CIS {
    CREATE_TABLE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS cis (
    baseYear CHAR(4) NOT NULL
,   basePeriod CHAR(2) NOT NULL
,   reportType CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL

,   fPflss INT NOT NULL DEFAULT 0 -- FULL_PROFITLOSS
,   fPrftBfTax INT NOT NULL DEFAULT 0 -- FULL_PROFIT_LOSS_BEFORE_TAX
,   fPrft2Own INT NOT NULL DEFAULT 0 -- FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT
,   oprtIcmLss INT NOT NULL DEFAULT 0 -- OPERATING_INCOME_LOSS
,   fGrft INT NOT NULL DEFAULT 0 -- FULL_GROSSPROFIT

,   dumpYMS DATETIME NOT NULL

,   PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
)`,

    CREATE_INDEX_PK = `
CREATE INDEX IF NOT EXISTS cis_idx_pk ON krx (baseYear, basePeriod, reportType, corpCd);`,
}