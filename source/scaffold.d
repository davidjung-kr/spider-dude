module com.davidjung.spider.scaffold;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.stdio;
import std.datetime;
import std.math;
import std.conv;
import com.davidjung.spider.parser;
import com.davidjung.spider.types;
import com.davidjung.spider.formula;
import com.davidjung.spider.report;
import com.davidjung.spider.downloader;

class NetNetStocks {
	this(Period period, ReportType reportType) {
		Report myReport = new Report();
		Downloader krxClient = new Downloader();
		krxClient.readKrxCapAllByBlock(Date(2022, 04, 04), myReport);

		Parser bsOfs2021Y4 = new Parser("2021", period, reportType, StatementType.BS);
		bsOfs2021Y4.read(myReport);

		Parser isOfs2021Y4 = new Parser("2021", period, reportType, StatementType.CIS);
		isOfs2021Y4.read(myReport);
		
		// 4. 비정상 종목 필터링
		myReport.filteringOnlyListed();			   // 비상장 종목
		myReport.filteringNotCapZero();			   // 상장폐지 종목
		myReport.filteringNotChineseCompany();     // 중국회사 제거
		myReport.filteringIntersectionCorpCode();  // 재무데이터 있는 종목만 남기기
		
		Formula f1 = new Formula(myReport);
		auto result = f1.query([FormulaName.NCAV, FormulaName.PER]);
		auto ncavs = result["NCAV"];
		auto pers = result["PER"];

		string current = Clock.currTime().toISOString();
		File ff = File("NetNetStocks_"~current~".txt", "w");
		ff.writeln("종목코드\t종목명\tCAP\tCurrent cash\t매출액\t당기순이익\tPER\t주가수익률\tNCAV");
		for(int i=0; i<ncavs.length; i++) {
			FormulaResult ncav = ncavs[i];
			FormulaResult per = pers[i];

			long cap = cast(long)round(myReport.getMarketCap(ncav.code));

			Bs bs = myReport.getBalanceStatement(ncav.code);
			Cis cis = myReport.getComprehensiveIncomeStatement(ncav.code);
			long revenue = cis.q(IfrsCode.FULL_REVENUE);
			long profitloss = cis.q(IfrsCode.FULL_PROFITLOSS);

			//float netProfit = profitloss/revenue;
			ff.writef("%s\t%s\t%d\t%d\t%d\t%d\t%f\t%f\t%f\n",
				ncav.code,
				myReport.getCorpName(ncav.code),
				cap,
				bs.getCurrentTerm(IfrsCode.FULL_CURRENTASSETS),
				cis.q(IfrsCode.FULL_REVENUE),
				cis.q(IfrsCode.FULL_PROFITLOSS),
				per.ratio,
				1/per.ratio,
				ncav.value
				);
		}
	}
}

class GpaStocks {
	this(Period period, ReportType reportType) {
		Report myReport = new Report();
		Downloader krxClient = new Downloader();
		krxClient.readKrxCapAllByBlock(Date(2022, 04, 04), myReport);

		Parser bsOfs2021Y4 = new Parser("2021", period, reportType, StatementType.BS);
		bsOfs2021Y4.read(myReport);

		Parser isOfs2021Y4 = new Parser("2021", period, reportType, StatementType.CIS);
		isOfs2021Y4.read(myReport);
		
		// 4. 비정상 종목 필터링
		myReport.filteringOnlyListed();			   // 비상장 종목
		myReport.filteringNotCapZero();			   // 상장폐지 종목
		myReport.filteringNotChineseCompany();     // 중국회사 제거
		myReport.filteringIntersectionCorpCode();  // 재무데이터 있는 종목만 남기기
		
		Formula f1 = new Formula(myReport);
		auto result = f1.query([FormulaName.GP_A, FormulaName.PBR, FormulaName.PER]);
		auto gpas = result["GP/A"];
		auto pbrs = result["PBR"];
		auto pers = result["PER"];

		string current = Clock.currTime().toISOString();
		File ff = File("GpaStocks_"~current~".txt", "w");

		
		ff.writeln("2021 / "~GetCodeFrom.period(period)~" / ["~GetCodeFrom.reportType(reportType)~"]");
		ff.writeln("종목코드\t종목명\t자산총계\t매출총이익\tGP/A\tPBR\tPER");
		for(int i=0; i<gpas.length; i++) {
			FormulaResult pbr = pbrs[i];
			FormulaResult gpa = gpas[i];
			FormulaResult per = pers[i];

			Cis income = myReport.getComprehensiveIncomeStatement(pbr.code);
			Bs balance = myReport.getBalanceStatement(pbr.code);

			ff.writef("'%s\t%s\t%d\t%d\t%f\t%f\t%f\n",
				pbr.code,
				myReport.getCorpName(pbr.code),
				balance.getCurrentTerm(IfrsCode.FULL_ASSETS),
				income.q(IfrsCode.FULL_GROSSPROFIT),
				gpa.ratio,
				pbr.ratio,
				per.ratio
			);
		}
	}
}

