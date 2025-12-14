module spider.application.etlkrx;

import core.time: dur;
import core.thread.osthread: Thread;
import std.stdio: writef;
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
        super("ETLKRXApplication");
        this.context = context;
    }

    public override void main() {
        Date[] bizDTs = Calendar.getBizDateOfKorea(
            this.context.getInquiryStartDate(),
            this.context.getInquiryEndDate(),
        );
        this.context.getTable().setAutoCommit(false);
        scope(exit) {
            this.context.getTable().setAutoCommit(true);
        }
        foreach(Date bizDt; bizDTs) {
            if (this.context.getTable().selectExistBy(bizDt)) {
                continue;
            }
            KrxBldAttendantResponse res = this.clientReq(bizDt);
            string dumpYMS = res.getStrOfCurDT();
            foreach(OutBlock block; parallel(res.blocks)) {
                this.tbInsert(block, Str.toYMD(bizDt), dumpYMS);
            }
            this.context.getTable().commit();
        }
    }

    private KrxBldAttendantResponse clientReq(Date bizDt) {
        KrxBldAttendantResponse res = DataKrx.getBldAttendant(bizDt);
        Thread.sleep(dur!("msecs")(this.context.getSleepMsecs()));
        writef("\tclientReq | bizDt:[%s], cnt:[%d]\n", bizDt.toISOString(), res.blocks.length);
        return res;
    }

    private void tbInsert(OutBlock block, string strBizDt, string dumpYMS) {
        RowKRX row = RowKRX.by(
            strBizDt,
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