# spider-dude
Self-made net-net & value stocks screener for KRX 📈

# Dependencies
* [ldc-developers/ldc](https://github.com/ldc-developers/ldc) - Compiler (Recommend🌟) 
* [libmir/asdf](https://github.com/libmir/asdf) - For JSON parsing

# Example
```d
Report rpt = new Report();

// 한국거래소 2022년 3월 21일 기준 전종목 시세와 시가총액 등
Downloader krxClient = new Downloader();
krxClient.readKrxCapAllByBlock(Date(2022,03,21), rpt);
    
// File name: 2021_3Q_OFS_IS_20220215.txt → 2021년 3분기 연결 재무제표
Parser bsOfs = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.BS);
bsOfs.read(rpt);

// NCAV 공식적용
Formula netNetStocks = new Formula(rpt);

// NCAV 결과 취득
File fs = File("my_ncav_stock_list.txt", "w");
fs.writeln("CorpCode\tNCAV");
foreach(ncav; netNetStocks.query([FormulaName.NCAV])["NCAV"]) {
    if(ncav.value > 0) {
        fs.write(ncav.code);
        fs.write("\t");
        fs.writeln(ncav.value);
    }
}
fs.close();
```
Easy squeezy lemon peasy 🍋
