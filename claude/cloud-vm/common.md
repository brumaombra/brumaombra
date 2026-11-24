# Common rules

These rules apply in every environment. The other rule files add what's specific to the work you do here.

## Guidelines

- Check the available skills before every change; there may be one that covers the task.
- Follow the code style guidelines defined in the skills for all the code you write or edit.
- If a repository has a `package.json`, install its dependencies with `npm ci`, so they match the lockfile exactly.
- Ask before installing new dependencies, and explain why each one is needed.
- After each change, double-check it before calling it done: review your diff, then run what you changed and, if the repository has them, its tests, to confirm it works and didn't break anything nearby.
- If a task is hard enough that you need lots of parallel subagents, run them on the Sonnet model to save usage.
- If the subagents' tasks will take a long time, don't run more than 2 subagents at the same time, or we risk hitting the session limit. Threads and other sessions running in parallel aren't your subagents: they don't count toward this limit.
- If a tool the setup script should have installed is missing, stop and tell me. Don't install it yourself.
- Don't use artifacts. Show me things in the reply itself (text, tables, code, or images), and use an artifact only when there's no other way to show me what you need to.

## Git

Repositories usually use the branches `develop → test → main`. `develop` is the main development line: changes reach it through pull requests, then flow up through the other branches in that order, one step at a time. Never skip a branch, for example by merging `develop` directly into `main`. If a repository doesn't have one of them (for example no `test`), the flow simply skips it.

Every task gets its own branch:

- **One branch per feature or fix, never one per commit.** A branch holds a whole task: commit to it as often as you need, and keep using it for every change of that task, including the follow-ups I ask for. Only start a new branch when I give you a new task.
- Create the branch from the latest `develop` (pull it first).
- When a task touches several repositories, open one pull request per repository.
- Commit and push only to your branch. Push often: anything that isn't pushed can be lost when the VM is rebuilt.
- When the task is done, open a pull request into `develop`. Don't merge it unless I ask.
- If the pull request solves a GitHub issue, close the issue as soon as the pull request is merged into `develop`.

## Issues

When you open a GitHub issue, give it one label from each group:

- **Type:** `bug`, `enhancement` (new feature or request), `chore` (maintenance), `documentation`, or `question`.
- **Area:** `area: <name>`, the part of the app it touches (for example `area: billing`, `area: i18n`, `area: privacy`). Reuse the repository's existing areas, and create a new one only for a part of the app none of them covers.
- **Priority:** `priority: high`, `priority: medium`, or `priority: low`.
- **Effort:** `effort: S`, `effort: M`, or `effort: L`.

Add `in progress` while you're working on an issue, and remove it when its pull request is open. Use GitHub's other default labels (`duplicate`, `invalid`, `wontfix`, `good first issue`, `help wanted`) only when they apply. If a repository is missing some of these labels, create them, with the same names.
- Never push to `develop`, `test`, or `main` directly unless I ask.