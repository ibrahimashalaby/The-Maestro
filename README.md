# The Maestro

Maestro is an English-language, local-first Windows app for exploring solutions and opportunities. It combines Exa web search with Anthropic Claude, source-backed answers, an AI chat, optional local browsing-interest memory, and a tenant-notice review workflow.

## Run on Windows

1. Install Windows PowerShell 5.1 or PowerShell 7.
2. Copy `.env.example` to `.env` and set `EXA_API_KEY` and `ANTHROPIC_API_KEY`.
3. Double-click `outputs/start-maestro.cmd`.

Maestro opens in an Edge app window and serves its API on `127.0.0.1:4174`. Node.js is not required. The API keys stay on the server and must never be placed in client-side code. The `.env` file is excluded from Git.

For a detailed feature guide and privacy notes, see [outputs/README.md](outputs/README.md). Railway container deployment notes are in [RAILWAY.md](RAILWAY.md).

## Search and AI

Exa is the app's only web search provider. Anthropic Claude analyzes Exa results and powers chat and solution planning. Source cards link to the pages returned by Exa.

## Personalization and privacy

Browser-history tracking is optional and provided by the separate companion extension. Imported visits and topic summaries stay in the browser by default. The user can choose to share an editable interest summary with Claude for an individual chat turn. Raw browsing history is not sent to Exa or Claude.

The local server listens only on loopback by default. Do not expose it to the public internet without enabling the app's password-protected public mode and using a secure tunnel or hosting service.
