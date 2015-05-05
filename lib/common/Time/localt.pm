package localt;

=pod

=head1 NAME

localt

=head1 SYNOPSIS

 localt->

=head1 DESCRIPTION

localt package of MSframe

=head1 VERSION

Version 0.1

=cut

use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";

sub localT{

        my (
                $sec,$min,$hour,
                $mday,$mon,$year,
                $wday,$yday,$isdst
        ) = localtime(time());

        my $format_time = sprintf(
                "%d-%d-%d %d:%d:%d",
                $year+1900,$mon+1,
                $mday,$hour,$min,$sec
        );

        return $format_time;

}

1;
