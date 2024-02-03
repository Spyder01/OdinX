package utils 

import "core:fmt"
import "core:strings"

string_join :: proc (arr: []string, seperator: string = "")-> string {
    builder: strings.Builder
    res: string

    for s in arr {
        res = fmt.sbprintf(&builder, "%s%s", s, seperator)
    }

    return res
}

main :: proc() {
    fmt.println(string_join([]string {"Helo", "World", "Some"}, " "))
}