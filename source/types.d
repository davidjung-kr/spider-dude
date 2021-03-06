module com.davidjung.spider.types;

/**
 * spider-dude :: Self-made net-net & value stocks screener for KRX ๐
 * github.com/davidjung-kr/spider-dude
 * 
 * Date: 03, 2022
 * Authors: David Jung
 * License: GPL-3.0
 */

import std.conv;
import std.string;
import std.math.rounding;

/// ์ฐ๊ฒฐ/๊ฐ๋ณ ์ฌ๋ถ
enum ReportType {
    /// ์ฐ๊ฒฐ ๋ณด๊ณ ์
    CFS,
    /// ๊ฐ๋ณ ๋ณด๊ณ ์
    OFS
}

/// ๋ณด๊ณ ์ ๊ตฌ๋ถ
enum StatementType {
    /// ์ฌ๋ฌด์ํํ
    BS,
    /// ์์ต๊ณ์ฐ์
    IS,
    /// ํฌ๊ด์์ต๊ณ์ฐ์
    CIS,
    /// ํ๊ธํ๋ฆํ
    CF,
    /// ์๋ณธ๋ณ๋ํ
    SCE
}

/// IFRS ์ฝ๋
enum IfrsCode {
	/// `ifrs-full_Assets`: ์ด์์ฐ
	FULL_ASSETS,
    /// `ifrs-full_CurrentAssets`: ์ ๋์์ฐ
    FULL_CURRENTASSETS,
    /// `ifrs-full_Liabilities`: ๋ถ์ฑ์ด๊ณ
    FULL_LIABILITIES,
	/// `ifrs-full_equity`: ์๋ณธ์ด๊ณ
	FULL_EQUITY,

	/// `ifrs-full_Revenue`:๋งค์ถ์ก
	FULL_REVENUE,
	/// `ifrs-full_GrossProfit`: ๋งค์ถ์ด์ด์ต
	FULL_GROSSPROFIT,
    /// `ifrs-full_ProfitLoss`: ๋น๊ธฐ์์ด์ต
    FULL_PROFITLOSS
}

/// DART ์ฝ๋
enum DartCode {
	/// `dart_DepreciationExpense`:๊ฐ๊ฐ์๊ฐ๋น
	DEPRECIATION_EXPENSE,
	/// `dart_OperatingIncomeLoss`:์์์ด์ต
	OPERATING_INCOME_LOSS,
	/// `dart_AmortisationExpense`:๋ฌดํ์์ฐ์๊ฐ๋น
	AMORTISATION_EXPENSE
}

/// N๋ถ๊ธฐ
enum Period {
    /// 1Q:1๋ถ๊ธฐ ๋ณด๊ณ ์
    Y1,
    /// 2Q:๋ฐ๊ธฐ ๋ณด๊ณ ์
    Y2,
    /// 3Q:3๋ถ๊ธฐ ๋ณด๊ณ ์
    Y3,
    /// 4Q:์ฌ์๋ณด๊ณ ์
    Y4
}

/// ๊ณต์๋ช
enum FormulaName {
    /// Net-net current value (NCAV)
    NCAV,
	/// Price to Book-value Ratio (์ฃผ๊ฐ์์์ฐ๋น์จ)
	PBR,
	/// Enterprise value / Earnings Before Interest, Taxes, Depreciation and Amortization
	EV_EBITA,
	/// Price-earning ratio (์ฃผ๊ฐ์์ต๋น์จ)
	PER,
	/// GrossProfit / Assets
	GP_A,
	/// None ์กด์ฌํ์ง ์์
    NONE
}

