module spider.client.dart.model.bs;

import spider.client.dart.consts;
import spider.client.dart.enums.to;
import spider.client.dart.enums.accounts;
import spider.client.dart.model.bs_item;

/// 재무상태표
struct DartBS {
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
	BalanceStatementItem[] items;

	/// 당기 금액 질의
	long getCurrentTerm(AccountIFRS code) {
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == EnumTo.ifrsCode(code)) {
				return this.items[i].currentTerm;
			}
		}
		return 0;
	}

	/// 전기 금액 질의
	long getEndOfTheFirstPeriod(AccountIFRS code) {
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == EnumTo.ifrsCode(code)) {
				return this.items[i].endOfTheFirstPeriod;
			}
		}
		return 0;
	}

	/// 전전기 금액 질의
	long getEndOfThePreviousPeriod(AccountIFRS ifrsCode) {
		for(int i=0; i<this.items.length; i++) {
			if(this.items[i].itemCode == EnumTo.ifrsCode(ifrsCode)) {
				return this.items[i].endOfThePreviousPeriod;
			}
		}
		return 0;
	}

	/// 계정과목 비어있는 지 확인
	public bool isItemsEmpty() {
		return this.items.length <= 0;
	}
}