# 3.3 Artefaktverwaltung definieren

Dieses Dokument beschreibt die Strategie zur Verwaltung von Build-Artefakten (z. B. Installer, Binaries) für das Projekt Tickoff.

## 1. Evaluierung geeigneter Artefakt-Repositorien

Für das Projekt Tickoff wurden verschiedene Optionen zur Speicherung von Artefakten evaluiert:

*   **GitHub (Releases & Packages):**
    *   *Vorteile:* Nahtlose Integration in den bestehenden Quellcode-Host, keine zusätzlichen Kosten für öffentliche Repositories (oder im Rahmen des Free-Tiers), direkte Verknüpfung von Code-Changes zu Artefakten, integrierte CI/CD (GitHub Actions).
    *   *Nachteile:* Speicherbegrenzungen bei sehr großen Artefakten (hier nicht relevant).
*   **Sonatype Nexus / JFrog Artifactory:**
    *   *Vorteile:* Sehr mächtige Enterprise-Funktionen, Caching von 3rd-Party-Dependencies.
    *   *Nachteile:* Hoher Wartungsaufwand (Self-Hosted) oder Kosten (SaaS), Overkill für ein einzelnes Projekt dieser Größe.
*   **GitLab Package Registry:**
    *   *Nachteile:* Projekt liegt bereits auf GitHub, ein Wechsel oder eine Hybrid-Lösung würde unnötige Komplexität erzeugen.

**Entscheidung:**
Wir nutzen **GitHub Releases** für die Speicherung der finalen Build-Artefakte (APKs, IPAs, Executables). Dies bietet die geringste Reibung im Entwicklungsprozess und zentralisiert Code und Builds an einem Ort.

## 2. Strategien zur Versionierung (SemVer)

Wir folgen strikt dem **Semantic Versioning 2.0.0** (SemVer) Prinzip (`MAJOR.MINOR.PATCH`).

*   **MAJOR:** Wenn inkompatible API-Änderungen durchgeführt werden.
*   **MINOR:** Wenn Funktionalität auf abwärtskompatible Weise hinzugefügt wird.
*   **PATCH:** Wenn abwärtskompatible Fehlerbehebungen durchgeführt werden.

**Technische Umsetzung:**
*   Die Version wird über **Git Tags** gesteuert (z. B. `v1.0.0`).
*   CI/CD-Pipelines (GitHub Actions) triggern automatisch Build-Prozesse, wenn ein neuer Tag gepusht wird.
*   Die Versionsnummer in den Konfigurationsdateien (z. B. `pubspec.yaml` für Dart/Flutter oder `CMakeLists.txt` für C++) muss vor dem Taggen mit dem Tag übereinstimmen.

## 3. Dokumentation der Integration (Integrationsprozess)

Die Artefakt-Verwaltung ist direkt in die GitHub Actions CI/CD-Pipeline integriert.

**Kurzbeschreibung des Prozesses:**

1.  Entwickler erhöht Versionsnummer im Code (`pubspec.yaml` / `CMakeLists.txt`).
2.  Code wird gemerged.
3.  Ein Git-Tag wird erstellt und gepusht: `git tag v1.0.1 && git push origin v1.0.1`.
4.  **GitHub Action Trigger:** Der Push des Tags startet den "Release Workflow".
5.  **Build:** Der Code wird für die Zielplattformen gebaut.
6.  **Upload:** Die kompilierten Binaries werden automatisch als Assets zum GitHub Release hochgeladen.

**Checkliste für Release:**
- [ ] Changelog aktualisiert
- [ ] Versionsnummern in Dateien erhöht
- [ ] Tests lokal erfolgreich
- [ ] Git Tag erstellt (Format `vX.Y.Z`)
- [ ] GitHub Action Durchlauf prüfen
- [ ] Artefakte im GitHub Release Tab verifizieren
