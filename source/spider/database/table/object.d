module spider.database.table.object;

import std.file: isFile, remove;

import spider.common.util.mkdir: Mkdir;
import spider.database.enums.database: DatabaseType;
import spider.database.enums.sqlite3: SQLite3Table;

import ddbc;

class SQLite3TableObject {
    protected Connection con;
    protected string conUrl;
    private string tbFilePath;
    
    this(string tbFilePath, DatabaseType dbType = DatabaseType.SQLITE3) {
        Mkdir.database();
        this.tbFilePath = tbFilePath;
        switch(dbType) {
            case DatabaseType.SQLITE3:
                this.conUrl = "sqlite:"~tbFilePath;
                break;
            default: break;
        }
        this.con = createConnection(this.conUrl);
    }

    public string getTbFilePath() {
        return this.tbFilePath;
    }

    public void txBegin() {
        Statement tx = con.createStatement();
        tx.executeUpdate("BEGIN TRANSACTION");
    }

    public void txEnd() {
        Statement tx = con.createStatement();
        tx.executeUpdate("END TRANSACTION");
    }

    public void setAutoCommit(bool yn) {
        this.con.setAutoCommit(yn);
    }

    public void commit() {
        this.con.commit();
    }
    
    public void close() {
        this.con.close();
    }

    public void rmTbFile() {
        if (isFile(this.tbFilePath)) {
            remove(this.tbFilePath);
        }
    }
}