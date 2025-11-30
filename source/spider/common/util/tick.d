module spider.common.util.tick;

import std.datetime: Clock, SysTime;
import std.datetime.timezone : SimpleTimeZone, TimeZone, UTC;
import core.time;

// immutable TimeZone TZ_ASIA_SEOUL = new SimpleTimeZone(dur!"hours"(9), "GMT+9");

struct Tick {
    public static SysTime getGMT() {
        return Clock.currTime(UTC());
    }

    public static SysTime getKoreaYMS() {
        SysTime gmt = getGMT();
        return gmt + 9.hours;
    }
}