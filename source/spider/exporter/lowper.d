module spider.exporter.lowper;

import std.stdio: File;
import std.datetime: Date, Clock;
import std.math: round;

import spider.report;
import spider.importer.dart_file;
import spider.loader.report_loader;
import spider.formula.enums;
import spider.formula.formula;
import spider.formula.result;
import spider.client.dart.model.bs;
import spider.client.dart.model.cis;
import spider.client.dart.enums.to;
import spider.client.dart.enums.period;
import spider.client.dart.enums.accounts;
import spider.client.dart.enums.statement;
import spider.client.dart.enums.report_type;

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
		ReportLoader loader = new ReportLoader();
		loader.readKrxCapAllByBlock(Date(2018, 04, 04), reports["2018"]);
		loader.readKrxCapAllByBlock(Date(2019, 04, 04), reports["2019"]);
		loader.readKrxCapAllByBlock(Date(2020, 04, 03), reports["2020"]);
		loader.readKrxCapAllByBlock(Date(2021, 04, 02), reports["2021"]);

		foreach(year; reports.keys) {
			Parser forBalance = new Parser(year, Period.Y4, reportType, StatementDART.BS);
			Parser forIncome = new Parser(year, Period.Y4, reportType, StatementDART.CIS);
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