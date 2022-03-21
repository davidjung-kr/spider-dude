module com.davidjung.spider.report;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import com.davidjung.spider.types;
import com.davidjung.spider.downloader;

/// 보고서 (재무상태표, 손익계산서, 포괄손익계산서 포함)
class Report {
	/// 재무상태표
	private Bs[string] _balance;
	/// 재무상태표(Getter)
	@property Bs[string] balance() { return _balance; }
	/// 재무상태표(Setter)
	@property void balance(Bs[string] bs) { this._balance = bs; }
    /// 손익계산서
    public Is[string] _income;
    /// 손익계산서(Getter)
	@property Is[string] income() { return _income; }
	/// 손익계산서(Setter)
	@property void income(Is[string] _is) { this._income = _is; }

    /// 전종목시세정보 정보
    public OutBlock[string] blocks;

    /**
     * 상장 종목만 남겨두기
     * Returns: 남은 종목 수
     */
    public int onlyListed() {
        int count = 0;
        Bs[string] temp;
        foreach(string k; blocks.keys) {
            if(k in _balance) {
                temp[k] = _balance[k];
                count ++;
            } 
        }
        _balance = temp;
        return count;
    }

    /// 회사명
    public string getCorpName(string code) {
        if((blocks == null || code !in blocks) && code in _balance)
            return _balance[code].name;
        return blocks[code].name;
    }

    /// 상장여부
    public bool isListed(string code) {
        if(code in blocks)
            return true;
        return false;
    }

    /// 시가총액
    public ulong getMarketCap(string code) {
        return blocks[code].marketCap;
    }

}