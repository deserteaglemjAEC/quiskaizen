# Discovery Guide — Phase 1

## Query Strategies

### Primary query
Run ONE broad query first to map the terrain:
```
/last30days "[topic] best practices"
```

### If <3 results, expand with:
```
firecrawl search "[topic] guide tutorial" --limit 10 -o .firecrawl/search-topic.json --json
firecrawl search "[topic] documentation official" --limit 5 -o .firecrawl/search-docs.json --json
```

### For comparison topics ("X vs Y"):
Run THREE passes in parallel:
1. `/last30days "[topic A]"`
2. `/last30days "[topic B]"`
3. `/last30days "[topic A] vs [topic B]"`

## What to Extract

From results, build a table:

| Voice | Platform | Engagement | Primary Source Referenced |
|-------|----------|------------|--------------------------|
| [name] | Reddit/X/YouTube | [upvotes/likes/views] | [URL they link to] |

## Fallback Chain

```
/last30days (full multi-platform)
    |
    v fails or <3 results
firecrawl search (web-only discovery)
    |
    v firecrawl unavailable
WebSearch (built-in, no API key needed)
    |
    v for library/framework topics
Context7 MCP (official docs search)
```

## Anti-Patterns

- Running /last30days 5 times with different prompts (diminishing returns after 1st)
- Treating engagement as authority (viral memes != expert analysis)
- Skipping vocabulary extraction (you need the right terms for Phase 2 searches)
