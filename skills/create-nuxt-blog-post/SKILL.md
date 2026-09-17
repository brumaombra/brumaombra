---
name: create-nuxt-blog-post
description: 'Generic workflow for adding a blog post to a Nuxt and Nuxt Content website. Handles content discovery, frontmatter, assets, MDC components, links, SEO metadata, FAQ schema, and validation.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Nuxt Blog Post Creator

Create a complete blog post for the target Nuxt website from the topic **${input:topic:e.g. "how to configure a home server"}**. This skill owns the technical and publishing work around the post. Keep technical publishing decisions separate from editorial voice and prose style.

Start from the target website repository. Verify local files before assuming a directory, collection, schema, route, locale, or component convention.

## Scope

This skill covers:

- Finding the correct Nuxt Content collection and English content directory.
- Matching the repository's frontmatter schema and route behavior.
- Choosing a non-conflicting filename, slug, category, and tags.
- Preparing and verifying featured and inline image assets.
- Selecting and correctly using the repository's MDC components.
- Adding internal and authoritative external links.
- Populating FAQ data used by the blog page's schema and UI.
- Checking Markdown, frontmatter, links, assets, and the Nuxt build.

This skill does not define the article's personality, sentence rhythm, humor, or vocabulary. Follow the project's established editorial conventions for those decisions.

## 1. Inspect Before Editing

Start at the website repository root. Read the equivalent files before creating the post:

1. `package.json` to confirm the Nuxt and Nuxt Content versions and available scripts.
2. `nuxt.config.ts` to confirm source directories, i18n, image handling, and route generation.
3. `content.config.ts` to get the authoritative collection schema.
4. Every relevant post in the target collection to identify existing titles, topics, categories, tags, links, and frontmatter conventions.
5. Every content-component directory before using an MDC component.
6. The blog route, content renderer, and prose styles to understand how frontmatter, FAQs, images, and links are rendered.
7. The configured public or static asset directory before choosing or adding assets.

Nuxt Content projects may use `content/blog/`, locale-specific directories, a custom collection source, or another content layout. Treat the inspected configuration and neighboring posts as the source of truth.

### Content gap check

Build a short inventory of existing English posts before drafting:

```text
Title        -> existing H1/title
Primary topic -> main question or search intent
Category     -> categorySlug and categoryText
Tags         -> existing taxonomy terms
Slug         -> filename-derived route
```

Choose an angle that does not duplicate an existing post's main intent. Do not rewrite or silently modify another post to make room for the new one.

### Writing-Style Skill Discovery

Before drafting, inspect the available skills and read the most pertinent writing-style `SKILL.md` for the post's format and audience, preferring the most specific match for the content type. If no suitable skill is available, use this skill's tone guidance; the selected style governs prose while this skill governs Nuxt Content and publishing requirements.

## 2. Use the Existing Collection Schema

Match the exact field names, types, indentation, and date format used by the content schema and neighboring posts. The following is an illustrative shape only; include only fields supported by the target project:

```yaml
---
title: "A clear article title"
description: "A concise search and sharing description."
image: "/images/blog/post-topic/featured-image.png"
datePublished: "YYYY-MM-DD"
dateModified: "YYYY-MM-DD"
author: "Author Name"
authorUrl: "https://example.com"
authorImageUrl: "/images/authors/author.jpg"
category: "guides"
language: "en"
tags: ["Topic", "Tool", "Privacy"]
faqs:
    - question: "A question readers are likely to ask?"
      answer: "A direct, accurate answer in one or two short sentences."
---
```

Rules:

- Do not assume any example field is required. Confirm required fields, optional fields, and nested object shapes in the target schema.
- Use the locale requested by the user and the exact locale representation expected by the target collection.
- Use the date format already used by the project. ISO `YYYY-MM-DD` is common, but it is not universal.
- Keep FAQ entries in the exact object shape expected by the target schema.
- Do not add a `slug` field when the project derives the slug from the filename; do not remove one when the schema requires it.
- Do not add arbitrary frontmatter fields. If a new field is genuinely required, update and validate the collection schema as a separate change.
- Quote strings containing punctuation, colons, or characters that could be interpreted as YAML syntax.
- Keep FAQ answers factual and concise. If the blog route renders FAQ data automatically, do not duplicate the FAQ as a heading in the Markdown body.

### Metadata checks

Before saving the post, check that:

- The title is specific, readable, and normally under 60 characters.
- The description is unique, useful, and normally under 160 characters.
- The primary topic appears naturally in the title and description.
- The filename is lowercase kebab case and produces the intended route.
- The featured image path follows the project's asset convention and points to an actual public or static asset.
- The category and tags reuse existing taxonomy values where possible.
- The locale, date, and author metadata are consistent with the repository's publishing workflow.

## 3. File and Asset Rules

Create the source file in the directory configured for the target collection. A common layout is:

```text
content/blog/<lowercase-kebab-case-slug>.md
```

The route may be derived from the filename, collection source, or route configuration. Confirm the resulting route before finishing. Create only the locale or translations requested by the user.

For images:

- Store new blog assets in the configured public or static asset directory, following the local folder convention.
- Use a stable, descriptive filename rather than `image1.png` or a generated temporary name.
- Confirm every featured and inline image exists before finishing.
- Give every image descriptive alt text that explains what the reader should see. Do not stuff keywords into alt text.
- Preserve intrinsic width and height metadata when the existing posts provide it. This prevents layout shifts and documents the expected asset dimensions.
- Use the existing Nuxt Content image syntax and project conventions. Do not add arbitrary raw `<img>` elements or Vue template logic to a Markdown post.
- Never place credentials, private account numbers, API keys, personal IP addresses, or other secrets in screenshots, source code, frontmatter, or examples.

