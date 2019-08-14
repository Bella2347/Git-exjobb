#!/usr/bin/perl
use strict;
use warnings;

#Takes a .txt file with individuals and a VCF-file and outputs a VCF file containing only those individuals

my $indiv = $ARGV[0];
my $vcf = $ARGV[1];

if (@ARGV < 2) {
	die "\tThis script takes as an input: a TXT-file with a list of individuals and a VCF-file.
\tIt outputs a VCF-file with only the individuals in the list.
\tPlease run the script submitting these files.\n";
}

open my $IN1, '<', $indiv or die "Could not open file '$indiv' $!";
open my $IN2, '<', $vcf or die "Could not open file '$vcf' $!";

my @ind;

while (my $line = <$IN1>){		#Saves all the individuals in an array
	chop($line);
	push (@ind, $line);
}

close $IN1;

my @pos;

while (my $line = <$IN2>){
	chop($line);
	if ($line =~ /^##/) {
		print "$line\n";			#If the line starts with ## it is printed directly to keep the header
	} else {
		my @fields = split(/\t/, $line);	#If it don't start with ## the line is split in columns and the first 8 columns are printed
		print "$fields[0]\t$fields[1]\t$fields[2]\t$fields[3]\t$fields[4]\t$fields[5]\t$fields[6]\t$fields[7]\t$fields[8]";
		
		if ($line =~ /^#C/) {					
			for (my $i = 9; $i < scalar(@fields); $i++) {	#if it is the field-head it steps through all individuals
				if (grep (/$fields[$i]/, @ind)) {	#and if the individual exists in the individual infile it is printed
					push (@pos, $i);		#and the number for the field is saved
					print "\t$fields[$i]";
				}
			}
		} else {
			foreach (@pos) {
				print "\t$fields[$_]";		#If it is a SNP-line only the fields corresponding to desired individuals are printed
			}
		}
		print "\n";
	}
}

close $IN2;
