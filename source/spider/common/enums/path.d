module spider.common.enums.path;

enum Path {
    DART_DATA = "dartdata",
    DART_DATA_WITH_DOT = "./"~DART_DATA,

    KRX_DATA = "krxdata",
    KRX_DATA_WITH_DOT = "./"~KRX_DATA,

    DATABASE_SQLITE3 = "database",
    DATABASE_SQLITE3_WITH_DOT = "./"~DATABASE_SQLITE3
}