---
name: "nuxt-project-structure"
description: "Project conventions for full-stack Nuxt apps. Use whenever adding a feature, creating or editing files, writing tests, or refactoring in a Nuxt project: pages, components, stores, API endpoints, DB functions, migrations, or nuxt.config.ts."
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Nuxt Project Structure

Conventions for Nuxt + Nitro apps built on Knex, Zod, and Firebase Auth. For general JavaScript style (formatting, naming, comments, functions, error handling), follow the `javascript-coding-style` skill; this skill covers only what is specific to Nuxt projects.

**Local code wins.** When a file or folder clearly follows an older or more specific pattern, match it. Don't rewrite a slice toward the "ideal" architecture unless asked, and never remove existing comments.

## Stack

| Layer | Technology |
|---|---|
| Framework | Nuxt + Nitro |
| UI | Vue 3 Composition API, `<script setup>` only |
| Styling | Tailwind CSS 4 via `@tailwindcss/vite`, CSS variables in `app/assets/css/main.css` |
| State | `useState` stores (never Pinia or Vuex) |
| Database | MySQL via Knex.js, migrations in `server/db/migrations/` |
| Auth | Server-side Google OAuth + Firebase Auth session cookies, from the `auth` feature of the shared layer `@brumaombra/nuxt-base` (no Firebase client SDK) |
| Validation | Zod 4 API (`zod/v4`): shared schemas in `shared/utils/schemas.js` when the project has it, server-only ones in `server/utils/objectsSchemas.js` |
| Icons | Hugeicons (`@hugeicons/core-free-icons`, `@hugeicons/vue`), never FontAwesome |
| Errors | Sentry via `server/sentry/instrument.js` |
| i18n | `@nuxtjs/i18n`, one JSON file per locale in `i18n/locales/` |
| Content | Nuxt Content + MDC components in `app/components/content/` |
| Images | `@nuxt/image` |
| Jobs | Nitro experimental tasks + `scheduledTasks` |
| Tests | Vitest + `@nuxt/test-utils` (happy-dom), in-memory SQLite via `node:sqlite` (`tests/helpers/nodeSqliteClient.js`, no `better-sqlite3`) |

## Layout

```
app/
  assets/css/main.css      # Tailwind entry + theme CSS variables
  components/
    <feature>/             # One folder per feature (markets/, surveys/, ...)
    common/ or ui/         # Shared UI primitives
    content/               # MDC components used inside Markdown (BlogList, ProseHr)
  composables/
    stores/                # useXStore.js files (optionally common/ private/ public/)
    useUtils.js            # Shared client helpers
    useAuth.js             # Signed-in user, sign-in, logout, account deletion
  layouts/                 # dashboard (app pages), landing (home, blog, legal, login), default
  middleware/auth.global.js # Route guard (pages with requiresAuth)
  pages/
  plugins/                 # auth.js loads the signed-in user; *.client.js for browser-only plugins
content/                   # Markdown (blog/, <locale>/blog/)
i18n/locales/              # en.json, it.json, ...
server/
  api/                     # Nitro route handlers (the sign-in routes come from the layer)
  auth/                    # app.js (the users the layer's sign-in reads and creates), accounts.js (app user on first sign-in)
  db/
    config/                # connection.js (getKnex)
    migrations/
    <entity>.js            # One module per entity (markets.js, users.js)
  middleware/security.js   # Runs on every request
  sse/                     # Server-sent events connection registries
  tasks/                   # Nitro scheduled tasks
  utils/                   # i18n.js, objectsSchemas.js, utils.js
shared/utils/              # Code used by both app and server (schemas.js: shared Zod schemas, where present)
tests/
  app/                     # Components, middleware, composables, locales (Nuxt environment)
  server/                  # DB functions, handlers, middleware, SSE, tasks (Node environment)
  shared/                  # Pure shared utilities (Node environment)
  helpers/database.js      # In-memory SQLite schema + insert helpers
  helpers/nodeSqliteClient.js # Knex client for node:sqlite
nuxt.config.ts
vitest.config.js
```

