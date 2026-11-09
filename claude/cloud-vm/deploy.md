# Deployment

These rules apply to every repository that is an app deployed to one or more environments (for example production, and sometimes a test environment). Each environment is deployed by a push to its own branch: find which ones the repository has before deploying it.

## Hosting

- **Static apps** are hosted on Cloudflare Pages. Pages may show some branches as deployable even though their deployments are actually skipped: judge which branches deploy by the deployments that really ran, not by that setting.
- **Non-static apps** are hosted on a VPS managed with Coolify.

Check whether the repository is a static app or not to know where it's deployed, and use that platform to check its deployments and status.

## Tools

- **Sentry MCP:** every non-static app has a Sentry project attached. Use it to check errors when relevant.
- **Coolify MCP:** for non-static apps, use it to check the status of applications, deployments, and logs. A stopped container may show as unhealthy: that's expected, not a problem.
- **Cloudflare MCP:** use it to manage the app's Cloudflare functionalities. Ask before changing any configuration.

## Deploying

Changes flow through the branches in order, one step at a time: `feature → develop → test → main`, skipping only the branches the repository doesn't have. Never merge a branch directly into a later one (for example `feature` into `main`).

When I ask you to deploy a repository to an environment, run this flow up to the branch that deploys it, merging and pushing each branch along the way. The request itself is my approval for those merges and pushes, even where other rules only allow pushing to `feature`.

**The VPS can only handle one build at a time. NEVER start a build while another one is running.** For non-static apps, before every push to a branch that deploys, and before any other action that starts a build (a deploy or restart through the Coolify MCP), ALWAYS check on Coolify that no deployment is queued or in progress for any app on the server, not only the one you're deploying: other agents deploy their projects to the same VPS. If one is running, wait for it to finish, then check again before pushing.

If more than one deploy branch is on the way (for example `test` before `main`), wait for each deployment to finish before pushing the next one.

For example, with the usual branches:

- **Deploy to test:** push `feature`, merge it into `develop` and push, then merge `develop` into `test` and push.
- **Deploy to production:** the same, then merge `test` into `main` and push, once the test deployment has finished.

After a production deploy of a non-static app, once the production deployment has finished successfully, stop the test app on Coolify to save the VPS resources. The production deploy request is my approval for this stop. Leave the test app running if the production deployment failed.