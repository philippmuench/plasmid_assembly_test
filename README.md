# automated assembly evaluation based on Arredono-Alonso et al., 2017

## usuage

1. put your fasta files to `data/fasta/`
2. add the name of files you want to be compared to `file_list.txt`
3. run docker and inspect `data/cbar_report_$file.txt`

```
sudo docker build -t plasmid_evaluation .
sudo docker run -v /absolute/path/to/data/folder:/home/data -t plasmid_evaluation
```
