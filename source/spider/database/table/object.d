module spider.database.table.object;

import spider.common.util.mkdir: Mkdir;
import spider.database.enums.database: DatabaseType;
import spider.database.enums.sqlite3: SQLite3Table;

import ddbc;

class SQLite3TableObject {
    protected Connection con;
    protected string conUrl;
    
    this(string tabileFilePath, DatabaseType dbType = DatabaseType.SQLITE3) {
        Mkdir.database();
        switch(dbType) {
            case DatabaseType.SQLITE3:
                this.conUrl = "sqlite:"~tabileFilePath;
                break;
            default: break;
        }
        this.con = createConnection(this.conUrl);
    }

    public void txBegin() {
        Statement tx = con.createStatement();
        tx.executeUpdate("BEGIN TRANSACTION");
    }

    public void txEnd() {
        Statement tx = con.createStatement();
        tx.executeUpdate("END TRANSACTION");
    }
    
    public void close() {
        this.con.close();
    }
}