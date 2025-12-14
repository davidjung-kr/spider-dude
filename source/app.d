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

import spider.database.table.krx: TableKRX;
import spider.application.etl: ETLKRXApplication, ETLKRXApplicationContext;
import spider.application.parent: IApplication;

void main() {
    
    TableKRX tbKRX = new TableKRX();
    scope(exit) tbKRX.close();
    tbKRX.createIfNotExists();
    tbKRX.createIndexes();

    // SysTime taskYMS = Clock.currTime();
    // Date taskYMD = Date(taskYMS.year, taskYMS.month, taskYMS.day);
    IApplication[] appQueue = [
        new ETLKRXApplication(new ETLKRXApplicationContext(tbKRX, Date(2025, 11, 01), Date(2025, 12, 10), 3000)),
    ];
    
    // while(true) {
    //     foreach(IApplication app; appQueue) {
    //         app.tick();
    //     }
    // }
    appQueue[0].tick();
}