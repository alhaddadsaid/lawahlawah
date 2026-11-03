# Push notifications: what Said does once

The code is ready. Push starts working after these steps, in a new app version (iPhone and
Android). Nothing here touches the versions now in review. Do not paste passwords or key
files into chat; Claude only needs the four public IDs in step 3.

## 1. Firebase project (Chrome)
1. Open https://console.firebase.google.com and sign in with your Google account.
2. Click **Create a project**, name it **Reelway**. Turn Google Analytics off. Click **Create project**.
3. On the project home click the **iOS+** icon (Add app). Apple bundle ID: `com.reelway.reelway`. Nickname: Reelway iPhone. Click **Register app**, then skip the other steps (**Next**, **Next**, **Continue to console**). Do not add any files.
4. Click **Add app** again, choose **Android**. Package name: `com.reelbrow.videobrowser`. Nickname: Reelway Android. Click **Register app** and skip the rest.
5. Optional, only if you want push in the ReelBro test build: add one more iOS app `com.reelway.reelbro`.

## 2. The four public IDs
Open the gear icon, **Project settings**, **General**, scroll to **Your apps**. For the iPhone app and the Android app copy: **App ID**, and from the top of the page **Project ID**, **Web API Key**, and under **Cloud Messaging** the **Sender ID**. Tell Claude these (they are not secrets). Claude puts them into `lib/push/firebase_options.dart`.
Alternative: click **GoogleService-Info.plist** (iPhone app) and **google-services.json** (Android app) download, and tell Claude where they are saved. Claude reads the values from them.

## 3. Apple push key (Apple Developer, you only)
1. Open https://developer.apple.com/account, **Certificates, Identifiers & Profiles**, **Identifiers**. Click `com.reelway.reelway`. Tick **Push Notifications**. Click **Save** (confirm). This makes Codemagic create a new provisioning profile with push on its next release build.
2. Left menu **Keys**, the blue **+**. Name: `Reelway APNs`. Tick **Apple Push Notifications service (APNs)**. **Continue**, **Register**.
3. Click **Download**. Apple lets you download the `.p8` only once. Keep it safe. Write down the **Key ID** (shown on the page) and your **Team ID** (top right under your name, or Membership details).
4. In Firebase: gear icon, **Project settings**, **Cloud Messaging** tab, section **Apple app configuration**, your iPhone app, **APNs authentication key**, **Upload**. Choose the `.p8`, type the **Key ID** and **Team ID**, click **Upload**.
Do not reuse your older `.p8`; make this new key.

## 4. Server key (Firebase, then Terminal, you only)
1. Firebase: gear icon, **Project settings**, **Service accounts** tab, click **Generate new private key**, **Generate key**. A `.json` file downloads (for example `reelway-firebase-adminsdk-xxxx.json`).
2. In Terminal on your Mac run, with the real file name:
```bash
scp -i ~/.ssh/rephotel_deploy ~/Downloads/reelway-firebase-adminsdk-xxxx.json root@157.180.27.86:/tmp/fcm.json
```
```bash
ssh -i ~/.ssh/rephotel_deploy root@157.180.27.86 "mkdir -p /etc/reelway && mv /tmp/fcm.json /etc/reelway/fcm-service-account.json && chown -R root:www-data /etc/reelway && chmod 750 /etc/reelway && chmod 640 /etc/reelway/fcm-service-account.json"
```
3. Delete the `.json` from your Downloads yourself. The key lives only in `/etc/reelway`, outside the website folder and outside git.
4. Open the admin. The "Send a push notification" section now shows its form instead of "not set up".

## 5. Testing
Push needs a real phone and a build that contains this code (the next release on each store; for the iPhone a TestFlight build). Install it, open the app three times, answer **Yes** to "Get news from Reelway?" and allow notifications. Then in the admin save a test announcement for that store and send the push. You should get the notification, and tapping it opens the announcement page. Try the other targets too (website, Settings, Pop-up protection).
Nothing is sent unless you press the send button and tick "Yes, send it now".
