module spider.loader.report_loader;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.datetime: Date;

import spider.report;
import spider.client.krx.data_krx;

struct ReportLoader {
    /**
     * 한국거래소 전종목 시세 정보 적재
     *
     * Params:
     *  date = 조회기준일
     *  rpt = 보고서
     */
    public static void krxCapAllBlock(Date date, ref Report rpt) {
        rpt.blocks = DataKrx.getKrxCapAllByBlock(date);
        rpt.refreshCorpCode();
    }
}