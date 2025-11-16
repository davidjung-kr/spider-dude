module spider.formula.result;

/** 
 * 공식결과
 */
struct FormulaResult {
    /// 종목코드
    private string _code;
    /// 종목코드(Getter)
    @property string code() { return _code; }
    /// 결과 값
    private long _value;
    /// 결과 값(Getter)
    @property long value() { return _value; }
    /// 결과 값(Setter)
    @property void value(long v) { this._value = v; }
    /// 비율 값
    private float _ratio;
    /// 비율 값(Getter)
    @property float ratio() { return _ratio; }
    /// 비율 값(Setter)
    @property void ratio(float v) { this._ratio = v; }

	/** 
	 * 생성자
	 * Params:
	 *	code = 종목코드
	 */
	this(string code) {
		this._code = code;
	}

	/// 비어있는 지 여부
	@property bool empty() {
		return (_value==0 && _ratio ==0);
	}

	@property bool notEmpty() {
		return !this.empty();
	}

	/**
	 * 비율 값이 x이상 y이하인 지 확인
	 */
	public bool ratioBetween(float x, float y) {
		return _ratio >= x && _ratio <= y;
	}
}