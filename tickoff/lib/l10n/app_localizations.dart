import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Tickoff'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In de, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @settings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In de, this message translates to:
  /// **'Willkommen 👋'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Behalte Zeckenstiche im Blick und bleib gesund.'**
  String get welcomeSubtitle;

  /// No description provided for @myHistory.
  ///
  /// In de, this message translates to:
  /// **'Meine Historie'**
  String get myHistory;

  /// No description provided for @riskMap.
  ///
  /// In de, this message translates to:
  /// **'Risikokarte'**
  String get riskMap;

  /// No description provided for @tipsAndInfo.
  ///
  /// In de, this message translates to:
  /// **'Tipps & Infos'**
  String get tipsAndInfo;

  /// No description provided for @theme.
  ///
  /// In de, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @selectTheme.
  ///
  /// In de, this message translates to:
  /// **'Theme auswählen'**
  String get selectTheme;

  /// No description provided for @light.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get dark;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache auswählen'**
  String get selectLanguage;

  /// No description provided for @german.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @english.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get english;

  /// No description provided for @french.
  ///
  /// In de, this message translates to:
  /// **'Französisch'**
  String get french;

  /// No description provided for @italian.
  ///
  /// In de, this message translates to:
  /// **'Italienisch'**
  String get italian;

  /// No description provided for @notifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get notifications;

  /// No description provided for @notificationSettings.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungseinstellungen'**
  String get notificationSettings;

  /// No description provided for @account.
  ///
  /// In de, this message translates to:
  /// **'Konto'**
  String get account;

  /// No description provided for @createAccount.
  ///
  /// In de, this message translates to:
  /// **'Konto erstellen'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Jetzt registrieren und alle Funktionen nutzen'**
  String get createAccountSubtitle;

  /// No description provided for @login.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Bereits ein Konto? Hier einloggen'**
  String get loginSubtitle;

  /// No description provided for @email.
  ///
  /// In de, this message translates to:
  /// **'E-Mail'**
  String get email;

  /// No description provided for @username.
  ///
  /// In de, this message translates to:
  /// **'Benutzername'**
  String get username;

  /// No description provided for @changePassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort ändern'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In de, this message translates to:
  /// **'Konto löschen'**
  String get deleteAccount;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du dich wirklich abmelden?'**
  String get logoutConfirmMessage;

  /// No description provided for @editEmail.
  ///
  /// In de, this message translates to:
  /// **'E-Mail ändern'**
  String get editEmail;

  /// No description provided for @newEmail.
  ///
  /// In de, this message translates to:
  /// **'Neue E-Mail'**
  String get newEmail;

  /// No description provided for @editUsername.
  ///
  /// In de, this message translates to:
  /// **'Benutzername ändern'**
  String get editUsername;

  /// No description provided for @newUsername.
  ///
  /// In de, this message translates to:
  /// **'Neuer Benutzername'**
  String get newUsername;

  /// No description provided for @currentPassword.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In de, this message translates to:
  /// **'Neues Passwort'**
  String get newPassword;

  /// No description provided for @minEightCharacters.
  ///
  /// In de, this message translates to:
  /// **'Mindestens 8 Zeichen'**
  String get minEightCharacters;

  /// No description provided for @confirmPassword.
  ///
  /// In de, this message translates to:
  /// **'Passwort bestätigen'**
  String get confirmPassword;

  /// No description provided for @password.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get password;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In de, this message translates to:
  /// **'Passwörter stimmen nicht überein'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In de, this message translates to:
  /// **'Passwort erfolgreich geändert'**
  String get passwordChangedSuccessfully;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In de, this message translates to:
  /// **'Diese Aktion kann nicht rückgängig gemacht werden. Bitte gib dein Passwort zur Bestätigung ein.'**
  String get deleteAccountWarning;

  /// No description provided for @emailOrUsername.
  ///
  /// In de, this message translates to:
  /// **'E-Mail oder Benutzername'**
  String get emailOrUsername;

  /// No description provided for @enterEmailOrUsername.
  ///
  /// In de, this message translates to:
  /// **'Bitte E-Mail oder Benutzername eingeben'**
  String get enterEmailOrUsername;

  /// No description provided for @enterPassword.
  ///
  /// In de, this message translates to:
  /// **'Bitte Passwort eingeben'**
  String get enterPassword;

  /// No description provided for @noAccountRegisterNow.
  ///
  /// In de, this message translates to:
  /// **'Noch kein Konto? Jetzt registrieren'**
  String get noAccountRegisterNow;

  /// No description provided for @continueWithoutLogin.
  ///
  /// In de, this message translates to:
  /// **'Ohne Anmeldung fortfahren'**
  String get continueWithoutLogin;

  /// No description provided for @usernameOptional.
  ///
  /// In de, this message translates to:
  /// **'Benutzername (optional)'**
  String get usernameOptional;

  /// No description provided for @usernameMinThree.
  ///
  /// In de, this message translates to:
  /// **'Benutzername muss mindestens 3 Zeichen haben'**
  String get usernameMinThree;

  /// No description provided for @usernameAllowedChars.
  ///
  /// In de, this message translates to:
  /// **'Nur Buchstaben, Zahlen und _ erlaubt'**
  String get usernameAllowedChars;

  /// No description provided for @enterEmail.
  ///
  /// In de, this message translates to:
  /// **'Bitte E-Mail eingeben'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In de, this message translates to:
  /// **'Ungültige E-Mail-Adresse'**
  String get invalidEmail;

  /// No description provided for @passwordMinEight.
  ///
  /// In de, this message translates to:
  /// **'Passwort muss mindestens 8 Zeichen haben'**
  String get passwordMinEight;

  /// No description provided for @alreadyRegisteredLogin.
  ///
  /// In de, this message translates to:
  /// **'Bereits registriert? Anmelden'**
  String get alreadyRegisteredLogin;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In de, this message translates to:
  /// **'E-Mail bereits registriert'**
  String get emailAlreadyRegistered;

  /// No description provided for @usernameAlreadyTaken.
  ///
  /// In de, this message translates to:
  /// **'Benutzername bereits vergeben'**
  String get usernameAlreadyTaken;

  /// No description provided for @invalidCredentials.
  ///
  /// In de, this message translates to:
  /// **'Ungültige Anmeldedaten'**
  String get invalidCredentials;

  /// No description provided for @usernameCannotBeEmpty.
  ///
  /// In de, this message translates to:
  /// **'Benutzername darf nicht leer sein'**
  String get usernameCannotBeEmpty;

  /// No description provided for @notLoggedIn.
  ///
  /// In de, this message translates to:
  /// **'Nicht angemeldet'**
  String get notLoggedIn;

  /// No description provided for @userNotFound.
  ///
  /// In de, this message translates to:
  /// **'Benutzer nicht gefunden'**
  String get userNotFound;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In de, this message translates to:
  /// **'Aktuelles Passwort ist falsch'**
  String get currentPasswordIncorrect;

  /// No description provided for @wrongPassword.
  ///
  /// In de, this message translates to:
  /// **'Falsches Passwort'**
  String get wrongPassword;

  /// No description provided for @errorWithDetails.
  ///
  /// In de, this message translates to:
  /// **'Fehler: {details}'**
  String errorWithDetails(Object details);

  /// No description provided for @aboutApp.
  ///
  /// In de, this message translates to:
  /// **'Über die App'**
  String get aboutApp;

  /// No description provided for @version.
  ///
  /// In de, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aboutDescription.
  ///
  /// In de, this message translates to:
  /// **'Tickoff hilft dir, Zeckenstiche zu dokumentieren und Risikobereiche zu identifizieren.'**
  String get aboutDescription;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schliessen'**
  String get close;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @register.
  ///
  /// In de, this message translates to:
  /// **'Registrieren'**
  String get register;

  /// No description provided for @history.
  ///
  /// In de, this message translates to:
  /// **'Historie'**
  String get history;

  /// No description provided for @noEntries.
  ///
  /// In de, this message translates to:
  /// **'Keine Einträge vorhanden'**
  String get noEntries;

  /// No description provided for @addEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag hinzufügen'**
  String get addEntry;

  /// No description provided for @date.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @location.
  ///
  /// In de, this message translates to:
  /// **'Ort'**
  String get location;

  /// No description provided for @notes.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get notes;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get edit;

  /// No description provided for @tickBite.
  ///
  /// In de, this message translates to:
  /// **'Zeckenstich'**
  String get tickBite;

  /// No description provided for @symptoms.
  ///
  /// In de, this message translates to:
  /// **'Symptome'**
  String get symptoms;

  /// No description provided for @systemTheme.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @newTickBiteTitle.
  ///
  /// In de, this message translates to:
  /// **'Neuer Zeckenstich gemeldet'**
  String get newTickBiteTitle;

  /// No description provided for @newTickBiteMessage.
  ///
  /// In de, this message translates to:
  /// **'Ein neuer Zeckenstich wurde erfolgreich registriert.'**
  String get newTickBiteMessage;

  /// No description provided for @enableNotifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen aktivieren'**
  String get enableNotifications;

  /// No description provided for @notificationsEnabledDesc.
  ///
  /// In de, this message translates to:
  /// **'Erhalte Benachrichtigungen bei neuen Zeckenstichen'**
  String get notificationsEnabledDesc;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In de, this message translates to:
  /// **'Eintrag löschen?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du diesen Zeckenstich-Eintrag wirklich löschen?'**
  String get deleteEntryMessage;

  /// No description provided for @entryDeleted.
  ///
  /// In de, this message translates to:
  /// **'Eintrag gelöscht'**
  String get entryDeleted;

  /// No description provided for @errorDeleting.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Löschen'**
  String get errorDeleting;

  /// No description provided for @yourTickBites.
  ///
  /// In de, this message translates to:
  /// **'Deine Zeckenstiche'**
  String get yourTickBites;

  /// No description provided for @timeAt.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit: {time} Uhr'**
  String timeAt(Object time);

  /// No description provided for @coordinatesAt.
  ///
  /// In de, this message translates to:
  /// **'Koordinaten: {coordinates}'**
  String coordinatesAt(Object coordinates);

  /// No description provided for @yourReportDescription.
  ///
  /// In de, this message translates to:
  /// **'Das ist dein gemeldeter Zeckenstich. Du kannst ihn wieder löschen.'**
  String get yourReportDescription;

  /// No description provided for @communityReportDescription.
  ///
  /// In de, this message translates to:
  /// **'Dieser Zeckenstich wurde von einer anderen Person gemeldet und kann nicht von dir gelöscht werden.'**
  String get communityReportDescription;

  /// No description provided for @deleteOwnTickBiteMessage.
  ///
  /// In de, this message translates to:
  /// **'Möchtest du deinen gemeldeten Zeckenstich wirklich löschen?'**
  String get deleteOwnTickBiteMessage;

  /// No description provided for @deleteNotAllowed.
  ///
  /// In de, this message translates to:
  /// **'Du kannst nur deine eigenen Markierungen löschen.'**
  String get deleteNotAllowed;

  /// No description provided for @noEntriesDescription.
  ///
  /// In de, this message translates to:
  /// **'Melde einen Zeckenstich auf der Risikokarte,\num ihn hier zu sehen.'**
  String get noEntriesDescription;

  /// No description provided for @errorLoading.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Laden'**
  String get errorLoading;

  /// No description provided for @successfullySaved.
  ///
  /// In de, this message translates to:
  /// **'Erfolgreich gespeichert!'**
  String get successfullySaved;

  /// No description provided for @tickBiteSavedMessage.
  ///
  /// In de, this message translates to:
  /// **'Der Zeckenstich wurde erfolgreich gemeldet und auf der Karte markiert.'**
  String get tickBiteSavedMessage;

  /// No description provided for @tapToMark.
  ///
  /// In de, this message translates to:
  /// **'Tippe auf die Karte, um einen Zeckenstich zu markieren'**
  String get tapToMark;

  /// No description provided for @locationLoading.
  ///
  /// In de, this message translates to:
  /// **'Standort wird ermittelt...'**
  String get locationLoading;

  /// No description provided for @errorSaving.
  ///
  /// In de, this message translates to:
  /// **'Fehler beim Speichern'**
  String get errorSaving;

  /// No description provided for @reportHere.
  ///
  /// In de, this message translates to:
  /// **'Hier melden'**
  String get reportHere;

  /// No description provided for @recognizeTicks.
  ///
  /// In de, this message translates to:
  /// **'Zecken erkennen'**
  String get recognizeTicks;

  /// No description provided for @recognizeTicksDesc.
  ///
  /// In de, this message translates to:
  /// **'Zecken sind kleine, spinnenartige Tiere (1-5mm). Sie bevorzugen warme, feuchte Körperstellen wie Achseln, Kniekehlen und Haaransatz.'**
  String get recognizeTicksDesc;

  /// No description provided for @removeTick.
  ///
  /// In de, this message translates to:
  /// **'Zecke entfernen'**
  String get removeTick;

  /// No description provided for @removeTickDesc.
  ///
  /// In de, this message translates to:
  /// **'1. Zeckenzange oder Pinzette verwenden\n2. Zecke nah an der Haut greifen\n3. Langsam und gerade herausziehen\n4. Nicht drehen oder quetschen\n5. Stelle desinfizieren'**
  String get removeTickDesc;

  /// No description provided for @whenToDoctor.
  ///
  /// In de, this message translates to:
  /// **'Wann zum Arzt?'**
  String get whenToDoctor;

  /// No description provided for @whenToDoctorDesc.
  ///
  /// In de, this message translates to:
  /// **'• Rötung breitet sich kreisförmig aus (Wanderröte)\n• Grippeähnliche Symptome nach Stich\n• Fieber, Kopf- oder Gliederschmerzen\n• Zecke lässt sich nicht entfernen'**
  String get whenToDoctorDesc;

  /// No description provided for @prevention.
  ///
  /// In de, this message translates to:
  /// **'Vorbeugung'**
  String get prevention;

  /// No description provided for @preventionDesc.
  ///
  /// In de, this message translates to:
  /// **'• Lange Kleidung in Wald und Wiesen\n• Helle Kleidung (Zecken besser sichtbar)\n• Zeckenschutzmittel verwenden\n• Nach dem Aufenthalt Körper absuchen\n• FSME-Impfung in Risikogebieten'**
  String get preventionDesc;

  /// No description provided for @diseases.
  ///
  /// In de, this message translates to:
  /// **'Krankheiten'**
  String get diseases;

  /// No description provided for @diseasesDesc.
  ///
  /// In de, this message translates to:
  /// **'• Borreliose: Durch Bakterien, behandelbar mit Antibiotika\n• FSME: Durch Viren, nur Impfschutz möglich\n• Nicht jeder Zeckenstich führt zu einer Erkrankung'**
  String get diseasesDesc;

  /// No description provided for @tickSize.
  ///
  /// In de, this message translates to:
  /// **'Größe: 1-5mm (ungefüllt) bis 1cm (vollgesogen)'**
  String get tickSize;

  /// No description provided for @tickLegs.
  ///
  /// In de, this message translates to:
  /// **'8 Beine (Spinnenart, kein Insekt)'**
  String get tickLegs;

  /// No description provided for @tickColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe: braun bis schwarz'**
  String get tickColor;

  /// No description provided for @tickPreferredSpots.
  ///
  /// In de, this message translates to:
  /// **'Bevorzugte Stellen: warm & feucht'**
  String get tickPreferredSpots;

  /// No description provided for @importantDontTwist.
  ///
  /// In de, this message translates to:
  /// **'Wichtig: Nicht drehen!'**
  String get importantDontTwist;

  /// No description provided for @removeWithin24h.
  ///
  /// In de, this message translates to:
  /// **'Zeit: Innerhalb 24h entfernen'**
  String get removeWithin24h;

  /// No description provided for @tickToolTweezer.
  ///
  /// In de, this message translates to:
  /// **'Werkzeug: Zeckenzange oder -karte'**
  String get tickToolTweezer;

  /// No description provided for @disinfectAfterRemoval.
  ///
  /// In de, this message translates to:
  /// **'Desinfektion nach Entfernung'**
  String get disinfectAfterRemoval;

  /// No description provided for @erythemaMigrans.
  ///
  /// In de, this message translates to:
  /// **'🔴 Wanderröte (kreisförmige Rötung)'**
  String get erythemaMigrans;

  /// No description provided for @fluLikeSymptoms.
  ///
  /// In de, this message translates to:
  /// **'🔴 Grippeähnliche Symptome'**
  String get fluLikeSymptoms;

  /// No description provided for @jointPain.
  ///
  /// In de, this message translates to:
  /// **'🔴 Gelenkschmerzen'**
  String get jointPain;

  /// No description provided for @paralysisSymptoms.
  ///
  /// In de, this message translates to:
  /// **'🔴 Lähmungserscheinungen'**
  String get paralysisSymptoms;

  /// No description provided for @feverAfterBite.
  ///
  /// In de, this message translates to:
  /// **'🔴 Fieber nach Zeckenstich'**
  String get feverAfterBite;

  /// No description provided for @wearLongClothing.
  ///
  /// In de, this message translates to:
  /// **'Lange, helle Kleidung tragen'**
  String get wearLongClothing;

  /// No description provided for @avoidTallGrass.
  ///
  /// In de, this message translates to:
  /// **'Hohes Gras meiden'**
  String get avoidTallGrass;

  /// No description provided for @useRepellent.
  ///
  /// In de, this message translates to:
  /// **'Repellent verwenden'**
  String get useRepellent;

  /// No description provided for @checkBody.
  ///
  /// In de, this message translates to:
  /// **'Körper absuchen'**
  String get checkBody;

  /// No description provided for @considerVaccination.
  ///
  /// In de, this message translates to:
  /// **'FSME-Impfung erwägen'**
  String get considerVaccination;

  /// No description provided for @lymeDiseaseTitle.
  ///
  /// In de, this message translates to:
  /// **'Borreliose (Lyme-Krankheit)'**
  String get lymeDiseaseTitle;

  /// No description provided for @lymeDiseaseInfo.
  ///
  /// In de, this message translates to:
  /// **'• Übertragung: 12-24h nach Stich\n• Symptom: Wanderröte\n• Behandlung: Antibiotika\n• Impfung: Nicht verfügbar'**
  String get lymeDiseaseInfo;

  /// No description provided for @tbeTitle.
  ///
  /// In de, this message translates to:
  /// **'FSME (Frühsommer-Meningoenzephalitis)'**
  String get tbeTitle;

  /// No description provided for @tbeInfo.
  ///
  /// In de, this message translates to:
  /// **'• Übertragung: Sofort nach Stich\n• Symptom: Grippeähnlich, Fieber\n• Behandlung: Nur symptomatisch\n• Impfung: Verfügbar & empfohlen'**
  String get tbeInfo;

  /// No description provided for @riskAreasActivities.
  ///
  /// In de, this message translates to:
  /// **'Risikobereiche & Aktivitäten'**
  String get riskAreasActivities;

  /// No description provided for @highRisk.
  ///
  /// In de, this message translates to:
  /// **'Hohes Risiko'**
  String get highRisk;

  /// No description provided for @mediumRisk.
  ///
  /// In de, this message translates to:
  /// **'Mittleres Risiko'**
  String get mediumRisk;

  /// No description provided for @lowRisk.
  ///
  /// In de, this message translates to:
  /// **'Niedriges Risiko'**
  String get lowRisk;

  /// No description provided for @hikingTallGrass.
  ///
  /// In de, this message translates to:
  /// **'Wandern in hohem Gras'**
  String get hikingTallGrass;

  /// No description provided for @forestEdges.
  ///
  /// In de, this message translates to:
  /// **'Waldränder & Lichtungen'**
  String get forestEdges;

  /// No description provided for @undergrowth.
  ///
  /// In de, this message translates to:
  /// **'Unterholz & Büsche'**
  String get undergrowth;

  /// No description provided for @parksGardens.
  ///
  /// In de, this message translates to:
  /// **'Parks & Gärten'**
  String get parksGardens;

  /// No description provided for @picnicMeadows.
  ///
  /// In de, this message translates to:
  /// **'Picknick auf Wiesen'**
  String get picnicMeadows;

  /// No description provided for @joggingForest.
  ///
  /// In de, this message translates to:
  /// **'Joggen im Wald'**
  String get joggingForest;

  /// No description provided for @maintainedLawns.
  ///
  /// In de, this message translates to:
  /// **'Gepflegte Rasenflächen'**
  String get maintainedLawns;

  /// No description provided for @pavedPaths.
  ///
  /// In de, this message translates to:
  /// **'Asphaltierte Wege'**
  String get pavedPaths;

  /// No description provided for @indoors.
  ///
  /// In de, this message translates to:
  /// **'Innenräume'**
  String get indoors;

  /// No description provided for @tickSeason.
  ///
  /// In de, this message translates to:
  /// **'Zeckensaison'**
  String get tickSeason;

  /// No description provided for @marchJune.
  ///
  /// In de, this message translates to:
  /// **'März - Juni'**
  String get marchJune;

  /// No description provided for @mainSeason.
  ///
  /// In de, this message translates to:
  /// **'Hauptsaison'**
  String get mainSeason;

  /// No description provided for @highestActivity.
  ///
  /// In de, this message translates to:
  /// **'Höchste Aktivität'**
  String get highestActivity;

  /// No description provided for @julyAugust.
  ///
  /// In de, this message translates to:
  /// **'Juli - August'**
  String get julyAugust;

  /// No description provided for @highSummer.
  ///
  /// In de, this message translates to:
  /// **'Hochsommer'**
  String get highSummer;

  /// No description provided for @mediumActivity.
  ///
  /// In de, this message translates to:
  /// **'Mittlere Aktivität'**
  String get mediumActivity;

  /// No description provided for @septemberOctober.
  ///
  /// In de, this message translates to:
  /// **'September - Oktober'**
  String get septemberOctober;

  /// No description provided for @autumn.
  ///
  /// In de, this message translates to:
  /// **'Herbst'**
  String get autumn;

  /// No description provided for @secondWave.
  ///
  /// In de, this message translates to:
  /// **'Zweite Welle'**
  String get secondWave;

  /// No description provided for @novemberFebruary.
  ///
  /// In de, this message translates to:
  /// **'November - Februar'**
  String get novemberFebruary;

  /// No description provided for @winter.
  ///
  /// In de, this message translates to:
  /// **'Winter'**
  String get winter;

  /// No description provided for @lowActivity.
  ///
  /// In de, this message translates to:
  /// **'Niedrige Aktivität'**
  String get lowActivity;

  /// No description provided for @inEmergencies.
  ///
  /// In de, this message translates to:
  /// **'Bei Notfällen'**
  String get inEmergencies;

  /// No description provided for @medicalEmergency.
  ///
  /// In de, this message translates to:
  /// **'Ärztlicher Notdienst: 116 117\nNotruf: 112'**
  String get medicalEmergency;

  /// No description provided for @seekHelpImmediately.
  ///
  /// In de, this message translates to:
  /// **'Bei Verdacht auf FSME oder schwere Symptome\nsofort ärztliche Hilfe aufsuchen!'**
  String get seekHelpImmediately;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
