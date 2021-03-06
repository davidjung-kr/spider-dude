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

	/// `ifrs-full_Revenue`:매출액
	FULL_REVENUE,
	/// `ifrs-full_GrossProfit`: 매출총이익
	FULL_GROSSPROFIT,
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
	/// GrossProfit / Assets
	GP_A,
	/// None 존재하지 않음
    NONE
}

/// 업종구분
enum IndustriesType {
	/// 도축, 육류 가공 및 저장 처리업
	C101,
	/// 수산물 가공 및 저장 처리업
	C102,
	/// 과실, 채소 가공 및 저장 처리업
	C103, 
	/// 낙농제품 및 식용빙과류 제조업
	C105, 
	/// 곡물가공품, 전분 및 전분제품 제조업
	C106, 
	/// 기타 식품 제조업
	C107,
	/// 동물용 사료 및 조제식품 제조업
	C108, 
	/// 작물 재배업
	C011, 
	/// 알코올음료 제조업
	C111, 
	/// 비알코올음료 및 얼음 제조업
	C112, 
	/// 담배 제조업
	C120, 
	/// 방적 및 가공사 제조업
	C131, 
	/// 직물직조 및 직물제품 제조업
	C132, 
	/// 편조원단 제조업
	C133, 
	/// 기타 섬유제품 제조업
	C139, 
	/// 봉제의복 제조업
	C141, 
	/// 편조의복 제조업
	C143, 
	/// 의복 액세서리 제조업
	C144, 
	/// 가죽, 가방 및 유사제품 제조업
	C151, 
	/// 신발 및 신발 부분품 제조업
	C152, 
	/// 제재 및 목재 가공업
	C161, 
	/// 나무제품 제조업
	C162, 
	/// 펄프, 종이 및 판지 제조업
	C171, 
	/// 골판지, 종이 상자 및 종이 용기 제조업
	C172, 
	/// 기타 종이 및 판지 제품 제조업
	C179, 
	/// 인쇄 및 인쇄관련 산업
	C181, 
	/// 기록매체 복제업
	C182, 
	/// 석유 정제품 제조업
	C192, 
	/// 기초 화학물질 제조업
	C201, 
	/// 합성고무 및 플라스틱 물질 제조업
	C202, 
	/// 비료, 농약 및 살균, 살충제 제조업
	C203, 
	/// 기타 화학제품 제조업
	C204, 
	/// 화학섬유 제조업
	C205, 
	/// 기초 의약물질 및 생물학적 제제 제조업
	C211, 
	/// 의약품 제조업
	C212, 
	/// 의료용품 및 기타 의약 관련제품 제조업
	C213, 
	/// 고무제품 제조업
	C221, 
	/// 플라스틱제품 제조업
	C222, 
	/// 유리 및 유리제품 제조업
	C231, 
	/// 내화, 비내화 요업제품 제조업
	C232, 
	/// 시멘트, 석회, 플라스터 및 그 제품 제조업
	C233, 
	/// 기타 비금속 광물제품 제조업
	C239, 
	/// 1차 철강 제조업
	C241, 
	/// 1차 비철금속 제조업
	C242, 
	/// 금속 주조업
	C243, 
	/// 구조용 금속제품, 탱크 및 증기발생기 제조업
	C251, 
	/// 무기 및 총포탄 제조업
	C252, 
	/// 기타 금속 가공제품 제조업
	C259, 
	/// 반도체 제조업
	C261, 
	/// 전자부품 제조업
	C262, 
	/// 컴퓨터 및 주변장치 제조업
	C263, 
	/// 통신 및 방송 장비 제조업
	C264, 
	/// 영상 및 음향기기 제조업
	C265, 
	/// 의료용 기기 제조업
	C271, 
	/// 측정, 시험, 항해, 제어 및 기타 정밀기기 제조업; 광학기기 제외
	C272, 
	/// 사진장비 및 광학기기 제조업
	C273, 
	/// 전동기, 발전기 및 전기 변환ㆍ 공급ㆍ제어 장치 제조업
	C281, 
	/// 일차전지 및 축전지 제조업
	C282, 
	/// 절연선 및 케이블 제조업
	C283, 
	/// 전구 및 조명장치 제조업
	C284, 
	/// 가정용 기기 제조업
	C285, 
	/// 기타 전기장비 제조업
	C289, 
	/// 일반 목적용 기계 제조업
	C291, 
	/// 특수 목적용 기계 제조업
	C292, 
	/// 자동차용 엔진 및 자동차 제조업
	C301, 
	/// 자동차 신품 부품 제조업
	C303, 
	/// 자동차 재제조 부품 제조업
	C304, 
	/// 어로 어업
	C031, 
	/// 선박 및 보트 건조업
	C311, 
	/// 철도장비 제조업
	C312, 
	/// 항공기, 우주선 및 부품 제조업
	C313, 
	/// 그 외 기타 운송장비 제조업
	C319, 
	/// 가구 제조업
	C320, 
	/// 귀금속 및 장신용품 제조업
	C331, 
	/// 악기 제조업
	C332, 
	/// 운동 및 경기용구 제조업
	C333, 
	/// 그 외 기타 제품 제조업
	C339, 
	/// 전기업
	C351, 
	/// 연료용 가스 제조 및 배관공급업
	C352, 
	/// 증기, 냉ㆍ온수 및 공기조절 공급업
	C353, 
	/// 폐기물 처리업
	C382, 
	/// 환경 정화 및 복원업
	C390, 
	/// 건물 건설업
	C411, 
	/// 토목 건설업
	C412, 
	/// 기반조성 및 시설물 축조관련 전문공사업
	C421, 
	/// 건물설비 설치 공사업
	C422, 
	/// 전기 및 통신 공사업
	C423, 
	/// 실내건축 및 건축마무리 공사업
	C424, 
	/// 자동차 판매업
	C451, 
	/// 자동차 부품 및 내장품 판매업
	C452, 
	/// 상품 중개업
	C461, 
	/// 산업용 농ㆍ축산물 및 동ㆍ식물 도매업
	C462, 
	/// 음ㆍ식료품 및 담배 도매업
	C463, 
	/// 생활용품 도매업
	C464, 
	/// 기계장비 및 관련 물품 도매업
	C465, 
	/// 기타 전문 도매업
	C467, 
	/// 상품 종합 도매업
	C468, 
	/// 종합 소매업
	C471, 
	/// 음ㆍ식료품 및 담배 소매업
	C472, 
	/// 섬유, 의복, 신발 및 가죽제품 소매업
	C474, 
	/// 연료 소매업
	C477, 
	/// 기타 상품 전문 소매업
	C478, 
	/// 무점포 소매업
	C479, 
	/// 육상 여객 운송업
	C492, 
	/// 도로 화물 운송업
	C493, 
	/// 해상 운송업
	C501, 
	/// 항공 여객 운송업
	C511, 
	/// 기타 운송관련 서비스업
	C529, 
	/// 일반 및 생활 숙박시설 운영업
	C551, 
	/// 음식점업
	C561, 
	/// 서적, 잡지 및 기타 인쇄물 출판업
	C581, 
	/// 소프트웨어 개발 및 공급업
	C582, 
	/// 영화, 비디오물, 방송프로그램 제작 및 배급업
	C591, 
	/// 오디오물 출판 및 원판 녹음업
	C592, 
	/// 텔레비전 방송업
	C602, 
	/// 전기 통신업
	C612, 
	/// 컴퓨터 프로그래밍, 시스템 통합 및 관리업
	C620, 
	/// 자료처리, 호스팅, 포털 및 기타 인터넷 정보매개 서비스업
	C631, 
	/// 기타 정보 서비스업
	C639, 
	/// 신탁업 및 집합투자업
	C642, 
	/// 기타 금융업
	C649, 
	/// 금융 지원 서비스업
	C661, 
	/// 보험 및 연금관련 서비스업
	C662, 
	/// 부동산 임대 및 공급업
	C681, 
	/// 자연과학 및 공학 연구개발업
	C701, 
	/// 광고업
	C713, 
	/// 시장조사 및 여론조사업
	C714, 
	/// 회사 본부 및 경영 컨설팅 서비스업
	C715, 
	/// 기타 전문 서비스업
	C716, 
	/// 기타 비금속광물 광업
	C072, 
	/// 건축기술, 엔지니어링 및 관련 기술 서비스업
	C721, 
	/// 기타 과학기술 서비스업
	C729, 
	/// 전문 디자인업
	C732, 
	/// 그 외 기타 전문, 과학 및 기술 서비스업
	C739, 
	/// 사업시설 유지ㆍ관리 서비스업
	C741, 
	/// 여행사 및 기타 여행보조 서비스업
	C752, 
	/// 경비, 경호 및 탐정업
	C753, 
	/// 기타 사업지원 서비스업
	C759, 
	/// 운송장비 임대업
	C761, 
	/// 개인 및 가정용품 임대업
	C762, 
	/// 산업용 기계 및 장비 임대업
	C763, 
	/// 초등 교육기관
	C851, 
	/// 일반 교습 학원
	C855, 
	/// 기타 교육기관
	C856, 
	/// 교육지원 서비스업
	C857, 
	/// 창작 및 예술관련 서비스업
	C901, 
	/// 유원지 및 기타 오락관련 서비스업
	C912,
	/// 그 외 기타 개인 서비스업
	C969 
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
		case IfrsCode.FULL_REVENUE:       return "ifrs-full_Revenue";
        case IfrsCode.FULL_PROFITLOSS:    return "ifrs-full_ProfitLoss";
		case IfrsCode.FULL_EQUITY:        return "ifrs-full_Equity";
		case IfrsCode.FULL_GROSSPROFIT:   return "ifrs-full_GrossProfit";
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
		case FormulaName.GP_A: return "GP/A";
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

/// 포괄손익계산서
struct Cis {
	// 분기
	private Period _period;

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

