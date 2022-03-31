module com.davidjung.spider.parser;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.stdio;
import std.regex;
import std.conv;
import std.path;
import std.file;
import std.format;
import std.regex;
import std.string;
import com.davidjung.spider.types;
import com.davidjung.spider.report;

/**
 * DART 재무데이터 파서
 *
 * Check out: https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do
 */
class Parser {
    /// 원본 파일이름
    private string _fileName;
    /// 원본 파일이름
	@property string fileName() {
		return _fileName;
	}
    /// 원본 파일생성 날짜 (From DART)
	private string _date;
	@property string date() {
		return this._date;
	}
    private bool _isReady = false;
	@property bool ready() {
		return _isReady;
	}

    private string _year;
    private ReportType _reportType;
	private StatementType _statementType;
	private int colSize = 0;
	private Period _period;

	/**
     * 생성자
     * 일괄 재무데이터 파싱에 필요한 매개변수를 받습니다.
     * Params:
     *  year = 회계년도
     *  p = 분기
     *  rt = 연결/개별 여부
     *  st = 보고서 구분
     */
	this(string year, Period p, ReportType rt, StatementType st) {
        this._year = year;
		this._period = p;
        this._reportType = rt;
        this._statementType = st;
		string pattern =  format("%s_%s_%s_%s_*.txt",
									year,
									GetCodeFrom.period(p),
									GetCodeFrom.reportType(rt),
									GetCodeFrom.statementType(st));
		auto list = dirEntries("", pattern, SpanMode.breadth);
		
		if(list.empty)
			throw new Exception("Can't find file with this pattern => " ~ pattern);
		this._fileName = list.front;
		auto rxResult = matchFirst(this._fileName, ctRegex!(`([\d]+).txt`));

		if(rxResult.empty)
			throw new Exception("Can't find date with this pattern => " ~ format("[%s : %s]", this._fileName, `([\d]+).txt`));
		
		this._date = rxResult[1];
		this._isReady = true;

        switch(this._statementType){
        case StatementType.BS: this.colSize = 13; break;
        case StatementType.IS: this.colSize = 16; break;
        default: break;
        }
    }

	/**
	 * 읽기
	 */
	public void read(ref Report rpt) {
		switch(this._statementType) {
		case StatementType.BS: readBalanceSheet(rpt); break;
		case StatementType.IS: readIncomeSheet(rpt); break;
		case StatementType.CIS:readComprehensiveIncomeSheet(rpt); break;
		default: break;
		}
	}

	/**
	 * 손익계산서 로드
	 */
	private void readIncomeSheet(ref Report rpt) {
		Is[string] incomeSheet;
		File f = File(this._fileName, "r");
		f.readln();
		while(!f.eof()) {
			string line = f.readln();
			string[] cell = line.split("\t");
			if(cell.length <= 0) continue;
			string code = cell[1][1..7];

			if(code !in incomeSheet) { // 없으면 신규 등록
				Is newIncomeSheet;
				newIncomeSheet.type = cell[0]; // 재무제표종류
				newIncomeSheet.code = code; // 종목코드
				newIncomeSheet.name = cell[2]; // 회사명
				newIncomeSheet.market = cell[3]; // 시장구분
				newIncomeSheet.sector = cell[4]; // 업종
				newIncomeSheet.sectorName = cell[5]; // 업종명
				newIncomeSheet.endMonth = cell[6]; // 결산월
				newIncomeSheet.endDay = cell[7]; // 결산기준일
				newIncomeSheet.report = cell[8]; // 보고서종류
				
				incomeSheet[newIncomeSheet.code] = newIncomeSheet;
			}

			StatementNq st = StatementNq();
			st.currency = cell[9];         // 통화코드
			st.statementCode = strip(cell[10]); // 항목코드
			st.rowName  = strip(cell[11]); // 항목명
			st.setMoney(cell[12], cell[13], cell[14], cell[15], cell[16], cell[17]);
			incomeSheet[code].statements ~= st;
		}
		f.close();
        rpt.income = incomeSheet;
	}

