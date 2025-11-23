module spider.common.util.mkdir;

import std.file: exists, isDir, mkdir;

import spider.common.enums.path: Path;

struct Mkdir {
    public static void byDotPath(string x) {
        if (!exists(x) || !isDir(x)) {
            mkdir(x);
        }
    }

    public static void dartdata() {
        if (!exists(Path.DART_DATA_WITH_DOT) || !isDir(Path.DART_DATA_WITH_DOT)) {
            mkdir(Path.DART_DATA_WITH_DOT);
        }
    }
}