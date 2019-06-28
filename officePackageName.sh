#!/bin/bash

title=$(curl -I "https://go.microsoft.com/fwlink/?linkid=2072327") 
echo $title > /Users/steve.summers/download_info.txt
title=$(/usr/bin/awk '{print$8}' /Users/steve.summers/download_info.txt)

echo $title > /Users/steve.summers/download_info.txt
title=$(cat /Users/steve.summers/download_info.txt)
title=$(cut -c101-157 /Users/steve.summers/download_info.txt)

echo $title