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
use common::Info::info;

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

	my %head=(); # ----- pipeline head info ----- #
	my %Modules=(); # ----- step 2 module ----- #
	my %components=(); # ----- module 2 component ----- #
	my %configurations=(); # ----- module 2 configuration ----- #
	my @order=(); # ----- step in order ----- #
	my $our_module=();
	foreach my $line(@f_content){
		if ($line=~/\s*(.+)\s*=\s*(.+)\s*/){  # ----- hash Head info ----- #
			my $key = $1;
			my $value = $2;
			$head{$key}=$value if $key eq "project";
			$head{$key}=$value if $key eq "outdir";
			if ($key=~/^input/){
				if ($value =~ /\*/){
					my @wildcard=glob "$value";
					foreach my $wildcard(@wildcard){
						push @{$components{$our_module}{$key}},$wildcard;
					}
				}else{
					push @{$components{$our_module}{$key}},$value;
				}
			}elsif($key=~/^parallel/){
				if ($key=~/parallel\s*\*\s*(.+)/){
					my $wildfile=$1;
					my @wildcard=@{$components{$our_module}{$wildfile}};
					foreach my $wildcard(@wildcard){
						my $new_value=$value;
						$new_value=~s/$wildfile/$wildcard/g;
						push @{$components{$our_module}{'parallel'}},$new_value; # ----- replace input component into inputfile ----- #
						push @{$components{$our_module}{$wildcard}},$wildcard;   # ----- store inputfile component as inputfile ----- #
					}
				}
			}
			push @{$components{$our_module}{$key}},$value if $key =~/^parameter/
								||	$key =~/^dependency/
								||	$key =~/^tool/
								||	$key =~/^output/
								||	$key =~/^exe/;
			push @{$configurations{$our_module}{$key}},$value if $key =~/^scheduler/
								||	$key =~/^cpu/
								||	$key =~/^memory/
								||	$key =~/^schedule\.type/
								||	$key =~/^maxjob/
								||	$key =~/^timeout/
								||	$key =~/^extra/;
		}elsif($line=~/step\d+/){ 			# ----- hash step info ----- #
			if ($line=~/step(\d+)\s+(\S+)\s*{/){
				my $step=$1;
				print STDOUT"$step\n";
				my $module=$2;
				push @order,$step;
				$our_module=$module;
				if ($module=~/,/){ # ----- loading default because of "," ----- #
					my @modules = split ",",$module;
					foreach my $modules(@modules){
						push @{$Modules{$step}},$modules;
					}
				}else{
					push @{$Modules{$step}},$module;
				}
			}else{
				info->INFO("$line: step not defined, skip");
				next;
			}
			
		}
	}
	@order =sort {$a<=>$b} @order;
	return (\%head,\@order,\%Modules,\%components,\%configurations);
}

1;
