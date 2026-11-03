# Reelway Browser: ASO research and localized metadata (draft for Said)

Date: 3 Nov 2026. Status: PROPOSAL ONLY. Nothing was changed in App Store Connect. Metadata goes out with the next app update, after Said approves each language.

Current English listing: name "Reelway Browser", subtitle "Browse & Play, No Pop-ups", Photo & Video. Planned name change: "Reelway: Video Browser".

## 1. Top findings

1. **People search for "browser" plus a pain or a trait, in every market.** Apple's own search suggestions (real autocomplete data) show the same pattern everywhere: "[language word for browser] + no ads / ad blocker / private / fast / video". "Pop-up blocker" itself is a weak term outside English (almost no local suggestions), while "ad blocker" and "browser without ads" are strong in nearly all markets. So the pop-up/redirect message works best as the subtitle (what the app does), and "ads / ad blocker / no ads" words should sit in keywords and where they fit in the subtitle.
2. **"Video browser" is a real, uncrowded niche in Photo & Video.** The suggestions "video browser", "private video browser", "[x]: video browser", "navegador de video", "navigateur vidéo", "動画ブラウザ", "视频浏览器", "동영상 브라우저" exist in US, UK, ES, MX, BR, FR, DE, IT, JP, KR, CN, TW, NL, IN, PH, MY. Video Lite has 174k ratings in the US, 102k in Brazil, 110k in Saudi Arabia, 15k in Mexico, so there is proven demand, and the other small players (ProTube, Morphe, Nova, Quetta, Viddle, SwizzTube) have only hundreds to a few thousand ratings. Putting "Video Browser" in the name is the single most valuable move.
3. **Ad-block browsers live in Utilities and are dominated by Brave, Opera, Firefox Focus, DuckDuckGo, Aloha** (10k to 2.4M ratings). Competing head to head for the plain term "browser" is not realistic. The long-tail phrases (video browser, browser without ads, popup blocker browser) are winnable.
4. **Cross-localization lets us index about twice the keywords in many storefronts** (section 3). The cheapest big win is adding **Spanish (Mexico)**: the US storefront also indexes it, so it adds a second 100-character keyword field for the US and Mexico at once.
5. **Competitor wording is plain and descriptive**: "Ad Block Browser: No Ads", "Halt: AdBlock Browser", "Nova: AdBlock Video Browser", "Quetta: Werbefr. Video-Browser", "ProTube: Navegador de video", "Private Video Browser". The pattern is "Brand: what it is". Our "Reelway: Video Browser" matches this and stays low profile.
6. **Do not use these words** (not in any draft): trademarks or competitor names, movies, series, dramas, reels, download, piracy, VPN (the app has none), Safari/Chrome/incognito.

## 2. Method and honesty about data limits

- **Apple search suggestions** (`MZSearchHints`, per storefront): about 180 queries across 35 storefronts. These are autocomplete suggestions, so they show what people actually type and in what order, but **not search volume**. An empty result means the phrase is rare in that store.
- **iTunes Search API** (`entity=software`, per country): top results for 21 market queries, to see who ranks and how they word names. Raw output is in the shared notes folder.
- **Not used:** Semrush (web volume does not match App Store search volume, so it would cost money for weak signal) and general web search. If Said wants real App Store volumes, a paid tool (AppTweak, Sensor Tower, Astro) is the next step; the drafts below do not depend on it.
- Translations are my drafts. Native checks are advised before submitting, especially Arabic, Hindi, Thai, Hebrew, Japanese, Korean, Vietnamese. Characters were counted by script on the final text.

### Evidence per market (Apple suggestions, in order of appearance)

