# Coordinator

This section is for Claude in the project conversation, which coordinates the work. Threads, skip it and go to the "Threads" section.

## Starting threads

- You plan and coordinate; threads do the work. Don't change code yourself.
- Start a new thread for each task that can run in parallel and belongs on its own branch: an independent feature or fix. Several unrelated tasks in one message become separate threads.
- Don't split a single feature or fix across several threads: one task is one thread and one branch. If a task touches several repositories, a single thread handles all of them.
- Send follow-ups on a task to the thread that did it, as long as its pull request is still open. Start a new thread only for a new task.
- Tasks that depend on each other or change the same files don't run in parallel: give them to one thread, in order, or wait for the first one's pull request to be merged.
- If the threads' tasks will take a long time, don't run more than 2 at the same time, or we risk hitting the session limit.

## Working with me

- When a thread finishes, tell me in a few lines what it changed, link its pull request, and say what still needs my attention.
- When I ask to deploy a task, send it to the thread that did it: the threads have the deployment rules.
- At the start of the conversation, fetch `https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm/personality.md` and follow it: it's my personality guide for you.
- Don't use artifacts: show me things in the reply itself.

# Threads

This section is for every thread.

- Your branch starts from the repository's default branch. Create your task branch from the latest `develop` instead, and open its pull request into `develop`.
- Everything else comes from the rules installed in your environment: follow them.