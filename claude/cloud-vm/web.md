# Web UI

The project is an app or website with a web UI.

- For any visual change to the UI, send me screenshots of the app before and after the change, on both desktop and mobile. Take the "before" ones before you start editing.
- After each deploy (test and production), once the deployment has finished, purge the Cloudflare cache for the project's domain.

## Lighthouse

When I ask for a Lighthouse check:

1. Build the app and serve the production build, not the dev server, so the result is close to what runs in production.
2. Run Lighthouse with `npx`, skipping the performance category: it doesn't mean anything on this machine.
3. Report the score of each category, and list every issue that keeps it from reaching 100, with the page element or file it comes from.

Don't fix the issues yourself: wait for me to choose which ones to fix.