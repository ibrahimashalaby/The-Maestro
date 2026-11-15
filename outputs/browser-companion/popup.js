const stateEl = document.querySelector('#state');
const statusEl = document.querySelector('#status');
const toggle = document.querySelector('#toggle');

async function refresh() {
  const data = await chrome.storage.local.get({ tracking: false, visits: [] });
  const count = (data.visits || []).length;
  stateEl.textContent = `${data.tracking ? 'Tracking is on' : 'Tracking is off'} · ${count} locally saved visits`;
  toggle.textContent = data.tracking ? 'Turn tracking off' : 'Enable tracking';
}

toggle.addEventListener('click', async () => {
  const data = await chrome.storage.local.get({ tracking: false });
  if (data.tracking) {
    await chrome.storage.local.set({ tracking: false });
    await chrome.permissions.remove({ permissions: ['history'] });
    statusEl.textContent = 'Tracking stopped. Saved visits remain until deleted.';
  } else {
    const granted = await chrome.permissions.request({ permissions: ['history'] });
    if (!granted) statusEl.textContent = 'History permission was not granted. Tracking remains off.';
    else {
      await chrome.storage.local.set({ tracking: true });
      statusEl.textContent = 'Tracking enabled on this device.';
    }
  }
  await refresh();
});

document.querySelector('#export').addEventListener('click', async () => {
  const data = await chrome.storage.local.get({ visits: [] });
  const payload = { source: 'Maestro Web Trail', exportedAt: new Date().toISOString(), visits: data.visits || [] };
  const url = URL.createObjectURL(new Blob([JSON.stringify(payload, null, 2)], { type: 'application/json' }));
  const link = document.createElement('a'); link.href = url; link.download = 'maestro-web-trail.json'; link.click(); URL.revokeObjectURL(url);
  statusEl.textContent = 'Export saved to your Downloads. It has not been uploaded.';
});

document.querySelector('#clear').addEventListener('click', async () => {
  await chrome.storage.local.set({ visits: [] });
  statusEl.textContent = 'Saved visits deleted from this extension.';
  await refresh();
});

refresh();
