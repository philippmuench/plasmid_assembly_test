#!/bin/bash

rm -rf plasmidminer/dat_tmp
mkdir -p plasmidminer/dat_tmp
rm -f contig_report_string.txt
rm -f /home/data/contig_reports/*

# contig level
while read file; do
  # run cbar
  start_time=`date +%s`
  /root/scr/cBar.1.2/cBar.pl /home/data/fasta/contig/$file /home/data/contig_reports/cbar_report_$file.txt
  end_time=`date +%s`
  echo execution time was `expr $end_time - $start_time` s.
  
  # run plasmidminer
  cd /root/plasmidminer
  start_time=`date +%s`
  rm contig_report_string.txt
  python plasmidminer/predict.py -m /home/data/models/test.pkl -i /home/data/fasta/contig/$file --sliding
  echo execution time was `expr $end_time - $start_time` s.
  cp contig_report_string.txt /home/data/contig_reports/pm_report_$file.txt
  cd /root

  # run deep-plasmid
  cd dna_lstm
  python predict.py -i /home/data/fasta/contig/$file -w /home/data/models/weights_78.hdf5 -m /home/data/models/model.json
  cp report_string.txt /home/data/contig_reports/deep_report_$file.txt
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
