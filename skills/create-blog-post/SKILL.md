---
name: create-blog-post
description: 'Expert SEO and GEO blog post writer. Creates complete, high-quality, original blog posts optimized for Google SERPs, AI Overviews, and LLM citations. Follows E-E-A-T guidelines and Generative Engine Optimization (GEO) best practices to maximize visibility in both traditional search and AI-powered answer engines.'
metadata:
  author: Mauro Brambilla
  author-url: https://brumaombra.com
---

# Blog Post Creator — SEO & GEO

Write a complete, SEO- and GEO-optimised blog post about **${input:topic:e.g. "how to start a blog"}**. Before writing, scan the existing content folder for published posts and choose an angle, keyword cluster, or search intent not yet covered.

> **Language**: Write the English version only (`content/blog/` directory). The app supports multiple languages but translations are handled separately — do not create localised versions.

> **Platform**: The blog is built with **Nuxt Content**. The post must be a valid `.md` file with a Nuxt Content frontmatter block and use MDC syntax for custom components.

## 🔍 Pre-Writing Research

### Existing Content Audit
- Read every file under the blog/content directory (the english version) and note each post's H1 title + primary keyword.
- Choose a topic angle that fills a gap — never duplicate an existing search intent.
- Map 8–15 semantic / long-tail related terms to weave naturally into the new post.

### Keyword & Intent Mapping
```
Primary keyword   → match user intent (informational / commercial investigation / navigational).
Semantic cluster  → 8–15 related terms, used naturally throughout.
Search gap        → sub-questions top-ranking pages miss.
Target density    → 0.8–1.8 % (front-loaded in intro + headings).
```

### GEO Intent Mapping
```
AI query types    → "what is", "how to", "best X for Y", "X vs Y", "explain X".
Snippet targets   → definition boxes, comparison tables, numbered steps, concise Q&A.
Entity coverage   → explicitly name tools, brands, standards, categories relevant to the topic.
Citation hooks    → original data, unique frameworks, contrarian takes AI models want to reference.
```

## 📐 Required Post Structure

### Meta Elements

Title selection can happen in two ways: use the title provided in the prompt when one is given, or choose the title autonomously when the prompt does not specify one.

```
Title        → under 60 chars · benefit-driven · includes main keyword
Description  → under 160 chars · compelling · includes main keyword
Slug         → kebab-case · max 5 words · matches primary keyword
```

### Content Tree
```
H1  — Compelling, benefit-driven, keyword-first
  Intro (150–200 words)
    ├── Hook: question / surprising stat / short story
    ├── Value promise: what the reader will learn
    ├── Keyword placed in first 100 words
    └── TL;DR-style one-liner summary

  H2 — [Core section 1]
    H3 — [Sub-topic]
    H3 — [Sub-topic]

  H2 — [Core section 2]
    ...

  Conclusion + CTA  ← required

> ⚠️ **Do NOT include a FAQ section in the markdown body.** FAQs must be added exclusively to the frontmatter `faqs` array. The blog component reads and renders them automatically from there.
```

### Word Count Target
- **1,800–2,400 words** — comprehensive yet scannable; expand only if competition demands it.

## 📄 Nuxt Content File Format

Every post must be a `.md` file placed in `content/blog/` and begin with a valid YAML frontmatter block. Read existing posts in that directory to match the exact frontmatter schema used by the project (fields such as `title`, `description`, `image`, `category`, `publishedAt`, `faqs`, etc.).

### Frontmatter Rules
- Match the exact field names and types used in existing posts — do not invent new fields.
- `slug` is derived from the filename — use a kebab-case filename (e.g. `how-to-do-x.md`).
- Dates must use the format already present in existing posts.
- `faqs` array (if present) must follow the same object shape used in other posts.

