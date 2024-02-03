package utils

import "core:os"
import "core:encoding/json"
import "core:path/filepath"

is_dir :: proc(path: string) -> bool {
	return os.is_dir(path)
}

get_basename :: proc(path: string) -> (string, os.Errno) {
	handle, err_ := os.open(path, 'r')
	defer os.close(handle)

	if err_ != 0 {
		return "", err_
	}

	file_info, err := os.fstat(handle)

	return file_info.name, err
}

make_json :: proc (structure: $T,  path: string) -> union {os.Errno, json.Marshal_Error}  {
	json_, err := json.marshal(structure)

	if err != nil {
		return err
	}

	handle, file_err := os.open(path, 'w')
	defer os.close(handle)

	if file_err != 0 {
		return file_err
	}

	os.write(handle, json_)
	return nil
}

read_json :: proc (structure: ^$T, path: string) -> (^T, json.Unmarshal_Error)  {
	handle, file_err := os.open(path, 'r')
	defer os.close(handle)
	
	json_data, _ := os.read_entire_file_from_handle(handle)
	unmarshal_err := json.unmarshal(json_data, structure)

	return structure, unmarshal_err
}

remove_dir :: proc (path: string) -> os.Errno {

		raw_ptr := ""
		err := filepath.walk(path, proc(info: os.File_Info, err: os.Errno, user_data: rawptr)-> (os.Errno, bool) {
		

		if err != 0 {
			return err, false
		}

		if info.is_dir {
			return remove_dir(info.fullpath), false
		}

		return os.remove(info.fullpath), false
	}, &raw_ptr)

	if err != 0 {
		return err
	}

	return os.remove(path)
}

path_join :: proc (path: ..string) -> string {
	return filepath.join(path)
}

get_abs :: proc (path: string) -> string {
	return path_join(os.get_current_directory(), path)
}