| Market | What people type (suggestions) | Niche signal |
|---|---|---|
| US | "ad blocker browser", "free ad blocker browser", "popup blocker safari/chrome", "private browser", "private browser with adblock", "video browser", "private video browser", "fast browser", "no ads browser" | "block redirects" has no suggestions; "popup blocker" is a known Utilities term |
| UK | "adblock browser", "ad block browser: no ads", "popup blocker", "private browser", "video browser", "browser no restrictions" | same as US |
| Spain | "navegador sin anuncios", "navegador privado", "navegador privado de vídeos", "bloqueador de anuncios (gratis)" | "navegador de videos" no suggestion; ProTube ranks for "navegador sin anuncios" |
| Mexico | "navegador sin anuncios (adblock)", "navegador privado de videos", "navegador de videos" results show Video Lite 15k, ProTube 3k | video browser terms have results |
| Brazil | "navegador sem anúncios", "bloqueador de anúncios", "navegador bloqueador de anúncios", "navegador de vídeos privado", "quetta - navegador de vídeo" | Video Lite 102k ratings for "navegador de vídeo" |
| France | "navigateur sans pub", "bloqueur de pub (gratuit)", "navigateur privé", "navigateur vidéo privé", "tubesurf : navigateur vidéo" | "bloqueur de popup" has only 1 suggestion |
| Germany | "browser ad block", "werbeblocker browser", "privater browser: adblock", "popup blocker", video-browser suggestions (Quetta, Nova, Vela, Newn "clean video browser") | strong video-browser cluster |
| Italy | "browser senza pubblicità", "blocco pubblicità", "blocca popup", "browser privato", "browser video", "quetta: browser video senza ad" | "blocca popup" exists |
| Saudi / Egypt / UAE / Algeria | "متصفح بدون اعلانات", "حظر الاعلانات", "متصفح سريع", "متصفح خاص", "متصفح فيديو" (results: Video Lite 110k, ProTube 2k, SwizzTube) | Arabic ad-free and fast browser terms are common in all four |
| Turkey | "reklam engelleyici tarayıcı", "hızlı tarayıcı", "gizli tarayıcı" | video term has no suggestion |
| Indonesia / Malaysia | "browser anti iklan", "pemblokir iklan", "browser video" / "video browser" cluster in MY | |
| Russia / Ukraine | "браузер без рекламы", "блокировщик рекламы", "быстрый браузер", "приватный браузер", "браузер без реклами", "блокувальник реклами" | "браузер для видео" empty |
| Japan | "広告ブロック ブラウザ", "広告ブロックブラウザ", "ポップアップブロック", "動画ブラウザ", "プライベートブラウザ", "高速ブラウザ", "ブラウザ 軽い", "ブラウザ 動画" | rich: ad-block, video, light/fast |
| Korea | "광고 차단 브라우저", "팝업 차단", "동영상 브라우저", "비공개 동영상 브라우저", "프라이빗 브라우저 광고 차단" | popup blocking is a real phrase |
| Vietnam | "trình duyệt chặn quảng cáo", "chặn quảng cáo", "trình duyệt riêng tư" | |
| Thailand | "เบราว์เซอร์ส่วนตัว", "บล็อกโฆษณา" | Thai video browser app exists in suggestions in US/UK/IN/MY |
| Netherlands | "adblock browser", "popup blocker", "video browser", "privé browser: adblock" | |
| Poland | "blokada reklam"; weak otherwise | smaller demand |
| India | "ad blocker browser", "popup blockers", "private video browser", "fast browser", "super fast browser" | English dominates |
| China / Taiwan | "视频浏览器", "弹窗拦截", "广告拦截", "隐私浏览器", "极速浏览器", "影片瀏覽器", "廣告攔截" | China needs an ICP filing for most apps, Taiwan is easier |
| Sweden, Czechia, Romania, Hungary, Greece, Israel | Mostly only "reklamblockerare / adblock / בלוק פרסומות" style suggestions, few browser phrases | low priority |

### Competitor wording (iTunes Search, top results)

| Pattern | Examples | Category |
|---|---|---|
| "Brand: Video Browser" | ProTube: Video Browser, Morphe Video Browser, Nova: AdBlock Video Browser, Vela, Newn - Clean Video Browser | Photo & Video / Utilities |
| Localized video browser | ProTube: Navegador de video, Quetta - Navegador de Video, Quetta: Werbefr. Video-Browser, Quetta: Browser video senza ad, tubesurf : navigateur vidéo, Navegador Privado de Videos | Photo & Video |
| Plain ad-block browser | Ad Block Browser: No Ads, Halt: AdBlock Browser, Hush: Adblock Browser, Bare: Private Ad Block Browser, ADB Browser - Faster Web | Utilities |
| Localized "no ads" | Hush: Navegador sin anuncios, Bare: navigateur sans pub, Hush: браузер без рекламы, 블로켓 - 광고차단 브라우저 | Utilities |
| Pop-up blocker apps | Undirect - Popup Blocker, NoNag: Popup Blocker, Ad Impede: Ad & Popup Blocker | Utilities |
| Big brands (avoid competing on "browser") | Brave, Opera, Firefox Focus, DuckDuckGo, Aloha, Yandex, UC | Utilities |

Takeaways: (a) all small rivals use "Name: what it is" with the generic phrase in the name, (b) the phrase "Video Browser" in the name is how Video Lite-like apps get found, (c) "pop-up blocker" apps are small, standalone, and use the exact term "popup" with no hyphen, so our keyword field should carry "popup" in addition to "Pop-ups" in the subtitle.

## 3. Apple cross-localization indexing

Apple lets each localization add its own name, subtitle and keywords. A storefront indexes the metadata of its **primary** localization and also of some **secondary** ones. Apple does not publish the full table; the list below is what ASO practice and community tests report, so verify with a quick search test after the first release (search a unique keyword from the extra locale and see whether the app appears).

| Storefront | Also indexes (reported) |
|---|---|
| United States | English (US) + **Spanish (Mexico)** |
| Mexico | Spanish (Mexico) + English (US) |
| UK, Australia, Ireland, NZ, Singapore etc. | English (their own) + English (US) |
| Canada | English (Canada), French (Canada), also English (US) |
| Spain, France, Germany, Italy, Netherlands, Poland, Turkey, Russia, Saudi Arabia, Japan, Korea, Vietnam, Thailand, Indonesia, Brazil and most others | Their own language + English (US) |

How we use it:
1. **English (US) keywords act as a second field almost everywhere.** So local keyword fields should not repeat generic English words (they would be wasted); they should carry local-language words. A few drafts (hi, tr, ru, pl, uk) still carry "popup" or "adblock" because people in those markets often type the English word, and it only costs 5 to 7 characters. Drop them if you want max local coverage.
2. **Add Spanish (Mexico) even if Mexico is not a goal**: it feeds US Spanish speakers too. Together with Spain (es-ES) this gives three Spanish keyword fields in total.
3. **Never repeat a word across name, subtitle and keywords** of the same locale: Apple combines them into phrases, so "popup" in the keywords plus "Block" in the subtitle already covers "block popup" and "popup blocker". Plurals are matched automatically in English, so only singular forms are used.
4. Name and subtitle weigh most, keywords least. Every locale name keeps "Reelway" plus the local words for "video browser" (the term with the best proven demand).
5. The UK draft uses a different keyword set from US (favourites, tidy, quick, surf) because US keywords are already indexed there.

