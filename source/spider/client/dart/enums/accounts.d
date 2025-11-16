module spider.client.dart.enums.accounts;

/// DART 계정코드
enum AccountDART {
	/// `dart_ShortTermTradeReceivable`: 매출채권
	SHORT_TERM_TRADE_RECEIVABLE,
	/// `dart_DepreciationExpense`:감가상각비
	DEPRECIATION_EXPENSE,
	/// `dart_OperatingIncomeLoss`:영업이익
	OPERATING_INCOME_LOSS,
	/// `dart_AmortisationExpense`:무형자산상각비
	AMORTISATION_EXPENSE
}

/// IFRS 코드
enum AccountIFRS {
	/// `ifrs-full_Assets`: 총자산
	FULL_ASSETS,
    /// `ifrs-full_CurrentAssets`: 유동자산
    FULL_CURRENTASSETS,
	/// `ifrs-full_CashAndCashEquivalents`: 현금및현금성자산
	FULL_CASH_AND_CASH_EQUIVALENTS,
	/// `ifrs-full_Inventories`: 재고자산
	FULL_INVENTORIES,
	/// `ifrs-full_NoncurrentAssets`: 비유동자산
	FULL_NONCURRENTASSETS,
	/// `ifrs-full_PropertyPlantAndEquipment`: 유형자산
	FULL_PROPERTY_PLANT_AND_EQUIPMENT,
	/// `ifrs-full_IntangibleAssetsOtherThanGoodwill`: 무형자산
	FULL_INTANGIBLE_ASSETS_OTHER_THAN_GOODWILL,

    /// `ifrs-full_Liabilities`: 부채총계
    FULL_LIABILITIES,
	/// `ifrs-full_CurrentLiabilities`: 유동부채
	FULL_CURRENT_LIABILITIES, 
	
	/// `ifrs-full_equity`: 자본총계
	FULL_EQUITY,

	/// `ifrs-full_Revenue`:매출액
	FULL_REVENUE,
	/// `ifrs-full_GrossProfit`: 매출총이익
	FULL_GROSSPROFIT,
	/// `ifrs-full_ProfitLossAttributableToOwnersOfParent`: 지배기업 소유주지분 순이익
	FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT,
	/// `ifrs-full_ProfitLossBeforeTax`: 법인세비용차감전순이익
	FULL_PROFIT_LOSS_BEFORE_TAX,
    /// `ifrs-full_ProfitLoss`: 당기순이익
    FULL_PROFITLOSS
}