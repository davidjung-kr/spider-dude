module com.davidjung.spider.parser;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX ๐
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
 * DART ์ฌ๋ฌด๋ฐ์ดํฐ ํ์
 *
 * Check out: https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do
 */
class Parser {
    /// ์๋ณธ ํ์ผ์ด๋ฆ
    private string _fileName;
    /// ์๋ณธ ํ์ผ์ด๋ฆ
	@property string fileName() {
		return _fileName;
	}
    /// ์๋ณธ ํ์ผ์์ฑ ๋ ์ง (From DART)
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
     * ์์ฑ์
     * ์ผ๊ด ์ฌ๋ฌด๋ฐ์ดํฐ ํ์ฑ์ ํ์ํ ๋งค๊ฐ๋ณ์๋ฅผ ๋ฐ์ต๋๋ค.
     * Params:
     *  year = ํ๊ณ๋๋
     *  p = ๋ถ๊ธฐ
     *  rt = ์ฐ๊ฒฐ/๊ฐ๋ณ ์ฌ๋ถ
     *  st = ๋ณด๊ณ ์ ๊ตฌ๋ถ
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
		auto list = dirEntries("dartdata/", pattern, SpanMode.breadth);
		
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
	 * ์ฝ๊ธฐ
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
	 * ์์ต๊ณ์ฐ์ ๋ก๋
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

			if(code !in incomeSheet) { // ์์ผ๋ฉด ์ ๊ท ๋ฑ๋ก
				Is newIncomeSheet = Is(this._period);
				newIncomeSheet.type = cell[0]; // ์ฌ๋ฌด์ ํ์ข๋ฅ
				newIncomeSheet.code = code; // ์ข๋ชฉ์ฝ๋
				newIncomeSheet.name = cell[2]; // ํ์ฌ๋ช
				newIncomeSheet.market = cell[3]; // ์์ฅ๊ตฌ๋ถ
				newIncomeSheet.sector = cell[4]; // ์์ข
				newIncomeSheet.sectorName = cell[5]; // ์์ข๋ช
				newIncomeSheet.endMonth = cell[6]; // ๊ฒฐ์ฐ์
				newIncomeSheet.endDay = cell[7]; // ๊ฒฐ์ฐ๊ธฐ์ค์ผ
				newIncomeSheet.report = cell[8]; // ๋ณด๊ณ ์์ข๋ฅ
				
				incomeSheet[newIncomeSheet.code] = newIncomeSheet;
			}

			StatementNq st = StatementNq();
			st.currency = cell[9];         // ํตํ์ฝ๋
			st.statementCode = strip(cell[10]); // ํญ๋ชฉ์ฝ๋
			st.rowName  = strip(cell[11]); // ํญ๋ชฉ๋ช
			st.setMoney(cell[12], cell[13], cell[14], cell[15], cell[16], cell[17]);
			incomeSheet[code].statements ~= st;
		}
		f.close();
        rpt.income = incomeSheet;
	}

	/**
	 * ํฌ๊ด์์ต๊ณ์ฐ์ ๋ก๋
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

			if(code !in comprehensiveIncomeSheet) { // ์์ผ๋ฉด ์ ๊ท ๋ฑ๋ก
				Cis newComprehensiveIncomeSheet = Cis(this._period);
				newComprehensiveIncomeSheet.type = cell[0]; // ์ฌ๋ฌด์ ํ์ข๋ฅ
				newComprehensiveIncomeSheet.code = code; // ์ข๋ชฉ์ฝ๋
				newComprehensiveIncomeSheet.name = cell[2]; // ํ์ฌ๋ช
				newComprehensiveIncomeSheet.market = cell[3]; // ์์ฅ๊ตฌ๋ถ
				newComprehensiveIncomeSheet.sector = cell[4]; // ์์ข
				newComprehensiveIncomeSheet.sectorName = cell[5]; // ์์ข๋ช
				newComprehensiveIncomeSheet.endMonth = cell[6]; // ๊ฒฐ์ฐ์
				newComprehensiveIncomeSheet.endDay = cell[7]; // ๊ฒฐ์ฐ๊ธฐ์ค์ผ
				newComprehensiveIncomeSheet.report = cell[8]; // ๋ณด๊ณ ์์ข๋ฅ
				
				comprehensiveIncomeSheet[newComprehensiveIncomeSheet.code] = newComprehensiveIncomeSheet;
			}

			StatementNq st = StatementNq();
			st.currency = cell[9];         // ํตํ์ฝ๋
			st.statementCode = strip(cell[10]); // ํญ๋ชฉ์ฝ๋
			st.rowName  = strip(cell[11]); // ํญ๋ชฉ๋ช
			// ์ฌ์๋ณด๊ณ ์ ์ธ์ง ์๋ ์ง์ ๋ฐ๋ผ, ๊ธ์ก์ ๋ํ ํญ๋ชฉ ์ธํ์ด ๋ค๋ฆ
			if(_period == Period.Y4) {
				st.setMoney("0", cell[13], "0", "0", cell[16], cell[17]);
			} else {
				st.setMoney(cell[12], cell[13], cell[14], cell[15], cell[16], cell[17]);
			}
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
			
			if(code !in bs) { // ์์ผ๋ฉด ์ ๊ท ๋ฑ๋ก
				Bs newBs;
				newBs.type = cell[0]; // ์ฌ๋ฌด์ ํ์ข๋ฅ
				newBs.code = code; // ์ข๋ชฉ์ฝ๋
				newBs.name = cell[2]; // ํ์ฌ๋ช
				newBs.market = cell[3]; // ์์ฅ๊ตฌ๋ถ
				newBs.sector = cell[4]; // ์์ข
				newBs.sectorName = cell[5]; // ์์ข๋ช
				newBs.endMonth = cell[6]; // ๊ฒฐ์ฐ์
				newBs.endDay = cell[7]; // ๊ฒฐ์ฐ๊ธฐ์ค์ผ
				newBs.report = cell[8]; // ๋ณด๊ณ ์์ข๋ฅ
				
				bs[newBs.code] = newBs;
			}

			Statement st = Statement();
			st.currency = cell[9]; // ํตํ์ฝ๋
			st.statementCode = strip(cell[10]); // ํญ๋ชฉ์ฝ๋
			st.rowName = strip(cell[11]); // ํญ๋ชฉ๋ช
			st.setMoney(cell[12], cell[13], cell[14]);
			bs[code].statements ~= st;
		}
        
		f.close();
        rpt.balance = bs;
	}

	/**
	 * ํญ๋ชฉ์ฝ๋ ์ ๊ทํ
	 * 
	 * entity00128661_udf_IS_2021111016569448 .. ์ ๊ฐ์ด
	 * ๊ณต์์ ์ธ IFRS ํญ๋ชฉ์ฝ๋๊ฐ ์๋ ํญ๋ชฉ๋ช์์ ๋ถํ์ํ ๋ฐ์ดํฐ๋ฅผ ์ง์ฐ๊ณ 
	 * `udf-`๋ฅผ ๋ถ์ฌ ๋ฆฌํดํ๋ค.
	 * ํด๋์งํ  ๋์์ด ์์ ๊ฒฝ์ฐ ์๋ ฅ ๊ฐ ๊ทธ๋๋ก ๋ฆฌํด.
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
		return "udf-"~matchResult[1]; // 0์ Full-match, 1๋ถํฐ group
	}
	
}

unittest {
	assert("udf-IncomeStatementAbstract" == Parser.cleaningAccountingCode(
			"entity00128661_udf_IS_2021111016569448_IncomeStatementAbstract")); // == ์ง๋ถ๋ฒ์ด์ต
}