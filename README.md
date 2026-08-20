# FoodHub v0.6

Flutter prototype with four roles: Customer, Merchant, Driver, and Admin.

## Build locally

```bash
flutter pub get
flutter analyze
flutter build apk --release
```

## GitHub Actions

Push this repository to GitHub on the `main` branch. The workflow creates the Android platform files when needed, installs dependencies, runs analysis, builds the release APK, and uploads the APK as a workflow artifact.
