// Taps title cards on the site like a user, with the app's tap recorder
// injected, and logs every pop-up / main-page jump plus what was tapped.
import { chromium, devices } from 'playwright';
import fs from 'node:fs';

const target = process.argv[2];
const out = 'probe-out';
fs.mkdirSync(out, { recursive: true });
const host = new URL(target).hostname;
const recorder = `(function(){if(window.__rwTap)return;window.__rwTap={href:null,t:0};function rec(e){var el=e.target,a=el&&el.closest?el.closest('a[href]'):null;window.__rwTap={href:a?a.href:'',t:Date.now()};}window.addEventListener('pointerdown',rec,true);window.addEventListener('click',rec,true);})();`;

const browser = await chromium.launch();
const ctx = await browser.newContext({ ...devices['Pixel 7'] });
await ctx.addInitScript(recorder);
const page = await ctx.newPage();
const events = [];
let lastTap = null;
ctx.on('page', async p => {
  await p.waitForLoadState('domcontentloaded').catch(() => {});
  events.push({ kind: 'popup', url: p.url(), tap: lastTap });
  await p.screenshot({ path: `${out}/popup-${events.length}.png` }).catch(() => {});
  await p.close().catch(() => {});
});
page.on('framenavigated', f => {
  if (f === page.mainFrame()) events.push({ kind: 'main', url: f.url(), tap: lastTap });
});

await page.goto(target, { waitUntil: 'domcontentloaded', timeout: 45000 });
await page.waitForTimeout(7000);

const report = { taps: [] };
for (let i = 0; i < 3; i++) {
  await page.goto(target, { waitUntil: 'domcontentloaded', timeout: 45000 }).catch(() => {});
  await page.waitForTimeout(5000);
  // Title cards: clickable elements that contain a poster image.
  const cards = await page.$$('a:has(img), [onclick]:has(img), div[class*="card"]:has(img)');
  const card = cards[i];
  if (!card) { report.taps.push({ i, note: 'no card found', count: cards.length }); continue; }
  const info = await card.evaluate(el => ({
    tag: el.tagName, href: el.closest('a') ? el.closest('a').href : null,
    text: (el.innerText || '').trim().slice(0, 60), cls: el.className && String(el.className).slice(0, 80),
  }));
  const before = events.length;
  await card.scrollIntoViewIfNeeded().catch(() => {});
  const box = await card.boundingBox();
  if (box) await page.mouse.click(box.x + box.width / 2, box.y + box.height / 2);
  lastTap = await page.evaluate(() => window.__rwTap).catch(() => null);
  await page.waitForTimeout(6000);
  report.taps.push({ i, card: info, recordedTap: lastTap, landedOn: page.url(), events: events.slice(before) });
  await page.screenshot({ path: `${out}/tap-${i + 1}.png` });
  if (page.url().includes(host) && page.url() !== target) fs.writeFileSync(`${out}/title-${i + 1}.html`, await page.content());
}
report.allEvents = events;
fs.writeFileSync(`${out}/report.json`, JSON.stringify(report, null, 2));
console.log(JSON.stringify(report, null, 2));
await browser.close();
