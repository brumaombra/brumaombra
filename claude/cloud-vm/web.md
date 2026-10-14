# Web UI

The project is an app or website with a web UI.

- For any visual change to the UI, send me screenshots of the app before and after the change, on both desktop and mobile. Take the "before" ones before you start editing.
- After each deploy, once the deployment has finished, purge the Cloudflare cache for the project's domain.
- After each deploy and cache purge, in every environment, do a quick check of the deployed website: open the home page and the pages affected by the change, and confirm they load, show the new version, and have no console errors. In production, only look around: don't submit forms or create data. If something is broken, tell me right away.

## Lighthouse

When I ask for a Lighthouse check:

1. Build the app and serve the production build, not the dev server, so the result is close to what runs in production.
2. Run Lighthouse with `npx`, skipping the performance category: it doesn't mean anything on this machine.
3. Report the score of each category, and list every issue that keeps it from reaching 100, with the page element or file it comes from.

Don't fix the issues yourself: wait for me to choose which ones to fix.