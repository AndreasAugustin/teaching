# Git - how and why sign commits

## abstract

You should always sign your git commits. [Why?](#why-to-sign-commits)

## Why to sign commits

The git commits are super easy referenced to a user. Anyone all around the world is able to push commits with another name. The reference is done in the commit message with the **user.email**.

You can try yourself. Just create a new repository in a folder of your choice.

Let's create locally a git repository.

```bash
mkdir sign_commits
cd sign_commits
git init
```

First lets check our current global settings

```bash
git config --global user.name
git config --global user.email
```

and compare them with our local git repo settings

```bash
git config user.name
git config user.email
```

Those are the same. Now lets change the local git repo settings

```bash
git config user.name 'john doe'
git config user.email 'john.doe@example.dev'
```

Lets now check the current settings and compare them to the global settings.

```bash
git config user.name
git config user.email
git config --global user.name
git config --global user.email
```

You can see that those differ. This does not give us any value for our current context,
but I wanted to make sure that we do not touch our global settings.

Now lets create some commits.

```bash
echo "# git sign commits" >> README.md
git add .
git commit -m "doc(): add some super nice docs"
```
