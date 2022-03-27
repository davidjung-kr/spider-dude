module com.davidjung.spider.formula;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
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
            foreach(formulaEnum; formulaNames) {
                string key = GetCodeFrom.formulaName(formulaEnum);
                string code = b.code;
                switch(formulaEnum){
                case FormulaName.NCAV:
                    result[key] ~= FormulaResult(code, calcNcav(code));
                    break;
                case FormulaName.PBR:
                    result[key] ~= FormulaResult(code, calcPbr(code));
                    break;
                default: continue;
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
            string code = b.code;
            result ~= FormulaResult(code, calcNcav(code));
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
            string code = b.code;
            result ~= FormulaResult(code, calcPbr(code));
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
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        long fullCurrentassets = balance.q(IfrsCode.FULL_CURRENTASSETS);
        long fullLiabilities = balance.q(IfrsCode.FULL_LIABILITIES);
        long netCurrentassets = fullCurrentassets - fullLiabilities;
        if(netCurrentassets > 0)
            return netCurrentassets;
        return -1;
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
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        ulong netEquity = balance.q(IfrsCode.FULL_ASSETS) - balance.q(IfrsCode.FULL_LIABILITIES);
        ulong shares = report.getListShared(code);
        uint price = report.getClosePrice(code);
        
       if(netEquity==0 || shares==0 || price==0)
            return -1;
        float bps = (netEquity/shares).to!float;
        return bps/price;
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
        Bs balance = report.getBalanceStatement(code);
        if(balance.empty)
            return -1;
        ulong marketCap = report.getMarketCap(code);
        ulong fullLiabilities = balance.q(IfrsCode.FULL_LIABILITIES);
        ulong fullCurrentassets = balance.q(IfrsCode.FULL_CURRENTASSETS);

       if(marketCap==0 || fullLiabilities==0 || fullCurrentassets==0)
            return -1;

        ulong enterpriseValue = marketCap + (fullLiabilities-fullCurrentassets); // ev

        return enterpriseValue;
    }
}