Imports: `~/` for app code, `~~/` for `server/` and `shared/` (`~/` points to `app/`). Keep whichever alias the file already uses, and always include the `.js` extension.

## nuxt.config.ts

Preserve these patterns rather than reintroducing old config shapes:

- Top-level `routeRules` own SSR, caching, and security headers per route. Protected areas (admin, private) are controlled here.
- `nitro.experimental.tasks = true`, with cron jobs in `nitro.scheduledTasks`.
- `nitro.prerender.routes = await createAppRoutesList()`.

## Frontend

### `<script setup>` order

`<script setup>` goes at the top of every `.vue` file, in this order:

```vue
<script setup>
// 1. External imports
import { ref, computed, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';

// 2. Composable imports
import { useGlobalStore } from '~/composables/stores/useGlobalStore.js';

// 3. Component imports
import Card from '~/components/ui/Card.vue';

// 4. Props and emits
const props = defineProps({ marketId: { type: String, required: true } });
const emits = defineEmits(['close']);

// 5. Composable initialization
const { t } = useI18n();
const store = useGlobalStore();

// 6. Reactive state
const isLoading = ref(false);

// 7. Computed properties
const hasResults = computed(() => store.value.list.length > 0);

// 8. Methods
const fetchData = async () => {
	// ...
};

// 9. Lifecycle hooks
onMounted(() => fetchData());
</script>
```

### Stores

Every store is a `useXStore.js` file in `app/composables/stores/`:

```js
// Initial state object (a factory, so every reset and SSR request gets a fresh copy)
const initialState = () => ({
	page: 1,
	hasMore: false,
	list: []
});

// Main store function
export const useMarketsSearchStore = () => useState('marketsSearch', initialState);

// Reset function to clear the store
export const resetMarketsSearchStore = () => {
	const store = useMarketsSearchStore();
	store.value = initialState();
};
```

- The `useState` key must be unique across the whole app.
- Always pass an `initialState` factory, never a plain object, to avoid hydration issues.
- Export a matching `resetXStore()` for any store that holds user or list data.
- Small apps keep stores flat. Larger ones split them into `common/` (public and private), `private/` (authenticated only), and `public/`. Follow the project's existing split.

### Styling

- Tailwind utilities, with theme colors taken from CSS variables and always paired light/dark:

```html
<!-- Correct: theme-aware variables for both modes -->
<div class="bg-[var(--bg-card-light)] dark:bg-[var(--bg-card-dark)] text-[var(--text-primary-light)] dark:text-[var(--text-primary-dark)]">

<!-- Wrong: hardcoded palette colors ignore the theme -->
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
```

- Variable families: `--bg-card-*`, `--bg-selected-*`, `--text-primary-*`, `--text-secondary-*`, `--border-*`, `--button-primary-*`, `--button-secondary-*`. Check `main.css` for the project's actual set.
- Raw palette classes (`text-red-500`, `bg-green-100`) are only for semantic colors: errors, success, destructive actions.
- When editing an existing file, keep its styling approach (utilities, gradient helpers, or a scoped `<style>` for prose). Don't convert a file between approaches unless the task requires it.
- Icons: `HugeiconsIcon` for plain icons. When a component renders `inline-flex` (such as a gradient icon pill), put responsive visibility classes on a wrapper, not the component.

### Pages

Each page declares its SEO, its structured data, and then its page metadata, in this order:

```js
// Define SEO metadata
useSeoMeta(createSEOMetatags({
	title: t('seo.markets.title'),
	description: t('seo.markets.description'),
	url: route.path
}));

// Define the breadcrumbs (public pages)
useSchemaOrg([
	defineBreadcrumb({
		itemListElement: [
			{ name: t('seo.home.breadcrumb'), item: localePath('/') },
			{ name: t('seo.markets.breadcrumb'), item: localePath('/markets') }
		]
	})
]);

// Define page metadata
definePageMeta({
	layout: 'dashboard', // Use a layout that exists in app/layouts/
	requiresAuth: true // Signed-in users only (checked by auth.global.js)
});
```