/// ์์ข๊ตฌ๋ถ
enum IndustriesType {
	/// ๋์ถ, ์ก๋ฅ ๊ฐ๊ณต ๋ฐ ์ ์ฅ ์ฒ๋ฆฌ์
	C101,
	/// ์์ฐ๋ฌผ ๊ฐ๊ณต ๋ฐ ์ ์ฅ ์ฒ๋ฆฌ์
	C102,
	/// ๊ณผ์ค, ์ฑ์ ๊ฐ๊ณต ๋ฐ ์ ์ฅ ์ฒ๋ฆฌ์
	C103, 
	/// ๋๋์ ํ ๋ฐ ์์ฉ๋น๊ณผ๋ฅ ์ ์กฐ์
	C105, 
	/// ๊ณก๋ฌผ๊ฐ๊ณตํ, ์ ๋ถ ๋ฐ ์ ๋ถ์ ํ ์ ์กฐ์
	C106, 
	/// ๊ธฐํ ์ํ ์ ์กฐ์
	C107,
	/// ๋๋ฌผ์ฉ ์ฌ๋ฃ ๋ฐ ์กฐ์ ์ํ ์ ์กฐ์
	C108, 
	/// ์๋ฌผ ์ฌ๋ฐฐ์
	C011, 
	/// ์์ฝ์ฌ์๋ฃ ์ ์กฐ์
	C111, 
	/// ๋น์์ฝ์ฌ์๋ฃ ๋ฐ ์ผ์ ์ ์กฐ์
	C112, 
	/// ๋ด๋ฐฐ ์ ์กฐ์
	C120, 
	/// ๋ฐฉ์  ๋ฐ ๊ฐ๊ณต์ฌ ์ ์กฐ์
	C131, 
	/// ์ง๋ฌผ์ง์กฐ ๋ฐ ์ง๋ฌผ์ ํ ์ ์กฐ์
	C132, 
	/// ํธ์กฐ์๋จ ์ ์กฐ์
	C133, 
	/// ๊ธฐํ ์ฌ์ ์ ํ ์ ์กฐ์
	C139, 
	/// ๋ด์ ์๋ณต ์ ์กฐ์
	C141, 
	/// ํธ์กฐ์๋ณต ์ ์กฐ์
	C143, 
	/// ์๋ณต ์ก์ธ์๋ฆฌ ์ ์กฐ์
	C144, 
	/// ๊ฐ์ฃฝ, ๊ฐ๋ฐฉ ๋ฐ ์ ์ฌ์ ํ ์ ์กฐ์
	C151, 
	/// ์ ๋ฐ ๋ฐ ์ ๋ฐ ๋ถ๋ถํ ์ ์กฐ์
	C152, 
	/// ์ ์ฌ ๋ฐ ๋ชฉ์ฌ ๊ฐ๊ณต์
	C161, 
	/// ๋๋ฌด์ ํ ์ ์กฐ์
	C162, 
	/// ํํ, ์ข์ด ๋ฐ ํ์ง ์ ์กฐ์
	C171, 
	/// ๊ณจํ์ง, ์ข์ด ์์ ๋ฐ ์ข์ด ์ฉ๊ธฐ ์ ์กฐ์
	C172, 
	/// ๊ธฐํ ์ข์ด ๋ฐ ํ์ง ์ ํ ์ ์กฐ์
	C179, 
	/// ์ธ์ ๋ฐ ์ธ์๊ด๋ จ ์ฐ์
	C181, 
	/// ๊ธฐ๋ก๋งค์ฒด ๋ณต์ ์
	C182, 
	/// ์์  ์ ์ ํ ์ ์กฐ์
	C192, 
	/// ๊ธฐ์ด ํํ๋ฌผ์ง ์ ์กฐ์
	C201, 
	/// ํฉ์ฑ๊ณ ๋ฌด ๋ฐ ํ๋ผ์คํฑ ๋ฌผ์ง ์ ์กฐ์
	C202, 
	/// ๋น๋ฃ, ๋์ฝ ๋ฐ ์ด๊ท , ์ด์ถฉ์  ์ ์กฐ์
	C203, 
	/// ๊ธฐํ ํํ์ ํ ์ ์กฐ์
	C204, 
	/// ํํ์ฌ์  ์ ์กฐ์
	C205, 
	/// ๊ธฐ์ด ์์ฝ๋ฌผ์ง ๋ฐ ์๋ฌผํ์  ์ ์  ์ ์กฐ์
	C211, 
	/// ์์ฝํ ์ ์กฐ์
	C212, 
	/// ์๋ฃ์ฉํ ๋ฐ ๊ธฐํ ์์ฝ ๊ด๋ จ์ ํ ์ ์กฐ์
	C213, 
	/// ๊ณ ๋ฌด์ ํ ์ ์กฐ์
	C221, 
	/// ํ๋ผ์คํฑ์ ํ ์ ์กฐ์
	C222, 
	/// ์ ๋ฆฌ ๋ฐ ์ ๋ฆฌ์ ํ ์ ์กฐ์
	C231, 
	/// ๋ดํ, ๋น๋ดํ ์์์ ํ ์ ์กฐ์
	C232, 
	/// ์๋ฉํธ, ์ํ, ํ๋ผ์คํฐ ๋ฐ ๊ทธ ์ ํ ์ ์กฐ์
	C233, 
	/// ๊ธฐํ ๋น๊ธ์ ๊ด๋ฌผ์ ํ ์ ์กฐ์
	C239, 
	/// 1์ฐจ ์ฒ ๊ฐ ์ ์กฐ์
	C241, 
	/// 1์ฐจ ๋น์ฒ ๊ธ์ ์ ์กฐ์
	C242, 
	/// ๊ธ์ ์ฃผ์กฐ์
	C243, 
	/// ๊ตฌ์กฐ์ฉ ๊ธ์์ ํ, ํฑํฌ ๋ฐ ์ฆ๊ธฐ๋ฐ์๊ธฐ ์ ์กฐ์
	C251, 
	/// ๋ฌด๊ธฐ ๋ฐ ์ดํฌํ ์ ์กฐ์
	C252, 
	/// ๊ธฐํ ๊ธ์ ๊ฐ๊ณต์ ํ ์ ์กฐ์
	C259, 
	/// ๋ฐ๋์ฒด ์ ์กฐ์
	C261, 
	/// ์ ์๋ถํ ์ ์กฐ์
	C262, 
	/// ์ปดํจํฐ ๋ฐ ์ฃผ๋ณ์ฅ์น ์ ์กฐ์
	C263, 
	/// ํต์  ๋ฐ ๋ฐฉ์ก ์ฅ๋น ์ ์กฐ์
	C264, 
	/// ์์ ๋ฐ ์ํฅ๊ธฐ๊ธฐ ์ ์กฐ์
	C265, 
	/// ์๋ฃ์ฉ ๊ธฐ๊ธฐ ์ ์กฐ์
	C271, 
	/// ์ธก์ , ์ํ, ํญํด, ์ ์ด ๋ฐ ๊ธฐํ ์ ๋ฐ๊ธฐ๊ธฐ ์ ์กฐ์; ๊ดํ๊ธฐ๊ธฐ ์ ์ธ
	C272, 
	/// ์ฌ์ง์ฅ๋น ๋ฐ ๊ดํ๊ธฐ๊ธฐ ์ ์กฐ์
	C273, 
	/// ์ ๋๊ธฐ, ๋ฐ์ ๊ธฐ ๋ฐ ์ ๊ธฐ ๋ณํใ ๊ณต๊ธใ์ ์ด ์ฅ์น ์ ์กฐ์
	C281, 
	/// ์ผ์ฐจ์ ์ง ๋ฐ ์ถ์ ์ง ์ ์กฐ์
	C282, 
	/// ์ ์ฐ์  ๋ฐ ์ผ์ด๋ธ ์ ์กฐ์
	C283, 
	/// ์ ๊ตฌ ๋ฐ ์กฐ๋ช์ฅ์น ์ ์กฐ์
	C284, 
	/// ๊ฐ์ ์ฉ ๊ธฐ๊ธฐ ์ ์กฐ์
	C285, 
	/// ๊ธฐํ ์ ๊ธฐ์ฅ๋น ์ ์กฐ์
	C289, 
	/// ์ผ๋ฐ ๋ชฉ์ ์ฉ ๊ธฐ๊ณ ์ ์กฐ์
	C291, 
	/// ํน์ ๋ชฉ์ ์ฉ ๊ธฐ๊ณ ์ ์กฐ์
	C292, 
	/// ์๋์ฐจ์ฉ ์์ง ๋ฐ ์๋์ฐจ ์ ์กฐ์
	C301, 
	/// ์๋์ฐจ ์ ํ ๋ถํ ์ ์กฐ์
	C303, 
	/// ์๋์ฐจ ์ฌ์ ์กฐ ๋ถํ ์ ์กฐ์
	C304, 
	/// ์ด๋ก ์ด์
	C031, 
	/// ์ ๋ฐ ๋ฐ ๋ณดํธ ๊ฑด์กฐ์
	C311, 
	/// ์ฒ ๋์ฅ๋น ์ ์กฐ์
	C312, 
	/// ํญ๊ณต๊ธฐ, ์ฐ์ฃผ์  ๋ฐ ๋ถํ ์ ์กฐ์
	C313, 
	/// ๊ทธ ์ธ ๊ธฐํ ์ด์ก์ฅ๋น ์ ์กฐ์
	C319, 
	/// ๊ฐ๊ตฌ ์ ์กฐ์
	C320, 
	/// ๊ท๊ธ์ ๋ฐ ์ฅ์ ์ฉํ ์ ์กฐ์
	C331, 
	/// ์๊ธฐ ์ ์กฐ์
	C332, 
	/// ์ด๋ ๋ฐ ๊ฒฝ๊ธฐ์ฉ๊ตฌ ์ ์กฐ์
	C333, 
	/// ๊ทธ ์ธ ๊ธฐํ ์ ํ ์ ์กฐ์
	C339, 
	/// ์ ๊ธฐ์
	C351, 
	/// ์ฐ๋ฃ์ฉ ๊ฐ์ค ์ ์กฐ ๋ฐ ๋ฐฐ๊ด๊ณต๊ธ์
	C352, 
	/// ์ฆ๊ธฐ, ๋ใ์จ์ ๋ฐ ๊ณต๊ธฐ์กฐ์  ๊ณต๊ธ์
	C353, 
	/// ํ๊ธฐ๋ฌผ ์ฒ๋ฆฌ์
	C382, 
	/// ํ๊ฒฝ ์ ํ ๋ฐ ๋ณต์์
	C390, 
	/// ๊ฑด๋ฌผ ๊ฑด์ค์
	C411, 
	/// ํ ๋ชฉ ๊ฑด์ค์
	C412, 
	/// ๊ธฐ๋ฐ์กฐ์ฑ ๋ฐ ์์ค๋ฌผ ์ถ์กฐ๊ด๋ จ ์ ๋ฌธ๊ณต์ฌ์
	C421, 
	/// ๊ฑด๋ฌผ์ค๋น ์ค์น ๊ณต์ฌ์
	C422, 
	/// ์ ๊ธฐ ๋ฐ ํต์  ๊ณต์ฌ์
	C423, 
	/// ์ค๋ด๊ฑด์ถ ๋ฐ ๊ฑด์ถ๋ง๋ฌด๋ฆฌ ๊ณต์ฌ์
	C424, 
	/// ์๋์ฐจ ํ๋งค์
	C451, 
	/// ์๋์ฐจ ๋ถํ ๋ฐ ๋ด์ฅํ ํ๋งค์
	C452, 
	/// ์ํ ์ค๊ฐ์
	C461, 
	/// ์ฐ์์ฉ ๋ใ์ถ์ฐ๋ฌผ ๋ฐ ๋ใ์๋ฌผ ๋๋งค์
	C462, 
	/// ์ใ์๋ฃํ ๋ฐ ๋ด๋ฐฐ ๋๋งค์
	C463, 
	/// ์ํ์ฉํ ๋๋งค์
	C464, 
	/// ๊ธฐ๊ณ์ฅ๋น ๋ฐ ๊ด๋ จ ๋ฌผํ ๋๋งค์
	C465, 
	/// ๊ธฐํ ์ ๋ฌธ ๋๋งค์
	C467, 
	/// ์ํ ์ขํฉ ๋๋งค์
	C468, 
	/// ์ขํฉ ์๋งค์
	C471, 
	/// ์ใ์๋ฃํ ๋ฐ ๋ด๋ฐฐ ์๋งค์
	C472, 
	/// ์ฌ์ , ์๋ณต, ์ ๋ฐ ๋ฐ ๊ฐ์ฃฝ์ ํ ์๋งค์
	C474, 
	/// ์ฐ๋ฃ ์๋งค์
	C477, 
	/// ๊ธฐํ ์ํ ์ ๋ฌธ ์๋งค์
	C478, 
	/// ๋ฌด์ ํฌ ์๋งค์
	C479, 
	/// ์ก์ ์ฌ๊ฐ ์ด์ก์
	C492, 
	/// ๋๋ก ํ๋ฌผ ์ด์ก์
	C493, 
	/// ํด์ ์ด์ก์
	C501, 
	/// ํญ๊ณต ์ฌ๊ฐ ์ด์ก์
	C511, 
	/// ๊ธฐํ ์ด์ก๊ด๋ จ ์๋น์ค์
	C529, 
	/// ์ผ๋ฐ ๋ฐ ์ํ ์๋ฐ์์ค ์ด์์
	C551, 
	/// ์์์ ์
	C561, 
	/// ์์ , ์ก์ง ๋ฐ ๊ธฐํ ์ธ์๋ฌผ ์ถํ์
	C581, 
	/// ์ํํธ์จ์ด ๊ฐ๋ฐ ๋ฐ ๊ณต๊ธ์
	C582, 
	/// ์ํ, ๋น๋์ค๋ฌผ, ๋ฐฉ์กํ๋ก๊ทธ๋จ ์ ์ ๋ฐ ๋ฐฐ๊ธ์
	C591, 
	/// ์ค๋์ค๋ฌผ ์ถํ ๋ฐ ์ํ ๋น์์
	C592, 
	/// ํ๋ ๋น์  ๋ฐฉ์ก์
	C602, 
	/// ์ ๊ธฐ ํต์ ์
	C612, 
	/// ์ปดํจํฐ ํ๋ก๊ทธ๋๋ฐ, ์์คํ ํตํฉ ๋ฐ ๊ด๋ฆฌ์
	C620, 
	/// ์๋ฃ์ฒ๋ฆฌ, ํธ์คํ, ํฌํธ ๋ฐ ๊ธฐํ ์ธํฐ๋ท ์ ๋ณด๋งค๊ฐ ์๋น์ค์
	C631, 
	/// ๊ธฐํ ์ ๋ณด ์๋น์ค์
	C639, 
	/// ์ ํ์ ๋ฐ ์งํฉํฌ์์
	C642, 
	/// ๊ธฐํ ๊ธ์ต์
	C649, 
	/// ๊ธ์ต ์ง์ ์๋น์ค์
	C661, 
	/// ๋ณดํ ๋ฐ ์ฐ๊ธ๊ด๋ จ ์๋น์ค์
	C662, 
	/// ๋ถ๋์ฐ ์๋ ๋ฐ ๊ณต๊ธ์
	C681, 
	/// ์์ฐ๊ณผํ ๋ฐ ๊ณตํ ์ฐ๊ตฌ๊ฐ๋ฐ์
	C701, 
	/// ๊ด๊ณ ์
	C713, 
	/// ์์ฅ์กฐ์ฌ ๋ฐ ์ฌ๋ก ์กฐ์ฌ์
	C714, 
	/// ํ์ฌ ๋ณธ๋ถ ๋ฐ ๊ฒฝ์ ์ปจ์คํ ์๋น์ค์
	C715, 
	/// ๊ธฐํ ์ ๋ฌธ ์๋น์ค์
	C716, 
	/// ๊ธฐํ ๋น๊ธ์๊ด๋ฌผ ๊ด์
	C072, 
	/// ๊ฑด์ถ๊ธฐ์ , ์์ง๋์ด๋ง ๋ฐ ๊ด๋ จ ๊ธฐ์  ์๋น์ค์
	C721, 
	/// ๊ธฐํ ๊ณผํ๊ธฐ์  ์๋น์ค์
	C729, 
	/// ์ ๋ฌธ ๋์์ธ์
	C732, 
	/// ๊ทธ ์ธ ๊ธฐํ ์ ๋ฌธ, ๊ณผํ ๋ฐ ๊ธฐ์  ์๋น์ค์
	C739, 
	/// ์ฌ์์์ค ์ ์งใ๊ด๋ฆฌ ์๋น์ค์
	C741, 
	/// ์ฌํ์ฌ ๋ฐ ๊ธฐํ ์ฌํ๋ณด์กฐ ์๋น์ค์
	C752, 
	/// ๊ฒฝ๋น, ๊ฒฝํธ ๋ฐ ํ์ ์
	C753, 
	/// ๊ธฐํ ์ฌ์์ง์ ์๋น์ค์
	C759, 
	/// ์ด์ก์ฅ๋น ์๋์
	C761, 
	/// ๊ฐ์ธ ๋ฐ ๊ฐ์ ์ฉํ ์๋์
	C762, 
	/// ์ฐ์์ฉ ๊ธฐ๊ณ ๋ฐ ์ฅ๋น ์๋์
	C763, 
	/// ์ด๋ฑ ๊ต์ก๊ธฐ๊ด
	C851, 
	/// ์ผ๋ฐ ๊ต์ต ํ์
	C855, 
	/// ๊ธฐํ ๊ต์ก๊ธฐ๊ด
	C856, 
	/// ๊ต์ก์ง์ ์๋น์ค์
	C857, 
	/// ์ฐฝ์ ๋ฐ ์์ ๊ด๋ จ ์๋น์ค์
	C901, 
	/// ์ ์์ง ๋ฐ ๊ธฐํ ์ค๋ฝ๊ด๋ จ ์๋น์ค์
	C912,
	/// ๊ทธ ์ธ ๊ธฐํ ๊ฐ์ธ ์๋น์ค์
	C969 
}

