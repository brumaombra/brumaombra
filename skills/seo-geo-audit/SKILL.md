---
name: seo-geo-audit
description: 'SEO and GEO (Generative Engine Optimization) audit of a website and its content. Use when asked for an SEO or GEO audit or review, when pages don''t rank, get indexed, or get cited by AI answer engines, or before launching a site, a blog, or a new language version.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# SEO and GEO Audit

Audit a site for two kinds of visibility: **SEO** (being crawled, indexed, and ranked in search results) and **GEO** (being retrieved, extracted, and cited by AI answer engines). Base findings on the code and the rendered output, not on generic advice, and give each one a concrete fix.

## Recon

Read the project before judging it:

1. **Framework config and rendering mode**: for example `nuxt.config.ts` (`routeRules`, sitemap, robots, i18n modules), `next.config.js`, or `astro.config.mjs`. Find out which routes are SSR, prerendered, or client-only.
2. **Layouts and the head setup**: global meta, canonical logic, hreflang, and JSON-LD injection (for example, `useSeoMeta`, `useHead`, a `createPageSchema` helper).
3. **Every public page component**: meta calls, the `<h1>`, heading order, images, and internal links.
4. **Content**: Markdown/MDC files and their frontmatter (`title`, `description`, dates, author, FAQs, tags) in every locale folder.
5. **`public/`** and generated files: `robots.txt`, the sitemap, `llms.txt`, the manifest, and OG images.
6. **Dynamic public pages** (profiles, listings, categories): their status codes, empty states, and indexing rules.

Then list every public route and content file. The findings reference this inventory.

## Technical SEO

**Crawling and indexing**
- `robots.txt` doesn't block public pages, CSS, JS, or images, and does keep private, auth, and API routes out. It links to the sitemap.
- The sitemap is generated and includes every indexable page in every locale, excluding redirected, `noindex`, and private URLs. `lastmod` values are accurate; `priority` and `changefreq` are ignored by Google.
- `noindex` appears only on private, auth, thin, or utility pages, and never on a page that is also in the sitemap or used as a canonical.
- Missing resources return a real 404 or 410 (for example, `throw createError({ statusCode: 404 })`), not an empty page with status 200 (a soft 404).
- There are no redirect chains, and HTTP → HTTPS, www, and trailing-slash variants each resolve in a single hop to one consistent form.

**Canonicals and languages**
- Every indexable page has an absolute, self-referencing canonical. Filter, sort, tracking, and pagination parameters don't create indexable duplicates.
- Each language version is canonical to itself, never to the English page.
- `hreflang` is reciprocal across all versions, includes the page itself, uses valid codes, and has `x-default`. The `<html lang>` attribute matches.

**Rendering**
- Titles, meta, canonical, JSON-LD, the main content, and internal links are present in the **server-rendered HTML**. Most AI crawlers don't execute JavaScript, and Google renders it late. Client-only rendering of public content is a Critical finding.
- Hydration or client redirects don't replace server content with something different.

**Meta and on-page**
- Every page has a unique `<title>` of about 60 characters or less that leads with the topic, plus a unique meta description of about 155 characters. Templated pages shouldn't produce duplicate or generic values.
- Open Graph and Twitter tags (title, description, absolute image URL, type, URL) are on shareable pages.
- Each page has one `<h1>` describing its topic, with logical `h2`/`h3` nesting and no levels used only for styling.
- Images have descriptive `alt` text (empty `alt` only for decorative images), meaningful file names, and explicit dimensions.
- URLs are lowercase kebab-case, readable, and stable, and locale prefixes are consistent (`/it/blog/...`).

**Structured data (JSON-LD)**
- `Organization` (logo, `sameAs`) and `WebSite` on the home page. `BlogPosting`/`Article` on posts with `headline`, `image`, `datePublished`, `dateModified`, and an `author` Person with `url` and `sameAs`. `BreadcrumbList` on nested pages. Page-specific types (`Product`, `ProfilePage`, `SoftwareApplication`, ...) where they apply.
- Markup matches visible content, has the required fields, uses absolute URLs, and has no duplicate conflicting entities. Recommend validating with the Rich Results Test and the Schema Markup Validator.
- `FAQPage` markup is fine for machine readability, but Google shows FAQ rich results only for authoritative government and health sites. Don't promise rich results. `HowTo` rich results are deprecated.

**Core Web Vitals** (LCP ≤ 2.5 s, INP ≤ 200 ms, CLS ≤ 0.1)
- LCP: the hero image isn't lazy-loaded, uses `fetchpriority="high"` or a preload, comes in a modern format at the right size (for example, via `@nuxt/image`), and SSR or caching keeps TTFB fast.
- CLS: images, embeds, and ads reserve space, and web fonts use `font-display: swap` with matched fallbacks.
- INP: third-party scripts (analytics, chat, animation libraries) are deferred or loaded after interaction, and there are no heavy client bundles on content pages.

