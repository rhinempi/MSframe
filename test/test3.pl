#! /usr/bin/perl
#
use strict;
use warnings;

my %hash=(
a=>[1,2,3],
b=>2,
c=>3
);

my $file = \%hash;

print $file->{'a'}."\n";
my @shit=$file->{'a'};
print @{$file->{'a'}}."\n";
print $file->{'b'}."\n";
