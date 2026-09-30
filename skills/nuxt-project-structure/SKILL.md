---
name: nuxt-project-structure
description: 'Architecture and conventions for full-stack Nuxt 4 apps (srcDir app/): folder layout, Vue script setup order, useState stores, Tailwind 4 theming, pages and SEO, Nitro API handlers, Knex DB layer, Zod validation, Firebase Auth, i18n, SSE, Nitro tasks, and security rules. Use whenever adding a feature, creating a file, or refactoring code in a Nuxt 4 project, including pages, components, stores, API endpoints, DB functions, migrations, or nuxt.config.ts.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Nuxt 4 Project Structure

Conventions for Nuxt 4 + Nitro apps built on Knex, Zod, and Firebase Auth. For general JavaScript style (formatting, naming, comments, functions, error handling), follow the `javascript-coding-style` skill; this skill covers only what is specific to Nuxt projects.

**Local code wins.** When a file or folder clearly follows an older or more specific pattern, match it. Don't rewrite a slice toward the "ideal" architecture unless asked, and never remove existing comments.

## Stack

| Layer | Technology |
|---|---|
| Framework | Nuxt 4 + Nitro, `srcDir: 'app/'`, `ssr: true` |
| UI | Vue 3 Composition API, `<script setup>` only |
| Styling | Tailwind CSS 4 via `@tailwindcss/vite`, CSS variables in `app/assets/css/main.css` |
| State | `useState` stores (never Pinia or Vuex) |
| Database | MySQL via Knex.js, migrations in `server/db/migrations/` |
| Auth | Firebase Auth (client) + Firebase Admin SDK (server) |
| Validation | Zod in `server/utils/objectsSchemas.js` |
| Icons | Hugeicons (`@hugeicons/core-free-icons`, `@hugeicons/vue`), never FontAwesome |
| Errors | Sentry via `server/sentry/instrument.js` |
| i18n | `@nuxtjs/i18n`, one JSON file per locale in `i18n/locales/` |
| Content | Nuxt Content 3 + MDC components in `app/components/content/` |
| Images | `@nuxt/image` |
| Jobs | Nitro experimental tasks + `scheduledTasks` |

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
    useFirebase.js         # Client auth
  layouts/                 # e.g. default, public, private, landing
  middleware/auth.js
  pages/
  plugins/                 # *.client.js for browser-only plugins
content/                   # Markdown (blog/, <locale>/blog/)
i18n/locales/              # en.json, it.json, ...
server/
  api/                     # Nitro route handlers
    public/                # Unauthenticated endpoints only
  db/
    config/                # connection.js (getKnex) + db.sql schema snapshot
    migrations/
    <entity>.js            # One module per entity (markets.js, users.js)
  firebase/firebaseAdmin.js
  middleware/security.js   # Runs on every request
  sentry/instrument.js
  sse/                     # Server-sent events connection registries
  tasks/                   # Nitro scheduled tasks
  utils/                   # i18n.js, objectsSchemas.js, utils.js
shared/utils/              # Code used by both app and server
nuxt.config.ts
```

Imports: `~/` for app code, `~~/` for `server/` and `shared/` (in Nuxt 4, `~/` points to `app/`). Keep whichever alias the file already uses, and always include the `.js` extension.

## nuxt.config.ts

Preserve these patterns rather than reintroducing old config shapes:

- `srcDir: 'app/'` and `ssr: true`.
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

Each page declares its layout, middleware, SEO, and schema:

```js
// Define page metadata
definePageMeta({
    layout: 'private', // Use a layout that exists in app/layouts/
    middleware: 'auth' // Required for protected routes
});

// Define SEO metadata
useSeoMeta(createSEOMetatags({
    title: t('seo.markets.title'),
    description: t('seo.markets.description'),
    url: route.path
}));
```

- Match the layout already used by sibling routes. Blog pages use `public`.
- Titles, descriptions, and breadcrumbs always come from i18n keys.
- SSR and caching for private or admin areas are set in `routeRules`, not per page.

### Content components

Components in `app/components/content/` are used inside Markdown. Blog prose styling is split between the page-level `.prose` CSS and these shared components. Put each concern in one place, preferring the shared component, and never duplicate it in both.

## Backend

### API handlers (`server/api/`)

File names follow Nitro method routing: `index.get.js`, `index.post.js`, `[id]/index.get.js`, `[id]/index.put.js`, `[id]/index.delete.js`, and action routes like `[id]/cancel.post.js`. Keep the naming style already used in the folder.

```js
import { getCurrentUser } from '~~/server/firebase/firebaseAdmin.js';
import { cancelMarket } from '~~/server/db/markets.js';
import { handleNuxtErrorMessages } from '~~/server/sentry/instrument.js';
import { t } from '~~/server/utils/i18n.js';

