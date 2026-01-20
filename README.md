# Evangéliumok 80 nap alatt – Offline Bible Reader (Flutter)

**HU:** Modern, offline Biblia-olvasó alkalmazás Flutterben több fordítással, napi olvasási tervvel és testreszabható megjelenéssel. Weben és Androidon is futtatható.  
**EN:** Offline Bible reader built with Flutter (Web + Android), featuring a daily reading plan, multiple translations, and customizable UI.

## Demo (Web)
https://evangeliumokhusvetig.netlify.app/

## Features
- **Daily reading plan** (date-based navigation)
- **Chapter & verse range support**
- **Multiple translations**
  - Károli Gáspár (1908)
  - Revideált Új Fordítás (RÚF)
  - In-app switching + saved selection (**SharedPreferences**)
- **Customizable UI**
  - Light/Dark mode
  - Font size
  - Highlight colors
- **Verse selection & copy**
  - Select verses with visual feedback
  - Long-press to copy verse to clipboard
- **Auto scroll**
  - Slow continuous scroll with start/pause controls
- **Offline-first**
  - Texts and reading plan are loaded from local **JSON** files

## Tech stack
- **Flutter (Dart)**
- **Flutter Web**
- **Android**
- **SharedPreferences**
- **JSON** (Bible texts + reading plan)
- *(Optional tooling)* Python scripts for data preparation

## How to run locally
```bash
flutter pub get
flutter run
# Web
flutter run -d chrome

Bible text files may be subject to separate licensing.
