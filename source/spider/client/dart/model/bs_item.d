module spider.client.dart.model.bs_item;

import spider.common.util.str;

/// 재무제표 계정항목
struct BalanceStatementItem {
	/// 통화
	private string _currency;
	/// 항목코드
	private string _itemCode;
	/// 항목명
	private string _itemName;
	/// 당기
	private long _currentTerm = 0;
	/// 전기말
	private long _endOfTheFirstPeriod = 0;
	/// 전전기말
	private long _endOfThePreviousPeriod = 0;

	/// 통화
	@property public string currency() {
		return this._currency;
	}

	/// 항목코드
	@property public string itemCode() {
		return this._itemCode;
	}

	/// 항목명
	@property public string itemName() {
		return this._itemName;
	}

	/// 당기
	@property public long currentTerm() {
		return this._currentTerm;
	}

	/// 전기말
	@property public long endOfTheFirstPeriod() {
		return this._endOfTheFirstPeriod;
	}

	/// 전전기말
	@property public long endOfThePreviousPeriod() {
		return this._endOfThePreviousPeriod;
	}

	/**
	 * 생성자
	 * Params:
	 *	currency = 통화코드
	 *	itemCode = 항목코드
	 *	itemName = 항목명
	 *	currentTerm = 당기
	 *	eofp = 전기
	 *	eopp = 전전기
	 */
	this(string currency, string itemCode, string itemName, string currentTerm, string eofp, string eopp) {
		this._currency = currency;
		this._itemCode = itemCode;
		this._itemName = itemName;
		this._currentTerm     = Str.amountStringToLong(currentTerm);
		this._endOfTheFirstPeriod    = Str.amountStringToLong(eofp);
		this._endOfThePreviousPeriod = Str.amountStringToLong(eopp);
	}
}