/// Enum to String
struct GetCodeFrom {
    public static string statementType(StatementType e) @safe {
        switch(e) {
        case StatementType.BS: return "BS";
        case StatementType.IS: return "IS";
        case StatementType.CIS: return "CIS";
        case StatementType.CF: return "CF";
        case StatementType.SCE: return "SCE";
        default: throw new Exception("Wrong code - ["~e.to!string~"]");
        }
    }

	public static string reportType(ReportType e) @safe {
        switch(e) {
        case ReportType.OFS: return "OFS"; // ๊ฐ๋ณ ๋ณด๊ณ ์
        case ReportType.CFS: return "CFS"; // ์ฐ๊ฒฐ ๋ณด๊ณ ์
        default: return "";
        }
    }

	/// IfrsCode Enum์ String์ผ๋ก
	public static string ifrsCode(IfrsCode e) @safe {
        switch(e) {
		case IfrsCode.FULL_ASSETS:        return "ifrs-full_Assets";
        case IfrsCode.FULL_CURRENTASSETS: return "ifrs-full_CurrentAssets";
        case IfrsCode.FULL_LIABILITIES:   return "ifrs-full_Liabilities";
		case IfrsCode.FULL_REVENUE:       return "ifrs-full_Revenue";
        case IfrsCode.FULL_PROFITLOSS:    return "ifrs-full_ProfitLoss";
		case IfrsCode.FULL_EQUITY:        return "ifrs-full_Equity";
		case IfrsCode.FULL_GROSSPROFIT:   return "ifrs-full_GrossProfit";
        default: return "";
        }
    }

