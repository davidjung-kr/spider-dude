module spider.database.table.krx;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.table.object: SQLite3TableObject;
import spider.database.sql.krx: SQL_TB_KRX, KRXSQL;
import spider.database.model.row_krx: RowKRX;

import ddbc;

class TableKRX : SQLite3TableObject {
    this() {
        super(SQLite3Table.KRX_FILE_FULL_PATH);
    }

    void createIfNotExists() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_KRX.CREATE_IF_NOT_EXISTS);
    }

    void insert(RowKRX row) {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(KRXSQL.ofInsert(row));
    }
}