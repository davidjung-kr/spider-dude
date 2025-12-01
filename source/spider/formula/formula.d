module spider.formula.formula;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv: to;

import spider.report;
import spider.formula.enums;
import spider.formula.result;
import spider.client.dart.consts;
import spider.client.dart.enums.account;
import spider.client.dart.model.bs;
import spider.client.dart.model.cis;

/**
 * 공식 클래스
 */
class Formula {
    private Report report;

    /**
     * 생성자
     */
    this(ref Report report) {
        this.report = report;
    }

    /**
     * 공식 질의
     * 결과 값은 연관배열로
     * `[공식Enum코드명:[FormulaResult#1, FormulaResult#2, FormulaResult#3]]...`와 같은 형태를 가집니다.

     * 질의수행(query)의 경우 순회 검색을 1번만 수행하기 때문에
     * Formula 클래스 내 각 공식별 함수 호출하는 것보다 더 효율적입니다. 단, 중복제거는 수행하지 않습니다.
     *
     * Params:
     *  formulaNames = 공식 열거형의 코드 문자열 값
     * Return: 조회 결과
     *
     * Examples:
     * ------------------------------------------------------------------------------
     * auto formula = new Formula(rpt);
     * formula.ncav();
     * formula.ncav();
     * formula.ncav(); // 검색을 위한 데이터 순회를 총 3번 수행
     * 
     * // 검색을 1번만 수행하면서 같은 결과
     * formula.query([FormulaName.NCAV, FormulaName.NCAV, FormulaName.NCAV]);
     * ------------------------------------------------------------------------------
     */
    FormulaResult[][string] query(FormulaName[] formulaNames) {
        FormulaResult[][string] result;
        foreach(b; report.balance) {
            foreach(enumName; formulaNames) {
                string key = StrFrom.formulaName(enumName);
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
     * NCAV 취득
     * 
     * calcNcav를 래핑한 메소드 입니다.
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
     * PBR 취득
     * 
     * calcPbr을 래핑한 메소드 입니다.
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
     * PER 취득
     * 
     * calcPer을 래핑한 메소드 입니다.
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
     * GP/A 취득
     * 
     * calcGpa를 래핑한 메소드 입니다.
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
     * NCAV 계산
     * 
     * 유동자산에서 총부채 제거한 값을 취득 합니다.
     * Params:
     *  code = 종목코드
     */
    private ulong calcNcav(string code) {
        DartBS balance = report.getBalanceStatement(code);
        if(balance.isItemsEmpty())
            return -1;
        long fullCurrentassets = balance.getCurrentTerm(Account.FULL_CURRENTASSETS);
        long fullLiabilities = balance.getCurrentTerm(Account.FULL_LIABILITIES);
        long netCurrentassets = fullCurrentassets - fullLiabilities;

        return netCurrentassets;
    }

    /**
     * PBR 계산
     *
     * 자본총계에서 유통주식수를 나눈 주당순자산(BPS)을 계산하고,
     * 여기에 해당 종목의 종가 나눈 값을 취득 합니다.
     * Params:
     *  code = 종목코드
     */
    private float calcPbr(string code) {
        DartBS balance = report.getBalanceStatement(code);
        if(balance.isItemsEmpty())
            return -1;
        ulong netEquity =
            balance.getCurrentTerm(Account.FULL_ASSETS) - balance.getCurrentTerm(Account.FULL_LIABILITIES);
        ulong shares = report.getListShared(code);
        uint price = report.getClosePrice(code);
        
       if(netEquity==0 || shares==0 || price==0)
            return -1;
        float bps = (netEquity/shares).to!float;
        return price/bps;
    }

    /**
     * PER 계산
     * 
     * Params:
     *  code = 종목코드
     */
    private float calcPer(string code) {
        DartCIS cIncome = report.getComprehensiveIncomeStatement(code);
        if(cIncome.isItemsEmpty())
            return -1;
        ulong marketCap = report.getMarketCap(code);
        double fullProfitloss = cIncome.q(Account.FULL_PROFITLOSS).to!double;

       if(marketCap==0 || fullProfitloss==0) {
            return -1;
       }
            

        return marketCap/fullProfitloss;
    }

    /**
     * EV/EBITA 계산
     * 
     * EV는 시가총액과 순차입금 더한 값을 계산하고,
     * EBITA는 영업이익에 감가상각비와 무형자산상각비, 차입금 이자를 더하며
     * EV에 EBITA를 나눈 값을 취득 합니다.
     * Params:
     *  code = 종목코드
     */
    private float calcEvEbita(string code) {
        DartBS balance = report.getBalanceStatement(code);
        DartIS income = report.getIncomeStatement(code);
        if(balance.isItemsEmpty() || income.isItemsEmpty())
            return -1;
        ulong marketCap = report.getMarketCap(code);
        ulong fullLiabilities = balance.getCurrentTerm(Account.FULL_LIABILITIES);
        ulong fullCurrentassets = balance.getCurrentTerm(Account.FULL_CURRENTASSETS);
    
        ulong incomeLoss = income.queryDartStatement(Account.OPERATING_INCOME_LOSS);
        ulong expense = income.queryDartStatement(Account.DEPRECIATION_EXPENSE) +
            income.queryDartStatement(Account.AMORTISATION_EXPENSE);

       if(marketCap==0 || fullLiabilities==0 || fullCurrentassets==0 || incomeLoss==0 || expense==0)
            return -1;

        long ev = marketCap + (fullLiabilities-fullCurrentassets); // 우량주 포함 필요
        long ebita = incomeLoss+expense;

        return ev/ebita;
    }

    /**
     * GP/A 계산
     * 
     * Params:
     *  code = 종목코드
     */
    private float calcGpa(string code) {
        DartBS balance = report.getBalanceStatement(code);
        if(balance.isItemsEmpty())
            return -1;
        double fullAssets = balance.getCurrentTerm(Account.FULL_ASSETS).to!double;
        double fullGrossProfit = 0;

        if(report.isComprehensive()) {
            DartCIS income = report.getComprehensiveIncomeStatement(code);
            fullGrossProfit = income.q(Account.FULL_GROSSPROFIT).to!double;
        } else {
            DartIS income = report.getIncomeStatement(code);
            fullGrossProfit = income.q(Account.FULL_GROSSPROFIT).to!double;
        }
        
        if(fullGrossProfit==0 || fullAssets==0)
            return -1;
        
        return fullAssets/fullGrossProfit;
    }
}