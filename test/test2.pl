#! /usr/bin/perl
#
use strict;
use warnings;

my $file1=shift;

my %hash=(
run=>1,
b=>2,
c=>3
);

my $test=\%hash;

print $test->{'run'}."\n";
print $test."\n";

my $test2=$test;

print $test2->{'run'}."\n";

my $test3=%hash;

print $test3;
