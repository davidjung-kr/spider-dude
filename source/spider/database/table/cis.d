module spider.database.table.cis;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.table.object: SQLite3TableObject;
import spider.database.model.row_krx: RowKRX;
import spider.database.sql.cis: SQL_TB_CIS;

import ddbc;

class TableCIS : SQLite3TableObject {
    this() {
        super(SQLite3Table.CIS_FILE_FULL_PATH);
    }

    void createIfNotExists() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_CIS.CREATE_TABLE_IF_NOT_EXISTS);
    }
}