module spider.exporter.gpa;

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

class GpaStocks {
	this(Period period, ReportType reportType) {
		Report myReport = new Report();
		ReportLoader.krxCapAllBlock(Date(2022, 04, 04), myReport);

		DartFileImporter bsOfs2021Y4 = new DartFileImporter("2021", period, reportType, StatementDART.BS);
		bsOfs2021Y4.read(myReport);

		DartFileImporter isOfs2021Y4 = new DartFileImporter("2021", period, reportType, StatementDART.CIS);
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

		
		ff.writeln("2021 / "~EnumTo.period(period)~" / ["~EnumTo.reportType(reportType)~"]");
		ff.writeln("종목코드\t종목명\t자산총계\t매출총이익\tGP/A\tPBR\tPER");
		for(int i=0; i<gpas.length; i++) {
			FormulaResult pbr = pbrs[i];
			FormulaResult gpa = gpas[i];
			FormulaResult per = pers[i];

			DartCIS income = myReport.getComprehensiveIncomeStatement(pbr.code);
			DartBS balance = myReport.getBalanceStatement(pbr.code);

			ff.writef("'%s\t%s\t%d\t%d\t%f\t%f\t%f\n",
				pbr.code,
				myReport.getCorpName(pbr.code),
				balance.getCurrentTerm(AccountIFRS.FULL_ASSETS),
				income.q(AccountIFRS.FULL_GROSSPROFIT),
				gpa.ratio,
				pbr.ratio,
				per.ratio
			);
		}
	}
}