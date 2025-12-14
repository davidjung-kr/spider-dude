module spider.database.sql.mapper;

import std.string: format;
import std.datetime: Date;

import spider.common.util.str: Str;
import spider.database.model.log: RowLog;
import spider.database.model.krx: RowKRX;
import spider.database.model.dart: RowDartBS, RowDartSI;
import spider.database.sql.log: SQL_TB_LOG;
import spider.database.sql.krx: SQL_TB_KRX;
import spider.database.sql.dart: SQL_TB_BS, SQL_TB_SI;

struct SQLMapper {
    struct KRX {
        public static string ofINSERT(RowKRX row) {
            return format(SQL_TB_KRX.INSERT,
                row.baseYMD,
                row.mktID,
                row.corpCd,
                row.corpNm,
                row.cap,
                row.shares,
                row.open,
                row.high,
                row.low,
                row.close,
                row.dumpYMS
            );
        }

        public static string ofSELECT_EXIST_BY_BASEYMD(Date baseYMD) {
            return format(SQL_TB_KRX.SELECT_EXIST_BY_BASEYMD,
                Str.toYMD(baseYMD)
            );
        }
    }

    struct Log {
        public static string ofINSERT(RowLog row) {
            return format(SQL_TB_LOG.INSERT,
                row.txYMS,
                row.txNm,
                row.txSeq,
                row.txUUID,
                row.txCtnt
            );
        }
    }

    struct DartBS {
        public static string ofINSERT(RowDartBS row) {
            return format(SQL_TB_BS.INSERT,
                row.baseYear,
                row.rptType,
                row.period,
                row.corpCd,
                row.fAsst,
                row.fCurAsst,
                row.fCash,
                row.fLibl,
                row.fCurLibl,
                row.dumpYMS
            );
        }
    }
    
    struct DartSI {
        public static string ofINSERT(RowDartSI row) {
            return format(SQL_TB_SI.INSERT,
                row.baseYear,
                row.rptType,
                row.period,
                row.sciYN,
                row.corpCd,
                row.fPflss,
                row.fPrftBfTax,
                row.fPrft2Own, 
                row.oprtIcmLss,
                row.fGrft,
                row.dumpYMS
            );
        }
    }
}