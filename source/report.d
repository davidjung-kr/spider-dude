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
     * 
     * 한국거래소에 존재하지 않는 재무제표 데이터를 삭제 합니다.
     * 인스턴스의 멤버필드(재무제표)에 영향을 미칩니다.
     * Returns: 제거한 후 남은 종목 수
     */
    public int filteringOnlyListed() {
        int count = 0;
        Bs[string] tempBs;
        OutBlock[string] tempBlocks;
        foreach(string k; blocks.keys) {
            if(k in _balance) {
                tempBs[k] = _balance[k];
                tempBlocks[k] = blocks[k];
                count ++;
            } 
        }
        _balance = tempBs;
        blocks = tempBlocks;
        return count;
    }

    /**
     * 시가총액이 0이 아닌 주식만 남겨두기
     *
     * 시가총액이 0이하인 종목을 제거 합니다.
     * 인스턴스의 멤버필드(재무제표, 거래소 데이터 등)에 영향을 미칩니다.
     * Returns: 제거한 후 남은 종목 수
     */
    public int filteringNotCapZero() {
        int count = 0;
        Bs[string] tempBs;
        OutBlock[string] tempBlocks;
        foreach(string k; blocks.keys) {
            if(blocks[k].marketCap > 0) {
                tempBs[k] = _balance[k];
                tempBlocks[k] = blocks[k];
                count ++;
            }
        }
        _balance = tempBs;
        blocks = tempBlocks;
        return count;
    }

    /**
     * 중국주식 제거 - 이걸 왜 사는거지..?
     *
     * 종목코드 앞자리가 9인 경우의 종목을 제거 합니다.
     * 인스턴스의 멤버필드(재무제표, 거래소 데이터 등)에 영향을 미칩니다.
     * Returns: 제거한 후 남은 종목 수
     */
    public int filteringNotChineseCompany() {
        int count = 0;
        Bs[string] tempBs;
        OutBlock[string] tempBlocks;
        foreach(string k; blocks.keys) {
            if(k[0] != '9') {
                tempBs[k] = _balance[k];
                tempBlocks[k] = blocks[k];
                count ++;
            }
        }
        _balance = tempBs;
        blocks = tempBlocks;
        return count;
    }

    /// 재무상태표
    public Bs getBalanceStatement(string code) {
        return _balance[code];
    }

    /// 손익계산서
    public Is getIncomeStatement(string code) {
        return _income[code];
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

    /// 종가
    public uint getClosePrice(string code) {
        return blocks[code].closePrice;
    }

    /// 유통주식 수
    public ulong getListShared(string code) {
        return blocks[code].listShared;
    }
}