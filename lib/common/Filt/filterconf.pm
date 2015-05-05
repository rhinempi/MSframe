package filterconf;

=pod

=head1 NAME

filterconf

=head1 SYNOPSIS

 filterconf->

=head1 DESCRIPTION

filterconf package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";

sub filterconfig{

	my $package = shift;

	my $content = $_[0];
	my @content = split /\n/,$content;
	my @f_content = ();
	foreach my $line(@content){
		next if $line=~/^$/;
		next if $line=~/^#/;
		next if $line=~/^\/\//;
		$line=~s/#.+//g;
		$line=~s/\/\/.*//g;
		$line=~s/\/\/*.*//g;
		push @f_content,$line;
	}

	return @f_content;
}

1;
