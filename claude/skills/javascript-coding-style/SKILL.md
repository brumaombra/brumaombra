---
name: javascript-coding-style
description: 'Personal JavaScript and TypeScript coding style. Use whenever writing, editing, refactoring, or reviewing JavaScript or TypeScript code.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# JavaScript Coding Style

Code should read top to bottom like a short story: small arrow functions, one step per block, and a plain-English comment above every step. Favor explicit, descriptive code over clever one-liners.

## Golden rules

1. **Match the project first.** Follow the conventions already in the codebase and any project skills or instruction files. Don't invent new patterns, folders, or helpers when an existing one fits. Read the relevant skill in full before acting on a task it covers, every time.
2. **Never weaken security.** Check authentication and ownership, validate every external input with a schema, and keep database access in a data layer, never directly in route handlers.
3. **Comment every step.** See [Comments](#comments). This is the most recognizable trait of the style.

## Formatting

- 4-space indentation, no tabs, no trailing whitespace.
- No newline at the end of the file: the last line of code (usually `};` or `});`) is the final character.
- Always use semicolons.
- Single quotes for strings; template literals for interpolation and multi-line strings (SQL, SSE payloads). Don't concatenate with `+`.
- No trailing commas in objects, arrays, parameters, or imports.
- No hard line-length limit. Keep a statement on one line when it reads well, and break it when it has a structure (objects, chains, long parameter lists).
- Opening braces on the same line; `} else {` and `} else if (...) {` on the closing-brace line.
- **Never write `if / else` without braces.** As soon as there is an `else` or `else if`, every branch uses braces, even single-statement ones. A lone `if` with no `else` may go on one line without braces when its body is a single short statement such as a `return`, `continue`, or one function call: `if (!slug) continue;`, `if (user) navTo('/home');`. Loops (`for`, `while`) always use braces.
- One blank line between logical blocks, and one between top-level declarations. Never two in a row.
- Strict equality only (`===`, `!==`).

```js
// Format a percentage
export const formatPercentage = ({ value, decimals = 2, includeSign = true, locale }) => {
    // Check for NaN
    if (value === null || value === undefined || isNaN(value)) {
        value = 0;
    }

    // Format the number based on the current locale
    const formattedNumber = new Intl.NumberFormat(locale, {
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    }).format(value * 100);

    // Return the formatted percentage string
    if (includeSign) {
        return `${formattedNumber}%`;
    } else {
        return formattedNumber;
    }
};
```

### Objects and arrays

- Short objects stay inline with spaces inside braces: `{ id: marketId }`, `{ method: 'POST' }`.
- Objects with more than two or three properties, or any nested structure, go one property per line.
- Use shorthand properties when the names match (`{ marketId, lang }`).
- Lists of small uniform records put one inline object per line:

```js
// Category metadata list
const categories = [
    { value: 'general', label: t('categories.general'), icon: Globe02Icon },
    { value: 'sports', label: t('categories.sports'), icon: FootballIcon }
];
```

- Arrays of larger objects join them with `}, {`:

```js
// Return the FAQs
return [{
    question: t('faq.closeTime.question'),
    answer: t('faq.closeTime.answer', { closeTime })
}, {
    question: t('faq.status.question'),
    answer: t('faq.status.answer', { status })
}];
```

- Group related properties in large objects with blank lines and a short comment per group:

```js
// Base metatags
const metatags = {
    // Title and description
    title,
    description,

    // Open graph
    ogType: 'website',
    ogTitle: title,

    // Twitter cards
    twitterCard: 'summary_large_image',
    twitterTitle: title
};
```

- Use spread for conditional properties: `...(tags.length > 0 ? { keywords: tags.join(', ') } : {})`.

### Chains

Break builder and query chains one call per line, indented one level:

```js
// Fetch usernames for the invited user IDs
const users = await knex('users')
    .whereIn('id', uniqueInvitedUserIds)
    .select('id', 'username');
```

## Modules

- ES modules only: `import` / `export`, never `require`.
- Always include the file extension in relative and aliased imports (`'~~/server/utils/i18n.js'`).
- Order imports third-party packages first, then project modules.
- Prefer **named exports** (`export const createMarket = ...`). Use `export default` only where a framework or tool requires it (route handlers, config files, plugins, migrations).
- Keep private helpers unexported at the top of the file, above the exported functions that use them.
- For long files, separate major sections with a banner comment:

```js
/******************************** LMSR functions ********************************/

// Format LMSR numbers for display
const formatLmsrNumber = (number, precision = 4) => {
    return parseFloat(number.toFixed(precision));
};
```

## Naming

- `camelCase` for variables and functions; `UPPER_SNAKE_CASE` for module-level constants (`MAX_INVITED_USERS`, `AUTH_READY_TIMEOUT_MS`), with the unit in the name when relevant.
- Descriptive, full names, never abbreviations: `uniqueInvitedUserIds`, `existingUserIds`, `defaultMessageToShow`. Callback parameters are named after the item (`user => user.id`, `change => ...`), not `x` or `u`.
- Booleans start with `is`, `has`, `should`, or `can`: `isPrivate`, `hasMore`, `isMarketOwner`.
- Lookup maps are named by key: `usernamesById`, `tagsBySlug`.
- Functions start with a verb that says what they do:
  - `get` / `read` load data (`readMarketFullById`).
  - `create`, `update`, `delete` change data.
  - `build` assembles a derived structure (`buildUserPosition`).
  - `format` produces display output (`formatPercentage`).
  - `check` / `validate` guard input and throw.
  - `handle` responds to errors or events (`handleError`, `handleGoogleLoginPress`).
  - `reset`, `add`, `remove`, `broadcast`, `send` do what they say.
- Error codes and enum-like string values use `snake_case` (`'market_not_found'`, `'balance_depleted'`).

## Functions

- Always arrow functions assigned to `const`. No `function` declarations, except where a library needs `this` (for example, a query-builder callback).
- A single plain parameter has no parentheses: `value => ...`, `async trx => { ... }`.
- Two or more parameters, or any optional parameter, go in a **destructured object with defaults**, so call sites stay self-describing:

```js
// Format a decimal number
export const formatDecimal = ({ value, decimals = 2, locale }) => {
    // Check for NaN
    if (value === null || value === undefined || isNaN(value)) {
        value = 0;
    }

    // Format the number based on the current locale
    return new Intl.NumberFormat(locale, {
        minimumFractionDigits: decimals,
        maximumFractionDigits: decimals
    }).format(value);
};

// Format an integer number
export const formatInteger = ({ value, locale }) => {
    return formatDecimal({ value, decimals: 0, locale });
};
```

- Put defaults in the destructuring (`lang = 'en'`, `userId = null`). Default the whole object when every field is optional: `({ category, t } = {})`.
- Keep functions small and single-purpose. Extract a helper as soon as a block has a clear name. Local helpers inside a function are fine when only that function uses them (`// Helper function to ...`).
- Use factory functions for fresh default state:

```js
// Initial state object
const initialState = () => ({
    page: 1,
    hasMore: false,
    list: []
});
```

- Return early instead of nesting. A guard that only returns fits on one line; guards that throw use braces:

```js
// Nothing to check
if (!invitedUserIds?.length) return;

// Check if market exists
if (!market) {
    throw createError({
        statusCode: 404,
        statusMessage: 'market_not_found',
        message: t(lang, 'server.error.marketNotFound')
    });
}
```

## Variables and control flow

- `const` by default; `let` only when the value is reassigned. Never `var`.
- Declare a `let` result outside a callback scope when the value is needed after it, with a comment saying so.
- Loop with `for...of`, destructuring entries when useful. Use `map`, `filter`, `flatMap`, `find`, and `some` for transformations, and `forEach` only for side effects.
- Deduplicate with `[...new Set(items)]`. Use `Map` and `Set` for lookups and membership.

```js
// Prepare the balance updates
const balanceUpdates = [];

// Return the net invested amount to each user
for (const [userId, netInvested] of netInvestedMap.entries()) {
    if (netInvested <= 0) continue;
    balanceUpdates.push({ userId, amount: netInvested });
}

// Get unique invited user IDs
const uniqueInvitedUserIds = [...new Set(invitedUserIds)];

// Create a map of user IDs to usernames for quick lookup
const usernamesById = new Map(users.map(user => [user.id, user.username]));
```
- Prefer **mapping objects** over `switch` or long `if` chains for value lookups, with a fallback:

```js
// Status mapping object
const statusMap = {
    open: 'marketStatus.open',
    closed: 'marketStatus.closed'
};

// Get the translation key, fallback to the status itself if not found
const translationKey = statusMap[status] || status;
```

- Use `switch` when each case runs different logic (for example, mapping error codes to thrown errors). Use `if / else if / else` chains, always with braces, for ranges and conditions:

```js
// Determine the appropriate format
if (diffSeconds < 60) {
    return t('common.timeAgo.justNow');
} else if (diffMinutes < 60) {
    return t('common.timeAgo.minutesAgo', { count: diffMinutes });
} else {
    return new Intl.DateTimeFormat(locale, { month: 'short', day: 'numeric' }).format(parsedDate);
}
```

- Use optional chaining (`error?.data?.message`) for possibly missing data. Use `||` for fallbacks when any falsy value should fall back, and `??` only when `0` or `''` are valid values.
- Check "no value" explicitly when `0` matters: `value === null || value === undefined || isNaN(value)`.
- Explain magic numbers with a trailing comment:

```js
// Keep connection alive
const keepAlive = setInterval(() => {
    res.write(': keep-alive\n\n'); // Send a comment as a keep-alive ping
}, 10000); // 10 seconds
```

## Async code

- `async` / `await` everywhere. No `.then()` chains, and `new Promise` only to wrap callback APIs.
- Run independent work in parallel with `Promise.all` and destructure the results. Comment each entry of the array:

```js
// Execute the queries in parallel
const [market, positions] = await Promise.all([
    // Get and lock the market
    trx('markets').where({ id: marketId }).first().forUpdate(),

    // Get every position in this market
    trx('positions').where({ marketId })
]);
```

- Always assign the result of a fetch request (`fetch`, `$fetch`, `useFetch`, API clients) to a `const`, either whole or destructured, before using it. Never use the awaited call itself as a value: no `return await $fetch(...)`, no `(await $fetch(...)).market`, no passing it inline as an argument:

```js
// Get the market from the API
const response = await $fetch(`/api/markets/${marketId}`, { query: { lang } });

// Get the user's positions from the API
const { positions } = await $fetch('/api/positions', { query: { marketId } });

// Return the market with the positions
return { ...response.market, positions };
```

- Fire-and-forget calls (notifications, broadcasts) are left unawaited on purpose, with the comment saying what they do.
- Always clean up timers, listeners, and connections, and centralize the cleanup in one function registered on every exit path:

```js
// Handle connection close
const cleanup = () => {
    clearInterval(keepAlive);
    removeConnection({ marketId, connection });
};

// Listen for client disconnect
res.on('close', cleanup);
res.on('error', cleanup);

// Broadcast update to the connected viewers (not awaited on purpose)
broadcastMarketUpdate({ marketId });
```

## Error handling

- Wrap the body of every async operation in `try / catch` and delegate to a central handler instead of logging ad hoc.
- Validate required parameters at the top of the function, before any work.

```js
// Delete a market
export const deleteMarket = async ({ marketId, userId }) => {
    const knex = getKnex();

    try {
        // Validate parameters
        if (!marketId || !userId) {
            throw new Error('Market ID and user ID are required');
        }

        // Delete the market owned by the user
        await knex('markets')
            .where({ id: marketId, userId })
            .delete();
    } catch (error) {
        handleError({ error, errorMessage: 'Error deleting market', throwError: true });
    }
};
```

- Internal error messages are short, sentence case, and have no trailing period. User-facing messages go through the translation layer, not hard-coded strings.
- Throw structured errors with a status code, a `snake_case` code, and a translated message for anything a client will see.
- Use `finally` to reset UI or resource state:

```js
// Handle Google login
const handleGoogleLoginPress = async () => {
    try {
        setBusy(true); // Busy on
        const user = await googleLogin({ t, locale: locale.value }); // Login with Google
        if (user) navTo('/private/markets'); // Redirect after login
    } catch (error) {
        showMessageToast({ message: error.message || t('auth.login.googleLoginError'), type: 'error' });
    } finally {
        setBusy(false); // Busy off
    }
};
```

- Use `console.log` / `console.error` only for startup messages and in the central error handler.

## Comments

Comments are what makes this style recognizable. Use them everywhere: in new code, in code you edit (comment the blocks you add or change), in helpers, in tests, and in config objects. Uncommented blocks are incomplete. Apply these rules consistently:

- **Every function has a one-line `//` comment directly above it** saying what it does, starting with a verb: `// Create a new market`, `// Format a percentage`. Add a parenthetical for non-obvious scope: `// Reset all market listing stores (explore, search, categories)`.
- **Every logical block inside a function starts with a `//` comment** after a blank line, again starting with a verb: `// Validate parameters`, `// Get the market ID from the route parameters`, `// Check if user is the creator`, `// Return the created market`. A function reads as a list of these steps.
- The final `return` in a multi-step function gets its own comment (`// Return the field changes with usernames resolved`).
- Short setup lines at the very top of a function (for example, `const knex = getKnex();`) and one-line functions don't need block comments.
- Use **trailing inline comments** for short clarifications of a single line: `setBusy(true); // Busy on`, `customError.name = errorMessage; // Set custom title`.
- Style: sentence case, no trailing period, plain English. Say *what* the block does, and add *why* in parentheses when the reason isn't obvious: `// Count the market against the daily quota (rolled back with the market if anything fails)`.
- Use `/****** Title ******/` banners to split long functions or files into phases (`Get the data`, `Validations`, `Process resolution`).
- A one-line header comment on standalone files like migrations: `// Migration to add 'category' column to markets table`.
- No JSDoc blocks, no commented-out code, no `TODO`s left behind.

A complete function with every comment type in place:

```js
// Build unique tag cards from blog posts
export const buildTagsFromPosts = posts => {
    const tagsList = posts.flatMap(post => post.tags || []);
    const tagsBySlug = new Map();

    // Loop through each tag and count it under its slug
    for (const tag of tagsList) {
        const slug = slugify(tag);
        if (!slug) continue; // Skip tags without a valid slug

        // Initialize the tag card the first time the slug appears
        if (!tagsBySlug.has(slug)) {
            tagsBySlug.set(slug, { name: tag, slug, count: 0 });
        }

        // Increment the count for this tag slug
        tagsBySlug.get(slug).count += 1;
    }

    // Return the unique tag cards (in order of first appearance)
    return [...tagsBySlug.values()];
};
```

## Tests

- Group tests with `describe` per unit and `it` per behavior. Test names are lowercase sentences: `it('keeps the other users\' markets intact', ...)`.
- Put a comment above each `describe` and `it` explaining the scenario or the bug it guards against.
- Inside a test, comment the setup, the action, and the assertions (`// Expect the market to be canceled with the other user refunded`).
- Comment each mock with the reason it exists (`// Rethrow errors instead of reporting them to Sentry`).
- Create fresh state in `beforeEach` and tear it down in `afterEach`.

```js
// Rethrow errors instead of reporting them to Sentry
vi.mock('~~/server/sentry/instrument.js', () => ({
    handleError: ({ error, throwError }) => {
        if (throwError) {
            throw error;
        }
    }
}));

// Account deletion: the user's data goes away, other users' funds stay
describe('deleteUser', () => {
    let knex;

    // Create a fresh database for each test
    beforeEach(async () => {
        knex = await createTestDatabase();
    });

    // Close the in-memory database
    afterEach(async () => {
        await knex.destroy();
    });

    // Deleting a user used to wipe the other traders' positions without a refund
    it('refunds the other traders of the user\'s open markets', async () => {
        // Create a market owned by the user and a trade by another user
        const market = await insertMarket(knex, { userId: deletedUser.id });
        await executeTrade({ userId: otherUser.id, marketId: market.id, tradeData: { option: 'yes', amount: 50 } });

        // Delete the account
        await deleteUser({ userId: deletedUser.id });

        // Expect the other user to be refunded
        expect((await knex('users').where({ id: otherUser.id }).first()).balance).toBeCloseTo(1000, 4);
    });
});
```

## Final check

Before finishing, confirm:

- 4 spaces, semicolons, single quotes, no trailing commas, blank lines between blocks, no final newline.
- No `if / else` without braces: every branch of an `if / else` chain and every loop has braces. Only a lone `if` with a single short statement may be inline.
- Only arrow functions, and destructured object parameters with defaults for multi-argument functions.
- Every function, logical block, `Promise.all` entry, object group, test, and mock has a verb-first `//` comment, including in code you only edited; no JSDoc, no periods.
- Guard clauses and parameter validation come first; async work is in `try / catch` with the central error handler.
- Every fetch response is assigned to a `const` (whole or destructured), never used inline as a value.
- Names are descriptive, booleans use `is` / `has`, constants are `UPPER_SNAKE_CASE`.
- Imports include `.js` extensions; exports are named unless a framework requires a default.
- Existing project conventions and skills were followed, and no security check was weakened.