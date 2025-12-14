module spider.application.etl;

import core.time: dur;
import core.thread.osthread: Thread;
import std.datetime: Date, DateTime;
import std.parallelism: parallel;

import spider.common.util.str: Str;
import spider.common.util.calendar: Calendar;
import spider.application.parent: IApplicationContext, ETLApplicateObject;
import spider.database.table.krx: TableKRX;
import spider.database.model.krx: RowKRX;
import spider.client.krx.datakrx: DataKrx;
import spider.client.krx.model;

class ETLKRXApplication : ETLApplicateObject {
    private ETLKRXApplicationContext context;
    this(ETLKRXApplicationContext context) {
        this.context = context;
    }

    public override void main() {
        Date[] bizDTs = Calendar.getBizDateOfKorea(
            this.context.getInquiryStartDate(),
            this.context.getInquiryEndDate(),
        );
        import std.stdio;

        this.context.getTable().setAutoCommit(false);
        scope(exit) {
            this.context.getTable().commit();
            this.context.getTable().setAutoCommit(true);
        }
        writeln(bizDTs);
        foreach(Date bizDt; bizDTs) {
            if (this.context.getTable().selectExistBy(bizDt)) {
                continue;
            }
            KrxBldAttendantResponse res = DataKrx.getBldAttendant(bizDt);
            Thread.sleep(dur!("msecs")(this.context.getSleepMsecs()) );
            writef("[%s] End! | CNT:[%d]\n", bizDt.toISOString(), res.blocks.length);

            string dumpYMS = res.getStrOfCurDT();
            foreach(OutBlock block; res.blocks) {
                RowKRX row = RowKRX.by(
                    Str.toYMD(bizDt),
                    block.mktId,
                    block.isuSrtCd,
                    block.name,
                    block.marketCap(),
                    block.listShared(),
                    block.openPrice(),
                    block.highPrice(),
                    block.lowPrice(),
                    block.closePrice(),
                    dumpYMS
                );
                this.context.getTable().insert(row);
            }
        }
    }
}

class ETLKRXApplicationContext : IApplicationContext {
    private TableKRX tb;
    private Date inqStDt;
    private Date inqEdDt;
    private int sleepMsecs;

    /**
     * Params:
     *  tbKRX = 한국거래소 테이블
     *  inqStDt = 조회시작일
     *  sleepMsecs = 슬립시간
     */
    this(TableKRX tbKRX, Date inqStDt, Date inqEdDt, int sleepMsecs=3000) {
        this.tb = tbKRX;
        this.inqStDt = inqStDt;
        this.inqEdDt = inqEdDt;
        this.sleepMsecs = sleepMsecs;
    }

    public TableKRX getTable() {
        return this.tb;
    }

    public Date getInquiryStartDate() {
        return this.inqStDt;
    }
    
    public Date getInquiryEndDate() {
        return this.inqEdDt;
    }

    public int getSleepMsecs() {
        return this.sleepMsecs;
    }
}