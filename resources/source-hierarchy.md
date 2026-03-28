# Source Quality Hierarchy — Phase 2

## Priority Order (highest to lowest)

1. **Official documentation** — the vendor/creator's own docs are ground truth
2. **Peer-reviewed/tested repositories** — actual code with tests and stars
3. **Expert practitioners** — people who built production systems with the technology
4. **Community discussion with corrections** — Reddit/HN posts where comments fix errors
5. **Tutorial/blog posts** — secondary synthesis, useful but inherits author's biases
6. **News articles** — facts only, skip opinion sections

## Source Type vs Research Value

| Source Type | Facts | Patterns | Opinions | Corrections |
|-------------|-------|----------|----------|-------------|
| Official docs | HIGH | MEDIUM | LOW | N/A |
| GitHub repos | HIGH | HIGH | LOW | Via issues |
| YouTube (with transcript) | MEDIUM | HIGH | HIGH | Via comments |
| Reddit threads | LOW | MEDIUM | HIGH | Via top comments |
| X posts | LOW | LOW | HIGH | Limited |
| Blog posts | MEDIUM | MEDIUM | HIGH | Rarely corrected |

## Reading Strategy

- Official docs: read the STRUCTURE page, not just the getting-started
- Repos: read the README + look at the actual file tree structure
- Reddit: read the TOP COMMENTS, not just the post (corrections live there)
- YouTube: read the TRANSCRIPT HIGHLIGHTS from /last30days output
- Skip: anything that's just a summary of another source (summaries of summaries)

## Scraping Fallback Chain

```
Firecrawl scrape (primary)
    |
    v blocked or unavailable
gemini-analyze-url MCP (reads any URL via Gemini)
    |
    v for library/framework docs specifically
Context7 MCP (resolve-library-id + query-docs)
    |
    v for GitHub repos specifically
GitHub MCP (get_file_contents, search_code)
    |
    v nothing works
Ask user to paste content manually
```
