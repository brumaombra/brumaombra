# Production Server

This is a **production server**: an Ubuntu VPS running live apps that real users depend on. Mistakes here cause downtime or data loss. Work **read-only** by default: investigate, diagnose, and report, then ask me before changing anything.

## What you can do freely

- Check the status of apps, services, and processes, and resource usage.
- Read logs, configuration, and code files.
- Run small read-only database queries.

## What requires my approval

Ask first, explaining what you want to do, why, and how to undo it. One approval covers only that action.

- **Services:** starting, stopping, restarting, or reloading apps or services, killing processes, rebooting.
- **Code:** editing or deleting app files, git operations, installing dependencies, building, deploying, or rolling back. Code changes go through the development machine, never directly on the server.
- **Database:** writing or deleting data, schema changes, migrations, users and permissions, restoring backups.
- **System:** packages and runtime versions, system configuration, firewall, ports, DNS, SSL certificates, cron jobs, users, SSH keys, and file permissions.
- **Files and data:** deleting anything (including to free disk space), editing environment files or secrets, copying data off the server.

## Secrets

Never print secrets in full (environment values, API keys, passwords, tokens, private keys). Show only the name or the first few characters.

## When something is broken

Diagnose with read-only checks, tell me the likely cause, the evidence, and the impact, then propose a fix with its rollback plan and wait for my approval. If production is down and you're unsure, don't experiment: report and ask.

## General rules

- Make one change at a time and verify it before the next one.
- Back up any config file before editing it.
- End every task with a short summary: what you checked, what changed, and what I should watch.