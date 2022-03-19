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
    /// ifrs-full_CurrentAssets:유동자산
    FULL_CURRENTASSETS,
    // ifrs-full_Liabilities:부채총계
    FULL_LIABILITIES
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
    /// Net-net current value
    NCAV,
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
        default: return "";
        }   
    }

	public static string reportType(ReportType e) @safe {
        switch(e) {
        case ReportType.OFS: return "OFS"; // 개별 보고서
        case ReportType.CFS: return "CFS"; // 연결 보고서
        default: return "";
        }   
    }

	public static string ifrsCode(IfrsCode e) @safe {
        switch(e) {
        case IfrsCode.FULL_CURRENTASSETS: return "ifrs-full_CurrentAssets";
        case IfrsCode.FULL_LIABILITIES: return "ifrs-full_Liabilities";
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
        default: return "NONE";
        }
    }

}

/// 보고서 (재무상태표, 손익계산서, 포괄손익계산서 포함)
class Report {
	/// 재무상태표
	private Bs[string] _balance;
	/// 재무상태표(Getter)
	@property Bs[string] balance() { return _balance; }
	/// 재무상태표(Setter)
	@property void balance(Bs[string] bs) { this._balance = bs; }
}

/// 재무상태표
struct Bs {
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

	// 계정항목들
	Statement[] statements;

	// 재무제표 쿼리
	long q(IfrsCode ifrsCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].ifrsCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}
}

// 계정항목
struct Statement {
	// [0] 통화
	string currency;
	// [1] 항목코드
	string ifrsCode;
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
    
    /// 생성자
    this(string code, long value) {
        this._code = code;
        this._value = value;
    }
}