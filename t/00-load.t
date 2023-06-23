#!perl
use v5.26;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Blockchain::Ethereum::Keystore' ) || print "Bail out!\n";
}

diag( "Testing Blockchain::Ethereum::Keystore $Blockchain::Ethereum::Keystore::VERSION, Perl $], $^X" );