## 4. Recommendation: which localizations to add first

Order by (demand evidence x low competition in Photo & Video x effort):

| # | Add | Why |
|---|---|---|
| 1 | Spanish (Mexico) | Also feeds the US store, Video Lite and ProTube prove video browser demand in Spanish |
| 2 | Portuguese (Brazil) | Video Lite has 102k ratings there, "navegador sem anúncios" is a top suggestion |
| 3 | Arabic | Video Lite has 110k ratings, 4 Arab storefronts share one localization, small rivals |
| 4 | Spanish (Spain) | Same language, own keyword field, "navegador sin anuncios" is a top suggestion |
| 5 | French | "navigateur sans pub", "navigateur vidéo privé" suggestions, weak local rivals |
| 6 | German | Video-browser cluster exists, rivals have under 100 ratings |
| 7 | Russian | "браузер без рекламы" very strong, also reaches Ukraine/Kazakhstan Russian speakers |
| 8 | Japanese | Richest suggestion set (ad-block, video, fast, light) and high revenue per user |
| 9 | Turkish | "reklam engelleyici tarayıcı" strong, big iOS market |
| 10 | Italian | "blocca popup" and "browser video" exist |
| 11 | Indonesian | "browser anti iklan", large market, also helps Malaysia partly |
| 12 | Korean | "팝업 차단" and "동영상 브라우저" both exist |
| 13 | Vietnamese | "trình duyệt chặn quảng cáo" is a top suggestion |
| 14 | Thai | Video browser interest, few rivals |
| 15 | English (UK) | Cheap extra keyword field for UK, AU, IE, NZ |

Second wave if effort allows: Dutch, Polish, Traditional Chinese, Hindi, Ukrainian, Malay, Hebrew, Portuguese (Portugal), Simplified Chinese (mainland China needs a local ICP filing and has special rules, so only add it for Singapore/Malaysia reach, not for China). Not drafted, low evidence: Swedish, Czech, Romanian, Hungarian, Greek.

Compliance notes: no VPN word (the app has none), no download words, no third-party names, no dashes. The description keeps the line that the app hosts no content. English "Balanced, Strict, Off" matches the in-app settings; translated mode names should match the translated app strings if the app is localized (it currently may not be, so check this before shipping the descriptions).

## 5. Drafts per language

Counts are characters (not bytes). Limits: name 30, subtitle 30, keywords 100, promotional text 170. "OK" means within the limit. The description is a short version of the current English one (limit 4000).


### English (US) (`en-US`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Video Browser | 22/30 |
| Subtitle | Block Pop-ups & Redirects | 25/30 |
| Keywords | `popup,blocker,adblock,ads,private,clean,fast,player,tabs,bookmarks,safe,web,secure,speed,history` | 96/100 |
| Promotional text | A clean, fast browser for video sites. Reelway stops pop-ups and surprise redirects, so you decide what opens. Balanced, Strict or Off, plus allow lists. | 153/170 |

Description:

```text
Reelway is a simple browser for video websites, without the pop-ups.

• Watch videos in a clean, native player
• Choose your playback speed
• Pick up where you left off
• Pop-ups and surprise redirects are stopped, so you decide what opens
• Allow pop-ups on the sites you trust
• Balanced, Strict or Off protection
• Tabs, bookmarks, history and dark mode

Reelway does not host any content. It opens the websites you choose, like any other browser.
```

### English (UK) (`en-GB`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Video Browser | 22/30 |
| Subtitle | Stop Pop-ups & Redirects | 24/30 |
| Keywords | `adblock,ads,popup,blocker,private,tidy,quick,secure,safe,internet,surf,favourites,history,tabs` | 94/100 |
| Promotional text | A tidy, quick browser for video sites. Reelway stops pop-ups and surprise redirects, so you decide what opens. Balanced, Strict or Off, plus allow lists. | 153/170 |

Description:

```text
Reelway is a simple browser for video websites, without the pop-ups.

• Watch videos in a clean, native player
• Choose your playback speed
• Pick up where you left off
• Pop-ups and surprise redirects are stopped, so you decide what opens
• Allow pop-ups on the sites you trust
• Balanced, Strict or Off protection
• Tabs, favourites, history and dark mode

Reelway does not host any content. It opens the websites you choose, like any other browser.
```

### Spanish (Spain) (`es-ES`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Navegador de Vídeo | 27/30 |
| Subtitle | Bloquea popups y redirecciones | 30/30 |
| Keywords | `adblock,anuncios,emergentes,privado,limpio,rapido,reproductor,pestañas,marcadores,seguro,web,gratis` | 99/100 |
| Promotional text | Navega sin sorpresas. Reelway detiene las ventanas emergentes y las redirecciones para que tú decidas qué se abre, y reproduce los vídeos en un reproductor limpio. | 163/170 |

Description:

