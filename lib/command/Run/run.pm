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
	my ($head,$order,$modules,$components,$configurations) = parser->parserconfig("$config"); # ----- parsing configuration file ----- #
	print STDOUT"$order\n";

	workflow($head,$order,$modules,$components,$configurations);  # ----- run workflow in order ----- #

}

sub workflow{

	my $head = shift;
	my $order = shift;
	my $modules = shift;
	my $components = shift;
	my $configurations = shift;

	my $outdir = $head->{'outdir'};
	foreach my $step(@{$order}){	# ----- run each step ----- #
		my $module_name = $modules->{$step};
		my $shell = writeshell($step,$module_name,$components,$outdir);
		my ($s_shell,$scheduler) = writeschedule($module_name,$configurations,$shell,$outdir);
#		execute($s_shell,$scheduler);
	}

}

sub execute{

	my $s_shell=shift;
	my $scheduler=shift;

	if ($scheduler eq "sge"){
		foreach my $shell (@{$s_shell}){
			$shell = async{
				`qsub $shell`;
				return 0;
			};
		}
		foreach my $shell (@{$s_shell}){
			$shell->join();
		}
	}
}

sub writeshell{

	my $step = shift;
	my $module_name = shift;
	my $components = shift;
	my $outdir = shift;

	my @scripts=();
	if ($components->{$module_name}{'exe'}){
		open OUT,">$outdir/.script/$step\_$module_name.sh";  # ----- write execution scripts ----- #
		push @scripts,"$outdir/.script/$step\_$module_name.sh";
		my @exe=@{$components->{$module_name}{'exe'}};
		foreach my $exe(@exe){
			my $execommand=readexe($exe,$components);
			print OUT"$execommand\n";
		}
		close OUT;
	} elsif ($components->{$module_name}{'parallel'}){
		my @parallel=@{$components->{$module_name}};
		my $thread=0;
		foreach my $parallel(@parallel){
			my $parallelcommand=readexe($parallel,$components);
			$thread++;
			open OUT2,"$outdir/.script/$step\_$module_name\_$thread.sh";
			push @scripts,"$outdir/.script/$step\_$module_name\_$thread.sh";
			print OUT2"$parallelcommand\n";
			close OUT2;
		}
	}

	return \@scripts;
}

sub readexe{

	my $exe=shift;
	my $components=shift;
	my $execommand = ();

	my @exes = split /\s*\+\s*/,$exe;
	foreach my $exes (@exes){
		if ($exes=~/\s*\*\s*/){ # ----- wildcard conponent or multi-components----- #
			my @multi_exes=split /\s*\*\s*/,$exes;

			if ($components->{$multi_exes[0]} && $components->{$multi_exes[1]}){
				my @a_components =@{$components->{$multi_exes[0]}};
				my @b_components =@{$components->{$multi_exes[1]}};

				if (@a_components == 1){  # ----- @a_components is not multi-components ----- #
					foreach my $b_components(@b_components){
						$execommand.="$a_components[0] $b_components \\";
					}
				}else{
					foreach my $a_components(@a_components){
						$execommand.="$a_components $b_components[0] \\";
					}
				}
			}else{
				logging->LOG("exe component \"$exes\" can`t be found in configuration file");
				error->ERROR("exe component \"$exes\" can`t be found in configuration file");
			}
		}else{
			if ($components->{$exes}){
				my @components =@{$components->{$exes}};
				
				foreach my $components(@components){
					$execommand.="$components \\";
				}
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

	my @s_shell=();
	my $scheduler;
	foreach my $c_shell(@{$shell}){
		open OUT,">$c_shell.schedule.sh";
		push @s_shell,"$c_shell.schedule.sh";
		if ($configuration->{$module_name}{'scheduler'}){
			$scheduler =$configuration->{$module_name}{'scheduler'};
			if ($scheduler eq 'sge'){
				print OUT"#! /bin/bash\n";
				print OUT"#$ -async \n";
				print OUT"#$ -wd $outdir/.shell/\n";
				print OUT"#$ -pe multislot $configuration->{$module_name}{'cpu'} \n";
				print OUT"#$ -l vf=$configuration->{$module_name}{'memory'} \n";
				print OUT"#$ -maxjob $configuration->{$module_name}{'maxjob'} \n";
#				print OUT"#$ -timeout $configuration->{$module_name}{'timeout'} \n";
#				print OUT"#$ $configuration->{$module_name}{'extra'} \n";
				print OUT"sh $shell\n";
			}
		}else{
			logging->LOG("scheduler can`t be found in configuration file");
			error->ERROR("scheduler can`t be found in configuration file");
		}
		close OUT;
	}
	return (\@s_shell,$scheduler);
}

1;
