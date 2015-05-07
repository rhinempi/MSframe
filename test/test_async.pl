#! /usr/bin/perl
#
use strict;
use warnings;
use threads;

my @line = ("foo","bar","I","have","no","idea");
my $as;

my $l;
foreach my $line (@line){
	$line = async {
 		sleep 10;
#		sleep 5 if $line eq "I";
		open OUT,">./$line.txt";
		print OUT"$line\n";
		print "$line\n";
		$line="shit";
#		my $test = async {sleep 5;}; 
#		$test->join();
		return 0;
	};
#	$line->join();
}

#$l->join();
foreach my $line (@line){
	$line->join() unless $line eq "I";
} 
print "12345i\n";
