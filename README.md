Git repository for degree project in Molecular Biotechnology Engineering at the Department of Ecology and Genetics, evolutionary biology.

chr_mapping_contigs.py 	: was used to extract the scaffolds that map to chromosomes
extract_individuals.py 	: was used to extract individuals specified in a file
remove_P.py 		: was used to remove the position row in fastPHASE input-files, the position row is saved as a separate file to be used in LDhelmet
split_lines.py          : used to split fastPHASE input that have to many characters on each line
ldhelmet_inp.py		: was used to create LDhelmet input-files from fastPHASE v1.4 output, can take a file of samples and only include them
ancestral_from_vcf.py	: was used to test if at least two of three groups are monomorphic for the same allele
prior_prob_state.py	: create the ancestral files used in LDhelmet from the output from the ancestral_from_vcf.py script

The files for the analysis with R were used to get the means and other results. The ones in the directory analysis_local were used localy on my computer and can not be used as they are but shows how correlation coefficents were found and plots were made.

not_used_scripts 	: not used in the final project

countMissing.py		: not used in the final project, counts the number of missing genotypes at each position from fastPHASE input-files

