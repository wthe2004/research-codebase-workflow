# Source Control

> See also [`pr-workflow.md`](pr-workflow.md) for the project-level branching model (`main` + `dev` double-trunk), branch protection, and the full PR lifecycle (precis template + full checklist report). This document covers the per-branch conventions; `pr-workflow.md` covers how branches compose into a release flow.

## Naming Branches

Here's an example of a branch naming convention:

```sh
[feature/bug/hotfix]/<title>
```

## Working with Secrets in Source Control

The best way to avoid leaking secrets is to store them in local/private files and exclude these from git tracking with a [.gitignore](https://git-scm.com/docs/gitignore) file.
E.g. the following pattern will exclude all files with the extension `.private.config`:

```bash
# remove private configuration
*.private.config
```

