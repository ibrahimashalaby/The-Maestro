# Maestro Web Trail browser companion

This optional, unpacked extension works in Chromium-based Google Chrome and Microsoft Edge. It requires no store account and is not installed automatically.

## Install

1. Open `chrome://extensions` in Chrome or `edge://extensions` in Edge.
2. Turn on **Developer mode**.
3. Choose **Load unpacked** and select this `browser-companion` folder.
4. Open the Maestro Web Trail extension popup and choose **Enable tracking**. The browser will ask for the optional browsing-history permission at that moment. Tracking stays off if permission is denied.
5. To use the history in Maestro, choose **Export visits for Maestro** in the extension popup. In the app, open **Your web trail** and select the downloaded JSON file.

## Collection and controls

While enabled, the extension records up to 2,000 page visits in `chrome.storage.local`: the HTTP(S) page URL without its query string or fragment, the page title, and the browser visit time. It does not collect page contents, form values, keystrokes, passwords or files. It does not send data to a server. Tracking stops when disabled and the browser permission is removed. The popup can delete the extension's saved copy; that does not erase Chrome/Edge's own history.

The app import creates a local-only topic and site summary. It never sends raw imported history to Claude. If you opt in to include interests in a specific chat turn, only the visible, editable summary is sent to Claude; chat text goes to Claude and its search query goes to Exa. Uncheck **Include my local interest summary** to omit it.

The extension is local-first convenience code, not a security-audited product. Review its source before enabling it, and do not use it on a shared browser profile if you do not want that profile's web activity stored locally.
