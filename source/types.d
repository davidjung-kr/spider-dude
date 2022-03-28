module com.davidjung.spider.types;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv;
import std.string;
import std.math.rounding;

/// 연결/개별 여부
enum ReportType {
    /// 연결 보고서
    CFS,
    /// 개별 보고서
    OFS
}

/// 보고서 구분
enum StatementType {
    /// 재무상태표
    BS,
    /// 손익계산서
    IS,
    /// 포괄손익계산서
    CIS,
    /// 현금흐름표
    CF,
    /// 자본변동표
    SCE
}

/// IFRS 코드
enum IfrsCode {
	/// `ifrs-full_Assets`: 총자산
	FULL_ASSETS,
    /// `ifrs-full_CurrentAssets`: 유동자산
    FULL_CURRENTASSETS,
    /// `ifrs-full_Liabilities`: 부채총계
    FULL_LIABILITIES,
	/// `ifrs-full_equity`: 자본총계
	FULL_EQUITY,

    /// `ifrs-full_ProfitLoss`: 당기순이익
    FULL_PROFITLOSS
}

/// DART 코드
enum DartCode {
	/// `dart_DepreciationExpense`:감가상각비
	DEPRECIATION_EXPENSE,
	/// `dart_OperatingIncomeLoss`:영업이익
	OPERATING_INCOME_LOSS,
	/// `dart_AmortisationExpense`:무형자산상각비
	AMORTISATION_EXPENSE
}

/// N분기
enum Period {
    /// 1Q:1분기 보고서
    Y1,
    /// 2Q:반기 보고서
    Y2,
    /// 3Q:3분기 보고서
    Y3,
    /// 4Q:사업보고서
    Y4
}

/// 공식명
enum FormulaName {
    /// Net-net current value (NCAV)
    NCAV,
	/// Price to Book-value Ratio (주가순자산비율)
	PBR,
	/// Enterprise value / Earnings Before Interest, Taxes, Depreciation and Amortization
	EV_EBITA,
	/// Price-earning ratio (주가수익비율)
	PER,
	/// None 존재하지 않음
    NONE
}

