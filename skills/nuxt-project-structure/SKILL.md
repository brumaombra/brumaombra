---
name: nuxt-project-structure
description: 'Expert guide for structuring, extending, and maintaining this Nuxt 4 application. Covers the current repo layout (`srcDir: app/`), coding style, frontend patterns (Vue 3 Composition API, `useState` stores, Tailwind CSS 4, Hugeicons), backend patterns (Nitro API handlers, Knex.js DB layer, Zod validation, Firebase Auth), i18n, route rules, Nitro tasks, and the new-feature checklist. Use this skill whenever adding a feature, creating a file, or refactoring existing code in this repository.'
---

# Nuxt 4 Project Structure Guide

This skill defines the authoritative conventions for the current Bruma Surveys Nuxt 4 codebase. Follow these rules unless the nearby code clearly establishes a more specific local pattern.

---

## Stack

| Layer | Technology |
|---|---|
| Framework | Nuxt 4 (`nuxt@4.4.x`) + Nitro |
| App root | `srcDir: 'app/'` |
| UI | Vue 3 Composition API (`<script setup>`) |
| Styling | Tailwind CSS 4 via `@tailwindcss/vite` |
| State | `useState` composable stores in `app/composables/stores/` |
| Database | MySQL via Knex.js |
| Auth | Firebase Auth (client) + Firebase Admin SDK (server) |
| Validation | Zod |
| Icons | Hugeicons (`@hugeicons/core-free-icons`, `@hugeicons/vue`) |
| Error tracking | Sentry |
| i18n | `@nuxtjs/i18n` with `i18n/locales/en.json` and `i18n/locales/it.json` |
| Blog/content | Nuxt Content 3 + MDC components in `app/components/content/` |
| Images | `@nuxt/image` with `ipx` provider |
| Scheduled jobs | Nitro experimental tasks + `scheduledTasks` in `nuxt.config.ts` |

---

## Project Structure

```
app/
  app.vue
  assets/css/            # Global styles
  components/
    admin/               # Admin UI and editors
    blog/                # Blog route components
    content/             # MDC/Nuxt Content components (BlogList, BlogTable, ProseHr)
    footer/
    landing/
    surveys/
    tools/
    ui/                  # Reusable UI primitives
    widgets/
  composables/
    stores/              # Flat `useXStore.js` files built with `useState`
    useFirebase.js
    useFormatter.js
    useGradientColors.js
    useStripe.js
    useUtils.js
    useCreateAppRoutesList.js
  layouts/
    dashboard.vue
    default.vue
    public.vue
    user.vue
  middleware/
    auth.js
  pages/
    admin/
    blog/
    survey/
    tools/
    widget/
  plugins/
    googleAnalytics.client.js
content/
  blog/                  # English posts
  it/blog/               # Italian posts
i18n/locales/
  en.json
  it.json
public/
  fonts/
  images/
  widget.js
server/
  api/                   # Nitro API route handlers
    public/              # Unauthenticated public endpoints
    auth/
    analytics/
    questions/
    responses/
    stripe/
    subscription/
    surveys/
    user/                # Single-user endpoints
    widgets/
  db/
    config/              # Knex connection + schema snapshot
    migrations/
    analytics/
    responses/
    surveyAnalytics/
    surveys.js
    subscriptions.js
    users.js
    webhooks.js
    widgets.js
  firebase/
    firebaseAdmin.js
  email/
  middleware/
  plugins/
  sentry/
    instrument.js
  stripe/
  tasks/
  utils/
    formatter.js
    i18n.js
    objectsSchemas.js
    utils.js
nuxt.config.ts           # Top-level routeRules, Nitro tasks, prerender routes
```

---

## Coding Style

