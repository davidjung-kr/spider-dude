/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 06, 2023
 * Authors: David Jung
 * License: GPL-3.0
 */

/** SAMPLE REPORT SQL */
SELECT	krx."mktId"
	 ,	krx."corpCd"
	 ,	krx."corpNm"
	 ,	krx."cap"
	 ,	krx."shares"
	 ,	krx."close"
	 ,	bs."fullAssets"
	 ,	bs."fullCurrentAssets"
	 ,	bs."fullCashAndCashEquivalents"
	 ,	bs."fullCurrentLiabilities"
	 ,	bs."fullLiabilities"
	 ,	cis."fullProfitloss"
	 ,	cis."fullProfitLossBeforeTax"
	 ,	cis."fullProfitLossAttributableToOwnersOfParent"
	 ,	cis."operatingIncomeLoss"
	 ,	cis."fullGrossProfit"
FROM krx
	LEFT JOIN bs  ON (krx.corpCd = bs.corpCd)
	LEFT JOIN cis ON (
			bs.baseYear = cis.baseYear
		AND bs.basePeriod  = cis.basePeriod
		AND bs.reportType = cis.reportType
		AND bs.corpCd = cis.corpCd
	)
WHERE 1=1
	AND krx.baseYmd = '20221229'
	AND bs.baseYear = '2022'
	AND bs.basePeriod  = '4Q'
	AND bs.reportType = 'CFS'