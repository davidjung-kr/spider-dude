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
        writeln("Please load a sample reports from scaffold.d");
        auto report = new DefaultReport(
                Date(2022, 11, 25),
                Period.Y3,
                ReportType.OFS
        );

        File f = File("default_report.csv", "w");
        DefaultRow[] rows = report.fetch();
        f.writeln(rows[0].getColumnsLine());
        foreach(DefaultRow row; rows) {
                f.writeln(row.getDatasLine());
        }
        f.close();
}