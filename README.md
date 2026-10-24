# CmrSchoolAI

Application Flutter éducative IA pour tous les niveaux scolaires camerounais, de la maternelle à l'université.

## Démarrage

```bash
flutter pub get
flutter run
```

Le premier écran permet de sélectionner le niveau afin d'adapter le vocabulaire, le programme et la difficulté. Les builds APK et IPA sont produits par GitHub Actions dans le workflow `build.yml`.

## Structure

- `lib/core` : thème, niveaux et sécurité
- `lib/data` : services et stockage chiffré
- `lib/features` : onboarding, tuteur, scan, examens, bibliothèque et progression
- `.github/workflows/build.yml` : artefacts Android et iOS
