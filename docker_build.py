#!/usr/bin/env python
import os

docker_tag = "moz"

def mk_docker_build_command(tag_name):
    return "docker build -t " + tag_name + " ."

os.system(mk_docker_build_command(docker_tag))
