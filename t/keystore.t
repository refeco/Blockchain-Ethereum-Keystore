#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Blockchain::Ethereum::Keystore;

my $keyfile = Blockchain::Ethereum::Keystore->new;

# https://ethereum.org/pt-br/developers/docs/data-structures-and-encoding/web3-secret-storage/#PBKDF2-SHA-256
subtest "pbkdf2_ctr" => sub {
    my $private_key_string =  "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d";
    my $password = "testpassword";

    my $private_key = $keyfile->private_key_from_keyfile("./t/resources/pbkdf2_v3.json", $password);
    is unpack("H*", $private_key), $private_key_string;

    my $object = $keyfile->keyfile_from_private_key($private_key_string, $password);
    is unpack("H*", $keyfile->private_key_from_keyobject($object, $password)), $private_key_string;

};

# https://ethereum.org/pt-br/developers/docs/data-structures-and-encoding/web3-secret-storage/#scrypt
subtest "scrypt_ctr" => sub {
    my $private_key = $keyfile->private_key_from_keyfile("./t/resources/scrypt_v3.json", "testpassword");
    is unpack("H*", $private_key), "7a28b5ba57c53603b0b07b56bba752f7784bf506fa95edc395f5cf6c7514fe9d";
};

done_testing;
