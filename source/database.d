module com.davidjung.spider.database;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.stdio;
import std.string;
import std.array:appender;
import mysql.safe;
import asdf;

enum CSQL {
    CREATE_TABLE = "X"
}

struct ConnectionData {
    string host = "";
    ulong port = 0;
    string user = "";
    string pwd = "";
}

class DatabaseHandler {
    this() {
        File f = File("db.conf", "r");
        auto content = appender!string;
        while(!f.eof()) {
            content.put(f.readln());
        }
        f.close();
        ConnectionData dbConf = content.data.deserialize!ConnectionData;
        auto con = new Connection("host=%s;port=%d;user=%s;pwd=%s;db=SPIDER_DUDE".format(
            dbConf.host,
            dbConf.port,
            dbConf.user,
            dbConf.pwd
        ));
    }
}

unittest {
    DatabaseHandler db = new DatabaseHandler();
}