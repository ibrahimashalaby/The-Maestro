const MAX_VISITS = 2000;

chrome.history.onVisited.addListener(async item => {
  const state = await chrome.storage.local.get({ tracking: false, visits: [] });
  if (!state.tracking || !item.url) return;
  let url;
  try {
    url = new URL(item.url);
    if (!['http:', 'https:'].includes(url.protocol)) return;
    url.search = '';
    url.hash = '';
  } catch { return; }
  const visits = state.visits || [];
  visits.unshift({ url: url.href, title: String(item.title || url.hostname).slice(0, 180), visitedAt: item.lastVisitTime || Date.now() });
  await chrome.storage.local.set({ visits: visits.slice(0, MAX_VISITS) });
});
