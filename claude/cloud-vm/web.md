# Web UI

The project is an app or website with a web UI.

- Use Playwright, which is already installed, for everything you do in the browser, and use the app like a normal user would.
- When I ask for a change that needs a UI edit, propose 3 different designs before implementing it. Show each one as a simple image (a screenshot of the variant rendered in the app), labelled with its letter: variant A, B, and C. Then ask me to pick one with an interactive question, if you have a tool for it (one option per variant, plus a short description of each), or in the reply otherwise. Wait for my answer, and only implement the variant I pick.
- For any visual change to the UI, send me screenshots of the app before and after the change, on both desktop and mobile. Take the "before" ones before you start editing.
- Add a title at the top of every screenshot you send me (a banner you add to the page before taking it), saying what it shows, so I can understand it without any other context: the page, the variant or before/after, and desktop or mobile (for example "Login page · Variant B · Mobile" or "Market page · After · Desktop").
- After each deploy, once the deployment has finished, purge the Cloudflare cache for the project's domain.
- After each deploy and cache purge, in every environment, do a quick check of the deployed website: open the home page and the pages affected by the change, and confirm they load, show the new version, and have no console errors. In production, only look around: don't submit forms or create data. If something is broken, tell me right away.

## Lighthouse

When I ask for a Lighthouse check:

1. Build the app and serve the production build, not the dev server, so the result is close to what runs in production.
2. Run Lighthouse with `npx`, skipping the performance category: it doesn't mean anything on this machine.
3. Report the score of each category, and list every issue that keeps it from reaching 100, with the page element or file it comes from.

Don't fix the issues yourself: wait for me to choose which ones to fix.