	/// DartCode Enum์ String์ผ๋ก
	public static string dartCode(DartCode e) @safe {
        switch(e) {
		case DartCode.DEPRECIATION_EXPENSE:  return "dart_DepreciationExpense";
		case DartCode.OPERATING_INCOME_LOSS: return "dart_OperatingIncomeLoss";
		case DartCode.AMORTISATION_EXPENSE:  return "dart_AmortisationExpense";
        default: return "";
        }
    }

    public static string period(Period e) @safe {
        switch(e) {
        case Period.Y1: return "1Q";
        case Period.Y2: return "2Q";
        case Period.Y3: return "3Q";
        case Period.Y4: return "4Q";
        default: return "";
        }
    }

    public static string formulaName (FormulaName e) {
        switch(e){
        case FormulaName.NCAV: return "NCAV";
		case FormulaName.PBR:  return "PBR";
		case FormulaName.PER:  return "PER";
		case FormulaName.EV_EBITA: return "EV/EBITA";
		case FormulaName.GP_A: return "GP/A";
        default: return "NONE";
        }
    }

}

/// ์ฌ๋ฌด์ํํ
struct Bs {
	/// [0] ์ฌ๋ฌด์ ํ์ข๋ฅ
	string type;
	/// [1] ์ข๋ชฉ์ฝ๋
	string code;
	/// [2] ํ์ฌ๋ช
	string name;
	/// [3] ์์ฅ๊ตฌ๋ถ
	string market;
	/// [4] ์์ข
	string sector;
	/// [5] ์์ข๋ช
	string sectorName;
	/// [6] ๊ฒฐ์ฐ์
	string endMonth;
	/// [7] ๊ฒฐ์ฐ๊ธฐ์ค์ผ
	string endDay;
	/// [8] ๋ณด๊ณ ์์ข๋ฅ
	string report;

