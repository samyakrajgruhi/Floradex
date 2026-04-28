# 🌿 FloraDex

<div align="center">

A gamified plant recognition app — scan, discover, and collect plants like a Pokédex.

*Powered by PlantNet API + Hive*

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart)](https://dart.dev)

</div>

## Features

- **Plant Recognition** — Scan plants and identify them using the PlantNet API
- **Plant Vault** — Save discovered plants to your personal collection
- **Detailed Plant Info** — Get taste, harvest time, and growth information for each plant
- **Offline Storage** — All your plants stored locally with Hive

## Tech Stack

- **Flutter** — Cross-platform UI framework
- **PlantNet API** — Plant species identification
- **Hive** — Local NoSQL database for storing plant records
- **LangChain** — AI-powered plant info service

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── screens/                # UI screens (scanner, vault, profile)
├── services/               # API and database services
├── models/                 # Data models
└── widgets/                # Reusable UI components
```

## Recent Updates

- Plant vault with Hive integration and database service
- PlantNet API refactor for plant identification
- Vault debug screen and reset functionality