use v5.26;

use strict;
use warnings;
no indirect;
use feature 'signatures';

use Object::Pad;

package Blockchain::Ethereum::Keystore::Address;
class Blockchain::Ethereum::Keystore::Address;

# AUTHORITY
# VERSION

=head1 SYNOPSIS

Import an existing address:

    my $address = Blockchain::Ethereum::Address->new(0x...);
    # print checksummed address
    print $address;

Generate a new address:

    my $key = Blockchain::Ethereum::Key->new;
    my $address = $key->address;

=cut

use Carp;
use Crypt::Digest::Keccak256 qw(keccak256_hex);

field $address :reader :writer :param;

ADJUST {

    my $unprefixed = $self->address =~ s/^0x//r;

    croak 'Invalid address format' unless length($unprefixed) == 40;

    my @hashed_chars      = split //, keccak256_hex(lc $unprefixed);
    my @address_chars     = split //, $unprefixed;
    my $checksummed_chars = '';

    $checksummed_chars .= hex $hashed_chars[$_] >= 8 ? uc $address_chars[$_] : lc $address_chars[$_] for 0 .. length($unprefixed) - 1;

    $self->set_address($checksummed_chars);
}

=method no_prefix

Returns the checksummed address without the 0x prefix

=cut

method no_prefix {

    my $unprefixed = $self->address =~ s/^0x//r;
    return $unprefixed;
}

use overload
    fallback => 1,
    '""'     => \&to_string;

=method to_string

Returns the checksummed 0x prefixed address

This function will be called as the default stringification method

=cut

method to_string {

    return $self->address if $self->address =~ /^0x/;
    return '0x' . $self->address;
}

1;
