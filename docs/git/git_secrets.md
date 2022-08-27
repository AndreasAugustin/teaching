# GIT - Pretend accidentaly pushing credentials

## abstract

Sometimes by accident people accidentally push credentials or other sensitive information into a git repository. For example **AWS_SECRET_ACCESS_KEY** and **AWS_ACCESS_KEY_ID**.
Obviously bad people are able to find those secrets in the git repository or history using them to e.q. start cryptominers in those accounts. That leads to super high costs and bills for the poor person who accidentally pushed those secrets.
There is a tool which can prevent you doing such mistakes: [git-secrets][git-secrets]

## Installation

Please check [git secrets installation][git-secrets-install] for your OS. Here I show you the installation for **Linux**.
Just type the following commands

```bash
git clone git@github.com:awslabs/git-secrets.git
cd git-secrets
[sudo] make install
make test
```

![install](../assets/git/git_secrets/install.gif)

### Remarks

- For users with docker knowledge: have prepared a [docker image][git-secrets-docker] where git-secret is already installed.
  - `docker run -v <local_git_repo>:/home/git-secrets/ andyaugustin/git-secrets:main git-secrets`
- For uninstallation on **Linux** just remove the copied files again

```bash
rm /usr/local/bin/git-secrets
rm /usr/local/share/man/man1/git-secrets.1
```

## Fun part

Now lets check the power of git-secrets.
Please keep in mind that you need to enable the tool for every repository. It will install [git hooks][git-hooks] into your **local** repository.

For the turorial we will init a git repo first and bootstrap **git-secrets**.

```bash
mkdir git-secrets-example
cd git-secrets-example
git init
echo "# git-secrets-example" >> README.md
git add .
git commit [-S] -m "doc(): initial commit :star:"
git-secrets --install
```

As stated in the output we got 3 new files added into our local git repository. Those will prevent us to accidentally commit secrets to the git database. Lets check one of those files

```bash
$ cat .git/hooks/pre-commit
#!/usr/bin/env bash
git secrets --pre_commit_hook -- "$@"
```

This hook will be run every time in the **local git repo** before the commit is added to the database. This means if the mentioned command will have an error, the commit won't be added to the local database.

![init](../assets/git/git_secrets/init.gif)

Now lets understand some more details. For that we will add some fake AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY into our markdown file and lets try to commit it.
Those keys are really fake, you can try :smiling_imp:

```bash
$ git secrets --register-aws
OK
$ echo "This is fake aws key id AKIAIOSFODNN7EXAMPLA" >> README.md
$ git add .
$ git commit -S -m "doc(): accidentally add keys :alien:"
README.md:4:This is fake aws key id AKIAIOSFODNN7EXAMPLA

[ERROR] Matched one or more prohibited patterns

Possible mitigations:
- Mark false positives as allowed using: git config --add secrets.allowed ...
- Mark false positives as allowed by adding regular expressions to .gitallowed at repository's root directory
- List your configured patterns: git config --get-all secrets.patterns
- List your configured allowed patterns: git config --get-all secrets.allowed
- List your configured allowed patterns in .gitallowed at repository's root directory
- Use --no-verify if this is a one-time false positive
```

As you can see it is not possible to commit the changes to the git history because there is a AWS KEY in the change.
In some cases you want to commit that key. Maybe because it is an example for a tutorial or anything else.
This is quite easy to establish. Just add the key to a file called **.gitallowed**.

```bash
echo "AKIAIOSFODNN7EXAMPLA" >> .gitallowed
git add .
git commit [-S] -m "doc(): now we are able to establish the commit :star:"
```

![example-usage](../assets/git/git_secrets/example_usage.gif)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/A0A4EKB66)

[git-secrets]: https://github.com/awslabs/git-secrets
[git-secrets-install]: https://github.com/awslabs/git-secrets#installing-git-secrets
[git-secrets-docker]: https://hub.docker.com/repository/docker/andyaugustin/git-secrets
[git-hooks]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
