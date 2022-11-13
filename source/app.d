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
import com.davidjung.spider.types;
import com.davidjung.spider.scaffold;

void main() {
        //new NetNetStocks(Period.Y4, ReportType.OFS);
        writeln("Please load a sample reports from scaffold.d");
        auto report = new DefaultReport(
                Date(2022, 11, 11),
                Period.Y3,
                ReportType.OFS
        );
        
        DefaultRow[] rows = report.fetch();
        foreach(DefaultRow row; rows) {
                writeln(row);
        }
}