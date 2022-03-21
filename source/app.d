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
	Report rpt = new Report();
	
	Parser incomeOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.CFS, StatementType.IS);
	incomeOfs2021Y3.read(rpt);

	writeln(rpt.income["005930"].q(IfrsCode.FULL_PROFITLOSS));

	/*
	// 시가총액정보
	Downloader krxClient = new Downloader();
	krxClient.readKrxCapAllByBlock(Date(2022,03,21), rpt);
	// File name: 2021_3Q_OFS_IS_20220215.txt → 2021년 3분기 연결 재무제표
	Parser bsOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.BS);
	bsOfs2021Y3.read(rpt);

	// 상장종목만 남기기
	rpt.onlyListed();

	// NCAV 공식적용
	Formula netNetStocks = new Formula(rpt);

	// NCAV 결과 취득
	File fs = File("MY_NCAV_"~bsOfs2021Y3.fileName, "w");
	fs.writeln("CorpCode\tCorpName\tNCAV");
	foreach(ncav; netNetStocks.query([FormulaName.NCAV])["NCAV"]) {
		if(ncav.value > 0 && ncav.value > rpt.getMarketCap(ncav.code)) {
			fs.writef("%s\t%s\t%f\n", ncav.code, rpt.getCorpName(ncav.code), ncav.value);
		}
	}
	fs.close();*/
}