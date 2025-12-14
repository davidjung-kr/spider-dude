module spider.database.table.dart;

import spider.database.enums.sqlite3: SQLite3Table;
import spider.database.table.object: SQLite3TableObject;
import spider.database.model.dart: RowDartBS, RowDartSI;
import spider.database.sql.mapper: SQLMapper;
import spider.database.sql.dart: SQL_TB_BS, SQL_TB_SI;

import ddbc;

class TableDartBS : SQLite3TableObject {
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
        tx.executeUpdate(SQLMapper.DartBS.ofINSERT(row));
    }
}

class TableDartSI : SQLite3TableObject {
    this() {
        super(SQLite3Table.CIS_FILE_FULL_PATH);
    }

    void createIfNotExists() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_SI.CREATE_TABLE_IF_NOT_EXISTS);
    }

    void createIndexes() {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQL_TB_SI.CREATE_INDEX_PK);
    }

    void insert(RowDartSI row) {
        Statement tx = this.con.createStatement();
        tx.executeUpdate(SQLMapper.DartSI.ofINSERT(row));
    }
}