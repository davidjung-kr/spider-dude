module spider.common.util.korean;

import std.range: empty;
import std.utf : toUTF8;
import core.sys.windows.winnls : MultiByteToWideChar; // 이걸로 바꿔!8;

immutable MS_WIN_CODEPAGE_949 = 949;

struct CP949 {
    public static string conv(const(ubyte)[] o) {
        if (o.empty) {
            return "";
        }
        int wlen = MultiByteToWideChar(MS_WIN_CODEPAGE_949, 0, cast(char*)o.ptr, cast(int)o.length, null, 0);
        wchar[] wbuf = new wchar[wlen];
        MultiByteToWideChar(MS_WIN_CODEPAGE_949, 0, cast(char*)o.ptr, cast(int)o.length, wbuf.ptr, wlen);
        return toUTF8(wbuf);
    }
}