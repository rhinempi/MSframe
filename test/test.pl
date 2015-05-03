#! /usr/bin/perl
#

use strict;
use warnings;
use Getopt::Long;
use test;

my $call = shift;

my %OPT;
GetOptions(
	\%OPT,
	'a=s'
);

print $call;
print test->opt(@_);
