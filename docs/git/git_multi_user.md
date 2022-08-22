# GIT - multi user

## Abstract

When we work on different projects, sometimes we have different git providers (e.q. GitHub, GitLab, Gitea,...).
Also it is possible that we need to use different users for our contribution.
This is obiously possible using git with **https**.
Because **ssh** is considered more secure in context of **git** you need to manage several ssh keys.

It is possible to specify the key you need. For example

```bash
GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes' git clone user@host:repo.git
```

As you can see this is not super convenient.
There is an easier way using an ssh config file.

## Theory

You are able to configure **ssh** with a file **~/.ssh/config**.
**Remark** If interested you are able to find all available configration parameters [here][ssh-config]
You are able to set the identity related to the host with the following parameters

```txt
Host <host>:<port>
  HostName <host>
  Port <port>
  IdentityFile <path_to_id_file>
```

- Host: add a name for the host
  - HostName: The domain, e.q. github.com, gitlab.com, ...
  - IdentityFile: absolute path to the specific private ssh cert
  - Port [OPTIONAL]: just use if you have your own git provider service running

## example

### setup

Get somehow 2 users in 2 different git providers (e.q. GitHub, GitLab,...).
Now lets create 2 different (public/private) ssh key pairs.

```bash
ssh-keygen -t rsa -N "" -C "<first_user_mail>" -f '~/.ssh/id_rsa_first'
ssh-keygen -t rsa -N "" -C "<second_user_mail>" -f '~/.ssh/id_rsa_second'
```

To be able to ssh into the git provider, you need to add the private keys to your git provider settings.
Add the public key content to related gitea account

```bash
cat ~/.ssh/id_rsa_first.pub
cat ~/.ssh/id_rsa_second.pub
```

This step is dependent on your git provider.

Now we want to configure git ssh to use those files related to the git provider.

```bash
touch ~/.ssh/config
```

add the following content to the file.
The hostname is dependent to the git provider.

```ssh
# user 1
Host <first_git_provider>
  HostName <hostname_1>
  IdentityFile ~/.ssh/id_rsa_first

# user 2
Host <second_git_provider>
  HostName <hostname_2>
  IdentityFile ~/.ssh/id_rsa_second
```

to **~/.ssh/config**

### test

Now we are set to test the settings.
Lets first create 2 repositories. One in each git provider.

Now lets clone the repositories. `cd` in a directory of your choice.

```bash
git clone <ssh_clone_url_1>
git clone <ssh_clone_url_2>
```

We want to clone the repositories.
Yay it works :rocket:

As you can see when that the right user is auto selected :rocket:

[ssh-config]: https://linux.die.net/man/5/ssh_config