```text
Reelway es un navegador sencillo para sitios web de vídeo, sin ventanas emergentes.

• Reproduce vídeos en un reproductor limpio y nativo
• Elige la velocidad de reproducción
• Continúa donde lo dejaste
• Se bloquean las ventanas emergentes y las redirecciones inesperadas, así que tú decides qué se abre
• Permite ventanas emergentes en los sitios de confianza
• Protección Equilibrada, Estricta o Desactivada
• Pestañas, marcadores, historial y modo oscuro

Reelway no aloja ningún contenido. Abre los sitios web que tú eliges, como cualquier otro navegador.
```

### Spanish (Mexico) (`es-MX`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Navegador de Videos | 28/30 |
| Subtitle | Sin popups ni redirecciones | 27/30 |
| Keywords | `bloqueador,anuncios,emergentes,privado,rapido,limpio,reproductor,pestañas,favoritos,seguro,gratis` | 97/100 |
| Promotional text | Navega sin sorpresas. Reelway detiene las ventanas emergentes y los redireccionamientos para que tú decidas qué se abre, y reproduce los videos en un reproductor limpio. | 169/170 |

Description:

```text
Reelway es un navegador sencillo para sitios web de videos, sin ventanas emergentes.

• Reproduce videos en un reproductor limpio y nativo
• Elige la velocidad de reproducción
• Continúa donde te quedaste
• Se bloquean las ventanas emergentes y los redireccionamientos inesperados, así que tú decides qué se abre
• Permite ventanas emergentes en los sitios de confianza
• Protección Equilibrada, Estricta o Desactivada
• Pestañas, favoritos, historial y modo oscuro

Reelway no aloja ningún contenido. Abre los sitios web que tú eliges, como cualquier otro navegador.
```

### Portuguese (Brazil) (`pt-BR`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Navegador de Vídeo | 27/30 |
| Subtitle | Bloqueie pop-ups e anúncios | 27/30 |
| Keywords | `bloqueador,adblock,redirecionamento,privado,limpo,rapido,player,abas,favoritos,seguro,gratis` | 92/100 |
| Promotional text | Navegue sem surpresas. O Reelway bloqueia pop-ups e redirecionamentos para você decidir o que abre, e toca vídeos em um player limpo. | 133/170 |

Description:

```text
O Reelway é um navegador simples para sites de vídeo, sem pop-ups.

• Assista a vídeos em um player limpo e nativo
• Escolha a velocidade de reprodução
• Continue de onde parou
• Pop-ups e redirecionamentos inesperados são bloqueados, e você decide o que abre
• Permita pop-ups nos sites de confiança
• Proteção Equilibrada, Rigorosa ou Desligada
• Abas, favoritos, histórico e modo escuro

O Reelway não hospeda nenhum conteúdo. Ele abre os sites que você escolhe, como qualquer outro navegador.
```

### Portuguese (Portugal) (`pt-PT`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Navegador de Vídeo | 27/30 |
| Subtitle | Sem pop-ups nem anúncios | 24/30 |
| Keywords | `bloqueador,adblock,redirecionamentos,privado,limpo,rapido,leitor,separadores,favoritos,seguro` | 93/100 |
| Promotional text | Navegue sem surpresas. O Reelway bloqueia pop-ups e redirecionamentos para decidir o que abre, e reproduz vídeos num leitor limpo. | 130/170 |

Description:

```text
O Reelway é um navegador simples para sites de vídeo, sem pop-ups.

• Veja vídeos num leitor limpo e nativo
• Escolha a velocidade de reprodução
• Retome onde ficou
• Pop-ups e redirecionamentos inesperados são bloqueados, e decide o que abre
• Permita pop-ups nos sites de confiança
• Proteção Equilibrada, Rigorosa ou Desligada
• Separadores, favoritos, histórico e modo escuro

O Reelway não aloja nenhum conteúdo. Abre os sites que escolher, como qualquer outro navegador.
```

### French (`fr-FR`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Navigateur Vidéo | 25/30 |
| Subtitle | Sans pop-ups ni redirections | 28/30 |
| Keywords | `bloqueur,pub,adblock,publicité,privé,propre,rapide,lecteur,onglets,favoris,sécurisé,gratuit` | 91/100 |
| Promotional text | Naviguez sans mauvaise surprise. Reelway bloque les pop-ups et les redirections pour que vous décidiez de ce qui s'ouvre, avec un lecteur vidéo propre. | 151/170 |

Description:

```text
Reelway est un navigateur simple pour les sites vidéo, sans pop-ups.

• Lisez les vidéos dans un lecteur propre et natif
• Choisissez la vitesse de lecture
• Reprenez là où vous vous étiez arrêté
• Les pop-ups et redirections surprises sont bloqués, vous décidez de ce qui s'ouvre
• Autorisez les pop-ups sur les sites de confiance
• Protection Équilibrée, Stricte ou Désactivée
• Onglets, favoris, historique et mode sombre

Reelway n'héberge aucun contenu. Il ouvre les sites web que vous choisissez, comme tout autre navigateur.
```

### German (`de-DE`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Browser für Videos | 27/30 |
| Subtitle | Ohne Popups und Umleitungen | 27/30 |
| Keywords | `werbeblocker,popupblocker,werbung,adblock,privat,sauber,schnell,player,tabs,lesezeichen,sicher` | 94/100 |
| Promotional text | Surfen ohne Überraschungen. Reelway stoppt Popups und unerwünschte Weiterleitungen, damit Sie entscheiden, was sich öffnet, und spielt Videos in einem sauberen Player ab. | 170/170 |

Description:

