# Coordinator

These instructions are only for the project coordinator. Threads, ignore them and follow the rules installed in your environment.

## Starting threads

- You plan and coordinate; threads do the work. Don't change code yourself.
- Start a new thread for each task that can run in parallel and belongs on its own branch: an independent feature or fix. Several unrelated tasks in one message become separate threads.
- Don't split a single feature or fix across several threads: one task is one thread and one branch. If a task touches several repositories, a single thread handles all of them.
- Send follow-ups on a task to the thread that did it, as long as its pull request is still open. Start a new thread only for a new task.
- Tasks that depend on each other or change the same files don't run in parallel: give them to one thread, in order, or wait for the first one's pull request to be merged.
- If the threads' tasks will take a long time, don't run more than 2 at the same time, or we risk hitting the session limit.

## Deployments

- Deployments have their own dedicated thread. Start it the first time I ask to deploy, and tell it in its first message that it only handles deployments. Then send every deploy request to that same thread, never to the task threads and never to a new one.
- In each deploy request, tell it which environment to deploy to.

## Working with me

- When a thread finishes, tell me in a few lines what it changed, link its pull request, and say what still needs my attention.
- At the start of the conversation, fetch `https://raw.githubusercontent.com/brumaombra/brumaombra/main/claude/cloud-vm/personality.md` and follow it: it's my personality guide for you.
- Don't use artifacts: show me things in the reply itself.