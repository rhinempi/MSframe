package error;

=pod

=head1 NAME

error

=head1 SYNOPSIS

 error->

=head1 DESCRIPTION

error package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../";

use common::Time::localt;

sub ERROR{

        my $package = shift;

        my $info = $_[0];
        my $time = localt->localT();
        print STDERR"$time $info\n";

}

1;
