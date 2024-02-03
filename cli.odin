package main

import "packages/frigga"
import "core:log"
import "core:fmt"
import "core:os"
import "core:path/filepath"
import "utils"

cli :: proc () -> (map[string]frigga.ArgValueType, frigga.ArgParseError) {
    return frigga.parse([]frigga.Arg{
        frigga.Arg{"init", "--init", "-in", frigga.ArgType.STRING, false, nil, ""},
        frigga.Arg{"install", "--install", "-i", frigga.ArgType.BOOL, false, nil, ""},
        frigga.Arg{"add", "--add", "-a", frigga.ArgType.STRING, false, nil, ""}
    })

}
    