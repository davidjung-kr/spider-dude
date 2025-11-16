module spider.client.krx.model.bld_attendant;

import spider.client.krx.model.outblock;

import asdf: serdeKeys;

/// 전종목시세 요청결과
struct KrxBldAttendantResponse {
    /// 조회날짜
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    /// 종목별 거래정보
    @serdeKeys("OutBlock_1") OutBlock[] blocks;
}