	string pprint() {
		string s;
		// [0] ์ฌ๋ฌด์ ํ์ข๋ฅ
		s ~= "type:"~type~",\n";
		// [1] ์ข๋ชฉ์ฝ๋
		s ~= "code:"~code~",\n";
		// [2] ํ์ฌ๋ช
		s ~= "name:"~name~",\n";
		// [3] ์์ฅ๊ตฌ๋ถ
		s ~= "market:"~market~",\n";
		// [4] ์์ข
		s ~= "sector:"~sector~",\n";
		// [5] ์์ข๋ช
		s ~= "sectorName:"~sectorName~",\n";
		// [6] ๊ฒฐ์ฐ์
		s ~= "endMonth:"~endMonth~",\n";
		// [7] ๊ฒฐ์ฐ๊ธฐ์ค์ผ
		s ~= "endDay:"~endDay~",\n";
		// [8] ๋ณด๊ณ ์์ข๋ฅ
		s ~= "report:"~report;
		return s;
	}

	/// ๊ณ์ ํญ๋ชฉ๋ค
	Statement[] statements;

	/// ์ฌ๋ฌด์ ํ ์ง์
	long q(IfrsCode ifrsCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * ๊ณ์ ๊ณผ๋ชฉ ๋น์ด์๋ ์ง ํ์ธ
	 */
	public bool empty() {
		if(statements.length <= 0)
			return true;
		return false;
	}
}

/// ํฌ๊ด์์ต๊ณ์ฐ์
struct Cis {
	// ๋ถ๊ธฐ
	private Period _period;

