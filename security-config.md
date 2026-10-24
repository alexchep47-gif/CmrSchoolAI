# Configuration mobile à appliquer lors de la génération Flutter

- Android : `usesCleartextTraffic=false`, `allowBackup=false`, permissions caméra et images uniquement à la demande.
- iOS : `NSCameraUsageDescription` et `NSPhotoLibraryUsageDescription` en français dans `Info.plist`; ATS activé.
- Release : obfuscation et symboles séparés via le workflow GitHub Actions.
- Les clés d'API ne doivent jamais être écrites dans le code : fournir uniquement via `--dart-define`.

La machine v0 ne possède pas le SDK Flutter; le workflow CI est donc la source de compilation reproductible pour APK et IPA.
