module spider.exporter.model.general;

import std.string: format;
import std.conv: to;

/// 보고서 기본 컬럼목록
struct GeneralRow {
	string mktId; /// 시장구분
	string corpCode; /// 종목코드
	string corpName; /// 종목명
	ulong marketCap; /// 시가총액
	ulong listedShares; /// 상장주식수
	uint closePrice; /// 종가
	ulong fullAssets; // 자산총계	
	ulong fullCurrentAssets; // 유동자산
	ulong fullCashAndCashEquivalents; // 현금성자산
	ulong fullCurrentLiabilities; // 유동부채
	ulong fullLiabilities; // 총부채
	long fullProfitloss; // 당기순이익
	long fullProfitLossBeforeTax; // 법인세차감전순이익
	long fullProfitLossAttributableToOwnersOfParent; // 지배기업 소유주지분 순이익
	long operatingIncomeLoss; // 영업이익
	long fullGrossProfit; // 매출총이익
	
	// private string columnLayout = "%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s";
	// private string dataLayout = "%s;'%s;%s;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d";
	private string columnLayout = "%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s";
	private string dataLayout = "%s;'%s;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d";


	public string getColumnsLine() {
			return columnLayout.format(
			"mktId", "corpCode", "marketCap", "listedShares", "closePrice",
			"fullAssets", "fullCurrentAssets", "fullCashAndCashEquivalents", "fullCurrentLiabilities","fullLiabilities",
			"fullProfitloss", "fullProfitLossBeforeTax", "fullProfitLossAttributableToOwnersOfParent", "operatingIncomeLoss",
			"fullGrossProfit");

		// return columnLayout.format(
		// 	"mktId", "corpCode", "corpName", "marketCap", "listedShares", "closePrice",
		// 	"fullAssets", "fullCurrentAssets", "fullCashAndCashEquivalents", "fullCurrentLiabilities","fullLiabilities",
		// 	"fullProfitloss", "fullProfitLossBeforeTax", "fullProfitLossAttributableToOwnersOfParent", "operatingIncomeLoss",
		// 	"fullGrossProfit");
	}

	public string getUnicodeLIne() {
		return mktId~","~corpCode~","~corpName~","~to!string(marketCap)~","~to!string(listedShares)~","~to!string(closePrice)~","~
			to!string(fullAssets)~","~to!string(fullCurrentAssets)~","~to!string(fullCashAndCashEquivalents)~","~
			to!string(fullCurrentLiabilities)~","~to!string(fullLiabilities)~","~to!string(fullProfitloss)~","~
			to!string(fullProfitLossBeforeTax)~","~to!string(fullProfitLossAttributableToOwnersOfParent)~","~
			to!string(operatingIncomeLoss)~","~to!string(fullGrossProfit);
	}

	public string getDatasLine() {
		return dataLayout.format(
			mktId, corpCode, marketCap, listedShares, closePrice,
			fullAssets, fullCurrentAssets, fullCashAndCashEquivalents, fullCurrentLiabilities, fullLiabilities,
			fullProfitloss, fullProfitLossBeforeTax, fullProfitLossAttributableToOwnersOfParent, operatingIncomeLoss,
			fullGrossProfit);
	}
}