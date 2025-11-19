import subprocess
import re
import yaml
from pathlib import Path

# Get all the packages installed
with open("pixi.lock", "r") as fh:
    d = yaml.safe_load(fh)

# Find ones in muses-conda-channel
d_muses = [
    Path(t["conda"])
    for t in d["packages"]
    if "conda" in t and re.search(r"\/muses-conda-channel\/", t["conda"])
]

# Copy data over to local channel
subprocess.run(["rm", "-r", "./muses-conda-channel"])
subprocess.run(["mkdir", "-p", "./muses-conda-channel/linux-64"], check=True)
subprocess.run(["mkdir", "-p", "./muses-conda-channel/noarch"], check=True)

for fname in d_muses:
    fbase = fname.name
    fsub = fname.parent.name
    print(f"Adding file {fsub}/{fbase}")
    subprocess.run(["cp", str(fname), f"./muses-conda-channel/{fsub}/"], check=True)

# Index packages    
subprocess.run(["rattler-index", "fs", "-f", "./muses-conda-channel"], check=True)

# Create tar file. Note we don't bother compressing, the various .conda files are
# already compressed so there is nothing really left to compress in the tar file.

subprocess.run(["tar", "-cf", "muses-conda-channel.tar", "./muses-conda-channel"])

# Remove the directory we used, now that it is tarred
subprocess.run(["rm", "-r", "./muses-conda-channel"])

