#!/bin/bash

#SRR3465535

# prepare output
mkdir -p /home/data/spades_out
mkdir -p /home/data/recycler

# download data
mkdir -p down_data

echo "prefetch $1"
prefetch $1 > /dev/null

echo "fastq-dump $1"
fastq-dump --outdir down_data/$1 \
  --gzip \
  --skip-technical \
  --readids \
  --dumpbase \
  --split-files \
  --clip $1 > /dev/null

# get lanes
array=($(ls down_data/$1))
fq_1=${array[0]}
fq_2=${array[1]}

#  preprocess
echo "trimfq lane 1 of $1"
seqtk trimfq down_data/$1/$fq_1 > down_data/$1/trim_1.fq
echo "trimfq lane 2 of $1"
seqtk trimfq down_data/$1/$fq_2 > down_data/$1/trim_2.fq

echo "run plasmidspades on $1"
python scr/SPAdes-3.8.2-Linux/bin/plasmidspades.py \
  -t 4 \
  --only-assembler \
  -1 down_data/$1/trim_1.fq \
  -2 down_data/$1/trim_2.fq \
  -o /home/data/spades_out > /dev/null

echo "run spades on $1"
python scr/SPAdes-3.8.2-Linux/bin/spades.py \
  -t 4 \
  --only-assembler \
  -1 down_data/$1/trim_1.fq \
  -2 down_data/$1/trim_2.fq \
  -o /home/data/spades_out

