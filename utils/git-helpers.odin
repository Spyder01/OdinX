package utils

import "core:c/libc"
import "core:strings"

repo_exists :: proc(url: string) -> bool {
    _url, err := strings.clone_to_cstring(url)

    if err != nil {
        return false
    }

    return libc.system(_url) == 0
}

clone_repo :: proc(name: string, depth: string = "1") -> i32 {

    _url, err := strings.clone_to_cstring(string_join([]string{"git clone --depth ", depth, " https://", name, " packages/", name}))

    if err != nil {
        return 1
    }

    return libc.system(_url)
}

