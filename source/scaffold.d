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
import com.davidjung.spider.parser;
import com.davidjung.spider.types;
import com.davidjung.spider.formula;
import com.davidjung.spider.report;
import com.davidjung.spider.downloader;

class NetNetStocks {
	this(Period period, ReportType reportType) {
		Report myReport = new Report();
		Downloader krxClient = new Downloader();
		krxClient.readKrxCapAllByBlock(Date(2022, 03, 31), myReport);

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
		ff.writeln("종목코드\t종목명\tCAP\tCurrent cash\t매출액\t당기순이익\tPER");
		for(int i=0; i<ncavs.length; i++) {
			FormulaResult ncav = ncavs[i];
			FormulaResult per = pers[i];

			long cap = cast(long)round(myReport.getMarketCap(ncav.code));

			Bs bs = myReport.getBalanceStatement(ncav.code);
			Cis cis = myReport.getComprehensiveIncomeStatement(ncav.code);
			long revenue = cis.q(IfrsCode.FULL_REVENUE);
			long profitloss = cis.q(IfrsCode.FULL_PROFITLOSS);

			//float netProfit = profitloss/revenue;
			if(ncav.value > cap) {
				ff.writef("%s\t%s\t%d\t%d\t%d\t%d\t%f\n",
					ncav.code,
					myReport.getCorpName(ncav.code),
					cap,
					bs.q(IfrsCode.FULL_CURRENTASSETS),
					cis.q(IfrsCode.FULL_REVENUE),
					cis.q(IfrsCode.FULL_PROFITLOSS), per.ratio);
			}
		}
	}
}