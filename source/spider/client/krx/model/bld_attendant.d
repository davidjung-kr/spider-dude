module spider.client.krx.model.bld_attendant;

import std.datetime: DateTime;

import spider.client.krx.model.outblock;
import spider.common.util.str: Str;

import asdf: serdeKeys, Asdf;

/// 전종목시세 요청결과
struct KrxBldAttendantResponse {
    /// 조회날짜
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    /// 종목별 거래정보
    @serdeKeys("OutBlock_1") OutBlock[] blocks;

    /// 조회날짜 취득 By DateTime
    public DateTime getCurDT() {
        return DateTime.fromISOString(Str.toKrxCurDtToISOString(currentDatetime));
    }
}