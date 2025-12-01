module spider.common.util.uuid;

import std.uuid: randomUUID;
import std.conv: to;

string newUUID() {
    return to!string(randomUUID());
}