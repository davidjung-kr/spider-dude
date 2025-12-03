module spider.database.table.bs;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.table.object: SQLite3TableObject;
import spider.database.model.dart: RowDartBS;
import spider.database.sql.bs: SQL_TB_BS, SQLMapperBS;

import ddbc;

class TableBs : SQLite3TableObject {
    this() {
        super(SQLite3Table.BS_FILE_FULL_PATH);
    }

    void createIfNotExists() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_BS.CREATE_IF_NOT_EXISTS);
    }

    void createIndexes() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_BS.CREATE_INDEX_PK_IF_NOT_EXISTS);
    }

    void insert(RowDartBS row) {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQLMapperBS.ofInsert(row));
    }
}