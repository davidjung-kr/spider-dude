module spider.exporter.netnet;

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
import spider.client.dart.enums.period;
import spider.client.dart.enums.accounts;
import spider.client.dart.enums.statement;
import spider.client.dart.enums.report_type;

class NetNetStocks {
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

			DartBS bs = myReport.getBalanceStatement(ncav.code);
			DartCIS cis = myReport.getComprehensiveIncomeStatement(ncav.code);
			long revenue = cis.q(AccountIFRS.FULL_REVENUE);
			long profitloss = cis.q(AccountIFRS.FULL_PROFITLOSS);

			//float netProfit = profitloss/revenue;
			ff.writef("%s\t%s\t%d\t%d\t%d\t%d\t%f\t%f\t%f\n",
				ncav.code,
				myReport.getCorpName(ncav.code),
				cap,
				bs.getCurrentTerm(AccountIFRS.FULL_CURRENTASSETS),
				cis.q(AccountIFRS.FULL_REVENUE),
				cis.q(AccountIFRS.FULL_PROFITLOSS),
				per.ratio,
				1/per.ratio,
				ncav.value
				);
		}
	}
}