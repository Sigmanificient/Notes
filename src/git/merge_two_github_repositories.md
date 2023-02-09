Add the first remote

```sh
git remote add -f repo-a https://github.com/[user]/[repository_1].git
```

Merge the first remote into the master branch

```sh
git merge [repository_1]/master
```

Add the second remote

```sh
git remote add -f repo-a https://github.com/[user]/[repository_2].git
```

Merge the two histories
```sh
git merge [repository_1]/master --allow-unrelated-histories
```