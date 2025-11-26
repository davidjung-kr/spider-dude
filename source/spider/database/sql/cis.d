module spider.database.sql.cis;

enum SQL_TB_CIS {
    CREATE_IF_NOT_EXISTS = `
CREATE TABLE IF NOT EXISTS cis (
    baseYear CHAR(4) NOT NULL
,   basePeriod CHAR(2) NOT NULL
,   reportType CHAR(3) NOT NULL
,   corpCd CHAR(6) NOT NULL

,   fullProfitloss INT NOT NULL DEFAULT 0
,   fullProfitLossBeforeTax INT NOT NULL DEFAULT 0
,   fullProfitLossAttributableToOwnersOfParent INT NOT NULL DEFAULT 0
,   operatingIncomeLoss INT NOT NULL DEFAULT 0
,   fullGrossProfit INT NOT NULL DEFAULT 0

,   dumpYms DATETIME NOT NULL

,   PRIMARY KEY (baseYear, basePeriod, reportType, corpCd)
)`
}