### Universal Rules
- **Indentation**: 4 spaces everywhere (JS, Vue, JSON)
- **Functions**: Arrow functions only — never `function` keyword
- **Variables**: `const` / `let` — never `var`
- **Strings**: Template literals for interpolation; plain quotes for static strings
- **Async**: `async/await` only — never `.then()` / `.catch()`
- **Imports**: ES modules only — never `require()`
- **Local imports**: Keep the repo’s existing alias/import style. App-side imports typically use `~/...`; many server files still use `~~/...`.
- **Semicolons**: Always
- **Comments**: NEVER remove existing comments; add comments for non-obvious logic
- **Single-param arrows**: Omit parentheses → `item => item.id`
- **Vue files**: Keep `<script setup>` at the top

### Import Order
1. External npm packages
2. Composables / utilities
3. Components
4. Local constants/types/helpers if defined in-file

```js
import { computed, ref } from 'vue';
import { useI18n } from 'vue-i18n';
import { getBackgroundGradient } from '~/composables/useGradientColors.js';
import Card from '~/components/ui/Card.vue';
```

---

## Nuxt Config

`nuxt.config.ts` in this repo currently establishes several important conventions:

- `srcDir: 'app/'`
- `ssr: true`
- top-level `routeRules` for SSR/caching/security headers
- `nitro.experimental.tasks = true`
- `nitro.scheduledTasks` for cron-like jobs
- `nitro.prerender.routes = await createAppRoutesList()`

When editing config, preserve those patterns instead of reintroducing old duplicated config shapes.

---

## Frontend

### Vue Component `<script setup>` Order

Always declare in this exact order inside `<script setup>`:

1. External imports
2. Composable imports
3. Component imports
4. `defineProps` & `defineEmits`
5. Composable initialisation (`const { t } = useI18n()`, store inits, router, etc.)
6. Reactive state (`ref`, `reactive`, `useState`)
7. Computed properties (`computed`)
8. Methods (plain functions / arrow functions)
9. Lifecycle hooks (`onMounted`, `onUnmounted`, etc.)

```vue
<script setup>
// 1. External
import { ref, computed, onMounted } from 'vue';
import { useI18n } from 'vue-i18n';

// 2. Composables
import { useGlobalStore } from '~/composables/stores/useGlobalStore.js';

// 3. Components
import Card from '~/components/ui/Card.vue';
import Button from '~/components/ui/Button.vue';

// 4. Props & Emits
const props = defineProps({ marketId: { type: String, required: true } });
const emits = defineEmits(['close']);

// 5. Composable init
const { t } = useI18n();
const store = useGlobalStore();

// 6. Reactive state
const isLoading = ref(false);
const errorMessage = ref('');

// 7. Computed
const hasResults = computed(() => store.value.list.length > 0);

// 8. Methods
const fetchData = async () => { ... };

// 9. Lifecycle
onMounted(() => fetchData());
</script>
```

### State Management — `useState` Stores

**Never use Pinia or Vuex.** State is managed with Nuxt's `useState` composable.

Every store lives in `composables/stores/` and follows this pattern:

```js
// composables/stores/private/useMarketsSearchStore.js

// Initial state as a factory function (important: must be a function, not an object)
const initialState = () => ({
    page: 1,
    hasMore: false,
    list: [],
    filters: null
});

// Named export — the store
export const useMarketsSearchStore = () => useState('marketsSearch', initialState);

// Named export — reset function
export const resetMarketsSearchStore = () => {
    const store = useMarketsSearchStore();
    store.value = initialState();
};
```

Rules:
- The unique key passed to `useState` must be globally unique across the app.
- Always provide an `initialState` factory function (not a plain object) to avoid SSR hydration issues.
- Always export a matching `resetXxxStore()` function.
- Place in `common/` if used across public + private routes; `private/` if only in authenticated pages; `public/` if only on public pages.

### Styling

Use Tailwind CSS 4 utility classes combined with CSS custom properties defined in `assets/css/main.css`.

**Always use the CSS variable pattern for theme-aware colors:**

```html
<!-- ✅ Correct — uses CSS variables for both light and dark -->
<div class="bg-[var(--bg-card-light)] dark:bg-[var(--bg-card-dark)] text-[var(--text-primary-light)] dark:text-[var(--text-primary-dark)]">

<!-- ❌ Wrong — hardcoded Tailwind color, not theme-aware -->
<div class="bg-white dark:bg-gray-800 text-gray-900 dark:text-white">
```

