module spider.database.enums.sqlite3;

enum SQLite3Table {
    FILE_PATH  = "./database",
    
    LOG_FILE_NAME = "log.sqlite",
    LOG_FILE_FULL_PATH = FILE_PATH~"/"~LOG_FILE_NAME,
    
    KRX_FILE_NAME = "krx.sqlite",
    KRX_FILE_FULL_PATH = FILE_PATH~"/"~KRX_FILE_NAME,

    BS_FILE_NAME = "bs.sqlite",
    BS_FILE_FULL_PATH = FILE_PATH~"/"~BS_FILE_NAME,

    CIS_FILE_NAME = "cis.sqlite",
    CIS_FILE_FULL_PATH = FILE_PATH~"/"~CIS_FILE_NAME

}