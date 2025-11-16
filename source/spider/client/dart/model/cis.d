module spider.client.dart.model.cis;

import spider.client.dart.consts;
import spider.client.dart.enums.to;
import spider.client.dart.enums.period;
import spider.client.dart.enums.accounts;
import spider.client.dart.model.cis_item;

/// 손익계산서
alias DartIS = DartCIS;

/// 포괄손익계산서
struct DartCIS {
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
	IncomeStatementItem[] items;

	/// 당기 금액 질의
	long getCurrentTerm(string code) {
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == code) {
				return this.items[i].currentTerm;
			}
		}
		return 0;
	}

	/// 재무제표 질의: 당기 누적을 기본으로 가져옴
	long q(AccountIFRS code) {
		import std.stdio;
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == EnumTo.ifrsCode(code)) {
				return this.items[i].currentAccumulation;
			}
		}
		return 0;
	}

	/// 다트 계정과목 조회: 당기 누적을 긱본으로 가져옴
	long queryDartStatement(AccountDART code) {
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == EnumTo.dartCode(code)) {
				return this.items[i].currentAccumulation;
			}
		}
		return 0;
	}

	/**
	 * 계정과목 비어있는 지 확인
	 */
	public bool isItemsEmpty() {
		if(items.length <= 0)
			return true;
		return false;
	}
}