	/// [0] ์ฌ๋ฌด์ ํ์ข๋ฅ
	string type;
	/// [1] ์ข๋ชฉ์ฝ๋
	string code;
	/// [2] ํ์ฌ๋ช
	string name;
	/// [3] ์์ฅ๊ตฌ๋ถ
	string market;
	/// [4] ์์ข
	string sector;
	/// [5] ์์ข๋ช
	string sectorName;
	/// [6] ๊ฒฐ์ฐ์
	string endMonth;
	/// [7] ๊ฒฐ์ฐ๊ธฐ์ค์ผ
	string endDay;
	/// [8] ๋ณด๊ณ ์์ข๋ฅ
	string report;

	/// ์์ฑ์
	this(Period period) {
		_period = period;
	}

	string pprint() {
		string s;
		/// [0] ์ฌ๋ฌด์ ํ์ข๋ฅ
		s ~= "type:"~type~",\n";
		/// [1] ์ข๋ชฉ์ฝ๋
		s ~= "code:"~code~",\n";
		/// [2] ํ์ฌ๋ช
		s ~= "name:"~name~",\n";
		/// [3] ์์ฅ๊ตฌ๋ถ
		s ~= "market:"~market~",\n";
		/// [4] ์์ข
		s ~= "sector:"~sector~",\n";
		/// [5] ์์ข๋ช
		s ~= "sectorName:"~sectorName~",\n";
		/// [6] ๊ฒฐ์ฐ์
		s ~= "endMonth:"~endMonth~",\n";
		/// [7] ๊ฒฐ์ฐ๊ธฐ์ค์ผ
		s ~= "endDay:"~endDay~",\n";
		/// [8] ๋ณด๊ณ ์์ข๋ฅ
		s ~= "report:"~report;
		return s;
	}