### MDC Syntax
Nuxt Content uses **MDC (Markdown Components)** to embed Vue components inside markdown:
```md
::ComponentName{prop="value"}
Slot content here
::
```
Use this syntax for any custom UI components discovered in `components/content/`. Always verify prop names and accepted values by reading the component file before using it.

### Compatibility Rules
- Do **not** use JSX, HTML tags, or Vue template syntax inside the markdown body.
- Exception: for internal app links, use locale-aware `NuxtLinkLocale` links so routing respects the current app language, for example `<NuxtLinkLocale to="/blog/how-to-boost-your-survey-response-rate-7-proven-tips">...</NuxtLinkLocale>`.
- Inline components use `:ComponentName{prop="value"}` (single colon, no block).
- Code blocks, tables, and standard markdown are fully supported.
- Keep frontmatter values as plain strings/numbers/arrays — no Vue expressions.

---

## 🧩 Custom UI Components

When a section calls for a styled list, step-by-step sequence, feature highlight, comparison table, or any other rich UI element, **do not default to plain markdown**. Instead, read every file inside the `components/content/` directory to discover what MDC components are available, then use them via the `::ComponentName` block syntax where appropriate.

### Discovery Rule
Before writing the post, inspect `components/content/` to understand:
- What components exist and what each one renders.
- What props each component accepts (variants, sizes, etc.).
- When each component is the right choice over plain markdown.

### Usage Rules
- Prefer content components over plain markdown whenever a richer presentation improves readability or scannability.
- Read each component's props carefully and only pass values the component actually accepts.
- Never nest complex markdown (headings, code blocks) inside component item strings unless the component explicitly supports it.
- Use plain markdown for FAQ answers, paragraph content, and anything prose-heavy.

## ✍️ E-E-A-T Content Standards

### ✅ GOOD: Experience-first writing
```
First-hand framing: "After testing six tools over three months, the one that consistently stood out was..."
Original insight:   "Most guides skip the setup phase, but that's where 80% of failures happen."
Contrarian take:    "Everyone says to start with keyword volume. We think that's the wrong first step."
```

### ❌ BAD: Generic AI filler
```
"In today's fast-paced world, X is becoming increasingly important..."
"There are many benefits to using X for your needs..."
"It goes without saying that..."
```

### Expertise Signals
- Deep, accurate explanations — go beyond "10 tips" surface coverage.
- Cite reputable external sources (link to studies, official docs, standards bodies) where relevant.
- Challenge common myths or add a unique framework when it genuinely adds value.

## 🌐 GEO — Generative Engine Optimization

GEO is the practice of structuring content so AI answer engines (Google AI Overviews, Perplexity, ChatGPT, Gemini, Claude) extract and cite it accurately.

### Core GEO Principles

| Principle | Implementation |
|---|---|
| **Direct answers first** | Answer the primary question in 1–2 sentences within the first 200 words |
| **Definition blocks** | Define key terms clearly and concisely — AI models extract these for "what is" queries |
| **Numbered steps** | Use ordered lists for processes — AI restructures these into step-by-step answers |
| **Comparison tables** | Use markdown tables for "X vs Y" topics — easy for AI to cite directly |
| **Entity-rich language** | Name platforms, standards, categories, and brands explicitly |
| **Original data / stat** | Include at least one unique insight, original framing, or data point AI would want to cite |
| **Cited claims** | Link to primary sources for statistics and research — boosts credibility for AI extraction |
| **Concise Q&A** | FAQ answers ≤ 60 words each — tuned for featured snippets and AI Overviews |

### AI Overview Optimisation Checklist
- [ ] Core question answered directly in the first 200 words
- [ ] Key terms defined explicitly (AI extracts definitions)
- [ ] Comparisons structured as tables (AI cites these for "vs" queries)
- [ ] How-to steps in numbered lists (AI cites these for "how to" queries)
- [ ] Entity-rich language throughout (platforms, tools, concepts named explicitly)
- [ ] FAQ answers ≤ 60 words — direct and factual
- [ ] At least one original insight, data point, or unique framework
- [ ] 2–4 external links to high-authority primary sources

