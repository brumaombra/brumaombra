# Common rules

These rules apply in every environment. The other rule files add what's specific to the work you do here.

## Guidelines

- Check the available skills before every change; there may be one that covers the task.
- Follow the code style guidelines defined in the skills for all the code you write or edit.
- If a repository has a `package.json`, install its dependencies with `npm ci`, so they match the lockfile exactly.
- Ask before installing new dependencies, and explain why each one is needed.
- After each change, double-check it before calling it done: review your diff, then run what you changed and, if the repository has them, its tests, to confirm it works and didn't break anything nearby.
- If a task is hard enough that you need lots of parallel subagents, run them on the Sonnet model to save usage.
- If the subagents' tasks will take a long time, don't run more than 2 subagents at the same time, or we risk hitting the session limit.
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
- When you merge a pull request, delete its branch right after, both on GitHub and locally.
- Never push to `develop`, `test`, or `main` directly unless I ask.