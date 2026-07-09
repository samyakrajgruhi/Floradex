# FloraDex

FloraDex is a gamified Flutter plant recognition app. It lets users scan or upload plant photos, identify the species with the PlantNet API, generate structured botanical details with Gemini through LangChain, and save discoveries into a local Hive-powered plant vault.

The app is styled around an 8-bit botanical field-device concept: sharp corners, pixel-like blocks, strong botanical colors, rank progression, and a collectible "Pokedex for plants" experience.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screens](#screens)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Data Flow](#data-flow)
- [Local Data Model](#local-data-model)
- [Rank System](#rank-system)
- [Environment Variables](#environment-variables)
- [Getting Started](#getting-started)
- [Common Commands](#common-commands)
- [Assets](#assets)
- [Testing](#testing)
- [Design System](#design-system)
- [Current Notes](#current-notes)

## Overview

FloraDex combines plant recognition, AI-generated plant facts, local persistence, and user progression into a mobile-first Flutter app.

Core workflow:

1. The user opens the scanner.
2. The user captures a photo or chooses one from the gallery.
3. The image is sent to PlantNet for plant identification.
4. The best scientific name is sent to Gemini.
5. Gemini returns a strict JSON object with display-ready plant details.
6. The app opens a botanical dossier screen.
7. The user can save the discovery to the Hive vault.
8. Saving a new plant increments user progress and contributes to rank progression.

## Features

- Plant image scanning with the device camera.
- Gallery image selection through `image_picker`.
- Plant species identification through the PlantNet API.
- AI-generated botanical details through Gemini using LangChain.
- Botanical dossier view with image, name, scientific name, rarity, environment, medical uses, edibility, taste, harvest season, growth time, origin, and quick facts.
- Local plant vault backed by Hive.
- Duplicate prevention using the scientific name as a stable plant key.
- Recent discoveries on the dashboard.
- Fuzzy search in the botanical vault.
- User profile with progress, rank, achievements UI, and field operation actions.
- Rank timeline driven by `assets/ranks.json`.
- Vault reset support from the profile and debug screen.
- 8-bit botanical design system implemented in `AppTheme`.

## Screens

The main app uses a bottom navigation shell with three primary tabs:

- `HOME` - dashboard with current rank, progress, recent discoveries, facts, and stats.
- `SCAN` - camera scanner and gallery picker.
- `VAULT` - searchable saved plant collection.

Additional screens:

- Botanical Dossier - detailed plant result screen shown after scanning and when viewing saved plants.
- Researcher Profile - user profile, progress, achievements, and operations.
- Debug Vault Screen - long-press profile icon shortcut for vault debugging.
- Rank Timeline - dialog for viewing rank progression.

UI reference screenshots are stored in `ui_images/`:

```text
ui_images/
├── Botanical Vault.png
├── Dashboard.png
├── Main.png
├── Plant Scanner.png
└── Researcher Profile.png
```

## Tech Stack

### Framework

- Flutter
- Dart
- Material 3

### Local Storage

- Hive
- Hive Flutter
- Path Provider

### Camera and Images

- Camera
- Image Picker

### Networking and API

- HTTP
- Flutter Dotenv
- PlantNet API

### AI and LLM Integration

- LangChain
- LangChain Google
- Google AI Dart
- LangChain OpenAI
- LangChain Ollama

### UI and Formatting

- Google Fonts
- Intl

### Development

- Flutter Lints
- Hive Generator
- Build Runner

## Project Structure

```text
Floradex/
├── README.md
├── DESIGN.md
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── .env
├── assets/
│   ├── ranks.json
│   └── icons/
│       ├── wild_seed.png
│       ├── sprout_seeker.png
│       ├── seedling.png
│       ├── sapling.png
│       ├── forager.png
│       ├── wildflower_scout.png
│       ├── naturalist.png
│       ├── botanist.png
│       ├── field_researcher.png
│       ├── flora_specialist.png
│       ├── forest_warden.png
│       ├── master_botanist.png
│       ├── botanical_sage.png
│       └── floradex_legend.png
├── lib/
│   ├── main.dart
│   ├── assets/
│   │   └── ranks.json
│   ├── models/
│   │   ├── plant_record.dart
│   │   ├── plant_record.g.dart
│   │   ├── user_info.dart
│   │   └── user_info.g.dart
│   ├── screens/
│   │   ├── botanical_dossier.dart
│   │   ├── botanical_vault.dart
│   │   ├── dashboard.dart
│   │   ├── debug_vault_screen.dart
│   │   ├── researcher_profile.dart
│   │   └── scanner.dart
│   ├── services/
│   │   ├── botanical_fact_service.dart
│   │   ├── database_service.dart
│   │   ├── plant_info.dart
│   │   ├── rank_service.dart
│   │   └── user_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       └── rank_timeline.dart
├── test/
│   └── widget_test.dart
├── ui_images/
│   ├── Botanical Vault.png
│   ├── Dashboard.png
│   ├── Main.png
│   ├── Plant Scanner.png
│   └── Researcher Profile.png
├── android/
├── ios/
├── linux/
├── macos/
├── web/
└── windows/
```

## Architecture

FloraDex uses a simple Flutter structure organized by responsibility.

### Entry Point

`lib/main.dart`

- Initializes Flutter bindings.
- Initializes Hive.
- Registers Hive adapters.
- Opens the `plants_vault` box.
- Bootstraps the current user in the `user_data` box.
- Loads `.env`.
- Starts `FloraDexApp`.
- Defines the main bottom-navigation shell.

### Models

`lib/models/plant_record.dart`

Represents a saved plant discovery in Hive.

`lib/models/user_info.dart`

Represents the local user profile and progress state.

Generated Hive adapters:

- `plant_record.g.dart`
- `user_info.g.dart`

These files are generated by `build_runner` and should be regenerated when Hive model fields or type IDs change.

### Screens

`lib/screens/dashboard.dart`

Loads user data, current rank, next rank, recent discoveries, and dashboard cards.

`lib/screens/scanner.dart`

Handles camera setup, gallery selection, photo capture, loading state, and plant analysis navigation.

`lib/screens/botanical_dossier.dart`

Displays scanned or saved plant details and handles saving a new scan to the vault.

`lib/screens/botanical_vault.dart`

Displays saved plants and provides fuzzy search by plant name.

`lib/screens/researcher_profile.dart`

Displays profile details, progress stats, achievements UI, and field operations such as vault reset.

`lib/screens/debug_vault_screen.dart`

Developer/debug screen for inspecting or clearing local vault state.

### Services

`lib/services/plant_info.dart`

- Sends image files to PlantNet through multipart upload.
- Extracts the best scientific name from PlantNet results.
- Sends that plant name to Gemini.
- Parses Gemini's response as JSON.

`lib/services/database_service.dart`

- Saves plant records to Hive.
- Copies scanned images into the application documents directory.
- Prevents duplicate vault records.
- Fetches all plants.
- Fetches recent discoveries.
- Clears the vault.

`lib/services/user_service.dart`

- Reads current user info from Hive.
- Increments user progress after new discoveries.

`lib/services/rank_service.dart`

- Loads rank definitions from `assets/ranks.json`.
- Resolves current rank by progress threshold.
- Resolves next rank.
- Calculates progress ratio toward the next rank.

`lib/services/botanical_fact_service.dart`

- Uses Gemini to generate a short daily botanical fact.

### Theme

`lib/theme/app_theme.dart`

Central app design system:

- Color tokens.
- Spacing scale.
- Typography.
- Material component themes.
- 0px radius shape rules.
- Helper widgets such as `FloraDataCard`, `FloraProgressBar`, and `FloraGhostBorder`.

### Widgets

`lib/widgets/rank_timeline.dart`

Displays rank progression using data from `RankService`.

## Data Flow

### Scan and Save Flow

```text
ScannerPage
└── captures or picks image
    └── PlantInfoService.analyzePlantImage()
        ├── sends image to PlantNet
        ├── reads best scientific match
        └── calls getPlantDetailsFromGemini()
            └── returns structured plant JSON
                └── BotanicalDossierScreen
                    └── save button
                        └── DatabaseService.savePlantToVault()
                            ├── copies image into app documents directory
                            ├── creates PlantRecord
                            ├── stores record in Hive
                            └── UserService.incrementProgress(1)
```

### App Startup Flow

```text
main()
├── WidgetsFlutterBinding.ensureInitialized()
├── Hive.initFlutter()
├── register PlantRecordAdapter
├── register UserInfoAdapter
├── open plants_vault
├── bootstrap user_data/current_user
├── dotenv.load(".env")
└── runApp(FloraDexApp)
```

## Local Data Model

### PlantRecord

Stored in Hive box: `plants_vault`

Fields:

- `id` - generated from the scientific name.
- `imagePath` - permanent local image path.
- `plantName` - common/display name.
- `scientificName` - scientific name.
- `rarity` - rarity value as text.
- `environment` - environment label.
- `medicalUses` - list of medical-use bullet points.
- `edibility` - edibility description.
- `taste` - taste description when edible.
- `harvestSeason` - harvest season when applicable.
- `growthTime` - growth or harvest duration when applicable.
- `origin` - plant origin.
- `facts` - quick facts.
- `timestamp` - save time.

### UserInfo

Stored in Hive box: `user_data`

Hive key:

- `current_user`

Fields:

- `userId`
- `userName`
- `userEmail`
- `rankName`
- `userProgress`

## Rank System

Ranks are loaded from:

```text
assets/ranks.json
```

Each rank contains:

- `id`
- `title`
- `threshold`
- `dashboardText`
- `popupText`
- `icon`

Current rank progression:

| Rank | Threshold |
| --- | ---: |
| Wild Seed | 0 |
| Sprout Seeker | 1 |
| Seedling | 3 |
| Sapling | 6 |
| Forager | 10 |
| Wildflower Scout | 15 |
| Naturalist | 22 |
| Botanist | 30 |
| Field Researcher | 40 |
| Flora Specialist | 55 |
| Forest Warden | 75 |
| Master Botanist | 100 |
| Botanical Sage | 140 |
| Floradex Legend | 200 |

Progress increases when a new plant is saved to the vault.

## Environment Variables

The project expects a `.env` file at the repository root. The file is listed as a Flutter asset in `pubspec.yaml`, so it is loaded at runtime with `flutter_dotenv`.

Required for the current scan flow:

```env
PLANTNET_API_KEY=your_plantnet_key_here
GOOGLE_API_KEY=your_google_gemini_key_here
```

Additional keys currently present or reserved in the environment:

```env
PLANT_ID_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
GROQ_API_KEY=your_key_here
```

Important:

- Do not commit real API keys.
- If `.env` is missing or `PLANTNET_API_KEY` is not set, plant identification returns `null`.
- If `GOOGLE_API_KEY` is missing, Gemini detail generation returns `null`.

## Getting Started

### Prerequisites

- Flutter SDK compatible with Dart `^3.10.7`.
- Android Studio or Xcode for mobile targets.
- A configured Android emulator, iOS simulator, or physical device.
- PlantNet API key.
- Google Gemini API key.

Check your Flutter environment:

```bash
flutter doctor
```

### Installation

Install dependencies:

```bash
flutter pub get
```

Create or update `.env`:

```env
PLANTNET_API_KEY=your_plantnet_key_here
GOOGLE_API_KEY=your_google_gemini_key_here
```

Run the app:

```bash
flutter run
```

### Platform Notes

The repository includes platform folders for:

- Android
- iOS
- Linux
- macOS
- Web
- Windows

The scanner depends on camera and image access. For best results during development, run on Android or iOS where camera behavior matches the target app experience.

## Common Commands

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

Run on a specific device:

```bash
flutter devices
flutter run -d <device-id>
```

Analyze the project:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Regenerate Hive adapters:

```bash
dart run build_runner build
```

Regenerate adapters and remove conflicting generated outputs:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Clean build artifacts:

```bash
flutter clean
flutter pub get
```

Build Android APK:

```bash
flutter build apk
```

Build web:

```bash
flutter build web
```

## Assets

Assets are registered in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - .env
    - assets/ranks.json
    - assets/icons/
```

Primary asset groups:

- `.env` - runtime API keys.
- `assets/ranks.json` - rank definitions.
- `assets/icons/` - rank icons.
- `ui_images/` - UI reference screenshots.

Note: `lib/assets/ranks.json` also exists, but the app currently loads `assets/ranks.json` through `rootBundle`.

## Testing

The project currently includes the default Flutter widget test in `test/widget_test.dart`.

Run tests with:

```bash
flutter test
```

Current test coverage is minimal. Useful future tests would include:

- Rank threshold resolution in `RankService`.
- Search ranking in `BotanicalVaultPage`.
- Duplicate prevention in `DatabaseService`.
- JSON cleanup/parsing behavior in `PlantInfoService`.
- Dashboard behavior when the vault is empty.

## Design System

The visual system is documented in:

```text
DESIGN.md
```

The implementation lives in:

```text
lib/theme/app_theme.dart
```

Design direction:

- 8-bit botanist field-device style.
- No rounded corners.
- No default Material shadows.
- Strong color blocking instead of divider lines.
- Press Start 2P for short display text.
- Manrope for readable body text.
- Space Grotesk for labels and metadata.
- Botanical greens, earthy browns, gold accents, and warm surface layers.

## Current Notes

- The user name default is currently set in code during bootstrapping.
- Plant vault records are local to the device because Hive is used for persistence.
- Saved image files are copied into the app documents directory.
- The PlantNet result is enriched by Gemini rather than relying only on PlantNet metadata.
- The botanical fact service currently calls Gemini but does not return the generated response.
- Some profile actions are UI placeholders and are not fully wired yet.
- The default widget test still references counter-app behavior and should be replaced with FloraDex-specific tests.
