module spider.common.util.calendar;

import std.datetime: Date, DayOfWeek;
import std.array: appender;
import core.time: Duration, dur;

import spider.common.enums.calendar: HOLIDAY_KR_YN;

struct Calendar {
    public static Date[] getBizDateOfKorea(Date bf, Date af) {
        Duration x = af-bf;
        long max = x.total!"days";
        Date[] result = new Date[max];

        if (max==0) {
            result = [bf];
            max=1;
        }
        
        long size;
        for(long dd=0; dd<max; dd++) {
            Date dt = bf + dur!"days"(dd);
            if(dt.dayOfWeek == DayOfWeek.sat || dt.dayOfWeek == DayOfWeek.sun) {
                continue;
            } else if(dt in HOLIDAY_KR_YN) {
                continue;
            }
            result[size] = dt;
            size +=1;
        }
        return result[0..size];
    }
}