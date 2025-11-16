module spider.common.util.str;

import std.conv: to;
import std.array: replace;
import std.string: strip;
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
}