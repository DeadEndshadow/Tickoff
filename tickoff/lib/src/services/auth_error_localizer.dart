import 'package:tickoff/l10n/app_localizations.dart';

String localizeAuthError(AppLocalizations l10n, String error) {
  if (error.startsWith('Fehler: ') || error.startsWith('Error: ')) {
    final details = error.substring(error.indexOf(':') + 2);
    return l10n.errorWithDetails(details);
  }

  switch (error) {
    case 'E-Mail bereits registriert':
      return l10n.emailAlreadyRegistered;
    case 'Benutzername bereits vergeben':
      return l10n.usernameAlreadyTaken;
    case 'Ungueltige Anmeldedaten':
      return l10n.invalidCredentials;
    case 'Benutzername darf nicht leer sein':
      return l10n.usernameCannotBeEmpty;
    case 'Nicht angemeldet':
      return l10n.notLoggedIn;
    case 'Ungültige E-Mail-Adresse':
      return l10n.invalidEmail;
    case 'Passwort muss mindestens 8 Zeichen haben':
      return l10n.passwordMinEight;
    case 'Benutzer nicht gefunden':
      return l10n.userNotFound;
    case 'Aktuelles Passwort ist falsch':
      return l10n.currentPasswordIncorrect;
    case 'Falsches Passwort':
      return l10n.wrongPassword;
    default:
      return error;
  }
}