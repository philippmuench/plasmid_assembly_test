#!/bin/bash

while read file; do
  /root/scr/cBar.1.2/cBar.pl /home/data/fasta/$file /home/data/cbar_report_$file.txt
done </home/data/file_list.txt