/// Enum to String
struct GetCodeFrom {
    public static string statementType(StatementType e) @safe {
        switch(e) {
        case StatementType.BS: return "BS";
        case StatementType.IS: return "IS";
        case StatementType.CIS: return "CIS";
        case StatementType.CF: return "CF";
        case StatementType.SCE: return "SCE";
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
	public static string ifrsCode(IfrsCode e) @safe {
        switch(e) {
		case IfrsCode.FULL_ASSETS:        return "ifrs-full_Assets";
        case IfrsCode.FULL_CURRENTASSETS: return "ifrs-full_CurrentAssets";
        case IfrsCode.FULL_LIABILITIES:   return "ifrs-full_Liabilities";
        case IfrsCode.FULL_PROFITLOSS:    return "ifrs-full_ProfitLoss";
		case IfrsCode.FULL_EQUITY:        return "ifrs-full_Equity";
        default: return "";
        }
    }

	/// DartCode Enum을 String으로
	public static string dartCode(DartCode e) @safe {
        switch(e) {
		case DartCode.DEPRECIATION_EXPENSE:  return "dart_DepreciationExpense";
		case DartCode.OPERATING_INCOME_LOSS: return "dart_OperatingIncomeLoss";
		case DartCode.AMORTISATION_EXPENSE:  return "dart_AmortisationExpense";
        default: return "";
        }
    }

    public static string period(Period e) @safe {
        switch(e) {
        case Period.Y1: return "1Q";
        case Period.Y2: return "2Q";
        case Period.Y3: return "3Q";
        case Period.Y4: return "4Q";
        default: return "";
        }
    }

    public static string formulaName (FormulaName e) {
        switch(e){
        case FormulaName.NCAV: return "NCAV";
		case FormulaName.PBR:  return "PBR";
		case FormulaName.PER:  return "PER";
		case FormulaName.EV_EBITA: return "EV/EBITA";
        default: return "NONE";
        }
    }

}

/// 재무상태표
struct Bs {
	/// [0] 재무제표종류
	string type;
	/// [1] 종목코드
	string code;
	/// [2] 회사명
	string name;
	/// [3] 시장구분
	string market;
	/// [4] 업종
	string sector;
	/// [5] 업종명
	string sectorName;
	/// [6] 결산월
	string endMonth;
	/// [7] 결산기준일
	string endDay;
	/// [8] 보고서종류
	string report;

	string pprint() {
		string s;
		// [0] 재무제표종류
		s ~= "type:"~type~",\n";
		// [1] 종목코드
		s ~= "code:"~code~",\n";
		// [2] 회사명
		s ~= "name:"~name~",\n";
		// [3] 시장구분
		s ~= "market:"~market~",\n";
		// [4] 업종
		s ~= "sector:"~sector~",\n";
		// [5] 업종명
		s ~= "sectorName:"~sectorName~",\n";
		// [6] 결산월
		s ~= "endMonth:"~endMonth~",\n";
		// [7] 결산기준일
		s ~= "endDay:"~endDay~",\n";
		// [8] 보고서종류
		s ~= "report:"~report;
		return s;
	}

	/// 계정항목들
	Statement[] statements;

	/// 재무제표 질의
	long q(IfrsCode ifrsCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * 계정과목 비어있는 지 확인
	 */
	public bool empty() {
		if(statements.length <= 0)
			return true;
		return false;
	}
}

/// 계정항목
struct Statement {
	// [0] 통화
	string currency;
	// [1] 항목코드
	string statementCode;
	// [2] 항목명
	string rowName;
	// [3] 당기
	long now = 0;
	// [4] 전기
	long y1 = 0;
	// [5] 전전기
	long y2 = 0;

	void setMoney(string now, string y1, string y2) {
		string e1 = strip(now).replace(",", "");
		string e2 = strip(y1).replace(",", "");
		string e3 = strip(y2).replace(",", "");
		this.now = (e1 == "") ? 0:to!long(e1);
		this.y1 =  (e2 == "") ? 0:to!long(e2);
		this.y2 =  (e3 == "") ? 0:to!long(e3);
	}
}

/// 손익계산서 계정항목
struct StatementNq {
    /// [0] 통화
    string currency;
    /// [1] 항목코드
    string statementCode;
    /// [2] 항목명
    string rowName;
    /// [3] 당기 3분기 3개월
    long now = 0;
    /// [4] 당기 3분기 누적
    long nowAcc = 0;
    /// [5] 전기 3분기 3개월
    long y1 = 0;
    /// [6] 전기 3분기 누적
    long y1Acc = 0;
    /// [7] 전기
    long y2 = 0;
    /// [8] 전전기
    long y2Acc = 0;

	void setMoney(string now, string nowAcc, string y1, string y1Acc, string y2, string y2Acc) {
		string n = strip(now).replace(",", "");
        string na = strip(nowAcc).replace(",", "");
        this.now    = (n == "")  ? 0:to!long(n);
        this.nowAcc = (na == "") ? 0:to!long(na);

        y1         = strip(y1).replace(",", "");
        string y1a = strip(y1Acc).replace(",", "");
        this.y1    = (y1 == "")  ? 0:to!long(y1);
        this.y1Acc = (y1a == "") ? 0:to!long(y1a);

        y2         = strip(y2)   .replace(",", "");
        string y2a = strip(y2Acc).replace(",", "");
        this.y2    = (y2 == "")  ? 0:to!long(y2);
        this.y2Acc = (y2a == "") ? 0:to!long(y2a);

	}
}


/// 손익계산서
struct Is {
	// [0] 재무제표종류
	string type;
	// [1] 종목코드
	string code;
	// [2] 회사명
	string name;
	// [3] 시장구분
	string market;
	// [4] 업종
	string sector;
	// [5] 업종명
	string sectorName;
	// [6] 결산월
	string endMonth;
	// [7] 결산기준일
	string endDay;
	// [8] 보고서종류
	string report;

	string pprint() {
		string s;
		// [0] 재무제표종류
		s ~= "type:"~type~",\n";
		// [1] 종목코드
		s ~= "code:"~code~",\n";
		// [2] 회사명
		s ~= "name:"~name~",\n";
		// [3] 시장구분
		s ~= "market:"~market~",\n";
		// [4] 업종
		s ~= "sector:"~sector~",\n";
		// [5] 업종명
		s ~= "sectorName:"~sectorName~",\n";
		// [6] 결산월
		s ~= "endMonth:"~endMonth~",\n";
		// [7] 결산기준일
		s ~= "endDay:"~endDay~",\n";
		// [8] 보고서종류
		s ~= "report:"~report;
		return s;
	}

	/// 계정항목들
	StatementNq[] statements;

	/// 재무제표 질의
	long q(IfrsCode ifrsCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * 다트 계정과목 조회
	 */
	long queryDartStatement(DartCode dartCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.dartCode(dartCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * 계정과목 비어있는 지 확인
	 */
	public bool empty() {
		if(statements.length <= 0)
			return true;
		return false;
	}
}

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

	/**
	 * 비어있는 지 여부
	 */
	@property bool empty() {
		return (_value==0 && _ratio ==0);
	}

	@property bool notEmpty() {
		return !this.empty();
	}
}