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
	krxClient.readKrxCapAllByBlock(Date(2022, 03, 21), myReport);

	// 2. 재무상태표를 내 보고서에 적재 (2021_3Q_OFS_BS_20220215.txt → 2021년 3분기 연결 재무제표)
	Parser bsOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.BS);
	bsOfs2021Y3.read(myReport);

	// 3. 손익계산서를 내 보고서에 적재 (2021_3Q_OFS_IS_20220215.txt → 2021년 3분기 연결 손익계산서)
	Parser isOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.IS);
	isOfs2021Y3.read(myReport);

	// 4. 비정상 종목 필터링
	//	- 비상장 종목, 상장폐지 종목, 중국회사 제거
	myReport.filteringOnlyListed();
	myReport.filteringNotCapZero();
	myReport.filteringNotChineseCompany();

	// 5. 원하는 밸류에이션 지표 적용
	/// - 예) PBR이 1 이하 주식 찾기
	Formula pbrFilter = new Formula(myReport);
	foreach(stock; pbrFilter.query([FormulaName.PBR])["PBR"]) {
		writef("[%s] %f\n", stock.code, stock.value);
	}
}