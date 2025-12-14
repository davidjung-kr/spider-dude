module spider.application.parent;

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
    private SysTime stYMS;
    private SysTime edYMS;

    public void pre() {
        this.stYMS = Clock.currTime();
    }

    public void main() {

    }

    public void post() {
        this.edYMS = Clock.currTime();
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
