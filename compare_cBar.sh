#!/bin/bash

# contig level
while read file; do
  start_time=`date +%s`
  /root/scr/cBar.1.2/cBar.pl /home/data/fasta/contig/$file /home/data/contig_reports/cbar_report_$file.txt
  end_time=`date +%s`
  echo execution time was `expr $end_time - $start_time` s.
  cd plasmidminer
  cd /root/plasmidminer
  start_time=`date +%s`
  python plasmidminer/predict.py -m /home/data/models/model_kleb.pkl -i /home/data/fasta/contig/$file --sliding
  echo execution time was `expr $end_time - $start_time` s.
  cp contig_report_string.txt /home/data/contig_reports/pm_report_$file.txt
  cd /root
  Rscript --vanilla plot.R "$file"
done </home/data/file_contig_list.txt


# read level
#while read file; do
#  start_time=`date +%s`
#  /root/scr/cBar.1.2/cBar.pl /home/data/read/fasta/$file /home/data/read_reports/cbar_report_$file.txt
#  end_time=`date +%s`
#  echo execution time was `expr $end_time - $start_time` s.
#  cd plasmidminer
#  cd /root/plasmidminer
#  start_time=`date +%s`
#  python plasmidminer/predict.py -m /home/data/models/model_kleb.pkl -i /home/data/read/fasta/$file -s
#  echo execution time was `expr $end_time - $start_time` s.
#  cd /root
#done </home/data/file_read_list.txt