- Match the layout already used by sibling routes: `dashboard` for the app pages (markets, users, private), `landing` for the home page, blog, legal pages, and login.
- Titles, descriptions, and breadcrumbs always come from i18n keys.
- SSR and caching for private or admin areas are set in `routeRules`, not per page.

### Content components

Components in `app/components/content/` are used inside Markdown. Blog prose styling is split between the page-level `.prose` CSS and these shared components. Put each concern in one place, preferring the shared component, and never duplicate it in both.

## Backend

### API handlers (`server/api/`)

File names follow Nitro method routing: `index.get.js`, `index.post.js`, `[id]/index.get.js`, `[id]/index.put.js`, `[id]/index.delete.js`, and action routes like `[id]/cancel.post.js`. Keep the naming style already used in the folder.

Every handler is a `defineApiHandler` from the shared layer: it reads the user, picks the language of the messages and reports the errors, so the handler holds only its own work.

```js
import { defineApiHandler } from '@brumaombra/nuxt-base/server/api';
import { cancelMarketAndNotify } from '~~/server/utils/marketActions.js';
import { t } from '~~/server/utils/i18n.js';

export default defineApiHandler({ auth: 'required', errorKey: 'server.error.cancelingMarket', errorMessage: 'Error canceling market' }, async ({ event, user, lang }) => {
	// Get the market ID from the route parameters
	const marketId = getRouterParam(event, 'id');
	if (!marketId) {
		throw createError({
			statusCode: 400,
			statusMessage: 'missing_market_id',
			message: t(lang, 'server.error.missingMarketId')
		});
	}

	// Cancel the market (ownership is checked in the DB layer)
	return await cancelMarketAndNotify({ marketId, userId: user.id, lang });
});
```

