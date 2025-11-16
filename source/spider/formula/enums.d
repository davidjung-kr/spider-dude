module spider.formula.enums;


/// 공식명
enum FormulaName {
    /// Net-net current value (NCAV)
    NCAV,
	/// Price to Book-value Ratio (주가순자산비율)
	PBR,
	/// Enterprise value / Earnings Before Interest, Taxes, Depreciation and Amortization
	EV_EBITA,
	/// Price-earning ratio (주가수익비율)
	PER,
	/// GrossProfit / Assets
	GP_A,
	/// None 존재하지 않음
    NONE
}

/// Enum to String
struct StrFrom {
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