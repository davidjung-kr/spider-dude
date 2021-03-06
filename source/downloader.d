module com.davidjung.spider.downloader;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX ๐
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.stdio:File;
import std.conv:to;
import std.datetime.date;
import std.net.curl;
import std.string;
import std.algorithm;
import asdf;
import com.davidjung.spider.report;
import com.davidjung.spider.types;

/** 
 * ์ธ๋ถ ๋ฐ์ดํฐ ๋ค์ด๋ก๋ :: ํ๊ตญ๊ฑฐ๋์, DART๊ณต์ ์ฌ์ดํธ ์ฐ๊ณ
 * 
 * ๋ฉ์๋๋ฅผ ํธ์ถํ  ๋ ๋ง๋ค ๋คํธ์ํฌ ์ ์๊ณผ ๋ฌธ์์ด ํ์ฑ์ ์๋ํ๋ฏ๋ก,
 * ์ฌ๋ฌ๋ฒ ํธ์ถํ  ๊ฒฝ์ฐ ๋ฆฌ์์ค๋ฅผ ๋ง์ด ์ฌ์ฉํ  ์ ์์ต๋๋ค.
 * ๊ฐ๋ฅํ๋ฉด ์์ฒญ ๊ฒฐ๊ณผ ๊ฐ์ ์ ์ฅํด ์ฌ์ฉํฉ๋๋ค.
 */
class Downloader {
    /**
     * ํ๊ตญ๊ฑฐ๋์ ์ ์ข๋ชฉ ์์ธ ์ ๋ณด ์ทจ๋
     *
     * ํ๊ตญ๊ฑฐ๋์์ ์ ์ข๋ชฉ ์์ธ, ์๊ฐ์ด์ก, ์ข๊ฐ ๋ฑ์ ๊ฐ์ ธ์ต๋๋ค.
     *
     * Params:
     *  date = ์กฐํ๊ธฐ์ค์ผ
     * Returns: ์ ์ข๋ชฉ ์์ธ์ ๋ณด [KrxCapRes]
     */
    public KrxCapRes getKrxCapAll(Date date) {
        auto content = post("http://data.krx.co.kr/comm/bldAttendant/getJsonData.cmd", [
            "bld":"dbms/MDC/STAT/standard/MDCSTAT01501",
            "mktId":"ALL",
            "locale":"ko_KR",
            "trdDd":date.toISOString(),
            "share":"1",
            "money":"1",
            "csvxls_isNo":"false",
        ]);
        string jsonText = content.to!string;
        return jsonText.deserialize!KrxCapRes;
    }

    /**
     * ํ๊ตญ๊ฑฐ๋์ ์ ์ข๋ชฉ ์์ธ ์ ๋ณด ์ ์ฌ
     *
     * Params:
     *  date = ์กฐํ๊ธฐ์ค์ผ
     *  rpt = ๋ณด๊ณ ์
     */
    void readKrxCapAllByBlock(Date date, ref Report rpt) {
        rpt.blocks = getKrxCapAllByBlock(date);
    }

    /**
     * ํ๊ตญ๊ฑฐ๋์ ์ ์ข๋ชฉ ์์ธ ์ ๋ณด ์ทจ๋
     *
     * Params:
     *  date = ์กฐํ๊ธฐ์ค์ผ
     * Returns: ์ข๋ชฉ์ฝ๋ ๊ธฐ์ค ์์ธ์ ๋ณด [OutBlock[string]]
     */
    OutBlock[string] getKrxCapAllByBlock(Date date) {
        OutBlock[string] result;
        KrxCapRes res = getKrxCapAll(date);
        foreach(b; res.blocks) {
            result[b.isuSrtCd] = b;
        }
        return result;
    }

    /**
     * ํ๊ตญ๊ฑฐ๋์ ์ ์ข๋ชฉ ์์ธ ์ ๋ณด ์ ์ฅ
     *
     * ํ๊ตญ๊ฑฐ๋์ ์ ์ข๋ชฉ ์์ธ ์ ๋ณด๋ฅผ ํ์ผ๋ก ์ ์ฅ ํฉ๋๋ค.
     * ํ์ผ๋ช์ `KRX_<์๋ ฅ๋ฐ์_์กฐํ๋์์ผ>.dump` ์๋๋ค.
     * Params:
     *  date = ์กฐํ๊ธฐ์ค์ผ
     * Returns: ์กฐํ๋ ์ข๋ชฉ ๊ฐ์
     */
    ulong fetchKrxCapAll(Date date) {
        KrxCapRes res = getKrxCapAll(date);
        File f = File("KRX_"~date.toISOString()~".dump", "w");
        f.writeln(res.currentDatetime);
        foreach(block; res.blocks) {
            f.writeln(block);
        }
        f.close();
        return res.blocks.length;
    }


