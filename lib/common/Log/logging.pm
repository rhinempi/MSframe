package logging;

=pod

=head1 NAME

logging

=head1 SYNOPSIS

 logging->

=head1 DESCRIPTION

logging package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../";

use common::Time::localt;

sub LOG{

	my $package = shift;

	my $info = $_[0];
	my $project_dir = $_[1];
	my $time = localt->localT();
	open OUT,">>$project_dir/MSlog.txt";
	print OUT"$time $info\n";

}

1;
