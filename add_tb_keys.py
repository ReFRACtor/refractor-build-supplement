#!/usr/bin/env python3

"""
TB host key adder

Uses ssh-keyscan to grab the ssh public host key for each TB host (1-27) and adds to known_hosts
"""

from os import environ
from subprocess import CalledProcessError, PIPE, run
from warnings import warn

LAST_TB = 27


def scan_for_key(hostname):
    scan_bin = "ssh-keyscan"
    key_opt = "-t"
    key_type = "rsa"
    args = [scan_bin, key_opt, key_type, hostname]
    try:
        proc_handle = run(args, stdout=PIPE, stderr=PIPE, check=True)
    except CalledProcessError:
        print(f"Unable to use {scan_bin} to scan for ssh-key on hostname. Run cmd: {args}")
        raise
    try:
        key_str = proc_handle.stdout.decode("utf-8")
    except UnicodeDecodeError:
        print(f"Unable to parse output: {proc_handle.stdout}")
        raise
    if key_str:
        return key_str
    else:
        warn(f"Unable to find ssh key for host {hostname}")
        return None


def add_key_to_known_hosts(host_key):
    if not environ["HOME"]:
        raise RuntimeError("Unable to lookup home directory in environment.")
    print(f"Adding host key to known_hosts:\n {host_key}")
    known_hosts_path = f"{environ['HOME']}/.ssh/known_hosts"
    # Could execute `ssh-keygen -R <hostname>` here to remove old entries
    try:
        with open(known_hosts_path, "a") as known_hosts:
            known_hosts.write(host_key)
    except OSError:
        print(f"Unable to open {known_hosts_path} for writing.")
        raise


def add_host_key(hostname):
    host_key = scan_for_key(hostname)
    if host_key:
        add_key_to_known_hosts(host_key)


def main():
    for tb_ind in range(LAST_TB + 1):
        add_host_key(f"tb{tb_ind}")


if __name__ == "__main__":
    main()

