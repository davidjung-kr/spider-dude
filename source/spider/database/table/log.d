module spider.database.table.log;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.sql.log: SQL_TB_LOG;
import spider.database.sql.mapper: SQLMapper;
import spider.database.model.row_log: RowLog;
import spider.database.table.object: SQLite3TableObject;

import ddbc;

class TableLog : SQLite3TableObject {
    this() {
        super(SQLite3Table.LOG_FILE_FULL_PATH);
    }

    void createTable() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_LOG.CREATE_TABLE_IF_NOT_EXISTS);
    }

    void createIndexes() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_LOG.CREATE_INDEX_PK);
        tx.executeUpdate(SQL_TB_LOG.CREATE_INDEX_1);
        tx.executeUpdate(SQL_TB_LOG.CREATE_INDEX_2);
    }

    void insert(RowLog row) {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQLMapper.Log.ofInsert(row));
    }
}

unittest {

    TableLog tb = new TableLog();
    scope(exit) tb.close();
    tb.createTable();
    tb.createIndexes();

    RowLog row = RowLog.byNew("test", `{"request":"pong"}`);
    tb.insert(row);
    tb.insert(row.byUpdate(`{"response":"pong"}`));
}