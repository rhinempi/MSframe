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
use common::Make::build;
use common::Log::logging;
use common::Error::error;
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

	foreach my $step(@{$order}){	# ----- run each step ----- #
		my $module_name = $modules->{$step};
		my $shell = writeshell();
		my $schedule = writeschedule();
	}

}

sub execute{

	`sh shell`;
	`qsub shell`;
	`spark-submit`;
	
}

sub writeshell{

	my $step = shift;
	my $module_name = shift;
	my $components = shift;
	my $outdir = shift;

	open OUT,">$outdir/.script/$step.sh";  # ----- write execution scripts ----- #
	if ($components->{$module_name}{'exe'}){
		my @exe=@{$components->{$module_name}{'exe'}};
		foreach my $exe(@exe){
			my $execommand=readexe($exe,$components);
			print OUT"$execommand\n";
		}
	}
	close OUT;

}

sub readexe{

	my $exe=shift;
	my $components=shift;
	my $execommand = ();

	my @exes = split /\s*\+\s*/,$exe;
	foreach my $exes (@exes){
		if ($exes=~/\s*\*\s*/){
			my @multi_exes=split /\s*\*\s*/,$exes;
			if ($components->{$multi_exes[0]} && $components->{$multi_exes[1]}){
				$execommand.="$multi_exes \\";
			}else{
				logging->LOG("exe component \"$exes\" can`t be found in configuration file");
				error->ERROR("exe component \"$exes\" can`t be found in configuration file");
			}
		}else{
			if ($components->{$exes}){
				$execommand.="$exes \\";
			}else{
				logging->LOG("exe component \"$exes\" can`t be found in configuration file");
				error->ERROR("exe component \"$exes\" can`t be found in configuration file");
			}
		}
	}
	return $execommand;
}

sub writeschedule{

	my $module_name = shift;
	my $configuration = shift;
	my $shell = shift;
	my $outdir = shift;

	open OUT,">$outdir/.shell/schedule_$shell";
	if ($configuration->{$module_name} && $configuration->{$module_name} eq "sge"){
		print OUT"";
	}else{
		logging->LOG("scheduler can`t be found in configuration file");
		error->ERROR("scheduler can`t be found in configuration file");
	}
	close OUT;
}

1;
