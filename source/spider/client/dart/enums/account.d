module spider.client.dart.enums.account;

/// 계정과목 코드
enum Account {
	/// 총자산
	FULL_ASSETS = "ifrs-full_Assets",
    /// 유동자산
    FULL_CURRENTASSETS = "ifrs-full_CurrentAssets",
	/// 현금및현금성자산
	FULL_CASH_AND_CASH_EQUIVALENTS = "ifrs-full_CashAndCashEquivalents",
	/// 재고자산
	FULL_INVENTORIES = "ifrs-full_Inventories",
	/// 비유동자산
	FULL_NONCURRENTASSETS = "ifrs-full_NoncurrentAssets",
	/// 유형자산
	FULL_PROPERTY_PLANT_AND_EQUIPMENT = "ifrs-full_PropertyPlantAndEquipment",
	/// 무형자산
	FULL_INTANGIBLE_ASSETS_OTHER_THAN_GOODWILL = "ifrs-full_IntangibleAssetsOtherThanGoodwill",

    /// 부채총계
    FULL_LIABILITIES = "ifrs-full_Liabilities",
	/// 유동부채
	FULL_CURRENT_LIABILITIES = "ifrs-full_CurrentLiabilities",
	
	/// 자본총계
	FULL_EQUITY = "ifrs-full_equity",

	/// 매출액
	FULL_REVENUE = "ifrs-full_Revenue",
	/// 매출총이익
	FULL_GROSSPROFIT = "ifrs-full_GrossProfit",
	/// 지배기업 소유주지분 순이익
	FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT = "ifrs-full_ProfitLossAttributableToOwnersOfParent",
	/// 법인세비용차감전순이익
	FULL_PROFIT_LOSS_BEFORE_TAX = "ifrs-full_ProfitLossBeforeTax",
    /// 당기순이익
    FULL_PROFITLOSS = "ifrs-full_ProfitLoss",



	/// 매출채권
	SHORT_TERM_TRADE_RECEIVABLE = "dart_ShortTermTradeReceivable`:",
	/// 감가상각비
	DEPRECIATION_EXPENSE = "dart_DepreciationExpense`:",
	/// 영업이익
	OPERATING_INCOME_LOSS = "dart_OperatingIncomeLoss`:",
	/// 무형자산상각비
	AMORTISATION_EXPENSE = "dart_AmortisationExpense",
}