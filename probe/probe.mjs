// Loads a site in a phone-sized Chromium (same engine as Android WebView)
// and records what our browser would face: final URL, framing headers,
// verification pages, pop-ups, redirects and third-party hosts.
import { chromium, devices } from 'playwright';
import fs from 'node:fs';

const target = process.argv[2];
const out = 'probe-out';
fs.mkdirSync(out, { recursive: true });
const report = { target, navigations: [], popups: [], hosts: {}, mainResponse: null };

const browser = await chromium.launch();
const ctx = await browser.newContext({ ...devices['Pixel 7'] });
const page = await ctx.newPage();
const targetHost = new URL(target).hostname;

ctx.on('page', p => report.popups.push({ url: p.url(), at: Date.now() }));
page.on('framenavigated', f => { if (f === page.mainFrame()) report.navigations.push(f.url()); });
page.on('request', r => { try { const h = new URL(r.url()).hostname; report.hosts[h] = (report.hosts[h] || 0) + 1; } catch {} });

try {
  const resp = await page.goto(target, { waitUntil: 'domcontentloaded', timeout: 45000 });
  const h = resp ? await resp.allHeaders() : {};
  report.mainResponse = {
    status: resp?.status(), url: resp?.url(),
    server: h['server'], xFrameOptions: h['x-frame-options'], csp: h['content-security-policy'],
    cfRay: h['cf-ray'], cfMitigated: h['cf-mitigated'],
  };
} catch (e) { report.loadError = String(e); }

await page.waitForTimeout(8000);
await page.screenshot({ path: `${out}/1-home.png` });
fs.writeFileSync(`${out}/home.html`, await page.content());
report.title = await page.title();
report.urlAfterLoad = page.url();
report.challenge = /just a moment|checking your browser|cf-challenge|captcha/i.test(await page.content());

// Simulate a user's first tap (popunder scripts usually fire here).
await page.mouse.click(200, 400).catch(() => {});
await page.waitForTimeout(5000);
report.urlAfterTap = page.url();
await page.screenshot({ path: `${out}/2-after-tap.png` });

// Open the first internal link that looks like a title/series page.
await page.goto(target, { waitUntil: 'domcontentloaded', timeout: 45000 }).catch(() => {});
await page.waitForTimeout(4000);
const links = await page.$$eval('a[href]', as => as.map(a => ({ href: a.href, text: (a.textContent || '').trim().slice(0, 80) })));
report.sampleLinks = links.filter(l => l.href.includes(targetHost)).slice(0, 60);
const detail = report.sampleLinks.find(l => /series|drama|movie|watch|episode|\d{2,}/i.test(l.href) && l.href !== target);
if (detail) {
  report.detailUrl = detail.href;
  await page.goto(detail.href, { waitUntil: 'domcontentloaded', timeout: 45000 }).catch(e => { report.detailError = String(e); });
  await page.waitForTimeout(6000);
  await page.screenshot({ path: `${out}/3-detail.png`, fullPage: false });
  fs.writeFileSync(`${out}/detail.html`, await page.content());
  report.detailIframes = await page.$$eval('iframe', fs => fs.map(f => f.src));
  report.detailVideos = await page.$$eval('video, source', vs => vs.map(v => v.src || v.currentSrc));
}

report.popupCount = report.popups.length;
report.topHosts = Object.entries(report.hosts).sort((a, b) => b[1] - a[1]).slice(0, 40);
delete report.hosts;
fs.writeFileSync(`${out}/report.json`, JSON.stringify(report, null, 2));
console.log(JSON.stringify(report, null, 2));
await browser.close();