	/**
	 * 포괄손익계산서 로드
	 */
	private void readComprehensiveIncomeSheet(ref Report rpt) {
		Cis[string] comprehensiveIncomeSheet;
		File f = File(this._fileName, "r");
		f.readln();
		while(!f.eof()) {
			string line = f.readln();
			string[] cell = line.split("\t");
			if(cell.length <= 0) continue;
			string code = cell[1][1..7];

			if(code !in comprehensiveIncomeSheet) { // 없으면 신규 등록
				Cis newComprehensiveIncomeSheet;
				newComprehensiveIncomeSheet.type = cell[0]; // 재무제표종류
				newComprehensiveIncomeSheet.code = code; // 종목코드
				newComprehensiveIncomeSheet.name = cell[2]; // 회사명
				newComprehensiveIncomeSheet.market = cell[3]; // 시장구분
				newComprehensiveIncomeSheet.sector = cell[4]; // 업종
				newComprehensiveIncomeSheet.sectorName = cell[5]; // 업종명
				newComprehensiveIncomeSheet.endMonth = cell[6]; // 결산월
				newComprehensiveIncomeSheet.endDay = cell[7]; // 결산기준일
				newComprehensiveIncomeSheet.report = cell[8]; // 보고서종류
				
				comprehensiveIncomeSheet[newComprehensiveIncomeSheet.code] = newComprehensiveIncomeSheet;
			}

			StatementNq st = StatementNq();
			st.currency = cell[9];         // 통화코드
			st.statementCode = strip(cell[10]); // 항목코드
			st.rowName  = strip(cell[11]); // 항목명
			st.setMoney(cell[12], cell[13], cell[14], cell[15], cell[16], cell[17]);
			comprehensiveIncomeSheet[code].statements ~= st;
		}
		f.close();
        rpt.comprehensiveIncome = comprehensiveIncomeSheet;
	}

	private void readBalanceSheet(ref Report rpt) {
		Bs[string] bs;

		File f = File(this._fileName, "r");
		f.readln();
		while(!f.eof()) {
			string line = f.readln();
			string[] cell = line.split("\t");

			if(cell.length <= 0) continue;
			
			string code = cell[1][1..7];
			
			if(code !in bs) { // 없으면 신규 등록
				Bs newBs;
				newBs.type = cell[0]; // 재무제표종류
				newBs.code = code; // 종목코드
				newBs.name = cell[2]; // 회사명
				newBs.market = cell[3]; // 시장구분
				newBs.sector = cell[4]; // 업종
				newBs.sectorName = cell[5]; // 업종명
				newBs.endMonth = cell[6]; // 결산월
				newBs.endDay = cell[7]; // 결산기준일
				newBs.report = cell[8]; // 보고서종류
				
				bs[newBs.code] = newBs;
			}

			Statement st = Statement();
			st.currency = cell[9]; // 통화코드
			st.statementCode = strip(cell[10]); // 항목코드
			st.rowName = strip(cell[11]); // 항목명
			st.setMoney(cell[12], cell[13], cell[14]);
			bs[code].statements ~= st;
		}
        
		f.close();
        rpt.balance = bs;
	}

	/**
	 * 항목코드 정규화
	 * 
	 * entity00128661_udf_IS_2021111016569448 .. 와 같이
	 * 공식적인 IFRS 항목코드가 아닌 항목명에서 불필요한 데이터를 지우고
	 * `udf-`를 붙여 리턴한다.
	 * 클랜징할 대상이 없을 경우 입력 값 그대로 리턴.
	 *
	 * Examples: 
	 *	assert("udf-IncomeStatementAbstract" ==
	 *         Parser.cleaningAccountingCode(
	 *	"entity00128661_udf_IS_2021111016569448_IncomeStatementAbstract"));
	 * 
	 */
	private static string cleaningAccountingCode(string blaha) {
		if(blaha.indexOf("entity") < 0) {
			return blaha;
		}
		auto matchResult = matchFirst(blaha, ctRegex!(`entity\d+_udf_[BIS]+_\d+_(\w+)`));
		if(matchResult.empty)
			return blaha;
		return "udf-"~matchResult[1]; // 0은 Full-match, 1부터 group
	}
	
}

unittest {
	assert("udf-IncomeStatementAbstract" == Parser.cleaningAccountingCode(
			"entity00128661_udf_IS_2021111016569448_IncomeStatementAbstract")); // == 지분법이익
}