    public void getKofiaBondYield() {
        auto content = post("https://www.kofiabond.or.kr/proframeWeb/XMLSERVICES/", 
            `<?xml version="1.0" encoding="utf-8"?><message><proframeHeader>
    <pfmAppName>BIS-KOFIABOND</pfmAppName>
    <pfmSvcName>BISBndSrtPrcSrchSO</pfmSvcName>
    <pfmFnName>getHeadList</pfmFnName>
  </proframeHeader>
  <systemHeader></systemHeader>
    <BISBndSrtPrcDayDTO>
    <standardDt>20220401</standardDt>
    <applyGbCd>C02</applyGbCd>
</BISBndSrtPrcDayDTO>
</message>`
        );
    }
}

struct DartUrl {
    private string baseUrl = "https://opendart.fss.or.kr/disclosureinfo/fnltt/dwld/main.do#download_";
    private string[string] urlMap;
    private string key;

    this(string year, Period p, StatementType st) {
        this.key = year~GetCodeFrom.period(p)~GetCodeFrom.statementType(st);
        this.urlMap["20211QBS"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_BS";
        this.urlMap["20211QIS"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_PL";
        this.urlMap["20211QCF"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CF";
        this.urlMap["20211QSCE"] = "2021_1%EB%B6%84%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CE";
        this.urlMap["20212QBS"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_BS";
        this.urlMap["20212QIS"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_PL";
        this.urlMap["20212QCF"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CF";
        this.urlMap["20212QSCE"] = "2021_%EB%B0%98%EA%B8%B0%EB%B3%B4%EA%B3%A0%EC%84%9C_CE";

    }

    public bool have() { 
        if(this.key in this.urlMap)
            return true;
        else
            return false;
    }

    string get() {
        return this.baseUrl ~ this.urlMap[this.key];
    }
}

/// ์ ์ข๋ชฉ์์ธ ์์ฒญ๊ฒฐ๊ณผ
struct KrxCapRes {
    /// ์กฐํ๋ ์ง
    @serdeKeys("CURRENT_DATETIME") string currentDatetime;
    /// ์ข๋ชฉ๋ณ ๊ฑฐ๋์ ๋ณด
    @serdeKeys("OutBlock_1") OutBlock[] blocks;
}

struct OutBlock {
    /// ๊ฑฐ๋๋๊ธ [Numberic String]
    @serdeKeys("ACC_TRDVAL") string accTrdval;
    /// ๊ฑฐ๋๋ [Numberic String]
    @serdeKeys("ACC_TRDVOL") string accTrdvol;
    /// ๋๋น [Numberic String] 
    @serdeKeys("CMPPREVDD_PRC") string cmpprevddPrc;
    /// ๋ฑ๋ฝ๋ฅ  [Floating String]
    @serdeKeys("FLUC_RT") string flucRt;
    /// ???
    @serdeKeys("FLUC_TP_CD") string flucTpCd;
    /// ์ข๋ชฉ๋ช [String]
    @serdeKeys("ISU_ABBRV") string name;
    /// ์ข๋ชฉ์ฝ๋ [String]
    @serdeKeys("ISU_SRT_CD") string isuSrtCd;
    /// ์์ฅ์ฃผ์์ [Numberic String]
    @serdeKeys("LIST_SHRS") string listShrs;
    /// ์๊ฐ์ด์ก [Numberic String]
    @serdeKeys("MKTCAP") string mktCap;
    /// ์์ฅ๊ตฌ๋ถID [String]
    @serdeKeys("MKT_ID") string mktId;
    /// ์์ฅ๊ตฌ๋ถ๋ช [String]
    @serdeKeys("MKT_NM") string mktNm;
    /// ์์๋ถ๋ช [String]
    @serdeKeys("SECT_TP_NM") string sectTpNm;
    /// ์ข๊ฐ [Numberic String]
    @serdeKeys("TDD_CLSPRC") string tddClsprc; 
    /// ๊ณ ๊ฐ [Numberic String]
    @serdeKeys("TDD_HGPRC") string tddHgprc;
    /// ์ ๊ฐ [Numberic String]
    @serdeKeys("TDD_LWPRC") string tddLwprc;
    /// ์๊ฐ [Numberic String]
    @serdeKeys("TDD_OPNPRC") string tddOpnprc;

    /// ์๊ฐ์ด์ก
    @property ulong marketCap() {
        return numbericToUlong(this.mktCap);
    }

    /// ๊ณ ๊ฐ
    @property uint highPrice() {
        return numbericToUint(this.tddHgprc);
    }

    /// ์ ๊ฐ
    @property uint lowPrice() {
        return numbericToUint(this.tddLwprc);
    }

    /// ์๊ฐ
    @property uint openPrice() {
        return numbericToUint(this.tddOpnprc);
    }

    /// ์ข๊ฐ
    @property uint closePrice() {
        return numbericToUint(this.tddClsprc);
    }

    /// ์ ํต์ฃผ์์ = ์์ฅ ์ฃผ์ ์
    @property ulong listShared() {
        return numbericToUlong(this.listShrs);
    }

    /**
     * ์ซ์๋ฐ์ดํฐ ํด๋์ง
     *
     * 0~9๊น์ง์ ์ซ์๋ง ์ฐจ๋ก๋๋ก ๋ด์ด ๋ฌธ์์ด๋ก ๋ฆฌํด ํฉ๋๋ค.
     * ๋ง์ฝ ํ๋ผ๋ฉํฐ ๋ฌธ์์ด์ ์ซ์๊ฐ ์์ ๊ฒฝ์ฐ 0์ผ๋ก ๋ฆฌํด ํฉ๋๋ค.
     *
     * Params:
     *  numberic = ์ซ์๊ฐ ํฌํจ๋ ์ด๋ค ๋ฌธ์์ด
     * Return: 0~9๋ง ๊ฑธ๋ฌ๋ด์ง ๋ฌธ์์ด
     */
    private string cleansingForNumeric(string numberic) {
        // string to char[] and filtering... ASCII๋ก ๋ณํํด 0~9๋ง ํ๋
        string result = numberic.dup.filter!(x => cast(int)x >= 48 && cast(int)x <= 57).to!string; 
        return result.length <= 0 ? "0":result;
    }

    /// ๋ฌธ์์ด์ ์ซ์๋ก
    private ulong numbericToUlong(string numberic) {
        return cleansingForNumeric(numberic).to!ulong;
    }

    /// ๋ฌธ์์ด์ ์ซ์๋ก
    private uint numbericToUint(string numberic) {
        return cleansingForNumeric(numberic).to!uint;
    }
}

/// ์ ๋ํ์คํธ
unittest {
    import std.stdio;
    Downloader client = new Downloader();
    Date dt = Date(2022, 03, 21);

    KrxCapRes capInfo = client.getKrxCapAll(dt);
    assert(capInfo.currentDatetime != "");
    assert(capInfo.blocks[0].name != "");
    assert(capInfo.blocks[0].listShared > 0);

    immutable string kbFinanceCode = "105560"; // ์ข๋ชฉ์ฝ๋: KB๊ธ์ต
    OutBlock[string] capInfoByBlocks = client.getKrxCapAllByBlock(dt);
    assert(capInfoByBlocks[kbFinanceCode].name == "KB๊ธ์ต");
    assert(capInfoByBlocks[kbFinanceCode].closePrice == 57_400); // KB๊ธ์ต ์ข๊ฐ: KRW 57,400

    ulong stockCount = client.fetchKrxCapAll(dt);
    assert(stockCount > 0);

    OutBlock funcTestBlock = OutBlock();
    string dirtyString = "AX#0(,Q@(*XNCNVDI#(";
    assert("0" == funcTestBlock.cleansingForNumeric(dirtyString));
    assert(0 == funcTestBlock.numbericToUlong(dirtyString));
    assert(0 == funcTestBlock.numbericToUint(dirtyString));


    client.getKofiaBondYield();
}