```text
Reelway ist ein einfacher Browser für Video-Websites, ohne Popups.

• Videos in einem sauberen, nativen Player ansehen
• Wiedergabegeschwindigkeit wählen
• Dort weitermachen, wo Sie aufgehört haben
• Popups und unerwünschte Weiterleitungen werden gestoppt, Sie entscheiden, was sich öffnet
• Popups auf vertrauenswürdigen Seiten erlauben
• Schutz: Ausgewogen, Streng oder Aus
• Tabs, Lesezeichen, Verlauf und Dunkelmodus

Reelway hostet keine Inhalte. Der Browser öffnet die Websites, die Sie auswählen, wie jeder andere Browser.
```

### Italian (`it`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Browser per Video | 26/30 |
| Subtitle | Blocca popup e redirect | 23/30 |
| Keywords | `adblock,pubblicità,annunci,bloccapopup,privato,pulito,veloce,player,schede,preferiti,sicuro` | 91/100 |
| Promotional text | Naviga senza sorprese. Reelway ferma popup e reindirizzamenti indesiderati, così decidi tu cosa si apre, e riproduce i video in un player pulito. | 145/170 |

Description:

```text
Reelway è un browser semplice per i siti di video, senza popup.

• Guarda i video in un player pulito e nativo
• Scegli la velocità di riproduzione
• Riprendi da dove avevi lasciato
• Popup e reindirizzamenti a sorpresa vengono bloccati, e decidi tu cosa si apre
• Consenti i popup sui siti di cui ti fidi
• Protezione Bilanciata, Rigida o Disattivata
• Schede, preferiti, cronologia e modalità scura

Reelway non ospita alcun contenuto. Apre i siti web che scegli tu, come qualsiasi altro browser.
```

### Arabic (`ar-SA`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: متصفح فيديو | 20/30 |
| Subtitle | بدون نوافذ منبثقة وإعلانات | 26/30 |
| Keywords | `حظر,اعلانات,منع,تحويل,سريع,نظيف,خاص,مشغل,تبويبات,علامات,آمن,انترنت,مجاني,سجل` | 76/100 |
| Promotional text | تصفح بدون مفاجآت. يمنع Reelway النوافذ المنبثقة وعمليات التحويل المفاجئة لتقرر أنت ما يُفتح، ويعرض الفيديو في مشغل نظيف. | 120/170 |

Description:

```text
Reelway متصفح بسيط لمواقع الفيديو، بدون نوافذ منبثقة.

• شاهد الفيديو في مشغل نظيف وأصلي
• اختر سرعة التشغيل
• أكمل من حيث توقفت
• يتم إيقاف النوافذ المنبثقة وعمليات التحويل المفاجئة، وأنت تقرر ما يُفتح
• اسمح بالنوافذ المنبثقة في المواقع التي تثق بها
• حماية متوازنة أو صارمة أو متوقفة
• تبويبات وإشارات مرجعية وسجل ووضع داكن

لا يستضيف Reelway أي محتوى. يفتح المواقع التي تختارها، مثل أي متصفح آخر.
```

### Turkish (`tr`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Video Tarayıcı | 23/30 |
| Subtitle | Açılır Pencere Engelleyici | 26/30 |
| Keywords | `reklam,yönlendirme,adblock,gizli,hızlı,temiz,oynatıcı,sekmeler,favoriler,güvenli,ücretsiz,popup` | 95/100 |
| Promotional text | Sürprizsiz gezinin. Reelway açılır pencereleri ve ani yönlendirmeleri durdurur, ne açılacağına siz karar verirsiniz. Videolar temiz bir oynatıcıda açılır. | 154/170 |

Description:

```text
Reelway, açılır pencereler olmadan video sitelerini gezmek için basit bir tarayıcıdır.

• Videoları temiz, yerel bir oynatıcıda izleyin
• Oynatma hızını seçin
• Kaldığınız yerden devam edin
• Açılır pencereler ve ani yönlendirmeler durdurulur, ne açılacağına siz karar verirsiniz
• Güvendiğiniz sitelerde açılır pencerelere izin verin
• Dengeli, Sıkı veya Kapalı koruma
• Sekmeler, yer imleri, geçmiş ve karanlık mod

Reelway hiçbir içerik barındırmaz. Diğer tarayıcılar gibi sizin seçtiğiniz siteleri açar.
```

### Indonesian (`id`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Browser Video | 22/30 |
| Subtitle | Blokir Popup dan Redirect | 25/30 |
| Keywords | `iklan,anti,adblock,pemblokir,privat,bersih,cepat,pemutar,tab,bookmark,aman,gratis` | 81/100 |
| Promotional text | Berselancar tanpa kejutan. Reelway menghentikan popup dan redirect mendadak, jadi Anda yang memutuskan apa yang terbuka, dengan pemutar video yang bersih. | 154/170 |

Description:

```text
Reelway adalah browser sederhana untuk situs video, tanpa popup.

• Tonton video di pemutar bawaan yang bersih
• Pilih kecepatan pemutaran
• Lanjutkan dari terakhir ditonton
• Popup dan redirect mendadak dihentikan, Anda yang memutuskan apa yang terbuka
• Izinkan popup di situs yang Anda percaya
• Perlindungan Seimbang, Ketat, atau Mati
• Tab, bookmark, riwayat, dan mode gelap

Reelway tidak menyimpan konten apa pun. Aplikasi ini membuka situs yang Anda pilih, seperti browser lainnya.
```

