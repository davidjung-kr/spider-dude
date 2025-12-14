module spider.common.util.str;

import std.conv: to;
import std.regex: matchFirst, ctRegex;
import std.array: replace;
import std.string: strip, format, indexOf;
import std.datetime: SysTime, Date;
import std.algorithm: filter;

struct Str {
	/// 금액형태의 문자열을 long형태로 변환
	public static long amountStringToLong(string numeric) {
		string cleanedNumeric = strip(numeric).replace(",", "");
		return cleanedNumeric=="" ? 0:cleanedNumeric.to!long;
	}

	/**
	* 숫자데이터 클랜징
	*
	* 0~9까지의 숫자만 차례대로 담어 문자열로 리턴 합니다.
	* 만약 파라메터 문자열에 숫자가 없을 경우 0으로 리턴 합니다.
	*
	* Params:
	*  numberic = 숫자가 포함된 어떤 문자열
	* Return: 0~9만 걸러내진 문자열
	*/
	public static string cleansingForNumeric(string numberic) {
		// string to char[] and filtering... ASCII로 변환해 0~9만 획득
		string result = numberic.dup.filter!(x => cast(int)x >= 48 && cast(int)x <= 57).to!string; 
		return result.length <= 0 ? "0":result;
	}

	/// 문자열을 숫자로
	public static ulong numbericToUlong(string numberic) {
		return cleansingForNumeric(numberic).to!ulong;
	}

	/// 문자열을 숫자로
	public static uint numbericToUint(string numberic) {
		return cleansingForNumeric(numberic).to!uint;
	}

	/// 한국거래소 currentDatetime를 ISO 표준으로 변경
	public static string toKrxCurDtToISOString(string currentDatetime) {
		//2025.11.23 AM 02:45:15
		//20180101T123010
		//ubyte gap = "AM"==currentDatetime[11..13] ? 0:12;
		string hours = "%02d".format(to!int(currentDatetime[14..16]));

		char[] result = new char[15];
		result[0] = currentDatetime[0];
		result[1] = currentDatetime[1];
		result[2] = currentDatetime[2];
		result[3] = currentDatetime[3];
		result[4] = currentDatetime[5];
		result[5] = currentDatetime[6];
		result[6] = currentDatetime[8];
		result[7] = currentDatetime[9];
		result[8] = 'T';
		result[9] = hours[0];
		result[10] = hours[1];
		result[11] = currentDatetime[17];
		result[12] = currentDatetime[18];
		result[13] = currentDatetime[20];
		result[14] = currentDatetime[21];

		return cast(string)result;
	}
	
	/// SQLITE3 ISO8601 방식 문자열로 리턴
	/// 
	/// `YYYY-MM-DD HH:MM:SS.SSS`
	public static string ofTimestamp(SysTime yms) {
		string bf = yms.toISOExtString(); // YYYY-MM-DDTHH:MM:SS.FFFFFFFTZ
		
		char[] af = new char[23];
		for(ubyte i=0; i<10; i++) {
			af[i] = bf[i];
		}
		af[10] = ' ';
		for(ubyte i=11; i<23; i++) {
			af[i] = bf[i];
		}
		return cast(string)af;
	}

	public static string toYMD(T)(T dt) {
		return format("%04d%02d%02d", dt.year(), dt.month(), dt.day());
	}

	

    /**
     * 항목코드 정규화
     * 
     * entity00128661_udf_IS_2021111016569448 .. 와 같이
     * 공식적인 IFRS 항목코드가 아닌 항목명에서 불필요한 데이터를 지우고
     * `udf-`를 붙여 리턴한다.
     * 클랜징할 대상이 없을 경우 입력 값 그대로 리턴.
     *
     * Examples: 
     *	assert("udf-IncomeStatementAbstract" ==
     *         Parser.cleaningDartAccountingCode(
     *	"entity00128661_udf_IS_2021111016569448_IncomeStatementAbstract"));
     * 
     */
    private static string cleaningDartAccountingCode(string blaha) {
        if(blaha.indexOf("entity") < 0) {
            return blaha;
        }
        auto matchResult = matchFirst(blaha, ctRegex!(`entity\d+_udf_[BIS]+_\d+_(\w+)`));
        if(matchResult.empty)
            return blaha;
        return "udf-"~matchResult[1]; // 0은 Full-match, 1부터 group
    }
}

unittest {
	assert(Str.toKrxCurDtToISOString("2025.11.23 AM 02:45:15")=="20251123T024515");
}