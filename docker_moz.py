#!/usr/bin/env python
import os
import sys

docker_tag = "moz"

def mk_docker_run_command():
    file_name = sys.argv[1]
    args_rest = " ".join(sys.argv[2:])
    file_path = os.path.abspath(file_name)
    container_file_path = "/tmp/" + file_name
    return "docker run -v " + file_path + ":" \
        + container_file_path + " " + docker_tag \
        +  " ./bin/moz --libpaths=./library " \
        + container_file_path + " " \
        + args_rest

def usage():
    print(sys.argv[0] + " [FILE] ...")

if len(sys.argv) > 1:
    os.system(mk_docker_run_command())
else:
    usage()
