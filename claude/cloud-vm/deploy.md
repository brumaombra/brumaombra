# Deployment

The project is an app deployed to one or more environments (for example production, and sometimes a test environment). Each environment is deployed by a push to its own branch: find which ones the project has before deploying.

## Hosting

- **Static apps** are hosted on Cloudflare Pages. Pages may show some branches as deployable even though their deployments are actually skipped: judge which branches deploy by the deployments that really ran, not by that setting.
- **Non-static apps** are hosted on a VPS managed with Coolify.

Check whether this project is static or not to know where it's deployed, and use that platform to check its deployments and status.

## Tools

- **Sentry MCP:** every non-static project has a Sentry project attached. Use it to check errors when relevant.
- **Coolify MCP:** for non-static apps, use it to check the status of applications, deployments, and logs. A stopped container may show as unhealthy: that's expected, not a problem.
- **Cloudflare MCP:** use it to manage the project's Cloudflare functionalities. Ask before changing any configuration.

## Deploying

When I ask you to deploy to an environment, run the branch flow up to the branch that deploys it, merging and pushing each branch along the way. The request itself is my approval for those merges and pushes.

If more than one deploy branch is on the way (for example `test` before `main`), wait for each deployment to finish before pushing the next one, so two deployments don't run at the same time.

For example, with the usual branches:

- **Deploy to test:** push `feature`, merge it into `develop` and push, then merge `develop` into `test` and push.
- **Deploy to production:** the same, then merge `test` into `main` and push, once the test deployment has finished.