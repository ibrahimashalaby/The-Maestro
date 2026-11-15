# Maestro — Personal Economic Shield

An English-language, local-first installable Windows PWA based on the attached Maestro 2.0 specification. It opens in its own app window and combines an open-ended Exa + Claude solution hunter, AI chat, optional local browser-interest memory and a source-backed tenant-notice workflow.

## Start Maestro as an app

1. Install Windows PowerShell 5.1 or PowerShell 7. No Node package installation is needed.
2. Add `EXA_API_KEY` and `ANTHROPIC_API_KEY` to the workspace `.env` file. The launcher can run Exa search without Claude, but AI chat and generated solution plans require both.
3. Double-click `start-maestro.cmd`. It loads `.env`, starts the local API service and opens an Edge app window.
4. For a permanent installed app, open `http://127.0.0.1:4174/` in a normal Edge window once and choose **Settings and more > Apps > Install this site as an app**. Run `start-maestro.cmd` when needed to start the local API service.

To stop the local service, close its hidden PowerShell process from Task Manager. Maestro listens only on `127.0.0.1`.

## Opportunity Hunter

Describe any problem, goal or question in your own words, with an optional region. After you approve the data notice, Exa searches the topic and Claude turns those results into practical options and next steps. Source cards link to the Exa-returned pages. No fixed categories limit the search. A separate opt-in repeats the current Exa search every six hours while the app is open and visible.

## Other features

- Chat with Maestro. Recent turns and Exa source cards are stored locally. The latest message is searched with Exa; Claude gets recent conversation context and the Exa excerpts. Common email, phone and URL patterns are removed from the Exa query.
- Optional browser companion in `browser-companion/` for Chrome and Edge. It asks for browser-history permission only when tracking is enabled, stores up to 2,000 page URL/title/time records locally, and exports them only when requested.
- Import the browser export in **Your web trail**. Maestro shows recent imported visits and derives an editable topic/site summary locally. Raw visit records are never sent to an AI provider. A user can choose to send the visible summary to Claude for an individual chat turn.
- Review a rent or lease notice, search Exa, inspect source evidence, calculate a possible rent impact, and edit a draft before deciding what to do. Maestro never sends messages or files claims.
- Lawyer, CFO and Concierge lenses; a small local Digital Twin; user-triggered browser speech; local review history; Exa excerpt comparisons; and GSKPI-style indicators.

## Privacy and accuracy

Before a notice review or an open-ended search, the user accepts an on-screen data-sharing notice. Exa is the only web-search provider. For a notice review, Exa receives a generalized topic and region and, if supplied, the public URL for extraction. For an open-ended search, Exa receives the user's search description and optional region. Claude receives the requested question or recent chat, the Exa evidence, and relevant lens/tenancy context. Only if opted in for a specific chat turn does Claude also receive the visible, editable interest summary. Raw browsing history and the local rent profile are not sent to providers.

The browser companion is optional and requires a separate browser-history permission. It stores visits on the device and does not read page contents, form fields, passwords or keystrokes. Use its popup to pause tracking or delete its stored copy; clear the separately imported copy in Maestro settings.

Exa results request a maximum 24-hour cache age; this does not guarantee that a page is legally current or authoritative. Authority labels use a basic host-name heuristic. AI results are not legal, medical, financial or regulatory advice; verify consequential decisions with qualified sources or professionals.

The model is not trained on browser history. Local personalization is computed on-device and included in a Claude request only when the user selects it for that turn.

## Files

- `index.html` — app interface and local browser storage.
- `server.ps1` — local server and Exa/Claude API proxy; keys stay out of client-side code.
- `start-maestro.cmd`, `start-maestro.ps1` — Windows app-window launcher and secure key prompts.
- `manifest.webmanifest`, `service-worker.js`, `icons/` — standalone PWA identity and offline shell.
- `browser-companion/` — optional Chrome/Edge extension and install guide.

The shell works offline after it has loaded, but Exa and Claude features need an internet connection and configured API keys. Browser-trail import and local review history remain available on-device.
