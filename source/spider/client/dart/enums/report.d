module spider.client.dart.enums.report;

enum ReportFileType {
	/// 알 수 없음
	NONE = "NONE",
	/// 재무제표
	BS = "BS",
	/// 손익계산서
	PL = "PL",
	/// 현금흐름표
	CF = "CF",
	/// 자본변동표
	CE = "CE"
}

/// 보고서 구분
enum ReportStatement {
	/// 알 수 없음
	NONE = "NONE",
    /// 재무상태표
    BS = "BS",
    /// 손익계산서 (Consolidated Statement of Income)
    CSI = "CIS",
    /// 포괄손익계산서 (Statement of Comprehensive Income)
    SCI = "SCI",
    /// 현금흐름표
    CF = "CF",
    /// 자본변동표
    SCE = "SCE"
}

/// 연결/개별 여부
enum ReportType {
    /// 연결 보고서
    CFS = "CFS",
    /// 개별 보고서
    OFS = "OFS"
}

/// N분기
enum Period {
	/// 알 수 없음
	NONE = "NONE",
    /// 1Q:1분기 보고서
    Q1 = "1Q",
    /// 2Q:반기 보고서
    Q2 = "2Q",
    /// 3Q:3분기 보고서
    Q3 = "3Q",
    /// 4Q:사업보고서
    Q4 = "4Q"
}