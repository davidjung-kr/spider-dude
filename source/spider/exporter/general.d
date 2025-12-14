module spider.exporter.general;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv;
import std.datetime;
import std.format: format;
import std.math;
import std.stdio;

import spider.report;
import spider.formula.enums;
import spider.formula.formula;
import spider.formula.result;
import spider.client.dart.consts;
import spider.client.dart.enums.to;
import spider.client.dart.enums.report;
import spider.client.dart.enums.account;
import spider.client.dart.model.bs;
import spider.client.dart.model.si;
import spider.loader.report_loader;
import spider.client.dart.parser: DartReportFileParser;
import spider.exporter.model.general;

class GeneralReport {
	private Report rpt;
	this(Date ymd, string rptYear, Period period, ReportType reportType) {
		this.rpt = new Report();
		ReportLoader.krxCapAllBlock(ymd, this.rpt);

		DartReportFileParser balacneSheet = new DartReportFileParser(rptYear, period, reportType, ReportStatement.BS);
		balacneSheet.read(this.rpt);
		DartReportFileParser incomeSheet = new DartReportFileParser(rptYear, period, reportType, ReportStatement.SCI);
		incomeSheet.read(this.rpt);

		this.rpt.filteringIntersectionCorpCode();
		
		//this.rpt.filteringOnlyListed(); // 비상장 종목
		//this.rpt.filteringNotCapZero(); // 상장폐지 종목
		//this.rpt.filteringNotChineseCompany(); // 중국회사 제거
		//this.rpt.filteringIntersectionCorpCode(); // 재무데이터 있는 종목만 남기기
	}

	public GeneralRow[] fetch() {
		string[] codes = this.rpt.getCorpCodes();
		GeneralRow[] rows;

		// 재무제표
		for(int i=0; i<codes.length; i++) {
			string code = codes[i]; /// 종목코드
			
			if(rpt.haveBalanceStatement(code)==false) {
				import std.stdio;
				writef("[%s(%s)]는 재무제표가 없어 스킵합니다.\n", rpt.getCorpName(codes[i]), code);
				continue;
			}

			GeneralRow row = GeneralRow();
			row.corpCode = code;
			row.mktId = rpt.getMarketId(codes[i]); /// 시장구분
			row.corpName = rpt.getCorpName(codes[i]); /// 종목명
			row.marketCap = rpt.getMarketCap(codes[i]); /// 시가총액
			row.listedShares = rpt.getListShared(codes[i]); /// 상장주식수
			row.closePrice = rpt.getClosePrice(codes[i]); /// 종가
			
			DartBS balance = rpt.getBalanceStatement(codes[i]);
			row.fullAssets = balance.getCurrentTerm(Account.FULL_ASSETS);
			row.fullCurrentAssets = balance.getCurrentTerm(Account.FULL_CURRENTASSETS);
			row.fullCashAndCashEquivalents = balance.getCurrentTerm(Account.FULL_CASH_AND_CASH_EQUIVALENTS);
			row.fullCurrentLiabilities = balance.getCurrentTerm(Account.FULL_CURRENT_LIABILITIES);
			row.fullLiabilities = balance.getCurrentTerm(Account.FULL_LIABILITIES);

			DartSI si = rpt.getComprehensiveIncomeStatement(codes[i]);
			row.fullProfitloss = si.q(Account.FULL_PROFITLOSS);
			row.fullProfitLossBeforeTax = si.q(Account.FULL_PROFIT_LOSS_BEFORE_TAX);
			row.fullProfitLossAttributableToOwnersOfParent = si.q(Account.FULL_PROFIT_LOSS_ATTRIBUTABLE_TO_OWNERS_OF_PARENT);
			row.operatingIncomeLoss = si.queryDartStatement(Account.OPERATING_INCOME_LOSS);
			row.fullGrossProfit = si.q(Account.FULL_GROSSPROFIT);
			rows ~= row;
		}
		return rows;
	}
}