class LowPerStocks {
	this(ReportType reportType) {
		Report[string] reports = [
			"2017":new Report(),
			"2018":new Report(),
			"2019":new Report(),
			"2020":new Report(),
			"2021":new Report(),
		];
		/*
		Downloader krxClient = new Downloader();
		krxClient.readKrxCapAllByBlock(Date(2018, 04, 04), reports["2018"]);
		krxClient.readKrxCapAllByBlock(Date(2019, 04, 04), reports["2019"]);
		krxClient.readKrxCapAllByBlock(Date(2020, 04, 03), reports["2020"]);
		krxClient.readKrxCapAllByBlock(Date(2021, 04, 02), reports["2021"]);

		foreach(year; reports.keys) {
			Parser forBalance = new Parser(year, Period.Y4, reportType, StatementType.BS);
			Parser forIncome = new Parser(year, Period.Y4, reportType, StatementType.CIS);
			forBalance.read(reports[year]);
			forIncome.read(reports[year]);

			reports[year].filteringOnlyListed(); // 비상장 종목
			reports[year].filteringNotChineseCompany();     // 중국회사 제거
			reports[year].filteringIntersectionCorpCode();  // 재무데이터 있는 종목만 남기기
		}

		foreach(reports["2017"].getListShared()) {
		
			Cis cis = reports[year].getComprehensiveIncomeStatement();	
		}*/
	}
}

/// 보고서 기본 컬럼목록
struct DefaultRow {
	string corpCode; /// 종목코드
	string corpName; /// 종목명
	ulong marketCap; /// 시가총액
	ulong listedShares; /// 상장주식수
	uint closePrice; /// 종가
	ulong fullCurrentAssets; // 유동자산
	ulong fullCashAndCashEquivalents; // 현금성자산
}

class DefaultReport {
	private Report rpt;
	this(Date ymd, Period period, ReportType reportType) {
		this.rpt = new Report();
		Downloader krxClient = new Downloader();
		krxClient.readKrxCapAllByBlock(ymd, this.rpt);

		string year = ymd.year.to!string;
		Parser balacneSheet = new Parser(year, period, reportType, StatementType.BS);
		balacneSheet.read(this.rpt);
		Parser incomeSheet = new Parser(year, period, reportType, StatementType.CIS);
		incomeSheet.read(this.rpt);
		
		//this.rpt.filteringOnlyListed();			   // 비상장 종목
		//this.rpt.filteringNotCapZero();			   // 상장폐지 종목
		//this.rpt.filteringNotChineseCompany();     // 중국회사 제거
		//this.rpt.filteringIntersectionCorpCode();  // 재무데이터 있는 종목만 남기기
	}

	public DefaultRow[] fetch() {
		string[] codes = this.rpt.getCorpCodes();
		DefaultRow[] rows;

		// 재무제표
		for(int i=0; i<codes.length; i++) {
			string code = codes[i]; /// 종목코드
			
			if(rpt.haveBalanceStatement(code)==false) {
				import std.stdio;
				writef("[%s(%s)]는 재무제표가 없어 스킵합니다.\n", rpt.getCorpName(codes[i]), code);
				continue;
			}

			DefaultRow row = DefaultRow();
			row.corpCode = code;
			row.corpName = rpt.getCorpName(codes[i]); /// 종목명
			row.marketCap = rpt.getMarketCap(codes[i]); /// 시가총액
			row.listedShares = rpt.getListShared(codes[i]); /// 상장주식수
			row.closePrice = rpt.getClosePrice(codes[i]); /// 종가
			
			Bs balance = rpt.getBalanceStatement(codes[i]);
			row.fullCurrentAssets = balance.getCurrentTerm(IfrsCode.FULL_CURRENTASSETS);
			row.fullCashAndCashEquivalents = balance.getCurrentTerm(IfrsCode.FULL_CASH_AND_CASH_EQUIVALENTS);	
			rows ~= row;
		}
		return rows;
	}
}