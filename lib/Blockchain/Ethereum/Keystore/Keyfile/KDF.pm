package Blockchain::Ethereum::Keystore::Keyfile::KDF;

use v5.26;
use strict;
use warnings;

# AUTHORITY
# VERSION

use Crypt::KeyDerivation qw(pbkdf2);
use Crypt::ScryptKDF     qw(scrypt_raw);

sub new {
    my ($class, %params) = @_;

    my $self = bless {}, $class;
    for (qw(algorithm dklen n p r prf c salt)) {
        $self->{$_} = $params{$_} if exists $params{$_};
    }

    return $self;
}

sub algorithm {
    return shift->{algorithm};
}

sub dklen {
    return shift->{dklen};
}

sub n {
    return shift->{n};
}

sub p {
    return shift->{p};
}

sub r {
    return shift->{r};
}

sub prf {
    return shift->{prf};
}

sub c {
    return shift->{c};
}

sub salt {
    return shift->{salt};
}

sub decode {
    my ($self, $password) = @_;

    my $kdf_function = '_decode_kdf_' . $self->algorithm;
    return $self->$kdf_function($password);
}

sub _decode_kdf_pbkdf2 {
    my ($self, $password) = @_;

    my $derived_key = pbkdf2($password, pack("H*", $self->salt), $self->c, 'SHA256', $self->dklen);

    return $derived_key;
}

sub _decode_kdf_scrypt {
    my ($self, $password) = @_;

    my $derived_key = scrypt_raw(
        $password,    #
        pack("H*", $self->salt),
        $self->n,
        $self->r,
        $self->p,
        $self->dklen
    );

    return $derived_key;
}

1;