	/// 생성자
	this(Period period) {
		_period = period;
	}

	string pprint() {
		string s;
		/// [0] 재무제표종류
		s ~= "type:"~type~",\n";
		/// [1] 종목코드
		s ~= "code:"~code~",\n";
		/// [2] 회사명
		s ~= "name:"~name~",\n";
		/// [3] 시장구분
		s ~= "market:"~market~",\n";
		/// [4] 업종
		s ~= "sector:"~sector~",\n";
		/// [5] 업종명
		s ~= "sectorName:"~sectorName~",\n";
		/// [6] 결산월
		s ~= "endMonth:"~endMonth~",\n";
		/// [7] 결산기준일
		s ~= "endDay:"~endDay~",\n";
		/// [8] 보고서종류
		s ~= "report:"~report;
		return s;
	}

	/// 계정항목들
	StatementNq[] statements;

	/// 재무제표 질의
	long q(IfrsCode ifrsCode) {
		import std.stdio;
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				// 사업보고서인지 여부에 따라 당기(nowAcc)인지 누적(now)인 지 항목이 달라짐
				return _period == Period.Y4 ? this.statements[i].nowAcc : this.statements[i].now;
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

/// 손익계산서
alias Is = Cis;

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

	/**
	 * 비율 값이 x이상 y이하인 지 확인
	 */
	public bool ratioBetween(float x, float y) {
		return _ratio >= x && _ratio <= y;
	}
}