# Git - share secrets

## Abstract

In some cases you want to securely share secrets with other teammates. Furthermore you want to have a history of those secrets.
For this purpose [Git crypt][git-crypt] helps you to handle secrets within your git repository.

*git-crypt enables transparent encryption and decryption of files in a git repository. Files which you choose to protect are encrypted when committed, and decrypted when checked out. git-crypt lets you freely share a repository containing a mix of public and private content.*

Some features

- No accidentaly push secrets in clear text
- Possible to Share credentials
- Put credentials into version control

## Installation

First we need to install git-crypt

**Remark** for details please check [install instructions][git-crypt-install] to install git-crpyt.
We need `make` for the installation.
Please clone the [repo][git-crypt] and use the following commands.
Please `cd` in a temporary directory first.

```bash
git clone git@github.com:AGWA/git-crypt.git
cd git-crypt
make
make install
```

## Setup

### GPG

We need a key-pair (maybe in reality it is already created for your mail adress)
Use the mail adress which is added to your git user

First we want to check those settings

```bash
$ git config --global user.email
john.doe@dummy.fake
$ git config --global user.name
John Doe
```

keep those entries in your mind or write them down :evil_imp:

Now we want to generate the gpg key.
Type in the name and mail you just received.

```bash
gpg --gen-key
```

### git-crypt

We need to have a git repository available. Please create a repository with name **git-crypt-test** in your favourite Git provider (e.q. GitHub, GitLab, Gitea, ...).
Please clone the repository and `cd` into it.

```bash
git clone <use_your_repo_url>/git-crypt-test
cd git-crypt-test
```

Now we need to init **git-crypt**

```bash
git-crypt init
```

Now we want to specify files we want to monitor and handle with **git-crypt**
That is easy. Therefore we just need to add a **.gitattributes** file with the files we want to encrypt.

```bash
echo "secretfile filter=git-crypt diff=git-crypt\n*.key filter=git-crypt diff=git-crypt\nsecretdir/** filter=git-crypt diff=git-crypt" >> .gitattributes
```

The content of the **.gitattributes** file should look now

```txt
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
secretdir/** filter=git-crypt diff=git-crypt
```

This is like a **.gitignore** file and has the following content.

- handle all files with name secretfile with git-crypt
- handle all files with extension *.key with git-crypt
- handle all files within directory secretdir/ with git-crypt

Now we add our git user to the secrets. Therefore we need to get the id of our gpg key.

```bash
gpg --list-key $(git config --global user.email)
```

(The id is at pub between / and the date).

Copy it to any text editor.

Now we add the key to the keyring of the local git repository database.
Please replace <USER_ID> with the id you copied to the text editor.

```bash
git-crypt add-gpg-user <USER_ID>
```

Now we add a file for encryption.

```bash
echo "This file will be encrypted" >> to_encrypt.key
```

and commit our changes

```bash
git add .
git commit -m "add file to encrypt :lock:"
```

Now lock the file and check it

```bash
git-crypt lock
```

just check the file

```bash
cat to_encrypt.key
```

it is encrypted. For unlocking type

```bash
git-crypt unlock
```

Check the file again

```bash
cat to_encrypt.key
```

The nice thing is that it is not possible to push the unencrypted file to git repo.
Lets test it.

```bash
git add .
git commit -m "add encrypted file"
git push
```

Check the file in your favourite git provider. You can see that it is encrypted.

### Add users to git-crypt database

To add a user to git-crypt you need the public gpg file.
Just tell the other users to use the following command

```bash
gpg --armor --output public-key.gpg --export <key_mail_address>
```

Import the key file into your gpg keyring and add trust level ultimate

```bash
gpg --import public-key.gpg
# get the id of the imported key
gpg --list-key <key_mail_address>
gpg --edit-key <key_id>
trust
# We need ultimate trust, so choose 5
save
```

now you are able to add the user as before with

```bash
# the user_id is the id of the user in your public key_ring
git-crypt add-gpg-user <USER_ID>
```

Now the other user is able to decrypt the file with git-crypt in the git repository :rocket:

[git-crypt]: https://github.com/AGWA/git-crypt
[git-crypt-install]: https://github.com/AGWA/git-crypt/blob/master/INSTALL.md
