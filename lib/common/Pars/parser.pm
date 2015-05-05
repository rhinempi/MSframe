package parser;

=pod

=head1 NAME

parser

=head1 SYNOPSIS

 parser->

=head1 DESCRIPTION

parser package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../";

use common::Filt::filterconf;

sub parserconfig{

	my $package = shift;

	my $config = $_[0];
	open IN,$config;
	my $content = <IN>;
	my @f_content = filterconf->filterconfig($content);
	my $h_content = hashconfig(@f_content);

}

sub hashconfig{

	my @f_content = shift;

	my %h_content=();
	foreach my $line(@f_content){
		$line=~s/\s*(.+)\s*=\s*(.+)\s*//g;
		my $key = $1;
		my $value = $2;
		$h_content{$key}=$value;
	}
	return \%h_content;
}

1;
