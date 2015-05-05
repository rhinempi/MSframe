package info;

=pod

=head1 NAME

info

=head1 SYNOPSIS

 info->

=head1 DESCRIPTION

info package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../";
use common::Time::localt;

sub INFO{

        my $info = shift;
        my $time = localt->localT();
        print STDOUT "$time: $info\n";
}

1;