Available CSS variable families (always pair `*-light` with `dark:*-dark`):
- `--bg-card-*` — card backgrounds
- `--bg-selected-*` — selected/hover state backgrounds
- `--text-primary-*` — primary text
- `--text-secondary-*` — secondary/muted text
- `--border-*` — borders
- `--button-primary-*` / `--button-secondary-*` — button backgrounds

Only use raw Tailwind color classes (e.g. `text-red-500`, `bg-green-100`) for semantic colors such as errors, success states, and destructive actions.

### Pages

Every page must include at the very top of `<script setup>`:

```js
// definePageMeta first
definePageMeta({
    layout: 'public',          // 'default' | 'public' | 'private' | 'landing'
    middleware: ['auth'],      // include 'auth' for protected routes
    ssr: false                 // always false for pages under pages/private/
});

// Then SEO meta
useSeoMeta(createSEOMetatags({
    title: t('page.title'),
    description: t('page.description'),
### State Management — `useState` Stores
}));
```

Stores in this repo are flat files in `app/composables/stores/` and follow the `useXStore.js` naming pattern:

---
// app/composables/stores/useWidgetsStore.js
## 🔧 Backend
### API Handlers (`server/api/`)
  items: [],
  isLoading: false
- `[id].get.js` — GET handler for a single resource (dynamic segment)
- `[id].put.js` / `[id].patch.js` — update handlers
export const useWidgetsStore = () => useState('widgetsStore', initialState);

