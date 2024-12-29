# !/bin/bash

sudo yum install libffi-devel -y

# Installation of libraries
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install -r /home/hadoop/scripts/requirement.txt --user


sh /home/hadoop/scripts/shell/master.sh