### Russian (`ru`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Видео Браузер | 22/30 |
| Subtitle | Без всплывающих окон | 20/30 |
| Keywords | `реклама,блокировщик,adblock,перенаправление,приватный,чистый,быстрый,плеер,вкладки,закладки` | 91/100 |
| Promotional text | Серфинг без сюрпризов. Reelway блокирует всплывающие окна и внезапные перенаправления, чтобы вы сами решали, что открывать, а видео играет в чистом плеере. | 155/170 |

Description:

```text
Reelway это простой браузер для сайтов с видео, без всплывающих окон.

• Смотрите видео в чистом встроенном плеере
• Выбирайте скорость воспроизведения
• Продолжайте с того места, где остановились
• Всплывающие окна и внезапные перенаправления блокируются, вы решаете, что открывать
• Разрешайте всплывающие окна на надежных сайтах
• Защита: Баланс, Строгая или Выкл.
• Вкладки, закладки, история и тёмная тема

Reelway не хранит никакой контент. Он открывает сайты, которые выбираете вы, как любой другой браузер.
```

### Japanese (`ja`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: 動画ブラウザ | 15/30 |
| Subtitle | ポップアップ広告をブロック | 13/30 |
| Keywords | `広告ブロック,リダイレクト,転送,プライベート,高速,クリーン,プレイヤー,タブ,ブックマーク,安全,ウェブ,無料,履歴,ダークモード` | 67/100 |
| Promotional text | 驚きのないブラウジングを。Reelwayはポップアップや突然のリダイレクトを止め、何を開くかをあなたが決められます。動画はすっきりしたプレイヤーで再生。 | 76/170 |

Description:

```text
Reelwayは、ポップアップのない動画サイト向けのシンプルなブラウザです。

• すっきりしたネイティブプレイヤーで動画を再生
• 再生速度を選択
• 続きから再生
• ポップアップや突然のリダイレクトを止めて、開くものを自分で決められます
• 信頼できるサイトではポップアップを許可
• 保護モードは「標準」「厳格」「オフ」
• タブ、ブックマーク、履歴、ダークモード

Reelwayはコンテンツを一切ホストしません。他のブラウザと同じく、あなたが選んだウェブサイトを開きます。
```

### Korean (`ko`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: 동영상 브라우저 | 17/30 |
| Subtitle | 팝업과 리디렉션 차단 | 11/30 |
| Keywords | `광고차단,광고,프라이빗,빠른,깔끔,플레이어,탭,북마크,안전,웹,무료,기록,다크모드,인터넷` | 49/100 |
| Promotional text | 놀랄 일 없는 브라우징. Reelway는 팝업과 갑작스러운 리디렉션을 막아 열 페이지를 직접 정하게 하고, 동영상은 깔끔한 플레이어로 재생합니다. | 81/170 |

Description:

```text
Reelway는 팝업 없이 동영상 사이트를 이용할 수 있는 간단한 브라우저입니다.

• 깔끔한 기본 플레이어로 동영상 재생
• 재생 속도 선택
• 이어서 보기
• 팝업과 갑작스러운 리디렉션을 막아 열리는 페이지를 직접 결정
• 신뢰하는 사이트에서는 팝업 허용
• 표준, 엄격, 끔 보호 모드
• 탭, 북마크, 방문 기록, 다크 모드

Reelway는 어떤 콘텐츠도 호스팅하지 않습니다. 다른 브라우저처럼 사용자가 선택한 웹사이트를 엽니다.
```

### Vietnamese (`vi`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Trình Duyệt Video | 26/30 |
| Subtitle | Chặn Popup và Chuyển Hướng | 26/30 |
| Keywords | `quảng,cáo,adblock,riêng,tư,nhanh,sạch,phát,tab,dấu,trang,an,toàn,web,miễn,phí,lịch,sử` | 85/100 |
| Promotional text | Duyệt web không bất ngờ. Reelway ngăn popup và chuyển hướng đột ngột để bạn quyết định điều gì được mở, và phát video trong trình phát gọn gàng. | 144/170 |

Description:

```text
Reelway là trình duyệt đơn giản cho các trang video, không có popup.

• Xem video trong trình phát gọn gàng, tích hợp sẵn
• Chọn tốc độ phát
• Xem tiếp từ chỗ đã dừng
• Popup và chuyển hướng đột ngột bị chặn, bạn quyết định điều gì được mở
• Cho phép popup trên các trang bạn tin cậy
• Bảo vệ Cân bằng, Nghiêm ngặt hoặc Tắt
• Tab, dấu trang, lịch sử và chế độ tối

Reelway không lưu trữ bất kỳ nội dung nào. Ứng dụng mở các trang web do bạn chọn, như mọi trình duyệt khác.
```

### Thai (`th`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: เบราว์เซอร์วิดีโอ | 26/30 |
| Subtitle | บล็อกป๊อปอัปและรีไดเร็กต์ | 25/30 |
| Keywords | `โฆษณา,บล็อกโฆษณา,ส่วนตัว,เร็ว,สะอาด,เครื่องเล่น,แท็บ,บุ๊กมาร์ก,ปลอดภัย,เว็บ,ฟรี,ประวัติ,อินเทอร์เน็ต` | 100/100 |
| Promotional text | เล่นเว็บแบบไม่มีเซอร์ไพรส์ Reelway หยุดป๊อปอัปและการรีไดเร็กต์กะทันหัน คุณเลือกเองว่าจะเปิดอะไร และเล่นวิดีโอในเครื่องเล่นที่สะอาด | 130/170 |

