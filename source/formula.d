module com.davidjung.spider.formula;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX 📈
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import com.davidjung.spider.types;
import com.davidjung.spider.report;

/**
 * 공식 클래스
 */
class Formula {
    private Report report;
    this(Report report) {
        this.report = report;
    }

    /**
     * 공식 질의
     * 결과 값은 연관배열로
     * `[공식Enum코드명:[FormulaResult#1, FormulaResult#2, FormulaResult#3]]`와 같은 형태를 가집니다.

     * 질의수행(query)의 경우 순회 검색을 1번만 수행하기 때문에
     * Formula 클래스 내 각 공식별 함수 호출하는 것보다 더 효율적입니다. 단, 중복제거는 수행하지 않습니다.
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
     * Return: 조회 결과
     */
    FormulaResult[][string] query(FormulaName[] formulaNames) {
        FormulaResult[][string] result;
        foreach(b; report.balance) {
            foreach(formulaEnum; formulaNames) {
                switch(formulaEnum){
                case FormulaName.NCAV:
                    result[GetCodeFrom.formulaName(formulaEnum)] ~= FormulaResult(b.code, calcNcav(b));
                    break;
                default: continue;
                }
            }
        }
        return result;
    }

    /**
     * NCAV 계산
     */
    public FormulaResult[] ncav() {
        FormulaResult[] result;
        foreach(b; report.balance) {
            result ~= FormulaResult(b.code, calcNcav(b));
        }
        return result;
    }

    // NCAV 계산
    private ulong calcNcav(Bs b) {
        long fullCurrentassets = b.q(IfrsCode.FULL_CURRENTASSETS);
        long fullLiabilities = b.q(IfrsCode.FULL_LIABILITIES);
        long netCurrentassets = fullCurrentassets - fullLiabilities;
        if(netCurrentassets > 0)
            return netCurrentassets;
        return -1;
    }
}