	/// ๊ณ์ ํญ๋ชฉ๋ค
	StatementNq[] statements;

	/// ์ฌ๋ฌด์ ํ ์ง์
	long q(IfrsCode ifrsCode) {
		import std.stdio;
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.ifrsCode(ifrsCode)) {
				// ์ฌ์๋ณด๊ณ ์์ธ์ง ์ฌ๋ถ์ ๋ฐ๋ผ ๋น๊ธฐ(nowAcc)์ธ์ง ๋์ (now)์ธ ์ง ํญ๋ชฉ์ด ๋ฌ๋ผ์ง
				return _period == Period.Y4 ? this.statements[i].nowAcc : this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * ๋คํธ ๊ณ์ ๊ณผ๋ชฉ ์กฐํ
	 */
	long queryDartStatement(DartCode dartCode) {
		for(int i=0; i<this.statements.length; i++) {
			if(this.statements[i].statementCode == GetCodeFrom.dartCode(dartCode)) {
				return this.statements[i].now;
			}
		}
		return 0;
	}

	/**
	 * ๊ณ์ ๊ณผ๋ชฉ ๋น์ด์๋ ์ง ํ์ธ
	 */
	public bool empty() {
		if(statements.length <= 0)
			return true;
		return false;
	}
}

/// ์์ต๊ณ์ฐ์
alias Is = Cis;

/// ๊ณ์ ํญ๋ชฉ
struct Statement {
	// [0] ํตํ
	string currency;
	// [1] ํญ๋ชฉ์ฝ๋
	string statementCode;
	// [2] ํญ๋ชฉ๋ช
	string rowName;
	// [3] ๋น๊ธฐ
	long now = 0;
	// [4] ์ ๊ธฐ
	long y1 = 0;
	// [5] ์ ์ ๊ธฐ
	long y2 = 0;