export default defineEventHandler(async event => {
    let lang = 'en';

    try {
        // Verify user is authenticated
        const user = await getCurrentUser(event);
        if (!user) {
            throw createError({
                statusCode: 401,
                statusMessage: 'unauthorized',
                message: t(lang, 'server.error.unauthorized')
            });
        }

        // Get the language from the user profile
        lang = user.language || lang;

        // Get the market ID from the route parameters
        const marketId = getRouterParam(event, 'id');

        // Cancel the market (ownership is checked in the DB layer)
        return await cancelMarket({ marketId, userId: user.id, lang });
    } catch (error) {
        handleNuxtErrorMessages({ error, errorTranslated: t(lang, 'server.error.cancelingMarket'), errorMessage: 'Error canceling market' });
    }
});
```

- Protected handlers call `getCurrentUser(event)` first. Only `server/api/public/` skips auth, and uses `readLanguageFromRequest(event)` for translated messages.
- Handlers never call Knex. They read input and delegate to a `server/db/` function.
- The whole body goes in `try / catch` with `handleNuxtErrorMessages()`.

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
        const market = { id: uuidv4(), userId, name: validatedData.name };

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
- Generate IDs with `uuidv4()`.
- Use `knex.transaction(async trx => { ... })` for any multi-step or multi-table write.
- Use `.forUpdate()` when a transaction reads a value and then updates it (balances, counters, statuses).
- Check ownership inside the DB function before updating or deleting (for example, `market.userId !== userId` → 403).
- Wrap errors with `handleError({ error, errorMessage, throwError: true })`.
- Use the query builder. `knex.raw()` is only for fragments the builder can't express (window functions, `CASE` ordering), never whole SQL statements.
- Keep the existing serialization of stored JSON fields; don't redesign it in a focused change.

**Migrations and schema:** add a Knex migration with a one-line header comment and `up` / `down`, then update `server/db/config/db.sql` to match. Column conventions:

| Field | Definition |
|---|---|
| Primary key | `CHAR(36) PRIMARY KEY DEFAULT (UUID())` |
| Created | `createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL` |
| Updated | `updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL` |
| Money | `DECIMAL(19,4)` |

### Validation (Zod)

All schemas and validators live in `server/utils/objectsSchemas.js`, one `validateXSchema({ xData, lang = 'en' })` per entity. Each one throws a 400 `createError` with a translated message on failure and returns the parsed data. Extend the existing file in its own style. Don't refactor older validators to a new signature during a focused change.

### Errors

| Where | Helper |
|---|---|
| DB and server utilities | `handleError({ error, errorMessage, throwError: true })` |
| API handlers | `handleNuxtErrorMessages({ error, errorTranslated, errorMessage })` |
| Client catch blocks | `handleBackendErrors({ t, error, popupType, defaultMessage })` |

Don't add ad hoc logging when these helpers exist.

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

// Server side
const lang = user?.language || readLanguageFromRequest(event);
const message = t(lang, 'server.error.unauthorized');
```

Every user-facing string goes through i18n, and every new key is added to **all** locale files in the same change.

## New feature checklist

Work through the layers in this order, skipping those the feature doesn't touch:

1. `nuxt.config.ts`: `routeRules` (SSR, caching, headers), tasks, prerender routes.
2. `app/pages/` and `app/layouts/`: route, layout, middleware, SEO.
3. `app/components/`: feature UI, shared primitives, content components.
4. `app/composables/` and `stores/`: shared logic and state, with a reset function.
5. `server/api/`: the endpoint, with auth and error handling.
6. `server/db/`: persistence, transactions, and ownership checks.
7. Migration + `server/db/config/db.sql` if the schema changes.
8. `server/utils/objectsSchemas.js`: validation.
9. `i18n/locales/`: keys in every locale.
10. Check the touched files with editor diagnostics and run the tests.

## Security non-negotiables

1. Protected handlers authenticate before touching user-owned data.
2. Mutations verify ownership before updating or deleting.
3. All user input is validated with Zod before it's persisted.
4. Knex is only called from `server/db/`.
5. Secrets live only in environment variables and `runtimeConfig`.
6. Existing security headers, caching rules, and the security middleware are preserved.