## 🔍 On-Page SEO Checklist

### Structure
- [ ] H1 includes primary keyword naturally
- [ ] Keyword appears in first 100 words of the intro
- [ ] 8+ H2/H3 subheadings throughout the post
- [ ] Short paragraphs (2–4 lines max)
- [ ] Bullet lists and numbered steps used throughout
- [ ] Bold key phrases (sparingly — not every sentence)

### Links & Schema
- [ ] 3–8 internal links to relevant existing posts or pages
- [ ] Internal app links use locale-aware `NuxtLinkLocale` with app-relative paths (for example `<NuxtLinkLocale to="/blog/how-to-boost-your-survey-response-rate-7-proven-tips">...</NuxtLinkLocale>`)
- [ ] 2–4 external links to high-authority sources
- [ ] Image alt text suggestions provided (descriptive + keyword)
- [ ] FAQ section formatted for FAQPage schema
- [ ] HowTo schema applicable where a step-by-step section exists

## ✍️ Tone & Style Standards

### ✅ GOOD
```
Conversational + expert: "Here's what most guides on this topic get wrong..."
Reader-first:            "If you've never tried this before, start with step two — it's the quickest win."
Empathy:                 "This sounds complex. It's actually three steps."
```

### ❌ BAD
```
Keyword stuffed:    "X tools for X are a great way to do X with the best X solution..."
Clichéd closings:   "In conclusion, X is a great option for..."
Filler padding:     "It is important to note that..." / "As mentioned earlier..."
```

## 📝 Writing Methodology

1. **Audit** — Read existing blog/content files in `content/blog/` (English); list existing keywords and intents. Note the frontmatter schema used.
2. **Components** — Read all files in `components/content/`; note available MDC components and their props.
3. **Gap** — Identify the search angle not yet covered; pick primary keyword.
4. **GEO mapping** — List AI query types this post should answer; plan definition blocks, tables, and step lists.
5. **Outline** — Build the H2/H3 tree and plan where to use components vs. plain markdown.
6. **Draft** — Write intro first (hook → value promise → TL;DR), then each section.
7. **Polish** — Check tone (no filler), verify keyword density, GEO formatting, and internal links.

Write the best possible version — the one that would realistically rank on page one of Google **and** be cited by AI answer engines.

## 📝 Writing Style Guidelines

Always write in an **extremely natural, human-like professional style**:
- **Conversational yet polished**: Sound like an experienced expert speaking directly to the reader — warm, authoritative, and approachable. Write long, full sentences with contractions (don't, it's, you're), varied pacing, and natural transitions.
- **Avoid AI hallmarks**: No repetitive structures, generic hype ("revolutionary," "game-changing," "delve into"), overly formal lists, short robotic sentences, or stiff phrasing. Be direct, subtle, and engaging.
- **Professional quality**: Clear logic, insightful examples or analogies where helpful, strong flow, and precise language. Tailor depth to audience (e.g., executive vs. general).
- **Human touches**: Occasional rhetorical questions, personal-feeling insights, varied vocabulary, and authentic voice. Read aloud in your mind — it should flow smoothly.

## Style Examples to Emulate
Draw inspiration from these well-regarded blogs for tone, flow, and depth:
- **Farnam Street (fs.blog)** by Shane Parrish: Clear, reflective synthesis of ideas with mental models — precise and profoundly readable.
- **The Marginalian** by Maria Popova: Lyrical, deeply researched essays that feel thoughtful and meaningful.
- **Seth’s Blog** by Seth Godin: Concise, provocative, elegantly simple insights.
- **Tim Ferriss Blog**: Detailed, practical, story-driven explanations.
- **Wait But Why** by Tim Urban: Engaging long-form storytelling with humor and clarity.

Incorporate elements like strong hooks, natural rhythm, authentic voice, and insightful examples from these.