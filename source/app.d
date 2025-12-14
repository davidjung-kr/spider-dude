module app;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.datetime: SysTime, Date, Clock;

import spider.client.dart.model.reportinfo: ReportInfo;
import spider.client.dart.enums.report: ReportFileType, ReportType, Period;
import spider.database.table.dart: TableDartBS, TableDartSI;
import spider.database.table.krx: TableKRX;
import spider.application.etlkrx: ETLKRXApplication, ETLKRXApplicationContext;
import spider.application.etldart: ETLOpenDartApplication, ETLOpenDartApplicationContext;
import spider.application.parent: IApplication;

void main() {
    
    TableKRX tbKRX = new TableKRX();
    scope(exit) tbKRX.close();
    tbKRX.createIfNotExists();
    tbKRX.createIndexes();

    TableDartBS tbDartBS = new TableDartBS();
    scope(exit) tbDartBS.close();
    tbDartBS.createIfNotExists();
    tbDartBS.createIndexes();

    TableDartSI tbDartSI = new TableDartSI();
    scope(exit) tbDartSI.close();
    tbDartSI.createIfNotExists();
    tbDartSI.createIndexes();
    
    ReportInfo[] reportInfo = [
        ReportInfo(2024, ReportType.OFS, ReportFileType.BS, Period.Q1)
    ];

    // SysTime taskYMS = Clock.currTime();
    // Date taskYMD = Date(taskYMS.year, taskYMS.month, taskYMS.day);
    IApplication[] appQueue = [
        //new ETLKRXApplication(new ETLKRXApplicationContext(tbKRX, Date(2025, 1, 1), Date(2025, 3, 31), 3000)),
        new ETLOpenDartApplication(new ETLOpenDartApplicationContext(
            tbDartBS, tbDartSI, reportInfo
        ))
    ];
    
    // while(true) {
    //     foreach(IApplication app; appQueue) {
    //         app.tick();
    //     }
    // }
    //appQueue[0].tick();
}