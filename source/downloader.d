module com.davidjung.spider.downloader;

import com.davidjung.spider.types;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

struct Url {
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