package Blockchain::Ethereum::Keystore;

use v5.26;
use strict;
use warnings;

use File::Slurp;
use JSON::MaybeXS qw(decode_json);
use Crypt::PBKDF2;
use Crypt::ScryptKDF qw(scrypt_raw);
use Net::SSH::Perl::Cipher;

my %cipher = (
    'aes-128-ctr' => 'AES128_CTR',
    'aes-128-ctb' => 'AES128_CBC',
);

my %kdf_hash_class = ('hmac-sha256' => 'HMACSHA2');

sub new {
    return bless {}, shift;
}

sub json {
    my $self = shift;
    return $self->{json_utf8} //= JSON::MaybeXS->new(utf8 => 1);
}

sub key_from_file {
    my ($self, $file_path, $password) = @_;

    my $content = read_file($file_path);
    my $decoded = json->decode($content);

    my $crypto     = $decoded->{crypto};
    my $kdf_params = $crypto->{kdfparams};

    my $kdf_function = '_decode_kdf_' . $crypto->{kdf};
    my $derived_key  = $self->$kdf_function($kdf_params, $password);

    my $cipher = Net::SSH::Perl::Cipher->new(
        $cipher{$crypto->{cipher}},    #
        $derived_key,
        pack("H*", $crypto->{cipherparams}->{iv}));

    return $cipher->decrypt(pack "H*", $crypto->{ciphertext});
}

sub keys_from_directory {
    my ($self, $directory_path) = @_;
}

sub _decode_kdf_pbkdf2 {
    my ($self, $kdf_params, $password) = @_;

    my $derived_key = Crypt::PBKDF2->new(
        hash_class => $kdf_hash_class{$kdf_params->{prf}},
        iterations => $kdf_params->{c},
        output_len => $kdf_params->{dklen},
    )->PBKDF2(pack("H*", $kdf_params->{salt}), $password);

    return $derived_key;
}

sub _decode_kdf_scrypt {
    my ($self, $kdf_params, $password) = @_;

    my $derived_key = scrypt_raw(
        $password,    #
        pack("H*", $kdf_params->{salt}),
        $kdf_params->{n},
        $kdf_params->{r},
        $kdf_params->{p},
        $kdf_params->{dklen});

    return $derived_key;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Blockchain::Ethereum::Keystore - The great new Blockchain::Ethereum::Keystore!

=head1 VERSION

Version 0.001

=cut

our $VERSION = '0.001';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Blockchain::Ethereum::Keystore;

    my $foo = Blockchain::Ethereum::Keystore->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 METHODS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Reginaldo Costa, C<< <refeco at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/refeco/perl-ethereum-keystore>

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Blockchain::Ethereum::Keystore

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2023 by REFECO.

This is free software, licensed under:

  The MIT License

=cut
