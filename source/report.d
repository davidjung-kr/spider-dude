module com.davidjung.spider.report;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.algorithm;
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
    
    /// 포괄손익계산서
    private Cis[string] _cIncome;
    /// 포괄손익계산서(Getter)
	@property Cis[string] comprehensiveIncome() { return _cIncome; }
	/// 포괄손익계산서(Setter)
	@property void comprehensiveIncome(Cis[string] cis) { this._cIncome = cis; }

    /// 손익계산서
    private Is[string] _income;
    /// 손익계산서(Getter)
	@property Is[string] income() { return _income; }
	/// 손익계산서(Setter)
	@property void income(Is[string] income) { this._income = income; }

    /// 종목코드
    private string[] corpCodes;

    /// 전종목시세정보 정보
    public OutBlock[string] blocks;

    /// 포괄손익계산서 여부
    public bool isComprehensive() {
        ulong cisLength = _cIncome.length;
        ulong isLength = _income.length;
        if(cisLength <= 0 && isLength <= 0) {
            throw new Exception("Please load a income or comprehensive income statement first.");
        }
        return cisLength > 0;
    }

    /**
     * 종목코드 업데이트
     */
    public void refreshCorpCode() {
        ulong len = blocks.length;
        if(len <= 0)
            return;
        this.corpCodes = blocks.keys;
        // string[] codes = [];
        // for(int i=0; i<len; i++) {
        //     codes ~= blocks[cast(int)i].isuSrtCd;
        // }
        // this.corpCodes = codes;
    }

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

    /**
     * 코스닥 종목만 남기기
     *
     * 한국거래소 데이터 기준으로 코스닥 종목만 남깁니다.
     * 인스턴스의 멤버필드(재무제표, 거래소 데이터 등)에 영향을 미칩니다.
     * Returns: 제거한 후 남은 종목 수
     */
    public int filteringKosdaq() {
        int count = 0;
        Bs[string] tempBs;
        OutBlock[string] tempBlocks;
        foreach(string k; blocks.keys) {
            if(blocks[k].mktNm == "KOSDAQ") {
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
     * 종목코드 교집합 처리
     *
     * 재무제표, 한국거래소에 존재하는 종목코드 교집합만 남기고
     * 다른 데이터는 모두 지웁니다.
     * 인스턴스의 멤버필드(재무제표, 거래소 데이터 등)에 영향을 미칩니다.
     * Returns: 제거한 후 남은 종목 수
     */
    public int filteringIntersectionCorpCode() {
        string[] krxCorpCodes = blocks.keys;
        string[] bsCorpCodes = _balance.keys;

        // 포괄을 쓸 껀 지 손익계산서 쓸건 지 결정
        StatementType type = _cIncome.length > 0 ? StatementType.CIS:StatementType.IS;
        string[] isCorpCodes =  type == StatementType.CIS ? _cIncome.keys : _income.keys;

        Bs[string] tempBs;
        Cis[string] tempIs;
        OutBlock[string] tempBlocks;
        uint count = 0;
        foreach(string code; krxCorpCodes) {
            if(countUntil(bsCorpCodes, code) < 0 || countUntil(isCorpCodes, code) < 0)
                continue;

            tempBs[code] = _balance[code];
            if(type == StatementType.CIS) {
                tempIs[code] = _cIncome[code];
            }
            else {
                tempIs[code] = _income[code];
            }
            tempBlocks[code] = blocks[code];
            count++;
        }
        import std.stdio;

        if(type == StatementType.CIS) {
            _cIncome = tempIs;
        }
        else {
            _income = tempIs;
        }
        _balance = tempBs;
        
        blocks = tempBlocks;
        return count;
    }

    /// 재무상태표
    public Bs getBalanceStatement(string code) {
        return _balance[code];
    }

    /// 포괄손익계산서
    public Cis getComprehensiveIncomeStatement(string code) {
        return _cIncome[code];
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