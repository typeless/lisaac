#!/bin/bash

for i in `find -name "*.li"` ; do cat $i | grep -q "main" && echo Compile $i && ../src2/lisaac $i ; done
