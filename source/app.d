module com.davidjung.spider.app;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import com.davidjung.spider.scaffold;
import com.davidjung.spider.types;

extern(Windows) int SetConsoleOutputCP(uint);

void main() {
	if(SetConsoleOutputCP(65001) == 0)
        throw new Exception("Failed");

        new NetNetStocks(Period.Y4, ReportType.OFS);
}