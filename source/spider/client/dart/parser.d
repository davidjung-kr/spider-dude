module spider.client.dart.parser;

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

import std.conv: to;
import spider.report;
import spider.client.dart.consts;
import spider.client.dart.enums.to;
import spider.client.dart.enums.report;
import spider.client.dart.enums.account: Account;
import spider.client.dart.model.bs;
import spider.client.dart.model.bs_item;
import spider.client.dart.model.si;
import spider.client.dart.model.si_item;
import spider.database.model.dart: RowDartBS;

struct ReportParsingRule {
    public static string corpCd(string[] cells) {
        return cells[1][1..7];
    }

    public static ItemBS eqItemOfBS(string[] cells, Account eqAcc) {
        if (false==(cells[10] == to!string(eqAcc))) {
            return ItemBS.makeEmpty();
        }
        return ItemBS(
            cells[9],  // 통화코드
            cells[10], // 항목코드
            cells[11], // 항목명
            cells[12], // 당기
            cells[13], // 전기
            cells[14]  // 전전기
        );
    }
}
/**
 * DART 재무데이터 파서
 *
 * Check out: https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do
 */
class DartReportFileParser {
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
    private ReportStatement _statementType;
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
    this(string year, Period p, ReportType rt, ReportStatement st) {
        this._year = year;
        this._period = p;
        this._reportType = rt;
        this._statementType = st;
        string pattern =  format("%s_%s_%s_%s_*.txt",
                                    year,
                                    EnumTo.period(p),
                                    EnumTo.reportType(rt),
                                    st);
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
        case ReportStatement.BS: this.colSize = 13; break;
        case ReportStatement.CSI: this.colSize = 16; break;
        default: break;
        }
    }

    /**
     * 읽기
     */
    public void read(ref Report rpt) {
        switch(this._statementType) {
        case ReportStatement.BS: readBalanceSheet(rpt); break;
        case ReportStatement.CSI: readIncomeSheet(rpt); break;
        case ReportStatement.SCI:readComprehensiveIncomeSheet(rpt); break;
        default: break;
        }
    }

    /**
     * 손익계산서 로드
     */
    private void readIncomeSheet(ref Report rpt) {
        DartSI[string] incomeSheet;
        File f = File(this._fileName, "r");
        f.readln();
        while(!f.eof()) {
            string line = f.readln();
            string[] cell = line.split("\t");
            if(cell.length <= 0) continue;
            string code = ReportParsingRule.corpCd(cell);

            if(code !in incomeSheet) { // 없으면 신규 등록
                DartSI newIncomeSheet = DartSI(this._period);
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

            ItemSI item = ItemSI(
                cell[9], // 통화코드
                cell[10], // 항목코드
                cell[11] // 항목명
            );
            item.setCurrentAmount(    cell[12], this._period == Period.Q4 ? cell[12]:cell[13]); // 당기
            item.setFirstPeriodAmount(cell[14], this._period == Period.Q4 ? cell[14]:cell[15]); // 전기
            item.setFirstPeriodAmount(cell[16], this._period == Period.Q4 ? cell[16]:cell[17]); // 전전기
            incomeSheet[code].items ~= item;
        }
        f.close();
        rpt.income = incomeSheet;
    }

    /**
     * 포괄손익계산서 로드
     */
    private void readComprehensiveIncomeSheet(ref Report rpt) {
        DartSI[string] comprehensiveIncomeSheet;
        File f = File(this._fileName, "r");
        f.readln();
        while(!f.eof()) {
            string line = f.readln();
            string[] cell = line.split("\t");
            if(cell.length <= 0) continue;
            string code = ReportParsingRule.corpCd(cell);

            if(code !in comprehensiveIncomeSheet) { // 없으면 신규 등록
                DartSI newComprehensiveIncomeSheet = DartSI(this._period);
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
            
            ItemSI item = ItemSI(
                cell[9], // 통화코드
                cell[10], // 항목코드
                cell[11] // 항목명
            );

            if(this._period == Period.Q4) {
                item.setCurrentAmount(cell[13], cell[13]); // 당기
                item.setFirstPeriodAmount(cell[16], cell[16]); // 전기
                item.setPreviousAmount(cell[17], cell[17]); // 전전기
            } else {
                item.setCurrentAmount(cell[12], cell[13]); // 당기
                item.setFirstPeriodAmount(cell[14], cell[15]); // 전기
                item.setPreviousAmount(cell[16], cell[17]); // 전전기
            }
            comprehensiveIncomeSheet[code].items ~= item;
        }
        f.close();
        rpt.comprehensiveIncome = comprehensiveIncomeSheet;
    }

    private void readBalanceSheet(ref Report rpt) {
        DartBS[string] bs;

        File f = File(this._fileName, "r");
        f.readln();
        while(!f.eof()) {
            string line = f.readln();
            string[] cell = line.split("\t");

            if(cell.length <= 0) continue;
            
            string code = ReportParsingRule.corpCd(cell);
            
            if(code !in bs) { // 없으면 신규 등록
                DartBS newBs;
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

            ItemBS item = ItemBS(
                cell[9],  // 통화코드
                cell[10], // 항목코드
                cell[11], // 항목명
                cell[12], // 당기
                cell[13], // 전기
                cell[14]  // 전전기
            );
            bs[code].items ~= item;
        }
        
        f.close();
        rpt.balance = bs;
    }   
}