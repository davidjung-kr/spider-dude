module spider.application.parent;

import core.time: Duration;
import std.stdio: writef;
import std.string: format;
import std.datetime: Clock, SysTime, Date;

import spider.common.util.str: Str;

interface IApplication {
    public void pre();
    public void main();
    public void post();
    public void tick();
}

class ETLApplicateObject : IApplication {
    private string appName;
    private SysTime stYMS;
    private SysTime edYMS;

    this(string appName) {
        this.appName = appName;
    }

    public void pre() {
        this.stYMS = Clock.currTime();
        writef("[%s] %s | Start\n", this.stYMS.toISOString(), this.appName);
    }

    public void main() {

    }

    public void post() {
        this.edYMS = Clock.currTime();
        Duration gap = this.edYMS-this.stYMS;

        writef("[%s] %s | End (%fs)\n",
            this.edYMS.toISOString(),
            this.appName,
            gap.total!"seconds");
    }

    public void tick() {
        pre();
        main();
        post();
    }

    protected Date getDate() {
        return Date(this.stYMS.year, this.stYMS.month, this.stYMS.day);
    }

    protected string getYMD() {
        return Str.toYMD(this.stYMS);
    }

    public SysTime getStYMS() {
        return this.stYMS;
    }

    public SysTime getEdYMS() {
        return this.edYMS;
    }
}

interface IApplicationContext {

}