export const resetWidgetsStore = () => {
  const store = useWidgetsStore();
import { readMarkets } from '~/server/db/markets.js';
import { handleNuxtErrorMessages } from '~/server/sentry/instrument.js';
import { t } from '~/server/utils/i18n.js';

export default defineEventHandler(async event => {
- The `useState` key must be globally unique.
- Always use an `initialState` factory function.
- Export a matching `resetXxxStore()` helper when the store is stateful enough to need clearing.
        const user = await getCurrentUser(event);
        if (!user) {
            throw createError({ statusCode: 401, statusMessage: 'unauthorized', message: t(lang, 'server.error.unauthorized') });
Use Tailwind CSS 4 utility classes. This repo already uses a mix of:

- direct Tailwind color utilities
- dark mode utility variants
- gradient helpers from `app/composables/useGradientColors.js`
- occasional CSS in component `<style>` blocks for prose/content surfaces

Follow the surrounding file’s styling approach. Do not rewrite a file from utility classes to CSS variables or vice versa unless the task explicitly requires it.

### Icons

Use Hugeicons, not FontAwesome.

Common patterns in this repo:

- `HugeiconsIcon` for plain icons
- `GradientIcon` for branded gradient icon/value pills

When a component already uses `GradientIcon`, do not attach responsive display classes directly to it if wrapper elements are a safer fit. The component renders `inline-flex`, so visibility changes are usually better applied on a wrapper.
Rules:
- **Never** use Knex directly inside an API handler — always delegate to a `server/db/` function.
- **Always** call `getCurrentUser(event)` first on protected endpoints; `server/api/public/` routes are the only exception.
Pages live under `app/pages/`. Layouts currently available in this repo are:

- `default`
- `public`
- `dashboard`
- `user`

Use the layout already established by the route you are editing. Blog pages use `public`.

Typical page setup:
- **Always** wrap the entire handler body in `try/catch` and call `handleNuxtErrorMessages()` in the catch block.


  layout: 'public'
import { v4 as uuidv4 } from 'uuid';
import { getKnex } from '~/server/db/config/connection.js';
import { validateMarketSchema } from '~/server/utils/objectsSchemas.js';

  description: t('page.description')

    try {
        // Validate input
Admin pages are controlled via `routeRules` in `nuxt.config.ts` rather than a legacy `pages/private/` convention.

### Content / MDC Components

Components in `app/components/content/` are consumed inside markdown/MDC documents.

Examples in this repo:

- `BlogList.vue`
- `BlogTable.vue`
- `ProseHr.vue`

When editing blog prose behavior, check both:

- the page-level `.prose` CSS in the blog route
- the shared MDC component in `app/components/content/`

Avoid duplicating the same concern in both places when a shared content component should own it.

        // Build the record
        const market = {
## Backend
            userId,
            name: validatedData.name,
            // ...
Nitro file naming conventions in this repo include patterns like:

- `index.get.js`
- `index.post.js`
- `[id].get.js`
- `[id].put.js`
- `[id].delete.js`
- nested action routes such as `[id]/toggle.post.js` or `[id]/webhooks/[webhookId]/test.post.js`

Use the local pattern in the slice you are editing. A typical protected handler looks like:
        });

        return market;
import { readLanguageFromRequest, t } from '~/server/utils/i18n.js';
import { readSurvey } from '~/server/db/surveys.js';
import { handleNuxtErrorMessages } from '~/server/sentry/instrument.js';
};
```
  let lang = readLanguageFromRequest(event);
Rules:
- **Always** call `getKnex()` inside the function body (not at module level).
- **Always** wrap errors with `handleError({ error, errorMessage, throwError: true })`.
- **Always** use `knex.transaction()` for any operation that writes to multiple tables.
- **Always** use `.forUpdate()` inside transactions that read a value and then update it (prevents race conditions on balances, counters, etc.).
- Only `server/db/` files may call Knex directly — no other layer.
- After every schema change via migration, update `server/db/config/db.sql`.
#### Knex Query Style

    return await readSurvey(user.id, getRouterParam(event, 'id'));
    .limit(25)
    handleNuxtErrorMessages({
      error,
      errorTranslated: t(lang, 'server.error.readingSurvey'),
      errorMessage: 'Error reading survey'
    });
// ✅ knex.raw() only when necessary
.select(knex.raw('AVG(price) OVER (PARTITION BY category) as avgPrice'))

// ❌ Never — full raw SQL string
knex.raw('SELECT id, name FROM markets WHERE userId = ? AND status = ?', [userId, 'open']);
- Keep DB access in `server/db/` modules, not directly in handlers.
- Protected endpoints should authenticate early with `getCurrentUser(event)`.
- Public endpoints can use `readLanguageFromRequest(event)` when they still need translated server messages.
- Prefer the existing error helpers in `server/sentry/instrument.js` rather than ad hoc logging.
| Field type | Convention |
|---|---|
| Primary key | `CHAR(36) PRIMARY KEY DEFAULT (UUID())` |
The DB layer is entity-oriented and lives in `server/db/`. Current modules include `surveys.js`, `widgets.js`, `users.js`, `subscriptions.js`, `webhooks.js`, plus nested analytics/response slices.

Patterns currently used in this repo:

- `getKnex()` inside function bodies
- `uuidv4()` for new IDs
- explicit transactions for multi-step writes
- JSON serialization for structured DB fields where the schema stores JSON strings
- `handleError({ error, errorMessage, throwError: true })` in catches
| Created timestamp | `createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL` |
| Updated timestamp | `updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL` |
| Currency / money | `DECIMAL(19,4)` |
import { getKnex } from '~~/server/db/config/connection.js';
import { validateSurveySchema } from '~~/server/utils/objectsSchemas.js';
import { handleError } from '~~/server/sentry/instrument.js';

export const createSurvey = async (userId, surveyData) => {
### Validation — Zod (`server/utils/objectsSchemas.js`)
  const trx = await knex.transaction();

Define one `validateXxx({ data, lang })` function per entity:
    const validatedData = validateSurveySchema(surveyData);
    const survey = {
      id: uuidv4(),
export const validateTradeSchema = ({ tradeData, lang = 'en' }) => {
      title: validatedData.title
        amount: z.number({ invalid_type_error: t(lang, 'server.error.invalidAmount') })
            .int()
    await trx('surveys').insert(survey);
    await trx.commit();
            statusCode: 400,
    return true;
            message: `[${firstError.path.join('.')}] ${firstError.message}`
    await trx.rollback();
        });
    }

    return parsed.data;
};
```
- Prefer preserving the import alias style already used by the file you touch.
- Keep Knex usage confined to the DB layer.
- Use transactions for multi-step writes.
- Preserve the existing DB serialization format instead of opportunistically redesigning stored JSON fields.

### Validation — Zod
import { getCurrentUser } from '~/server/firebase/firebaseAdmin.js';
Validation is centralized in `server/utils/objectsSchemas.js`.

This file currently exports:

- schema constants
- enum/value lists
- helper validators like `validateSurveySchema()` and `validateWidgetSchema()`

Preserve the current local style when extending it. This repo does not yet use a single uniform `{ data, lang }` validator signature everywhere, so do not force that refactor when making a focused change.

### i18n

Client side:
const user = await getCurrentUser(event);
// user is null if unauthenticated, otherwise: { id, email, language, role, ... }
const { t } = useI18n();
const label = t('common.save');
```

Server side:

```js
import { readLanguageFromRequest, t } from '~~/server/utils/i18n.js';

const lang = readLanguageFromRequest(event);
const message = t(lang, 'server.error.unauthorized');
```

Locale files live in:

- `i18n/locales/en.json`
- `i18n/locales/it.json`

Keep both files in sync when adding new translation keys.

### Error Handling

Prefer the repo’s existing helpers in `server/sentry/instrument.js`:

- `handleError(...)` in DB/server utility layers
- `handleNuxtErrorMessages(...)` in API handlers

Avoid adding fresh ad hoc logging/error patterns when a nearby file already uses these helpers.
| DB layer | `handleError({ error, errorMessage: 'Context string', throwError: true })` |
---
| Client-side catch | `handleBackendErrors({ t, error, popupType, defaultMessage })` |
## Feature Checklist
### i18n
When adding or restructuring a feature, check these layers in this order:
**Server side** — use the `t()` from `~/server/utils/i18n.js`:
1. `nuxt.config.ts`
   - Route behavior in top-level `routeRules`
   - Nitro tasks/prerender changes under `nitro`
2. `app/pages/` and `app/layouts/`
   - Route, layout, and SEO setup
3. `app/components/`
   - Feature UI, shared UI primitives, or blog/content components
4. `app/composables/` and `app/composables/stores/`
   - Shared logic, formatting, app state
5. `server/api/`
   - Endpoint surface
6. `server/db/`
   - Persistence and ownership checks
7. `server/utils/objectsSchemas.js`
   - Validation
8. `i18n/locales/`
   - Translation keys
const label = t('markets.createButton');
### New Feature Checklist

- [ ] Add or update route behavior in `nuxt.config.ts` if caching/SSR/security headers are affected
- [ ] Add/update frontend page or component under `app/`
- [ ] Add/update shared logic in composables or stores if needed
- [ ] Add/update server handler(s) under `server/api/`
- [ ] Add/update DB logic in `server/db/`
- [ ] Add/update validation in `server/utils/objectsSchemas.js`
- [ ] Add/update translations in both locale files
- [ ] Validate the touched files with editor diagnostics/tests where available

---

## Important Repo-Specific Notes
Runs on every request automatically. Handles:
- This repo is on Nuxt 4, not Nuxt 3.
- The application root is `app/` because `srcDir` is configured.
- Blog content uses both page-level prose CSS and shared `app/components/content/` MDC components.
- Hugeicons are the current icon system.
- Route behavior lives in top-level `routeRules` in `nuxt.config.ts`.
- Nitro is still used for tasks and prerendering.
- Preserve local file conventions when a slice is older than the rest of the repo. Do not use a “rewrite to ideal architecture” approach unless explicitly asked.
## 🔄 Server-Sent Events (SSE)
## Security Non-Negotiables

1. Protected API handlers must authenticate before touching user-owned data.
2. Mutations must check ownership before updating/deleting resources.
3. Validate user input before persisting it.
4. Keep direct Knex access in the DB layer.
5. Keep secrets in environment variables only.
6. Preserve the existing security headers and caching behavior configured in `nuxt.config.ts` route rules.