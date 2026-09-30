---
name: translate
description: 'Natural, idiomatic translation and localization between any languages: i18n JSON/locale files, UI strings, Markdown/MDC blog posts with frontmatter, marketing copy, error messages, emails, and legal text. Preserves placeholders, plural syntax, markup, keys, slugs, URLs, and brand terms. Use when asked to translate, localize, or add a new language, when syncing missing keys across locale files, or when creating the translated version of a blog post or page.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Translation and Localization

Translate meaning, not words. The result must read as if a native speaker wrote it for this audience: never a calque, never machine-translation phrasing, and nothing added or dropped.

## Before translating

1. **Identify the source language, target language, and content type** from the request and files. Ask only if the target language is genuinely unclear.
2. **Read the whole source first**, so terminology and tone stay consistent across segments.
3. **Reuse existing translations as the glossary.** When other locale files or translated posts exist, match their terminology, formality (for example, Italian `tu` vs `Lei`), and style.
4. **Mark protected elements** that must survive unchanged: placeholders, keys, markup, URLs, slugs, code, brand and product names.

## Always preserve

- **Placeholders**, character for character: `{name}`, `{count}`, `%s`, `{0}`, `{{ value }}`. Move them to wherever the target grammar needs them, but never rename or translate them.
- **Plural and select syntax**: translate only the text inside each branch. Add the plural forms the target language requires (ICU `{count, plural, one {...} other {...}}`, vue-i18n `a | b | c`).
- **Linked messages and escapes**: vue-i18n `@:key`, literal `{'@'}`. Don't introduce unescaped `@`, `|`, `{`, or `}` into vue-i18n strings.
- **Keys and structure**: JSON keys, nesting, and key order stay identical. Only values change, and no key is omitted.
- **Markup**: HTML tags, Markdown syntax (headings, emphasis, lists, tables, code), and MDC components (`::BlogList`, props, `---`, `::`). Translate only the human-readable text inside them.
- **Identifiers**: URLs, slugs, image paths, error codes, enum values, CSS classes, and code blocks.
- **Brand and product names and trademarks** stay as they are. Keep facts, numbers, dates, and proper nouns exact.

```json
// Source (EN)
"welcome": "Welcome back, {name}!"

// Correct (IT)
"welcome": "Bentornato, {name}!"

// Wrong (IT): placeholder renamed
"welcome": "Bentornato, {nome}!"
```

## Style

- Match the source's tone and register (formal, conversational, playful, technical), adjusted to the target language's conventions.
- Replace idioms, metaphors, humor, and cultural references with natural equivalents when a literal version would be confusing.
- Follow target-language typography: sentence case rather than English Title Case (Italian, French, Spanish, ...), native quotation marks, and spacing rules (for example, French non-breaking spaces before `? ! : ;`).
- Don't hard-code number, date, or currency formats that the app formats at runtime; leave the placeholders. Localize them only in static prose.
- Keep gender and number agreement correct around placeholders. Reword neutrally when the placeholder's gender is unknown.

## Content-type rules

**UI strings and locale files**
- Keep strings about as long as the source. Buttons and labels have little room, so prefer a shorter natural phrasing to a long exact one.
- Use one consistent term per concept across the whole file.
- When syncing locales, add every missing key to every locale file in the same change.

**Blog posts and Markdown pages**
- Translate frontmatter prose fields (`title`, `description`, FAQ `question` and `answer` values, image `alt` text). Keep technical fields unchanged (`slug`, `image`, `categorySlug`, `author`, dates, keys).
- The `slug` is identical in every language and uses the original English slug. The translated file goes in the locale folder the project already uses (for example, `content/it/blog/`).
- Keep SEO fields within typical limits: titles around 60 characters, descriptions around 155.
- Translate link labels in prose, but keep URLs. Keep code examples as they are; only their comments may be translated, and only if the source's convention allows it.
- Keep the heading hierarchy and document structure identical.

**Marketing copy**: aim for persuasion and emotional impact in the target culture, not literal accuracy. Adapt CTAs to what sounds natural and compelling there.

**Error messages and system strings**: concise, clear, and in the target language's conventions for error phrasing. Keep error codes verbatim.

**Legal and policy text**: translate precisely and formally without paraphrasing. Use the target jurisdiction's standard term when one exists.

## Output

- **Files** (locale JSON, Markdown posts): write the complete translated file, with every key, the full frontmatter, and all formatting. Never leave a partial or truncated file.
- **Strings given in chat**: return the translations only, in the same order and format as the input.
- Never put notes, comments, or explanations *inside* the translated content. If something needs attention (an untranslatable pun, a legal term with no exact equivalent, an ambiguous source string), mention it briefly in your chat reply, separate from the translation.

## Final check

- Every placeholder, plural branch, tag, component, key, URL, and slug matches the source.
- No key or paragraph is missing, and nothing was added.
- It reads naturally aloud in the target language, with consistent terminology and formality.
- UI strings fit their space, and SEO fields are within their limits.
- JSON still parses, and the Markdown/MDC structure is intact.