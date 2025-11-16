module spider.client.dart.model.cis_item;

import spider.common.util.str;

/// 손익계산서 계정항목
struct IncomeStatementItem {
	/// 통화
	private string _currency;
	/// 항목코드
	private string _itemCode;
	/// 항목명
	private string _itemName;
	/// 당기
	private long _currentTerm = 0;
	/// 당기누적
	private long _currentAccumulation = 0;
	/// 전기말
	private long _endOfTheFirstPeriod = 0;
	/// 전기말 누적
	private long _accumulationAtEndOfTheFirstPeriod = 0;
	/// 전전기말
	private long _endOfThePreviousPeriod = 0;
	/// 전전기말 누적
	private long _accumulationAtEndOfThePriviousPeriod = 0;

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

	/// 당기 누적
	@property public long currentAccumulation() {
		return this._currentAccumulation;
	}

	/// 전기말
	@property public long endOfTheFirstPeriod() {
		return this._endOfTheFirstPeriod;
	}

	/// 전기말 누적
	@property public long accumulationAtEndOfTheFirstPeriod() {
		return this._accumulationAtEndOfTheFirstPeriod;
	}

	/// 전전기말
	@property public long endOfThePreviousPeriod() {
		return this._endOfThePreviousPeriod;
	}

	/// 전전기말 뉴적
	@property public long accumulationAtEndOfThePriviousPeriod() {
		return this._accumulationAtEndOfThePriviousPeriod;
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
	this(string currency, string itemCode, string itemName) {
		this._currency = currency;
		this._itemCode = itemCode;
		this._itemName = itemName;
	}

	/** 
	 * 당기금액 설정
	 * Params:
	 *	currentTerm = 당기
	 *	currentAccumulation = 당기누적
	 */
	public void setCurrentAmount(string currentTerm, string currentAccumulation) {
		this._currentTerm = Str.amountStringToLong(currentTerm);
		this._currentAccumulation = Str.amountStringToLong(currentAccumulation);
	}

	/** 
	 * 전기금액 설정
	 * Params:
	 *	eofp = 전기
	 *	accEofp = 전기누적
	 */
	public void setFirstPeriodAmount(string eofp, string accEofp) {
		this._endOfTheFirstPeriod = Str.amountStringToLong(eofp);
		this._accumulationAtEndOfTheFirstPeriod = Str.amountStringToLong(accEofp);
	}

	/** 
	 * 전전기금액 설정
	 * Params:
	 *	eofp = 전전기
	 *	accEofp = 전전기누적
	 */
	public void setPreviousAmount(string eofp, string accEopp) {
		this._endOfThePreviousPeriod = Str.amountStringToLong(eofp);
		this._accumulationAtEndOfThePriviousPeriod= Str.amountStringToLong(accEopp);
	}
}