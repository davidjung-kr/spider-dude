module com.davidjung.spider.formula;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX π
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv;
import com.davidjung.spider.types;
import com.davidjung.spider.report;

/**
 * κ³΅μ ν΄λμ€
 */
class Formula {
    private Report report;

    /**
     * μμ±μ
     */
    this(ref Report report) {
        this.report = report;
    }

    /**
     * κ³΅μ μ§μ
     * κ²°κ³Ό κ°μ μ°κ΄λ°°μ΄λ‘
     * `[κ³΅μEnumμ½λλͺ:[FormulaResult#1, FormulaResult#2, FormulaResult#3]]...`μ κ°μ ννλ₯Ό κ°μ§λλ€.

     * μ§μμν(query)μ κ²½μ° μν κ²μμ 1λ²λ§ μννκΈ° λλ¬Έμ
     * Formula ν΄λμ€ λ΄ κ° κ³΅μλ³ ν¨μ νΈμΆνλ κ²λ³΄λ€ λ ν¨μ¨μ μλλ€. λ¨, μ€λ³΅μ κ±°λ μννμ§ μμ΅λλ€.
     *
     * Params:
     *  formulaNames = κ³΅μ μ΄κ±°νμ μ½λ λ¬Έμμ΄ κ°
     * Return: μ‘°ν κ²°κ³Ό
     *
     * Examples:
     * ------------------------------------------------------------------------------
     * auto formula = new Formula(rpt);
     * formula.ncav();
     * formula.ncav();
     * formula.ncav(); // κ²μμ μν λ°μ΄ν° μνλ₯Ό μ΄ 3λ² μν
     * 
     * // κ²μμ 1λ²λ§ μννλ©΄μ κ°μ κ²°κ³Ό
     * formula.query([FormulaName.NCAV, FormulaName.NCAV, FormulaName.NCAV]);
     * ------------------------------------------------------------------------------
     */
    FormulaResult[][string] query(FormulaName[] formulaNames) {
        FormulaResult[][string] result;
        foreach(b; report.balance) {
            foreach(enumName; formulaNames) {
                string key = GetCodeFrom.formulaName(enumName);
                string code = b.code;
                FormulaResult r = FormulaResult(code);
                switch(enumName) {
                case FormulaName.NCAV:     r.value = calcNcav(code);    break;
                case FormulaName.PBR:      r.ratio = calcPbr(code);     break;
                case FormulaName.PER:      r.ratio = calcPer(code);     break;
                case FormulaName.EV_EBITA: r.ratio = calcEvEbita(code); break;
                case FormulaName.GP_A:     r.ratio = calcGpa(code);     break;
                default: continue;
                }
                if(r.notEmpty) {
                    result[key] ~= r;
                }
            }
        }
        return result;
    }

    /**
     * NCAV μ·¨λ
     * 
     * calcNcavλ₯Ό λνν λ©μλ μλλ€.
     * See_Also: this.calcNcav
     */
    public FormulaResult[] ncav() {
        FormulaResult[] result;
        foreach(b; report.balance) {
            FormulaResult r = FormulaResult(b.code);
            r.value = calcNcav(b.code);
            result ~= r;
        }
        return result;
    }

    /**
     * PBR μ·¨λ
     * 
     * calcPbrμ λνν λ©μλ μλλ€.
     * See_Also: this.calcPbr
     */
    public FormulaResult[] pbr() {
        FormulaResult[] result;
        foreach(b; report.balance) {
            FormulaResult r = FormulaResult(b.code);
            r.ratio = calcPbr(b.code);
            result ~= r;
        }
        return result;
    }

    /**
     * PER μ·¨λ
     * 
     * calcPerμ λνν λ©μλ μλλ€.
     * See_Also: this.calcPer
     */
    public FormulaResult[] per() {
        FormulaResult[] result;
        foreach(b; report.balance) {
            FormulaResult r = FormulaResult(b.code);
            r.ratio = calcPer(b.code);
            result ~= r;
        }
        return result;
    }

    /**
     * GP/A μ·¨λ
     * 
     * calcGpaλ₯Ό λνν λ©μλ μλλ€.
     * See_Also: this.calcGpa
     */
    public FormulaResult[] gpa() {
        FormulaResult[] result;
        foreach(b; report.balance) {
            FormulaResult r = FormulaResult(b.code);
            r.ratio = calcGpa(b.code);
            result ~= r;
        }
        return result;
    }

