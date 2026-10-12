# Git in Claude cloud sessions

- Work directly on the `feature` branch: commit to it and push to it. Don't create a `claude/...` branch, even if the session's own instructions name one: this file is my explicit permission to use `feature` instead.
- If the checkout isn't on `feature`, switch to it (`git fetch origin feature && git checkout feature`) before making changes.
- Pull `feature` before starting new work: the session is long-lived, and the branch may have changed since you last saw it.
- Don't push to any other branch unless I ask.
