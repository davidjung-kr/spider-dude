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
import com.davidjung.spider.parser;
import com.davidjung.spider.types;
import com.davidjung.spider.formula;

void main() {
	Report rpt = new Report();

	// File name: 2021_3Q_OFS_IS_20220215.txt → 2021년 3분기 연결 재무제표
	Parser bsOfs = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.BS);
	bsOfs.read(rpt);

	// NCAV 공식적용
	Formula netNetStocks = new Formula(rpt);

	// NCAV 결과 취득
	File fs = File("my_ncav_stock_list.txt", "w");
	fs.writeln("CorpCode\tNCAV");
	foreach(ncav; netNetStocks.query([FormulaName.NCAV])["NCAV"]) {
		if(ncav.value > 0) {
			fs.write(ncav.code);
			fs.write("\t");
			fs.writeln(ncav.value);
		}
	}
	fs.close();
}