## 4. Markdown and MDC Components

Use standard Markdown for prose, headings, links, lists, tables, and fenced code blocks. Use MDC only when a component gives the reader a real presentation or comprehension benefit.

Before using a component, open its implementation and verify its props. Common content component roles include lists, flows, images, code blocks, and dividers, but component names and props differ by project.

Use the exact block syntax supported by the target Nuxt Content version, for example:

```md
::BlogList
---
variant: numbered
items:
  - "Check the service status."
  - "Run the test command."
  - "Compare the result with the expected output."
---
::
```

MDC rules:

- Use the exact component name and prop names exported by `app/components/content/`.
- Keep component item strings short. Put explanation in normal paragraphs before or after the component.
- Use spaces for new YAML indentation and keep the block easy to parse.
- Do not nest headings, code blocks, or complex prose inside an item string unless the component explicitly supports it.
- Do not use JSX, Vue control flow, or arbitrary HTML as a substitute for an existing component.
- Use plain Markdown when the content is prose-heavy or when a component would make the page harder to scan.

## 5. Links and Technical Accuracy

### Internal links

Read neighboring posts and link to relevant pages only when the link helps the reader continue the task. Use the link syntax already used by the project. A relative Markdown link may look like:

```md
[the related guide](/blog/related-post-slug)
```

Do not invent a framework-specific link component inside Markdown unless the current content renderer explicitly supports it. Verify every internal target exists and uses the intended locale and route.

### External links

Use authoritative primary sources for commands, compatibility requirements, security claims, product behavior, and changing platform instructions. Prefer official documentation, standards, and vendor pages. Check that:

- The URL is correct and reachable.
- The link label describes the destination.
- The claim is supported by the linked source.
- A link opening in a new tab follows the existing project syntax and includes the project's expected security attributes.

### Commands and procedures

For every command or configuration value:

1. State what the command changes and any assumptions about the environment.
2. Use placeholders for values that differ by network, device, account, or installation.
3. Explain how the reader can discover the correct local value.
4. Show the expected result or the next verification step.
5. Explain how to undo or troubleshoot a risky change when practical.

Never present a destructive command, firewall rule, DNS change, routing rule, or authentication step without enough context to use it safely. Do not claim that a VPN makes a reader anonymous or that a setup is secure in every situation. Separate what was verified from what depends on the reader's hardware, operating system, network, or software version.

## 6. SEO, GEO, and FAQ Data

Technical structure should help both readers and search systems without distorting the article.

- Put the main question in the title, description, and early body copy when natural.
- Use a logical heading tree with one H1 supplied by the post title and ordered H2/H3 sections.
- Answer the central question directly near the beginning.
- Use numbered lists for procedures, tables for genuine comparisons, and definitions for unfamiliar terms.
- Add roughly 3-8 useful internal links and 2-4 authoritative external links when the topic supports them. Relevance matters more than hitting a quota.
- Add 5-8 FAQs when there are genuine related questions. Keep each answer direct and do not repeat a full FAQ section in the body.
- Include original experience, measurements, or observations only when they are real and can be defended.
- Do not keyword-stuff headings, links, alt text, or FAQs.
- Do not add JSON-LD, Article schema, FAQ schema, or page-level SEO composables to the Markdown file when the blog route already builds them from frontmatter. Follow the target project's ownership boundary.

## 7. Drafting Workflow

1. **Inspect** the collection schema, blog route, components, content inventory, and asset directory.
2. **Define** the reader's problem, the intended route, the primary topic, and the search gap.
3. **Plan** the article sections, verification points, internal links, external sources, and FAQ questions.
4. **Create** the Markdown file with valid frontmatter before writing the body.
5. **Write** the body using the project's established editorial conventions, while keeping commands and technical claims accurate.
6. **Add** only the MDC blocks and images that the existing project supports and the article needs.
7. **Audit** headings, links, image paths, commands, placeholders, FAQs, and secrets.
8. **Validate** the content through the checks below.

## 8. Validation Checklist

Run checks from the website repository root:

- Confirm the new file is in the configured collection source directory and its filename is unique.
- Parse or build the content so invalid YAML and collection-schema errors are caught.
- Confirm all image paths resolve under the configured public or static directory and all internal links target real routes.
- Confirm every MDC component name and prop matches its Vue implementation.
- Search the post for accidental secrets, real account numbers, private IP addresses, and copied placeholder values.
- Run the project's normal production check, normally `npm run build` or the current equivalent from `package.json`.
- If the repository has a content-specific or generate command, run it as an additional check.
- Review the rendered route, if a browser is available, for missing images, broken components, bad heading hierarchy, overflowing code, and FAQ rendering.

Report the created path and the validation commands that actually passed. Do not report a build as successful when only a text inspection was performed.

## Technical Don'ts

- Do not write into another locale's collection directory when the request is for a single locale.
- Do not guess frontmatter fields from another Nuxt project.
- Do not put FAQ headings in the body when the route renders `faqs` automatically.
- Do not use an MDC component without reading its implementation.
- Do not use a filename that conflicts with an existing route.
- Do not reference an image that has not been checked into the configured public or static asset directory.
- Do not paste secrets or environment-specific values into commands or screenshots.
- Do not claim that a command was tested when it was only written down.
- Do not solve a prose problem by adding SEO filler, repeated keywords, or decorative components.