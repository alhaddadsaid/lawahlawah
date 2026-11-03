# App Store metadata (DRAFT, not uploaded)

One folder per App Store Connect locale, in fastlane `deliver` format. Source and research: `docs/ASO_RESEARCH.md`.

Nothing here has been uploaded. Metadata (except promotional text) can only be changed on an editable app version, so upload after 1.0 is approved and version 1.1 exists.

Delete the folder of any language Said does not approve. Upload with an App Store Connect API key:

    fastlane deliver --api_key_path <key.json> --metadata_path ios/fastlane/metadata --skip_binary_upload --skip_screenshots --force

(The key json holds key_id, issuer_id and the .p8 contents. Keep it outside the repo.)
