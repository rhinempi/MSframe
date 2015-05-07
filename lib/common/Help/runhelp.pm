package runhelp;

=pod

=head1 NAME

runhelp

=head1 SYNOPSIS

 runhelp->

=head1 DESCRIPTION

runhelp package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";

sub dumprunhelp{

        my $package = shift;

        my $usage = << "USAGE";
msframe run -conf metagenomics.cfg

Usage:
  -conf         configuration file
  -outdir       output directory
  -project	project name of a pipeline run

USAGE

        print STDOUT $usage;
	exit(1);
}

1;
