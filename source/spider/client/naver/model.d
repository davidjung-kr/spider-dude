module spider.client.naver.model;

import asdf: serdeKeys, Asdf, serdeOptional;

struct StockNaverResponse {    
    @serdeKeys("list") StockNaverCandleItem[] list;
}

struct StockNaverCandleItem {
    @serdeKeys("localDate") string localDate;
    @serdeKeys("closePrice") double closePrice;
    @serdeKeys("openPrice") double openPrice;
    @serdeKeys("highPrice") double highPrice;
    @serdeKeys("lowPrice") double lowPrice;
    @serdeKeys("accumulatedTradingVolume") long accumulatedTradingVolume;
    @serdeKeys("foreignRetentionRate")
    @serdeOptional
    float foreignRetentionRate;
}