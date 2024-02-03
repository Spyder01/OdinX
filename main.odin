package main

import "core:c/libc"
import "core:fmt"
import "core:path/filepath"
import "core:strings"
import "packages/frigga"
import "utils"


OdinXInfo :: struct {
	name:         string,
	// path:          string,
	dependencies: [dynamic]string,
}

main :: proc() {
	args, err := cli()
	if err != nil {
		fmt.println(frigga.get_error_message(err))
		return
	}
	init, init_contains := args["init"]

	if init_contains {
		#partial switch i in init {
		case string:
			if utils.is_dir(i) {
				name, err := utils.get_basename(i)
				fmt.println(err)
				_err := utils.make_json(
					OdinXInfo{name, [dynamic]string{}},
					filepath.join([]string{i, "odinx.json"}),
				)
				fmt.println(_err)
			}
		}

		return
	}

	odinx := OdinXInfo{}

	utils.read_json(&odinx, "./odinx.json")

	install, install_contains := args["add"]

	if install_contains {
		#partial switch i in install {
		case string:
			exists := false
			registered := false
			package_dir := utils.get_abs(utils.path_join("packages", i))

			for dependecy in odinx.dependencies {

				if dependecy == i && utils.is_dir(package_dir) {
					fmt.printf("The Package %s is already installed.\n", i)
					exists = true
					registered = true
					break
				}

				if dependecy == i {
					registered = true
					break
				}
			}

			if !exists {

				if !registered {
					append(&odinx.dependencies, i)
				}

				err_code := utils.clone_repo(i)

				if err_code != 0 {
					return
				}
				utils.make_json(odinx, "./odinx.json")
			}
		}
	}

	install_all, install_all_contains := args["install"]

	if install_all_contains {
		#partial switch i in install_all {
		case bool:
			for dependecy in odinx.dependencies {
				err := utils.clone_repo(dependecy)
				if err != 0 {
					fmt.println(err)
				}
			}
		}
	}
}