Description:

```text
Reelway เป็นเบราว์เซอร์ที่เรียบง่ายสำหรับเว็บไซต์วิดีโอ ไม่มีป๊อปอัป

• ดูวิดีโอในเครื่องเล่นที่สะอาดและเป็นของแอปเอง
• เลือกความเร็วในการเล่น
• เล่นต่อจากที่ค้างไว้
• ป๊อปอัปและรีไดเร็กต์กะทันหันถูกหยุด คุณเลือกเองว่าจะเปิดอะไร
• อนุญาตป๊อปอัปบนเว็บไซต์ที่คุณไว้ใจ
• การป้องกันแบบสมดุล เข้มงวด หรือปิด
• แท็บ บุ๊กมาร์ก ประวัติ และโหมดมืด

Reelway ไม่ได้โฮสต์เนื้อหาใด ๆ แต่จะเปิดเว็บไซต์ที่คุณเลือก เหมือนเบราว์เซอร์ทั่วไป
```

### Dutch (`nl`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Videobrowser | 21/30 |
| Subtitle | Geen popups of omleidingen | 26/30 |
| Keywords | `adblock,advertenties,adblocker,privé,schoon,snel,speler,tabbladen,bladwijzers,veilig,gratis` | 91/100 |
| Promotional text | Surfen zonder verrassingen. Reelway stopt popups en onverwachte omleidingen, zodat jij bepaalt wat opent, en speelt video af in een schone speler. | 146/170 |

Description:

```text
Reelway is een eenvoudige browser voor videosites, zonder popups.

• Bekijk video's in een schone, eigen speler
• Kies je afspeelsnelheid
• Ga verder waar je gebleven was
• Popups en onverwachte omleidingen worden gestopt, jij bepaalt wat opent
• Sta popups toe op sites die je vertrouwt
• Bescherming: Gebalanceerd, Streng of Uit
• Tabbladen, bladwijzers, geschiedenis en donkere modus

Reelway host geen content. De app opent de websites die jij kiest, zoals elke andere browser.
```

### Polish (`pl`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Przeglądarka Wideo | 27/30 |
| Subtitle | Bez wyskakujących okien | 23/30 |
| Keywords | `reklamy,blokada,adblock,przekierowania,prywatna,czysta,szybka,odtwarzacz,karty,zakładki` | 87/100 |
| Promotional text | Przeglądaj bez niespodzianek. Reelway zatrzymuje wyskakujące okna i nagłe przekierowania, więc to Ty decydujesz, co się otworzy, a wideo gra w czystym odtwarzaczu. | 163/170 |

Description:

```text
Reelway to prosta przeglądarka do stron z wideo, bez wyskakujących okien.

• Oglądaj wideo w czystym, własnym odtwarzaczu
• Wybierz prędkość odtwarzania
• Wznów od miejsca, w którym skończyłeś
• Wyskakujące okna i nagłe przekierowania są blokowane, a Ty decydujesz, co się otworzy
• Zezwalaj na wyskakujące okna na zaufanych stronach
• Ochrona: Zrównoważona, Ścisła lub Wyłączona
• Karty, zakładki, historia i tryb ciemny

Reelway nie przechowuje żadnych treści. Otwiera strony, które wybierasz, jak każda inna przeglądarka.
```

### Hindi (`hi`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: वीडियो ब्राउज़र | 24/30 |
| Subtitle | पॉप-अप और रीडायरेक्ट बंद | 24/30 |
| Keywords | `विज्ञापन,ऐडब्लॉक,प्राइवेट,तेज़,क्लीन,प्लेयर,टैब,बुकमार्क,सुरक्षित,वेब,मुफ़्त,popup,adblock` | 90/100 |
| Promotional text | बिना झंझट के ब्राउज़ करें। Reelway पॉप-अप और अचानक होने वाले रीडायरेक्ट रोकता है, ताकि आप तय करें कि क्या खुले, और वीडियो साफ़ प्लेयर में चलते हैं। | 147/170 |

Description:

```text
Reelway वीडियो वेबसाइटों के लिए एक सरल ब्राउज़र है, बिना पॉप-अप के।

• साफ़ और नेटिव प्लेयर में वीडियो देखें
• प्लेबैक स्पीड चुनें
• जहाँ छोड़ा था वहीं से शुरू करें
• पॉप-अप और अचानक रीडायरेक्ट रोके जाते हैं, आप तय करते हैं कि क्या खुले
• भरोसेमंद साइटों पर पॉप-अप की अनुमति दें
• संतुलित, सख़्त या बंद सुरक्षा
• टैब, बुकमार्क, हिस्ट्री और डार्क मोड

Reelway कोई कंटेंट होस्ट नहीं करता। यह आपकी चुनी हुई वेबसाइटें खोलता है, किसी भी अन्य ब्राउज़र की तरह।
```

### Chinese (Simplified) (`zh-Hans`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: 视频浏览器 | 14/30 |
| Subtitle | 拦截弹窗和跳转 | 7/30 |
| Keywords | `广告拦截,去广告,隐私,极速,纯净,播放器,标签页,书签,安全,网页,免费,历史,深色模式` | 45/100 |
| Promotional text | 浏览不再有意外。Reelway 拦截弹窗和突然跳转，让你决定打开什么，视频在简洁的播放器中播放。 | 48/170 |

