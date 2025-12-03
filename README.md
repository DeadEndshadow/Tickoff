# Tickoff

[Repository-Link](https://github.com/DeadEndshadow/Tickoff)

## Übersicht

**Tickoff** ist eine plattformübergreifende Desktop-Anwendung, die mit **Flutter** entwickelt wurde. Das Projekt verwendet Flutter als Haupttechnologie und integriert plattformspezifischen Code in C++ (wie es für Flutter-Desktop-Ziele wie Windows und Linux erforderlich ist).

---

## Voraussetzungen

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (aktuelle stabile Version)
- [Git](https://git-scm.com/)
- Für Windows: [Visual Studio](https://visualstudio.microsoft.com/) mit dem Workload „Desktopentwicklung mit C++“

### Empfohlene IDEs

- [Visual Studio Code](https://code.visualstudio.com/)
  - Erweiterungen: Flutter, Dart
- [Android Studio](https://developer.android.com/studio) oder [IntelliJ IDEA](https://www.jetbrains.com/idea/)
  - Plugins: Flutter & Dart

---

## Erste Schritte

### 1. Repository klonen

```bash
git clone https://github.com/DeadEndshadow/Tickoff.git
cd Tickoff
```

### 2. Flutter-Abhängigkeiten installieren

```bash
flutter pub get
```

### 3. Plattformspezifische Einrichtung

#### Linux

- Notwendige Systempakete installieren:
  ```bash
  sudo apt-get update
  sudo apt-get install -y libgtk-3-dev clang cmake ninja-build pkg-config
  ```

#### Windows

- Visual Studio installieren (mit dem Workload „Desktopentwicklung mit C++“).
- Sicherstellen, dass `cmake`, `ninja` und `git` im PATH verfügbar sind (Flutter installiert diese bei Bedarf automatisch).

#### macOS (falls zutreffend)

- Stelle sicher, dass Xcode und die Command Line Tools installiert sind.
- Hinweis: Möglicherweise musst du macOS-Unterstützung mit `flutter config --enable-macos-desktop` aktivieren, wenn du macOS als Ziel verwendest.

---

## Bauen und Ausführen

Um die App auf deiner aktuellen Plattform auszuführen:

```bash
flutter run -d windows   # Unter Windows
flutter run -d linux     # Unter Linux
flutter run -d macos     # Unter macOS (falls aktiviert)
```

Um Release-Versionen zu bauen:

```bash
flutter build windows    # Windows
flutter build linux      # Linux
flutter build macos      # macOS
```

---

## IDE-Einrichtung

### Visual Studio Code

1. Öffne den Ordner in VS Code.
2. Installiere die Erweiterungen **Flutter** und **Dart**, falls noch nicht vorhanden.
3. Verwende die Befehlspalette (`Strg+Shift+P` → "Flutter: Run"), um das Projekt zu bauen und auszuführen.
4. Debugging, Hot Reload und andere Flutter-Tools sind integriert.

### Android Studio / IntelliJ IDEA

1. Öffne das Projekt über „Verzeichnis öffnen“.
2. Installiere die Plugins **Flutter** und **Dart** aus dem Plugin-Marktplatz.
3. Nutze das integrierte Flutter-Toolfenster, um das Projekt zu starten, zu debuggen und zu verwalten.

---

## Projektstruktur

- `lib/`: Haupt-Quellcode der App in Flutter (Dart).
- `tickoff/`: Plattform-spezifischer Runner-Code (CMake-Dateien, usw. für Windows/Linux).
- `doc/`: Projektdokumentation.
- `.github/`: GitHub Workflows und Issue-Templates.

---

## Zusätzliche Hinweise

- Unter `tickoff/` ist für die Flutter-Runner plattformspezifischer C++-Code enthalten.
- Stelle sicher, dass dein System alle [Flutter Desktop Anforderungen](https://docs.flutter.dev/desktop) erfüllt.
- Hilfe zur Einrichtung und Problemlösung findest du in der [offiziellen Flutter Desktop-Dokumentation](https://docs.flutter.dev/desktop).

---

Für weitere Informationen und Beiträge besuche das [Tickoff GitHub-Repository](https://github.com/DeadEndshadow/Tickoff).
