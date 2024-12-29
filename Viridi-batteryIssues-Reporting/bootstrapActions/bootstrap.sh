#!/bin/bash

aws s3 cp $1 $2 --recursive
chmod -R +x $2