Description:

```text
Reelway 是一款适合视频网站的简洁浏览器，没有弹窗。

• 在简洁的原生播放器中播放视频
• 选择播放速度
• 从上次中断的地方继续
• 拦截弹窗和突然跳转，由你决定打开什么
• 在信任的网站上允许弹窗
• 均衡、严格或关闭三种保护模式
• 标签页、书签、历史记录和深色模式

Reelway 不托管任何内容，它和其他浏览器一样，只打开你选择的网站。
```

### Chinese (Traditional) (`zh-Hant`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: 影片瀏覽器 | 14/30 |
| Subtitle | 阻擋彈出視窗與跳轉 | 9/30 |
| Keywords | `廣告攔截,去廣告,隱私,極速,乾淨,播放器,分頁,書籤,安全,網頁,免費,歷史,深色模式` | 44/100 |
| Promotional text | 瀏覽不再有意外。Reelway 阻擋彈出視窗和突然跳轉，讓你決定開啟什麼，影片在簡潔的播放器中播放。 | 50/170 |

Description:

```text
Reelway 是一款適合影片網站的簡潔瀏覽器，沒有彈出視窗。

• 在簡潔的原生播放器中播放影片
• 選擇播放速度
• 從上次中斷的地方繼續
• 阻擋彈出視窗和突然跳轉，由你決定開啟什麼
• 在信任的網站上允許彈出視窗
• 平衡、嚴格或關閉三種保護模式
• 分頁、書籤、歷史記錄和深色模式

Reelway 不託管任何內容，它和其他瀏覽器一樣，只開啟你選擇的網站。
```

### Ukrainian (`uk`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Відео Браузер | 22/30 |
| Subtitle | Без спливаючих вікон | 20/30 |
| Keywords | `реклама,блокувальник,adblock,перенаправлення,приватний,чистий,швидкий,плеєр,вкладки,закладки` | 92/100 |
| Promotional text | Перегляд без сюрпризів. Reelway блокує спливаючі вікна й раптові перенаправлення, щоб ви самі вирішували, що відкривати, а відео грає в чистому плеєрі. | 151/170 |

Description:

```text
Reelway це простий браузер для сайтів з відео, без спливаючих вікон.

• Дивіться відео в чистому вбудованому плеєрі
• Обирайте швидкість відтворення
• Продовжуйте з того місця, де зупинилися
• Спливаючі вікна й раптові перенаправлення блокуються, ви вирішуєте, що відкривати
• Дозволяйте спливаючі вікна на надійних сайтах
• Захист: Збалансований, Суворий або Вимкнено
• Вкладки, закладки, історія й темна тема

Reelway не зберігає жодного вмісту. Він відкриває сайти, які обираєте ви, як будь-який інший браузер.
```

### Hebrew (`he`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: דפדפן וידאו | 20/30 |
| Subtitle | חוסם חלונות קופצים | 18/30 |
| Keywords | `פרסומות,אדבלוק,הפניות,פרטי,נקי,מהיר,נגן,כרטיסיות,סימניות,בטוח,אינטרנט,חינם,היסטוריה` | 83/100 |
| Promotional text | גלישה בלי הפתעות. Reelway עוצר חלונות קופצים והפניות פתאומיות, כדי שאתם תחליטו מה ייפתח, והסרטונים מתנגנים בנגן נקי. | 116/170 |

Description:

```text
Reelway הוא דפדפן פשוט לאתרי וידאו, בלי חלונות קופצים.

• צפו בסרטונים בנגן נקי ומובנה
• בחרו את מהירות ההפעלה
• המשיכו מהמקום שבו עצרתם
• חלונות קופצים והפניות פתאומיות נעצרים, ואתם מחליטים מה ייפתח
• אפשרו חלונות קופצים באתרים שאתם סומכים עליהם
• הגנה מאוזנת, קפדנית או כבויה
• כרטיסיות, סימניות, היסטוריה ומצב כהה

Reelway אינו מארח תוכן כלשהו. הוא פותח את האתרים שאתם בוחרים, כמו כל דפדפן אחר.
```

### Malay (`ms`)

| Field | Text | Count |
|---|---|---|
| Name | Reelway: Pelayar Video | 22/30 |
| Subtitle | Sekat Popup dan Ubah Hala | 25/30 |
| Keywords | `iklan,adblock,browser,peribadi,bersih,pantas,pemain,tab,penanda,selamat,web,internet,percuma,sejarah` | 100/100 |
| Promotional text | Layari web tanpa kejutan. Reelway menghentikan popup dan ubah hala mengejut supaya anda yang tentukan apa yang dibuka, dengan pemain video yang bersih. | 151/170 |

Description:

```text
Reelway ialah pelayar ringkas untuk laman web video, tanpa popup.

• Tonton video dalam pemain asli yang bersih
• Pilih kelajuan main
• Sambung dari tempat anda berhenti
• Popup dan ubah hala mengejut dihentikan, anda yang tentukan apa yang dibuka
• Benarkan popup di laman yang anda percayai
• Perlindungan Seimbang, Ketat atau Mati
• Tab, penanda, sejarah dan mod gelap

Reelway tidak menyimpan sebarang kandungan. Ia membuka laman web pilihan anda, seperti pelayar lain.
```
