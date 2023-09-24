# NAME

Blockchain::Ethereum::Keystore - Ethereum wallet management utilities

# VERSION

version 0.006

# SYNOPSIS

Generating a new address and writing it to a keyfile:

```perl
my $key = Blockchain::Ethereum::Keystore::Key->new;
# checksummed address
print $key->address;
my $keyfile = Blockchain::ethereum::Keystore::Keyfile->new;

$keyfile->import_key($key);
$keyfile->write_to_file("...");
...
```

Generating a new seed and derivating new keys (BIP44):

```perl
my $seed = Blockchain::Ethereum::Keystore::Seed->new;
my $key = $seed->derive_key(0);
print $key->address;
...
```

Importing a keyfile and changing the password:

```perl
my $keyfile = Blockchain::Ethereum::Keystore::Keyfile->new;
my $password = "old_password";
$keyfile->import_file("...", $password);
$keyfile->change_password($password, "newpassword");
$keyfile->write_to_file("...");
```

Signing a transaction:

```perl
my $transaction = Blockchain::Ethereum::Transaction::EIP1559->new(
    ...
);

my $keyfile = Blockchain::Ethereum::Keystore::Keyfile->new;
$keyfile->import_file("...");
$keyfile->private_key->sign_transaction($transaction);
```

Export private key:

```perl
my $keyfile = Blockchain::Ethereum::Keystore::Keyfile->new;
$keyfile->import_file("...");

# private key bytes
print $keyfile->private_key->export;
```

# OVERVIEW

This module provides a collection of Ethereum wallet management utilities.

Core functionalities:

- Manage Ethereum keyfiles, facilitating easy import, export, and password change.
- Sign [Blockchain::Ethereum::Transaction](https://metacpan.org/pod/Blockchain%3A%3AEthereum%3A%3ATransaction) transactions.
- Private key and seed generation through [Crypt::PRNG](https://metacpan.org/pod/Crypt%3A%3APRNG)
- Support for BIP44 for hierarchical deterministic wallets and key derivation.

# AUTHOR

Reginaldo Costa <refeco@cpan.org>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2023 by REFECO.

This is free software, licensed under:

```
The MIT (X11) License
```
