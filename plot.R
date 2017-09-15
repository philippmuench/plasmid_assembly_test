#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

#name <- args[1]
name <- 'ref_small.fasta'
pm <- read.table(paste0('/home/data/contig_reports/pm_report_', name, '.txt'), sep=',', header=F)
cbar <- read.table(paste0('/home/data/contig_reports/cbar_report_', name, '.txt'), sep='\t', header=F)

truth_pm <- substring(pm$V1, 1,3)
pm_pla_ind <- which(truth_pm == 'pos')
pm_chr_ind <- which(truth_pm == 'neg')

truth_cbar <- substring(cbar$V1, 1,3)
cbar_pla_ind <- which(truth_cbar == 'pos')
cbar_chr_ind <- which(truth_cbar == 'neg')

#processing pm
pm_tp <- length(which(pm$V2[pm_pla_ind] == 'plasmid'))
pm_fp <- length(which(pm$V2[pm_pla_ind] == 'chromosome'))
pm_tn <- length(which(pm$V2[pm_chr_ind] == 'chromosome'))
pm_fn <- length(which(pm$V2[pm_chr_ind] == 'plasmid'))

# processing cbar
cbar_tp <- length(which(cbar$V3[cbar_pla_ind] == 'Plasmid'))
cbar_fp <- length(which(cbar$V3[cbar_pla_ind] == 'Chromosome'))
cbar_tn <- length(which(cbar$V3[cbar_chr_ind] == 'Chromosome'))
cbar_fn <- length(which(cbar$V3[cbar_chr_ind] == 'Plasmid'))

pm_precision = pm_tp / (pm_tp + pm_fp)
pm_recall = pm_tp / (pm_tp + pm_fn)

cbar_precision = cbar_tp / (cbar_tp + cbar_fp)
cbar_recall = cbar_tp / (cbar_tp + cbar_fn)

print(paste('pm_precision', pm_precision))
print(paste('pm_recall', pm_recall))
print(paste('cbar_precision', cbar_precision))
print(paste('cbar_recall', cbar_recall))

print(df)

df = data.frame(PlasmidMiner = c(pm_precision, pm_recall), cBar = c(cbar_precision, cbar_recall))
rownames(df) <- c('precision', 'recall')

pdf(paste0('/home/data/recall_plot_', args[1],'.pdf'))
barplot(as.matrix(df), col=c("darkblue","red"), legend = rownames(df)) 
dev.off()