    /**
     * NCAV κ³μ°
     * 
     * μ λμμ°μμ μ΄λΆμ± μ κ±°ν κ°μ μ·¨λ ν©λλ€.
     * Params:
     *  code = μ’λͺ©μ½λ
     */
    private ulong calcNcav(string code) {
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        long fullCurrentassets = balance.q(IfrsCode.FULL_CURRENTASSETS);
        long fullLiabilities = balance.q(IfrsCode.FULL_LIABILITIES);
        long netCurrentassets = fullCurrentassets - fullLiabilities;

        return netCurrentassets;
    }

    /**
     * PBR κ³μ°
     *
     * μλ³Έμ΄κ³μμ μ ν΅μ£Όμμλ₯Ό λλ μ£ΌλΉμμμ°(BPS)μ κ³μ°νκ³ ,
     * μ¬κΈ°μ ν΄λΉ μ’λͺ©μ μ’κ° λλ κ°μ μ·¨λ ν©λλ€.
     * Params:
     *  code = μ’λͺ©μ½λ
     */
    private float calcPbr(string code) {
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        ulong netEquity = balance.q(IfrsCode.FULL_ASSETS) - balance.q(IfrsCode.FULL_LIABILITIES);
        ulong shares = report.getListShared(code);
        uint price = report.getClosePrice(code);
        
       if(netEquity==0 || shares==0 || price==0)
            return -1;
        float bps = (netEquity/shares).to!float;
        return price/bps;
    }

    /**
     * PER κ³μ°
     * 
     * Params:
     *  code = μ’λͺ©μ½λ
     */
    private float calcPer(string code) {
        Cis cIncome = report.getComprehensiveIncomeStatement(code);
        if(cIncome.empty)
            return -1;
        ulong marketCap = report.getMarketCap(code);
        double fullProfitloss = cIncome.q(IfrsCode.FULL_PROFITLOSS).to!double;

       if(marketCap==0 || fullProfitloss==0) {
            return -1;
       }
            

        return marketCap/fullProfitloss;
    }

    /**
     * EV/EBITA κ³μ°
     * 
     * EVλ μκ°μ΄μ‘κ³Ό μμ°¨μκΈ λν κ°μ κ³μ°νκ³ ,
     * EBITAλ μμμ΄μ΅μ κ°κ°μκ°λΉμ λ¬΄νμμ°μκ°λΉ, μ°¨μκΈ μ΄μλ₯Ό λνλ©°
     * EVμ EBITAλ₯Ό λλ κ°μ μ·¨λ ν©λλ€.
     * Params:
     *  code = μ’λͺ©μ½λ
     */
    private float calcEvEbita(string code) {
        Bs balance = report.getBalanceStatement(code);
        Is income = report.getIncomeStatement(code);
        if(balance.empty || income.empty)
            return -1;
        ulong marketCap = report.getMarketCap(code);
        ulong fullLiabilities = balance.q(IfrsCode.FULL_LIABILITIES);
        ulong fullCurrentassets = balance.q(IfrsCode.FULL_CURRENTASSETS);
    
        ulong incomeLoss = income.queryDartStatement(DartCode.OPERATING_INCOME_LOSS);
        ulong expense = income.queryDartStatement(DartCode.DEPRECIATION_EXPENSE) +
            income.queryDartStatement(DartCode.AMORTISATION_EXPENSE);

       if(marketCap==0 || fullLiabilities==0 || fullCurrentassets==0 || incomeLoss==0 || expense==0)
            return -1;

        long ev = marketCap + (fullLiabilities-fullCurrentassets); // μ°λμ£Ό ν¬ν¨ νμ
        long ebita = incomeLoss+expense;

        return ev/ebita;
    }

    /**
     * GP/A κ³μ°
     * 
     * Params:
     *  code = μ’λͺ©μ½λ
     */
    private float calcGpa(string code) {
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        double fullAssets = balance.q(IfrsCode.FULL_ASSETS).to!double;
        double fullGrossProfit = 0;

        if(report.isComprehensive()) {
            Cis income = report.getComprehensiveIncomeStatement(code);
            fullGrossProfit = income.q(IfrsCode.FULL_GROSSPROFIT).to!double;
        } else {
            Is income = report.getIncomeStatement(code);
            fullGrossProfit = income.q(IfrsCode.FULL_GROSSPROFIT).to!double;
        }
        
        if(fullGrossProfit==0 || fullAssets==0)
            return -1;
        
        return fullAssets/fullGrossProfit;
    }
}