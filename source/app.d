module com.davidjung.spider.app;

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
import com.davidjung.spider.parser;
import com.davidjung.spider.types;
import com.davidjung.spider.formula;
import com.davidjung.spider.report;
import com.davidjung.spider.downloader;

void main() {
	// 내 보고서
	Report myReport = new Report();
	
	// 1. 거래소 데이터 적재 (2022년 3월 21일 기준)
	Downloader krxClient = new Downloader();
	krxClient.readKrxCapAllByBlock(Date(2022, 03, 28), myReport);

	Parser bsOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.CFS, StatementType.BS);
	bsOfs2021Y3.read(myReport);

	Parser isOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.CFS, StatementType.IS);
	isOfs2021Y3.read(myReport);
	
	// 4. 비정상 종목 필터링
	// myReport.filteringOnlyListed();				-- 비상장 종목
	// myReport.filteringNotCapZero();				-- 상장폐지 종목
	// myReport.filteringNotChineseCompany();		-- 중국회사 제거
	myReport.filteringIntersectionCorpCode(); //	-- 재무데이터 있는 종목만 남기기

	Formula f1 = new Formula(myReport);
	foreach(per; f1.per()) {
		writef("[%s] PER: %f\n", per.code, per.ratio);
	}

	Formula f2 = new Formula(myReport);
	foreach(evEbita; f1.per()) {
		writef("[%s] EV/EBITA: %f\n", evEbita.code, evEbita.ratio);
	}
}