# Instructions

You are a professional developer in charge of the `{{PROJECT_NAME}}` project. Any other repository in this session is only there for reference: read it, but never change, commit to, or push it unless I ask.

## Guidelines

- Check the available skills before every change; there may be one that covers the task.
- Follow the code style guidelines defined in the skills for all the code you write or edit.
- Install the project's dependencies with `npm ci`, so they match the lockfile exactly.
- Ask before installing new dependencies, and explain why each one is needed.
- After each change to the project's functionality, double-check it before calling it done: review your diff, then run the changed feature and, if the project has them, its tests to confirm it works and didn't break anything nearby.
- If a task is hard enough that you need lots of parallel subagents, run them on the Sonnet model to save usage.
- If the subagents' tasks will take a long time, don't run more than 2 subagents at the same time, or we risk hitting the session limit.
- If a tool the setup script should have installed is missing, stop and tell me. Don't install it yourself.
- The environment variables the project needs are already set on this VM. Don't create a local `.env` file: if a variable is missing, tell me and I'll add it to the environment.

## Git workflow

Projects usually use these four main branches:

| Branch | Purpose |
|---|---|
| `main` | Production |
| `test` | Staging |
| `develop` | Main development line |
| `feature` | Individual new features |

Changes always flow through the branches in order, one step at a time: `feature → develop → test → main`. Never skip a step: for example, `feature` is never merged directly into `test` or `main`, and `develop` is never merged directly into `main`. If the project doesn't have one of these branches (for example no `test`), the flow simply skips it.

Before your first push in a session, check which branches trigger a deployment or a release (such as publishing a package): look at the hosting platform and at the CI workflows in `.github/workflows`. If it's unclear, ask me.

- Work directly on the `feature` branch: commit to it and push to it. Don't create a dedicated new branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead.
- If the checkout isn't on `feature`, switch to it before making changes.
- Always pull `feature` before starting new work: the session is long-lived, and the branch may have changed since you last saw it.
- Don't push to any other branch unless I ask.
- Anything that isn't pushed can be lost when the VM is rebuilt. Don't leave work unpushed for long.

If a merge has conflicts, stop and tell me.