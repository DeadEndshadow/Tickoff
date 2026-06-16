// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tickoff';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Einstellungen';

  @override
  String get welcome => 'Willkommen 👋';

  @override
  String get welcomeSubtitle =>
      'Behalte Zeckenstiche im Blick und bleib gesund.';

  @override
  String get myHistory => 'Meine Historie';

  @override
  String get riskMap => 'Risikokarte';

  @override
  String get tipsAndInfo => 'Tipps & Infos';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Theme auswählen';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get german => 'Deutsch';

  @override
  String get english => 'Englisch';

  @override
  String get french => 'Französisch';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get account => 'Konto';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get createAccountSubtitle =>
      'Jetzt registrieren und alle Funktionen nutzen';

  @override
  String get login => 'Anmelden';

  @override
  String get loginSubtitle => 'Bereits ein Konto? Hier einloggen';

  @override
  String get email => 'E-Mail';

  @override
  String get username => 'Benutzername';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get logout => 'Abmelden';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get logoutConfirmMessage => 'Möchtest du dich wirklich abmelden?';

  @override
  String get editEmail => 'E-Mail ändern';

  @override
  String get newEmail => 'Neue E-Mail';

  @override
  String get editUsername => 'Benutzername ändern';

  @override
  String get newUsername => 'Neuer Benutzername';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get minEightCharacters => 'Mindestens 8 Zeichen';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get password => 'Passwort';

  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';

  @override
  String get passwordChangedSuccessfully => 'Passwort erfolgreich geändert';

  @override
  String get deleteAccountWarning =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Bitte gib dein Passwort zur Bestätigung ein.';

  @override
  String get emailOrUsername => 'E-Mail oder Benutzername';

  @override
  String get enterEmailOrUsername => 'Bitte E-Mail oder Benutzername eingeben';

  @override
  String get enterPassword => 'Bitte Passwort eingeben';

  @override
  String get noAccountRegisterNow => 'Noch kein Konto? Jetzt registrieren';

  @override
  String get continueWithoutLogin => 'Ohne Anmeldung fortfahren';

  @override
  String get usernameOptional => 'Benutzername (optional)';

  @override
  String get usernameMinThree => 'Benutzername muss mindestens 3 Zeichen haben';

  @override
  String get usernameAllowedChars => 'Nur Buchstaben, Zahlen und _ erlaubt';

  @override
  String get enterEmail => 'Bitte E-Mail eingeben';

  @override
  String get invalidEmail => 'Ungültige E-Mail-Adresse';

  @override
  String get passwordMinEight => 'Passwort muss mindestens 8 Zeichen haben';

  @override
  String get alreadyRegisteredLogin => 'Bereits registriert? Anmelden';

  @override
  String get emailAlreadyRegistered => 'E-Mail bereits registriert';

  @override
  String get usernameAlreadyTaken => 'Benutzername bereits vergeben';

  @override
  String get invalidCredentials => 'Ungültige Anmeldedaten';

  @override
  String get usernameCannotBeEmpty => 'Benutzername darf nicht leer sein';

  @override
  String get notLoggedIn => 'Nicht angemeldet';

  @override
  String get userNotFound => 'Benutzer nicht gefunden';

  @override
  String get currentPasswordIncorrect => 'Aktuelles Passwort ist falsch';

  @override
  String get wrongPassword => 'Falsches Passwort';

  @override
  String errorWithDetails(Object details) {
    return 'Fehler: $details';
  }

  @override
  String get aboutApp => 'Über die App';

  @override
  String get version => 'Version';

  @override
  String get aboutDescription =>
      'Tickoff hilft dir, Zeckenstiche zu dokumentieren und Risikobereiche zu identifizieren.';

  @override
  String get close => 'Schliessen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get register => 'Registrieren';

  @override
  String get history => 'Historie';

  @override
  String get noEntries => 'Keine Einträge vorhanden';

  @override
  String get addEntry => 'Eintrag hinzufügen';

  @override
  String get date => 'Datum';

  @override
  String get location => 'Ort';

  @override
  String get notes => 'Notizen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get tickBite => 'Zeckenstich';

  @override
  String get symptoms => 'Symptome';

  @override
  String get systemTheme => 'System';

  @override
  String get newTickBiteTitle => 'Neuer Zeckenstich gemeldet';

  @override
  String get newTickBiteMessage =>
      'Ein neuer Zeckenstich wurde erfolgreich registriert.';

  @override
  String get enableNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get notificationsEnabledDesc =>
      'Erhalte Benachrichtigungen bei neuen Zeckenstichen';

  @override
  String get deleteEntryTitle => 'Eintrag löschen?';

  @override
  String get deleteEntryMessage =>
      'Möchtest du diesen Zeckenstich-Eintrag wirklich löschen?';

  @override
  String get entryDeleted => 'Eintrag gelöscht';

  @override
  String get errorDeleting => 'Fehler beim Löschen';

  @override
  String get yourTickBites => 'Deine Zeckenstiche';

  @override
  String timeAt(Object time) {
    return 'Uhrzeit: $time Uhr';
  }

  @override
  String coordinatesAt(Object coordinates) {
    return 'Koordinaten: $coordinates';
  }

  @override
  String get noEntriesDescription =>
      'Melde einen Zeckenstich auf der Risikokarte,\num ihn hier zu sehen.';

  @override
  String get errorLoading => 'Fehler beim Laden';

  @override
  String get successfullySaved => 'Erfolgreich gespeichert!';

  @override
  String get tickBiteSavedMessage =>
      'Der Zeckenstich wurde erfolgreich gemeldet und auf der Karte markiert.';

  @override
  String get tapToMark =>
      'Tippe auf die Karte, um einen Zeckenstich zu markieren';

  @override
  String get locationLoading => 'Standort wird ermittelt...';

  @override
  String get errorSaving => 'Fehler beim Speichern';

  @override
  String get reportHere => 'Hier melden';

  @override
  String get recognizeTicks => 'Zecken erkennen';

  @override
  String get recognizeTicksDesc =>
      'Zecken sind kleine, spinnenartige Tiere (1-5mm). Sie bevorzugen warme, feuchte Körperstellen wie Achseln, Kniekehlen und Haaransatz.';

  @override
  String get removeTick => 'Zecke entfernen';

  @override
  String get removeTickDesc =>
      '1. Zeckenzange oder Pinzette verwenden\n2. Zecke nah an der Haut greifen\n3. Langsam und gerade herausziehen\n4. Nicht drehen oder quetschen\n5. Stelle desinfizieren';

  @override
  String get whenToDoctor => 'Wann zum Arzt?';

  @override
  String get whenToDoctorDesc =>
      '• Rötung breitet sich kreisförmig aus (Wanderröte)\n• Grippeähnliche Symptome nach Stich\n• Fieber, Kopf- oder Gliederschmerzen\n• Zecke lässt sich nicht entfernen';

  @override
  String get prevention => 'Vorbeugung';

  @override
  String get preventionDesc =>
      '• Lange Kleidung in Wald und Wiesen\n• Helle Kleidung (Zecken besser sichtbar)\n• Zeckenschutzmittel verwenden\n• Nach dem Aufenthalt Körper absuchen\n• FSME-Impfung in Risikogebieten';

  @override
  String get diseases => 'Krankheiten';

  @override
  String get diseasesDesc =>
      '• Borreliose: Durch Bakterien, behandelbar mit Antibiotika\n• FSME: Durch Viren, nur Impfschutz möglich\n• Nicht jeder Zeckenstich führt zu einer Erkrankung';

  @override
  String get tickSize => 'Größe: 1-5mm (ungefüllt) bis 1cm (vollgesogen)';

  @override
  String get tickLegs => '8 Beine (Spinnenart, kein Insekt)';

  @override
  String get tickColor => 'Farbe: braun bis schwarz';

  @override
  String get tickPreferredSpots => 'Bevorzugte Stellen: warm & feucht';

  @override
  String get importantDontTwist => 'Wichtig: Nicht drehen!';

  @override
  String get removeWithin24h => 'Zeit: Innerhalb 24h entfernen';

  @override
  String get tickToolTweezer => 'Werkzeug: Zeckenzange oder -karte';

  @override
  String get disinfectAfterRemoval => 'Desinfektion nach Entfernung';

  @override
  String get erythemaMigrans => '🔴 Wanderröte (kreisförmige Rötung)';

  @override
  String get fluLikeSymptoms => '🔴 Grippeähnliche Symptome';

  @override
  String get jointPain => '🔴 Gelenkschmerzen';

  @override
  String get paralysisSymptoms => '🔴 Lähmungserscheinungen';

  @override
  String get feverAfterBite => '🔴 Fieber nach Zeckenstich';

  @override
  String get wearLongClothing => 'Lange, helle Kleidung tragen';

  @override
  String get avoidTallGrass => 'Hohes Gras meiden';

  @override
  String get useRepellent => 'Repellent verwenden';

  @override
  String get checkBody => 'Körper absuchen';

  @override
  String get considerVaccination => 'FSME-Impfung erwägen';

  @override
  String get lymeDiseaseTitle => 'Borreliose (Lyme-Krankheit)';

  @override
  String get lymeDiseaseInfo =>
      '• Übertragung: 12-24h nach Stich\n• Symptom: Wanderröte\n• Behandlung: Antibiotika\n• Impfung: Nicht verfügbar';

  @override
  String get tbeTitle => 'FSME (Frühsommer-Meningoenzephalitis)';

  @override
  String get tbeInfo =>
      '• Übertragung: Sofort nach Stich\n• Symptom: Grippeähnlich, Fieber\n• Behandlung: Nur symptomatisch\n• Impfung: Verfügbar & empfohlen';

  @override
  String get riskAreasActivities => 'Risikobereiche & Aktivitäten';

  @override
  String get highRisk => 'Hohes Risiko';

  @override
  String get mediumRisk => 'Mittleres Risiko';

  @override
  String get lowRisk => 'Niedriges Risiko';

  @override
  String get hikingTallGrass => 'Wandern in hohem Gras';

  @override
  String get forestEdges => 'Waldränder & Lichtungen';

  @override
  String get undergrowth => 'Unterholz & Büsche';

  @override
  String get parksGardens => 'Parks & Gärten';

  @override
  String get picnicMeadows => 'Picknick auf Wiesen';

  @override
  String get joggingForest => 'Joggen im Wald';

  @override
  String get maintainedLawns => 'Gepflegte Rasenflächen';

  @override
  String get pavedPaths => 'Asphaltierte Wege';

  @override
  String get indoors => 'Innenräume';

  @override
  String get tickSeason => 'Zeckensaison';

  @override
  String get marchJune => 'März - Juni';

  @override
  String get mainSeason => 'Hauptsaison';

  @override
  String get highestActivity => 'Höchste Aktivität';

  @override
  String get julyAugust => 'Juli - August';

  @override
  String get highSummer => 'Hochsommer';

  @override
  String get mediumActivity => 'Mittlere Aktivität';

  @override
  String get septemberOctober => 'September - Oktober';

  @override
  String get autumn => 'Herbst';

  @override
  String get secondWave => 'Zweite Welle';

  @override
  String get novemberFebruary => 'November - Februar';

  @override
  String get winter => 'Winter';

  @override
  String get lowActivity => 'Niedrige Aktivität';

  @override
  String get inEmergencies => 'Bei Notfällen';

  @override
  String get medicalEmergency => 'Ärztlicher Notdienst: 116 117\nNotruf: 112';

  @override
  String get seekHelpImmediately =>
      'Bei Verdacht auf FSME oder schwere Symptome\nsofort ärztliche Hilfe aufsuchen!';
}
