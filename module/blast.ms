project=test
outdir=/vol/cluster-data/huanglr/metagenomics/framework/test


step01 blastp {

	input.file.1 = /prj/metagencourse/Friday_Nov.14/03.blast.go/SPLIT/contigs_k31_3M.gene.scaffold-14934.faa.*
	input.file.2 = /vol/biodb/asn1/nr
	parameter.1 = -max_target_seqs 100 -evalue 0.1 -outfmt 6
	parameter.2 = -query
	parameter.3 = -db
	tool.blastp = /vol/biotools/bin/blastp
	output.file = blastp.out.tab

	parallel * input.file.1 = tool.blastp + parameter.1 + parameter.2 + input.file.1 + parameter.3 + output.file


	scheduler=sge
	cpu=1
	memory=12G
	schedule.type=batch
	maxjob=100
	timeout=1m
	extra=

}
