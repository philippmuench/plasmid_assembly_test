#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

pm <- read.table(paste0('/home/data/contig_reports/pm_report_', args[1], '.txt'), sep=',', header=F)
cbar <- read.table(paste0('/home/data/contig_reports/cbar_report_', args[1], '.txt'), sep='\t', header=F)

truth <- substring(pm$V1, 1,3)
pla_ind <- which(truth == 'pla')
chr_ind <- which(truth == 'chr')

#processing pm
pm_tp <- length(which(pm$V2[pla_ind] == 'plasmid'))
pm_fp <- length(which(pm$V2[pla_ind] == 'chromosome'))
pm_tn <- length(which(pm$V2[chr_ind] == 'chromosome'))
pm_fn <- length(which(pm$V2[chr_ind] == 'plasmid'))

# processing cbar
cbar_tp <- length(which(cbar$V3[pla_ind] == 'Plasmid'))
cbar_fp <- length(which(cbar$V3[pla_ind] == 'Chromosome'))
cbar_tn <- length(which(cbar$V3[chr_ind] == 'Chromosome'))
cbar_fn <- length(which(cbar$V3[chr_ind] == 'Plasmid'))

pm_precision = pm_tp / (pm_tp + pm_fp)
pm_recall = pm_tp / (pm_tp + pm_fn)

cbar_precision = cbar_tp / (cbar_tp + cbar_fp)
cbar_recall = cbar_tp / (cbar_tp + cbar_fn)

df = data.frame(PlasmidMiner = c(pm_precision, pm_recall), cBar = c(cbar_precision, cbar_recall))
rownames(df) <- c('precision', 'recall')

pdf(paste0('/home/data/recall_plot_', args[1],'.pdf'))
barplot(as.matrix(df), col=c("darkblue","red"), legend = rownames(df)) 
dev.off()