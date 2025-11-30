module spider.database.enums.columns;

import spider.client.dart.enums.account: Account;

immutable string[Account] COL_MAP_BS = [
    Account.FULL_ASSETS : "fAsst",
    Account.FULL_CURRENTASSETS : "fCurAsst",
    Account.FULL_CASH_AND_CASH_EQUIVALENTS : "fCash",
    Account.FULL_INVENTORIES : "fIvnt",
    Account.FULL_NONCURRENTASSETS : "fNonCurAsset",
    Account.FULL_PROPERTY_PLANT_AND_EQUIPMENT : "fPrptNEqtm",
    Account.FULL_INTANGIBLE_ASSETS_OTHER_THAN_GOODWILL : "fItgblAsst",
    Account.FULL_LIABILITIES : "fLibl",
    Account.FULL_CURRENT_LIABILITIES : "fCurLibl",
    Account.FULL_EQUITY : "fEqty",
    Account.FULL_REVENUE : "fRevn",
    Account.FULL_GROSSPROFIT : "fGrft",
    Account.FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT : "fPrft2Own",
    Account.FULL_PROFIT_LOSS_BEFORE_TAX : "fPrftBfTax",
    Account.FULL_PROFITLOSS : "fPflss"
];