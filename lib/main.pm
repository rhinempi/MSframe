package main;

our $version = "0.1";

=pod

=head1 NAME

	Ein Sehr Gut Name

=head1 SYNOPSIS

	main->run(%parameter);

=head1 DESCRIPTION

	This is the main module

=head1 VERSION

	Version 0.1

=cut



use strict;
use warnings;
use FindBin qw($Lib);
use lib "$Lib";




#use usage;

my %parameter=();
GetOptions(
	\%parameter,

	# main command
	'run=s',
	'list=s',
	'implement=s',
	'pipeline=s',
	
	'help',
	'version',

	# parameters for running a pipeline
	'c|config=s',
);

sub run {

	my \%parameter = shift;

	# -------
	# usage: parameters for run a pipeline
	# -------
        if ($parameter->{'help'} || $parameter->{'h'}){
#		usage('usage_run');
	}
	
#	if ($parameter->{'config'} || $parameter->{'c'}){
#		readconfig()}
#	if ($parameter->{''})

}


1;
