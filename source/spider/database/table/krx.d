module spider.database.table.krx;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.table.object: SQLite3TableObject;
import spider.database.sql.mapper: SQLMapper;
import spider.database.sql.krx: SQL_TB_KRX;
import spider.database.model.krx: RowKRX;

import ddbc;

class TableKRX : SQLite3TableObject {
    this() {
        super(SQLite3Table.KRX_FILE_FULL_PATH);
    }

    void createIfNotExists() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_KRX.CREATE_TABLE_IF_NOT_EXISTS);
    }

    void createIndexes() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_KRX.CREATE_INDEX_PK);
    }

    void insert(RowKRX row) {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQLMapper.KRX.ofINSERT(row));
    }
}

unittest {
    TableKRX tb = new TableKRX();
    scope(exit) {
        tb.close();
        //tb.rmTbFile();
    }
    // tb.createIfNotExists();
    // tb.createIndexes();

    // import std.datetime;
    // import spider.client.krx.model.outblock: OutBlock;
    // import spider.client.krx.datakrx: DataKrx;
    // import std.parallelism: parallel;
    
    // foreach(OutBlock block; parallel(DataKrx.getBldAttendant(Date(2025, 11, 28)).blocks) ) {
    //     tb.insert(RowKRX.from("20251128", block));
    // }
}