- `auth`: `'required'` for the endpoints of signed-in users (401 without a session), `'optional'` for the ones open to visitors that show more to a signed-in user (`user` is null for a visitor), and nothing (`false`) for the ones that never read a user. The first two need `brumaBase.auth`.
- The handler gets `{ event, user, lang, params }`. `lang` is the language of the user, otherwise the one of the request (`?lang=` or the browser).
- Errors: throw `createError` with a translated message for the expected ones (400, 403, 404, 429): they reach the client as they are, and aren't reported. Anything else goes to Sentry as `errorMessage` and answers a 500 with the translated `errorKey`. Never write the `try / catch` yourself.
- Validation stays in the handler, with the project's validators (they throw translated 400s in `lang`).
- Handlers never call Knex. They read input and delegate to a `server/db/` function.
- A project can build its own wrapper on top, for checks every endpoint of an area repeats (Bruma Surveys' `defineUserHandler` adds the workspace, role and ownership checks). Use it where the project has one.
- Write a plain `defineEventHandler` only when the wrapper can't express the endpoint: a `catch` that has to undo something (like giving back rate-limit points), an error key that depends on the request, a check that must run before reading the user, a stream (SSE), a webhook, or a redirect.
- Sign-in: the layer's `auth` feature owns the Google sign-in, the session and the logout. Read the user with `getCurrentUser(event)` or `requireCurrentUser({ event, lang })` from `@brumaombra/nuxt-base/server/auth` only outside an API handler. In server tests, mock that path with `createAuthMock` from `@brumaombra/nuxt-base/testing/auth`.

### DB layer (`server/db/`)

One module per entity. Only these files may call Knex.

```js
// Create a new market
export const createMarket = async ({ userId, marketData, lang = 'en' }) => {
	const knex = getKnex();

	try {
		// Validate parameters
		if (!userId || !marketData) {
			throw new Error('User ID and market data are required');
		}

		// Validate market data schema
		const validatedData = validateMarketSchema({ marketData, lang });

		// Build the market record
		const market = { id: randomUUID(), userId, name: validatedData.name };

		// Insert the market and its related rows atomically
		await knex.transaction(async trx => {
			await trx('markets').insert(market);
		});

		// Return the created market
		return market;
	} catch (error) {
		handleError({ error, errorMessage: 'Error creating market', throwError: true });
	}
};
```

- Call `getKnex()` inside the function, never at module level.
- Generate IDs with `randomUUID()` from `node:crypto` (no `uuid` package).
- Use `knex.transaction(async trx => { ... })` for any multi-step or multi-table write.
- Use `.forUpdate()` when a transaction reads a value and then updates it (balances, counters, statuses).
- Check ownership inside the DB function before updating or deleting (for example, `market.userId !== userId` → 403).
- Wrap errors with `handleError({ error, errorMessage, throwError: true })`.
- Use the query builder. `knex.raw()` is only for fragments the builder can't express (window functions, `CASE` ordering), never whole SQL statements.
- Keep the existing serialization of stored JSON fields; don't redesign it in a focused change.

**Migrations and schema:** add a Knex migration with a header comment and `up` / `down`, and update the test schema in `tests/helpers/database.js` to match. Column conventions:

| Field | Definition |
|---|---|
| Primary key | `CHAR(36) PRIMARY KEY DEFAULT (UUID())` |
| Created | `createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL` |
| Updated | `updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL` |
| Money | `DECIMAL(19,4)` |

**Migrations must be safe to run twice.** MySQL 8 commits every schema change on its own, and Knex records a migration only once its `up` has finished, so a migration that stops halfway (a failing statement, a lost connection, a container killed mid-deploy) runs again from the top on the next start. Write `up` so that a second run skips what the first one already did:

- Tables: `CREATE TABLE IF NOT EXISTS` and `DROP TABLE IF EXISTS`.
- Columns, indexes and foreign keys (MySQL 8 has no `IF [NOT] EXISTS` for them): check first, with `knex.schema.hasColumn(table, column)` for a column, or a query on `information_schema.STATISTICS` (index) or `information_schema.TABLE_CONSTRAINTS` (foreign key) for the others.
- Data changes (`UPDATE`, `INSERT`, backfills): a `WHERE` that leaves out the rows already changed.

Never edit a migration that has already run in production: fix forward with a new one.

### Validation (Zod)

Write schemas with the Zod 4 API (`import { z } from 'zod/v4'`).

**Projects with `shared/utils/schemas.js`** (for example Bruma Surveys) keep one rule per field there, used by the app, the API and the MCP tools alike:

- `shared/utils/schemas.js` holds the Zod schemas of everything the app edits, plus their enums and limits. It stays pure (no Vue, no Nitro). Its error messages are locale keys (`errors.<entity>.<problem>`, with `{min}` / `{max}` placeholders read from the issue by `readIssueParams`); add each new key to every locale file.
- Enums and limits the light pages need live without Zod in `shared/utils/validationRules.js` (re-exported by `schemas.js`). Never import `schemas.js` or Zod from a public page such as the survey page: its answer checks are plain functions in `shared/utils/answerChecks.js`.
- `server/utils/objectsSchemas.js` holds only `parseSchema`, the `validateXSchema` wrappers that call it with the shared schemas, and the server-only schemas (OAuth, push subscriptions, the response wrapper). `parseSchema` translates a locale-key message with `t(lang)`.
- Editors check with `schema.safeParse()` and map each issue's `path` to its field; selects and `maxlength` read the shared enums and limits. MCP tools build their arguments from the shared schemas (`.pick`, `.extend`, `.describe`) instead of retyping limits.
- Don't move a shared schema back into `objectsSchemas.js`, and don't retype a limit or an enum in a component.

**Other projects** keep all schemas and validators in `server/utils/objectsSchemas.js`, one `validateXSchema({ xData, lang = 'en' })` per entity. Each one throws a 400 `createError` with a translated message on failure and returns the parsed data. Extend the existing file in its own style. Don't refactor older validators to a new signature during a focused change.

### Errors

| Where | Helper |
|---|---|
| DB and server utilities | `handleError({ error, errorMessage, throwError: true })` |
| API handlers | `defineApiHandler({ auth, errorKey, errorMessage }, handler)`, which reports for you |
| Client catch blocks | `handleBackendErrors({ t, error, popupType, defaultMessage })` |

Don't add ad hoc logging when these helpers exist.

### MCP server for AI assistants (`server/mcp/`)

The MCP server and its OAuth sign-in come from the `mcp` feature of the shared layer (`brumaBase.mcp`). It serves `/mcp`, `/oauth/register`, `/oauth/token`, the consent page's `/api/oauth/authorize`, the `.well-known` OAuth files and the server card. Never write OAuth or the MCP protocol by hand.

- **What the app keeps:** `server/mcp/app.js` (`serverInfo`, `serverDescription`, `instructions`, `tools` and `readMcpUser`), the tools in `server/mcp/tools.js`, the consent page, the assistants list of the profile, and the migrations of the four `oauth*` tables. The layer's README lists their columns, and the startup check fails the healthcheck when one is missing.
- **A tool** is `{ name, title, description, requiresUser, annotations, schema, run }`:
  - `schema` is a strict Zod schema of its arguments.
  - `run(arguments, { baseUrl, user, ...context })` returns plain data.
  - Throw `McpToolError` from `@brumaombra/nuxt-base/server/mcp` for an answer the assistant should read (like a resource not found). Anything else is reported to Sentry and hidden from the assistant.
  - Mark the tools that change data with `readOnlyHint: false`, and the irreversible ones with `destructiveHint: true`, so the assistant asks the user first.
- **Something every tool needs** (like a workspace): add it with the app's `toolContext` hook. Something the user picks on the consent page goes in `readConsentConnection`, stored in the columns of `connectionColumns`. Don't fork the protocol.
- **Tests:** mock the layer's helpers by their package path (`@brumaombra/nuxt-base/server/mcp`), and stub `useRuntimeConfig` with the app's `brumaBase.mcp` settings (see the app's `tests/helpers/mcpSettings.js`).

### Server-sent events (`server/sse/`)

Real-time endpoints are `realtime-updates.get.js` handlers that register the connection in a module-level `Map` of `Set`s keyed by resource ID. Each registry sets SSE headers, sends an initial `connected` event, pings every 10 seconds, removes the connection on `close` / `error` with a shared cleanup function, and sets `event._handled = true`. Broadcast functions read fresh data per viewer, drop closed connections, and are called without `await` after mutations.

### Security middleware and tasks

- `server/middleware/security.js` runs on every request: it blocks known scanner paths, rate-limits by IP and session, and applies request guards. Extend it; don't bypass it.
- Scheduled jobs go in `server/tasks/` and are registered in `nitro.scheduledTasks`.

## i18n

```js
// Client side
const { t } = useI18n();
const label = t('common.save');

// Server side (in an API handler, lang comes with the handler)
const message = t(lang, 'server.error.marketNotFound');
```

Every user-facing string goes through i18n, and every new key is added to **all** locale files in the same change.

## Tests

Vitest via `npm test`. Test style follows the `javascript-coding-style` skill. `vitest.config.js` splits the tests into two projects:

```js
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { defineVitestProject } from '@nuxt/test-utils/config';
import { defineConfig } from 'vitest/config';

const projectRoot = dirname(fileURLToPath(import.meta.url));

export default defineConfig({
	test: {
		projects: [
			// Server and shared code: plain Node, the database is mocked with SQLite
			{
				resolve: {
					alias: {
						'~~': projectRoot,
						'~': resolve(projectRoot, 'app')
					}
				},
				test: {
					name: 'server',
					environment: 'node',
					include: ['tests/server/**/*.test.js', 'tests/shared/**/*.test.js']
				}
			},

			// Frontend: runs inside a Nuxt app (auto-imports, i18n, useState...) in a simulated browser
			await defineVitestProject({
				test: {
					name: 'app',
					environment: 'nuxt',
					include: ['tests/app/**/*.test.js'],
					hookTimeout: 60000, // Booting the Nuxt app for each file can take more than the default 10s
					environmentOptions: {
						nuxt: {
							domEnvironment: 'happy-dom'
						}
					}
				}
			})
		]
	}
});
```

- **Server tests** keep `vi.hoisted` synchronous (an async block races the mock registration and can load the real modules), mock the boundaries (`~~/server/db/config/connection.js`, Sentry, Firebase Admin, notifications, SSE), set the Nitro globals they need at module level (`globalThis.createError = createError`, with `createError` imported from `h3`), then load the module under test with `await import(...)` after the mocks.
- **DB functions** run real queries on in-memory SQLite: `getKnex` is mocked to return the database from `createTestDatabase()` in `tests/helpers/database.js`, recreated in `beforeEach` and destroyed in `afterEach`. Insert rows with the `insertX(knex, overrides)` helpers and assert on the database state. Update the helper schema with every migration.
- **API handlers** are called as plain functions with a minimal `buildEvent()` object and mocked DB modules; assert with `rejects.toMatchObject({ statusCode: 400 })`.
- **Frontend tests** mount with `mountSuspended`, set state through the real stores, mock auto-imports with `mockNuxtImport`, and interact like a user (`setValue`, `trigger('click')`, assert on text and `emitted`).
- Keep a locale test checking that every locale has the English keys and placeholders, and that every literal `t('...')` key exists.
- Every bug fix gets a test whose comment describes the bug. Prioritize money, auth, ownership, and input validation paths.

```js
import { createError } from 'h3';

// Share the in-memory database with the mock factory, since Vitest hoists vi.mock
// Synchronous on purpose: an async block (e.g. a dynamic import) races the mock registration and can load the real modules
const database = vi.hoisted(() => ({ knex: null }));

// Run the queries against an in-memory SQLite database instead of MySQL
vi.mock('~~/server/db/config/connection.js', () => ({
	getKnex: () => database.knex
}));

// The Nitro global used by the queries (only called at runtime, so it can be set after the hoisted block)
globalThis.createError = createError;

// Load the module under test after the mocks
const { closeDueMarkets } = await import('../../server/db/markets.js');
```

## New feature checklist

Work through the layers in this order, skipping those the feature doesn't touch:

1. `nuxt.config.ts`: `routeRules` (SSR, caching, headers), tasks, prerender routes.
2. `app/pages/` and `app/layouts/`: route, layout, middleware, SEO.
3. `app/components/`: feature UI, shared primitives, content components.
4. `app/composables/` and `stores/`: shared logic and state, with a reset function.
5. `server/api/`: the endpoint, with auth and error handling.
6. `server/db/`: persistence, transactions, and ownership checks.
7. A migration if the schema changes.
8. Validation: `shared/utils/schemas.js` for what the app edits (where the project has it), `server/utils/objectsSchemas.js` for server-only input.
9. `i18n/locales/`: keys in every locale.
10. `tests/`: cover the new behavior (DB functions against SQLite, handlers, components), and update `tests/helpers/database.js` if the schema changed.
11. Check the touched files with editor diagnostics and run `npm test`.

## Security non-negotiables

1. Protected handlers authenticate before touching user-owned data.
2. Mutations verify ownership before updating or deleting.
3. All user input is validated with Zod before it's persisted.
4. Knex is only called from `server/db/`.
5. Secrets live only in environment variables and `runtimeConfig`.
6. Existing security headers, caching rules, and the security middleware are preserved.