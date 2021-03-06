module com.davidjung.spider.report;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX π
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.algorithm;
import com.davidjung.spider.types;
import com.davidjung.spider.downloader;

/// λ³΄κ³ μ (μ¬λ¬΄μνν, μμ΅κ³μ°μ, ν¬κ΄μμ΅κ³μ°μ ν¬ν¨)
class Report {
	/// μ¬λ¬΄μνν
	private Bs[string] _balance;
	/// μ¬λ¬΄μνν(Getter)
	@property Bs[string] balance() { return _balance; }
	/// μ¬λ¬΄μνν(Setter)
	@property void balance(Bs[string] bs) { this._balance = bs; }
    
    /// ν¬κ΄μμ΅κ³μ°μ
    private Cis[string] _cIncome;
    /// ν¬κ΄μμ΅κ³μ°μ(Getter)
	@property Cis[string] comprehensiveIncome() { return _cIncome; }
	/// ν¬κ΄μμ΅κ³μ°μ(Setter)
	@property void comprehensiveIncome(Cis[string] cis) { this._cIncome = cis; }

    /// μμ΅κ³μ°μ
    private Is[string] _income;
    /// μμ΅κ³μ°μ(Getter)
	@property Is[string] income() { return _income; }
	/// μμ΅κ³μ°μ(Setter)
	@property void income(Is[string] income) { this._income = income; }

    /// μ μ’λͺ©μμΈμ λ³΄ μ λ³΄
    public OutBlock[string] blocks;

    /// ν¬κ΄μμ΅κ³μ°μ μ¬λΆ
    public bool isComprehensive() {
        ulong cisLength = _cIncome.length;
        ulong isLength = _income.length;
        if(cisLength <= 0 && isLength <= 0) {
            throw new Exception("Please load a income or comprehensive income statement first.");
        }
        return cisLength > 0;
    }

    /**
     * μμ₯ μ’λͺ©λ§ λ¨κ²¨λκΈ°
     * 
     * νκ΅­κ±°λμμ μ‘΄μ¬νμ§ μλ μ¬λ¬΄μ ν λ°μ΄ν°λ₯Ό μ­μ  ν©λλ€.
     * μΈμ€ν΄μ€μ λ©€λ²νλ(μ¬λ¬΄μ ν)μ μν₯μ λ―ΈμΉ©λλ€.
     * Returns: μ κ±°ν ν λ¨μ μ’λͺ© μ
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
     * μκ°μ΄μ‘μ΄ 0μ΄ μλ μ£Όμλ§ λ¨κ²¨λκΈ°
     *
     * μκ°μ΄μ‘μ΄ 0μ΄νμΈ μ’λͺ©μ μ κ±° ν©λλ€.
     * μΈμ€ν΄μ€μ λ©€λ²νλ(μ¬λ¬΄μ ν, κ±°λμ λ°μ΄ν° λ±)μ μν₯μ λ―ΈμΉ©λλ€.
     * Returns: μ κ±°ν ν λ¨μ μ’λͺ© μ
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
     * μ€κ΅­μ£Όμ μ κ±° - μ΄κ±Έ μ μ¬λκ±°μ§..?
     *
     * μ’λͺ©μ½λ μμλ¦¬κ° 9μΈ κ²½μ°μ μ’λͺ©μ μ κ±° ν©λλ€.
     * μΈμ€ν΄μ€μ λ©€λ²νλ(μ¬λ¬΄μ ν, κ±°λμ λ°μ΄ν° λ±)μ μν₯μ λ―ΈμΉ©λλ€.
     * Returns: μ κ±°ν ν λ¨μ μ’λͺ© μ
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
     * μ½μ€λ₯ μ’λͺ©λ§ λ¨κΈ°κΈ°
     *
     * νκ΅­κ±°λμ λ°μ΄ν° κΈ°μ€μΌλ‘ μ½μ€λ₯ μ’λͺ©λ§ λ¨κΉλλ€.
     * μΈμ€ν΄μ€μ λ©€λ²νλ(μ¬λ¬΄μ ν, κ±°λμ λ°μ΄ν° λ±)μ μν₯μ λ―ΈμΉ©λλ€.
     * Returns: μ κ±°ν ν λ¨μ μ’λͺ© μ
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
     * μ’λͺ©μ½λ κ΅μ§ν© μ²λ¦¬
     *
     * μ¬λ¬΄μ ν, νκ΅­κ±°λμμ μ‘΄μ¬νλ μ’λͺ©μ½λ κ΅μ§ν©λ§ λ¨κΈ°κ³ 
     * λ€λ₯Έ λ°μ΄ν°λ λͺ¨λ μ§μλλ€.
     * μΈμ€ν΄μ€μ λ©€λ²νλ(μ¬λ¬΄μ ν, κ±°λμ λ°μ΄ν° λ±)μ μν₯μ λ―ΈμΉ©λλ€.
     * Returns: μ κ±°ν ν λ¨μ μ’λͺ© μ
     */
    public int filteringIntersectionCorpCode() {
        string[] krxCorpCodes = blocks.keys;
        string[] bsCorpCodes = _balance.keys;

        // ν¬κ΄μ μΈ κ» μ§ μμ΅κ³μ°μ μΈκ±΄ μ§ κ²°μ 
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

    /// μ¬λ¬΄μνν
    public Bs getBalanceStatement(string code) {
        return _balance[code];
    }

    /// ν¬κ΄μμ΅κ³μ°μ
    public Cis getComprehensiveIncomeStatement(string code) {
        return _cIncome[code];
    }

    /// μμ΅κ³μ°μ
    public Is getIncomeStatement(string code) {
        return _income[code];
    }

    /// νμ¬λͺ
    public string getCorpName(string code) {
        if((blocks == null || code !in blocks) && code in _balance)
            return _balance[code].name;
        return blocks[code].name;
    }

    /// μμ₯μ¬λΆ
    public bool isListed(string code) {
        if(code in blocks)
            return true;
        return false;
    }

    /// μκ°μ΄μ‘
    public ulong getMarketCap(string code) {
        return blocks[code].marketCap;
    }

    /// μ’κ°
    public uint getClosePrice(string code) {
        return blocks[code].closePrice;
    }

    /// μ ν΅μ£Όμ μ
    public ulong getListShared(string code) {
        return blocks[code].listShared;
    }
}