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
import std.conv;
import std.path;
import std.file;
import std.format;
import std.regex;
import std.string;
import com.davidjung.spider.types;

/**
 * DART 재무데이터 파서
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

	public void read(ref Report rpt) {
		Bs[string] _bs;

		File f = File(this._fileName, "r");
		f.readln();
		while(!f.eof()) {
			string line = f.readln();
			string[] cell = line.split("\t");

			if(cell.length <= 0) continue;
			
			string code = cell[1][1..7];
			
			if(code !in _bs) { // 없으면 신규 등록
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
				
				_bs[newBs.code] = newBs;
			}

			Statement st = Statement();
			st.currency = cell[9]; // 통화코드
			st.ifrsCode = strip(cell[10]); // 항목코드
			st.rowName = strip(cell[11]); // 항목명
			st.setMoney(cell[12], cell[13], cell[14]);
			_bs[code].statements ~= st;
		}
        
		f.close();
        rpt.balance = _bs;
	}
}