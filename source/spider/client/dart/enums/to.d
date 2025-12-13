module spider.client.dart.enums.to;

import std.conv: to;
import spider.client.dart.consts;
import spider.client.dart.enums.report;
import spider.client.dart.enums.account;
import spider.client.dart.enums.statement;

struct EnumTo {
    public static string statementType(StatementDART e) @safe {
        switch(e) {
        case StatementDART.BS: return "BS";
        case StatementDART.IS: return "IS";
        case StatementDART.CIS: return "CIS";
        case StatementDART.CF: return "CF";
        case StatementDART.SCE: return "SCE";
        default: throw new Exception("Wrong code - ["~e.to!string~"]");
        }
    }

	public static string reportType(ReportType e) @safe {
        switch(e) {
        case ReportType.OFS: return "OFS"; // 개별 보고서
        case ReportType.CFS: return "CFS"; // 연결 보고서
        default: return "";
        }
    }

	/// IfrsCode Enum을 String으로
	public static string ifrsCode(Account e) @safe {
        switch(e) {
		case Account.FULL_ASSETS:        return "ifrs-full_Assets";
        case Account.FULL_CURRENTASSETS: return "ifrs-full_CurrentAssets";
		case Account.FULL_CASH_AND_CASH_EQUIVALENTS: return "ifrs-full_CashAndCashEquivalents";
		case Account.FULL_INVENTORIES: return "ifrs-full_Inventories";
		case Account.FULL_NONCURRENTASSETS: return "ifrs-full_NoncurrentAssets";
		case Account.FULL_PROPERTY_PLANT_AND_EQUIPMENT: return "ifrs-full_PropertyPlantAndEquipment";
		case Account.FULL_INTANGIBLE_ASSETS_OTHER_THAN_GOODWILL: return "ifrs-full_IntangibleAssetsOtherThanGoodwill";
		case Account.FULL_CURRENT_LIABILITIES: return "ifrs-full_CurrentLiabilities";
        case Account.FULL_LIABILITIES:   return "ifrs-full_Liabilities";
		case Account.FULL_REVENUE:       return "ifrs-full_Revenue";
        case Account.FULL_PROFITLOSS:    return "ifrs-full_ProfitLoss";
		case Account.FULL_EQUITY:        return "ifrs-full_Equity";
		case Account.FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT: return "ifrs-full_ProfitLossAttributableToOwnersOfParent";
		case Account.FULL_PROFIT_LOSS_BEFORE_TAX: return "ifrs-full_ProfitLossBeforeTax";
		case Account.FULL_GROSSPROFIT:   return "ifrs-full_GrossProfit";
        default: return "";
        }
    }

	/// DartCode Enum을 String으로
	public static string dartCode(Account e) @safe {
        switch(e) {
		case Account.SHORT_TERM_TRADE_RECEIVABLE: return "dart_ShortTermTradeReceivable";
		case Account.DEPRECIATION_EXPENSE:  return "dart_DepreciationExpense";
		case Account.OPERATING_INCOME_LOSS: return "dart_OperatingIncomeLoss";
		case Account.AMORTISATION_EXPENSE:  return "dart_AmortisationExpense";
        default: return "";
        }
    }

    public static string period(Period e) @safe {
        switch(e) {
        case Period.Q1: return "1Q";
        case Period.Q2: return "2Q";
        case Period.Q3: return "3Q";
        case Period.Q4: return "4Q";
        default: return "";
        }
    }

	public static string reportFileType(ReportFileType e) {
		switch(e) {
		case ReportFileType.BS: return "BS";
		case ReportFileType.PL: return "PL";
		case ReportFileType.CF: return "CF";
		case ReportFileType.CE: return "CE";
		default: return "";
		}
	}
}


/// 보고서 구분
struct ParseAs {
	public static ReportFileType reportFileType(string code) {
		switch(code) {
		case "BS": return ReportFileType.BS;
		case "PL": return ReportFileType.PL;
		case "CF": return ReportFileType.CF;
		case "CE": return ReportFileType.CE;
		default:   return ReportFileType.NONE;
		}
	}

	public static Period period(string code) {
		switch(code) {
		case "1Q": return Period.Q1;
		case "2Q": return Period.Q2;
		case "3Q": return Period.Q3;
		case "4Q": return Period.Q4;
		default: return Period.NONE;
		}
	}
}