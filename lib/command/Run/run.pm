package run;

=pod

=head1 NAME

run - Run a project with a particular pipeline

=head1 SYNOPSIS

 run->params(%parameter)

=head1 DESCRIPTION

main package for run command of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use Cwd 'abs_path';
use Exporter;
use vars qw ($VERSION @ISA @EXPORT);
use lib "$Bin/../../";

use common::Info::info;
use common::Help::runhelp;
use common::Pars::parser;
#use command::Run::params::check;

$VERSION = 0.1;
@ISA	 = qw(Exporter);
@EXPORT  = qw(params);

sub params{

	my $package = shift; # ----- package name ----- #

	my $param = $_[0];   # ----- input parameters ----- #
	runhelp->dumprunhelp() unless $param->{'conf'};  # ----- dump help information for run command ----- #

	my $config = $param->{'conf'};
	$config = abs_path ($config);
	my ($order,$modules,$components,$configurations) = parser->parserconfig("$config"); # ----- parsing configuration file ----- #

	workflow($order,$modules,$components,$configurations);  # ----- run workflow in order ----- #

}

sub workflow{

	my $order = shift;
	my $modules = shift;
	my $components = shift;
	my $configurations = shift;

	foreach my $step(@{$order}){
		execute ();
	}

}

sub execute{

	shellwrapper;
	`sh shell`;
	`qsub shell`;
	`spark-submit`;
	
}

sub shellwrapper{

}

1;
