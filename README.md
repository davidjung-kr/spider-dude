# spider-dude
Self-made net-net & value stocks screener for KRX ๐

# Dependencies
* [ldc-developers/ldc](https://github.com/ldc-developers/ldc) - Compiler (Recommend๐) 
* [libmir/asdf](https://github.com/libmir/asdf) - For JSON parsing

# Features
## Loading Data
1. [Balance sheet from FSS (DART ์ฌ๋ฌด์ ๋ณด ํ์ผ ์ ์ฌ)](https://opendart.fss.or.kr/)
2. [Market cap, shares and prices from KRX (ํ๊ตญ๊ฑฐ๋์ ์ค์๊ฐ ์์  ์ ์ฌ)](http://data.krx.co.kr/contents/MDC/MDI/mdiLoader/index.cmd?menuId=MDC0201020101)
## Formula
* [x] NCAV
* [x] PBR
* [x] PER
* [ ] PSR
* [ ] ROE
* [ ] EV/EBITA
 
# Example
```.d
// ๋ด ๋ณด๊ณ ์
Report myReport = new Report();

// 1. ๊ฑฐ๋์ ๋ฐ์ดํฐ ์ ์ฌ (2022๋ 3์ 21์ผ ๊ธฐ์ค)
Downloader krxClient = new Downloader();
krxClient.readKrxCapAllByBlock(Date(2022, 03, 21), myReport);

// 2. ์ฌ๋ฌด์ํํ๋ฅผ ๋ด ๋ณด๊ณ ์์ ์ ์ฌ (2021_3Q_OFS_BS_20220215.txt โ 2021๋ 3๋ถ๊ธฐ ์ฐ๊ฒฐ ์ฌ๋ฌด์ ํ)
Parser bsOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.BS);
bsOfs2021Y3.read(myReport);

// 3. ์์ต๊ณ์ฐ์๋ฅผ ๋ด ๋ณด๊ณ ์์ ์ ์ฌ (2021_3Q_OFS_IS_20220215.txt โ 2021๋ 3๋ถ๊ธฐ ์ฐ๊ฒฐ ์์ต๊ณ์ฐ์)
Parser isOfs2021Y3 = new Parser("2021", Period.Y3, ReportType.OFS, StatementType.IS);
isOfs2021Y3.read(myReport);

// 4. ๋น์ ์ ์ข๋ชฉ ํํฐ๋ง
//	- ๋น์์ฅ ์ข๋ชฉ, ์์ฅํ์ง ์ข๋ชฉ, ์ค๊ตญํ์ฌ ์ ๊ฑฐ
myReport.filteringOnlyListed();
myReport.filteringNotCapZero();
myReport.filteringNotChineseCompany();

// 5. ์ํ๋ ๋ฐธ๋ฅ์์ด์ ์งํ ์ ์ฉ
Formula pbrFilter = new Formula(myReport);
foreach(stock; pbrFilter.query([FormulaName.PBR])["PBR"]) {
    writef("[%s] %f\n", stock.code, stock.value);
}
```
Easy squeezy lemon peasy ๐