	void setMoney(string now, string y1, string y2) {
		string e1 = strip(now).replace(",", "");
		string e2 = strip(y1).replace(",", "");
		string e3 = strip(y2).replace(",", "");
		this.now = (e1 == "") ? 0:to!long(e1);
		this.y1 =  (e2 == "") ? 0:to!long(e2);
		this.y2 =  (e3 == "") ? 0:to!long(e3);
	}
}

/// ์์ต๊ณ์ฐ์ ๊ณ์ ํญ๋ชฉ
struct StatementNq {
    /// [0] ํตํ
    string currency;
    /// [1] ํญ๋ชฉ์ฝ๋
    string statementCode;
    /// [2] ํญ๋ชฉ๋ช
    string rowName;
    /// [3] ๋น๊ธฐ 3๋ถ๊ธฐ 3๊ฐ์
    long now = 0;
    /// [4] ๋น๊ธฐ 3๋ถ๊ธฐ ๋์ 
    long nowAcc = 0;
    /// [5] ์ ๊ธฐ 3๋ถ๊ธฐ 3๊ฐ์
    long y1 = 0;
    /// [6] ์ ๊ธฐ 3๋ถ๊ธฐ ๋์ 
    long y1Acc = 0;
    /// [7] ์ ๊ธฐ
    long y2 = 0;
    /// [8] ์ ์ ๊ธฐ
    long y2Acc = 0;

	void setMoney(string now, string nowAcc, string y1, string y1Acc, string y2, string y2Acc) {
		string n = strip(now).replace(",", "");
        string na = strip(nowAcc).replace(",", "");
        this.now    = (n == "")  ? 0:to!long(n);
        this.nowAcc = (na == "") ? 0:to!long(na);

        y1         = strip(y1).replace(",", "");
        string y1a = strip(y1Acc).replace(",", "");
        this.y1    = (y1 == "")  ? 0:to!long(y1);
        this.y1Acc = (y1a == "") ? 0:to!long(y1a);

        y2         = strip(y2)   .replace(",", "");
        string y2a = strip(y2Acc).replace(",", "");
        this.y2    = (y2 == "")  ? 0:to!long(y2);
        this.y2Acc = (y2a == "") ? 0:to!long(y2a);
	}
}

/** 
 * ๊ณต์๊ฒฐ๊ณผ
 */
struct FormulaResult {
    /// ์ข๋ชฉ์ฝ๋
    private string _code;
    /// ์ข๋ชฉ์ฝ๋(Getter)
    @property string code() { return _code; }
    /// ๊ฒฐ๊ณผ ๊ฐ
    private long _value;
    /// ๊ฒฐ๊ณผ ๊ฐ(Getter)
    @property long value() { return _value; }
    /// ๊ฒฐ๊ณผ ๊ฐ(Setter)
    @property void value(long v) { this._value = v; }
    /// ๋น์จ ๊ฐ
    private float _ratio;
    /// ๋น์จ ๊ฐ(Getter)
    @property float ratio() { return _ratio; }
    /// ๋น์จ ๊ฐ(Setter)
    @property void ratio(float v) { this._ratio = v; }

	/** 
	 * ์์ฑ์
	 * Params:
	 *	code = ์ข๋ชฉ์ฝ๋
	 */
	this(string code) {
		this._code = code;
	}

	/**
	 * ๋น์ด์๋ ์ง ์ฌ๋ถ
	 */
	@property bool empty() {
		return (_value==0 && _ratio ==0);
	}

	@property bool notEmpty() {
		return !this.empty();
	}

	/**
	 * ๋น์จ ๊ฐ์ด x์ด์ y์ดํ์ธ ์ง ํ์ธ
	 */
	public bool ratioBetween(float x, float y) {
		return _ratio >= x && _ratio <= y;
	}
}