## Content and E-E-A-T

- **Intent match**: the page fully answers the query it targets. Judge coverage against what that intent needs, not against a word count or keyword density.
- **Topic placement**: the main topic appears naturally in the title, `<h1>`, first paragraph, and at least one subheading, and the page uses the vocabulary of the topic rather than repeating one phrase.
- **Internal linking**: descriptive anchor text, links between related posts and from hub or category pages, and no orphan pages.
- **External links**: statistics and claims link to primary sources.
- **Freshness**: `datePublished` and `dateModified` are accurate, visible on the page, and match the JSON-LD.
- **Authorship**: a visible author with a bio or author page, credentials, and first-hand experience ("we tested", screenshots, original examples).
- **Thin or duplicate content**: near-identical templated pages, empty categories or tags, and untranslated pages served as a different locale.

## GEO: AI answer engines

AI engines retrieve pages through search indexes and their own crawlers, then extract self-contained passages to cite. Check the following.

**Access (check first)**
- `robots.txt`, firewall and CDN rules, and bot protection don't unintentionally block AI search and retrieval crawlers: `OAI-SearchBot`, `ChatGPT-User`, `PerplexityBot`, `Claude-SearchBot`, `Claude-User`, `Googlebot`, and `Bingbot`. Blocking training-only crawlers (`GPTBot`, `ClaudeBot`, `Google-Extended`, `CCBot`) is a business choice. Report it as Informational and note that `Google-Extended` doesn't affect AI Overviews.
- Pages are indexed in Bing as well as Google (Bing Webmaster Tools, IndexNow), since several AI engines use Bing's index.
- Content is in the server HTML (see Rendering).
- `llms.txt` is optional and unproven. Mention it only as Informational.

**Extractable content**

| Signal | What to look for |
|---|---|
| Direct answer | The core question is answered in the first one or two sentences under the `<h1>` or relevant heading |
| Self-contained sections | Each `h2` section makes sense when quoted alone; headings phrased like the questions people ask |
| Definitions | Key terms defined in one or two plain sentences ("X is...") |
| Steps | How-to content in ordered lists with one action per step |
| Tables | Comparisons, specs, and pricing in real HTML tables |
| FAQ | Real follow-up questions with concise answers (about 40–60 words) |
| Entities | Products, standards, organizations, and people named explicitly, not "this tool" or "it" |
| Original information | Data, tests, examples, or frameworks unique to this page, which gives an engine a reason to cite it |
| Cited claims | Statistics attributed to primary sources |
| Trust | Visible author, dates, and an organization identity consistent across the site and `sameAs` profiles |

## Severity and scoring

**Severity**
- **Critical**: blocks indexing or citation site-wide (public content client-rendered only, `noindex` or robots blocking public pages, AI search crawlers blocked unintentionally, broken canonicals).
- **High**: hurts a whole template or section (missing or duplicate titles, broken hreflang, no structured data on posts, soft 404s, bad LCP).
- **Medium**: page-level gaps (weak intro, missing internal links, incomplete schema fields).
- **Low**: polish.
- **Informational**: optional or unproven opportunities.

**SEO score**: start at 100 and deduct 20 per Critical, 10 per High, 4 per Medium, and 1 per Low SEO finding.
**GEO score**: the same deductions, applied to GEO-category findings plus any rendering or access findings that also block AI engines.

Minimum score is 0. Labels: 90–100 Excellent, 75–89 Good, 55–74 Fair, 35–54 Needs Work, 0–34 Poor.

## Output

Always output these sections, in this order.

**0. Scores**, each with a one-sentence rationale:

```
**SEO Score**: XX / 100 - [label]
**GEO Score**: XX / 100 - [label]
```

**1. Summary**: `X findings total (Y Critical, Z High, A Medium, B Low, C Informational)`, plus the number of public routes and content files audited.

**2. Critical and High findings**, in full format:

```
**Severity**: Critical | High | Medium | Low | Informational
**Category**: Technical SEO | Rendering | Structured Data | Performance | Content | GEO
**Location**: file path, route, or content section
**Issue**: short name (e.g. Blog posts missing BlogPosting JSON-LD)
**Description**: plain-English explanation
**Impact**: how it hurts ranking, indexing, or AI citation
**Evidence**: the relevant code, rendered HTML, or content snippet
**Fix**: concrete code change or content rewrite
```

**3. Medium, Low, and Informational findings**, in the same format but more concise. Group repeated issues into one finding that lists the affected files.

**4. What's already good.**

**5. Quick wins**: the five fixes with the highest impact for the lowest effort.

**6. Recommendations**: strategic next steps, such as validation tools (Rich Results Test, PageSpeed Insights, Search Console, Bing Webmaster Tools) and content patterns to roll out across posts.