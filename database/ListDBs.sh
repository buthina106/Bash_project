#!/bin/bash

echo "***** existing databases are ****"
current_dir=$(pwd)
cd DataBases/

# List databases and remove trailing '/'
ls -F | grep '/' | sed 's/\///g'

cd "$current_dir"

