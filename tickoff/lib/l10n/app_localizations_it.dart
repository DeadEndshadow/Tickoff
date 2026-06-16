// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Tickoff';

  @override
  String get home => 'Home';

  @override
  String get settings => 'Impostazioni';

  @override
  String get welcome => 'Benvenuto 👋';

  @override
  String get welcomeSubtitle =>
      'Tieni traccia delle punture di zecca e resta in salute.';

  @override
  String get myHistory => 'La mia cronologia';

  @override
  String get riskMap => 'Mappa del rischio';

  @override
  String get tipsAndInfo => 'Consigli e info';

  @override
  String get theme => 'Tema';

  @override
  String get selectTheme => 'Seleziona tema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get german => 'Tedesco';

  @override
  String get english => 'Inglese';

  @override
  String get french => 'Francese';

  @override
  String get italian => 'Italiano';

  @override
  String get notifications => 'Notifiche';

  @override
  String get notificationSettings => 'Impostazioni notifiche';

  @override
  String get account => 'Account';

  @override
  String get createAccount => 'Crea account';

  @override
  String get createAccountSubtitle =>
      'Registrati ora e sblocca tutte le funzionalità';

  @override
  String get login => 'Accedi';

  @override
  String get loginSubtitle => 'Hai già un account? Accedi qui';

  @override
  String get email => 'E-mail';

  @override
  String get username => 'Nome utente';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get logout => 'Disconnetti';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get logoutConfirmMessage => 'Vuoi davvero disconnetterti?';

  @override
  String get editEmail => 'Cambia e-mail';

  @override
  String get newEmail => 'Nuova e-mail';

  @override
  String get editUsername => 'Cambia nome utente';

  @override
  String get newUsername => 'Nuovo nome utente';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get minEightCharacters => 'Almeno 8 caratteri';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get password => 'Password';

  @override
  String get passwordsDoNotMatch => 'Le password non coincidono';

  @override
  String get passwordChangedSuccessfully => 'Password cambiata con successo';

  @override
  String get deleteAccountWarning =>
      'Questa azione non può essere annullata. Inserisci la tua password per confermare.';

  @override
  String get emailOrUsername => 'E-mail o nome utente';

  @override
  String get enterEmailOrUsername => 'Inserisci la tua e-mail o il nome utente';

  @override
  String get enterPassword => 'Inserisci la tua password';

  @override
  String get noAccountRegisterNow =>
      'Non hai ancora un account? Registrati ora';

  @override
  String get continueWithoutLogin => 'Continua senza accedere';

  @override
  String get usernameOptional => 'Nome utente (opzionale)';

  @override
  String get usernameMinThree =>
      'Il nome utente deve contenere almeno 3 caratteri';

  @override
  String get usernameAllowedChars => 'Sono consentiti solo lettere, numeri e _';

  @override
  String get enterEmail => 'Inserisci la tua e-mail';

  @override
  String get invalidEmail => 'Indirizzo e-mail non valido';

  @override
  String get passwordMinEight =>
      'La password deve contenere almeno 8 caratteri';

  @override
  String get alreadyRegisteredLogin =>
      'Hai già effettuato la registrazione? Accedi';

  @override
  String get emailAlreadyRegistered => 'E-mail già registrata';

  @override
  String get usernameAlreadyTaken => 'Nome utente già in uso';

  @override
  String get invalidCredentials => 'Credenziali non valide';

  @override
  String get usernameCannotBeEmpty => 'Il nome utente non può essere vuoto';

  @override
  String get notLoggedIn => 'Accesso non effettuato';

  @override
  String get userNotFound => 'Utente non trovato';

  @override
  String get currentPasswordIncorrect => 'La password attuale non è corretta';

  @override
  String get wrongPassword => 'Password errata';

  @override
  String errorWithDetails(Object details) {
    return 'Errore: $details';
  }

  @override
  String get aboutApp => 'Informazioni sull\'app';

  @override
  String get version => 'Versione';

  @override
  String get aboutDescription =>
      'Tickoff ti aiuta a documentare le punture di zecca e a identificare le aree a rischio.';

  @override
  String get close => 'Chiudi';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get register => 'Registrati';

  @override
  String get history => 'Cronologia';

  @override
  String get noEntries => 'Nessuna voce disponibile';

  @override
  String get addEntry => 'Aggiungi voce';

  @override
  String get date => 'Data';

  @override
  String get location => 'Luogo';

  @override
  String get notes => 'Note';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get tickBite => 'Puntura di zecca';

  @override
  String get symptoms => 'Sintomi';

  @override
  String get systemTheme => 'Sistema';

  @override
  String get newTickBiteTitle => 'Nuova puntura di zecca segnalata';

  @override
  String get newTickBiteMessage =>
      'Una nuova puntura di zecca è stata registrata con successo.';

  @override
  String get enableNotifications => 'Attiva notifiche';

  @override
  String get notificationsEnabledDesc =>
      'Ricevi notifiche per nuove punture di zecca';

  @override
  String get deleteEntryTitle => 'Eliminare la voce?';

  @override
  String get deleteEntryMessage =>
      'Vuoi davvero eliminare questa voce della puntura di zecca?';

  @override
  String get entryDeleted => 'Voce eliminata';

  @override
  String get errorDeleting => 'Errore durante l\'eliminazione';

  @override
  String get yourTickBites => 'Le tue punture di zecca';

  @override
  String timeAt(Object time) {
    return 'Ora: $time';
  }

  @override
  String coordinatesAt(Object coordinates) {
    return 'Coordinate: $coordinates';
  }

  @override
  String get yourReportDescription =>
      'Questa è la tua puntura di zecca segnalata. Puoi eliminarla.';

  @override
  String get communityReportDescription =>
      'Questa puntura di zecca è stata segnalata da un\'altra persona e non può essere eliminata da te.';

  @override
  String get deleteOwnTickBiteMessage =>
      'Vuoi davvero eliminare la tua puntura di zecca segnalata?';

  @override
  String get deleteNotAllowed => 'Puoi eliminare solo i tuoi marcatori.';

  @override
  String get noEntriesDescription =>
      'Segnala una puntura di zecca sulla mappa del rischio\nper vederla qui.';

  @override
  String get errorLoading => 'Errore durante il caricamento';

  @override
  String get successfullySaved => 'Salvato con successo!';

  @override
  String get tickBiteSavedMessage =>
      'La puntura di zecca è stata segnalata con successo e contrassegnata sulla mappa.';

  @override
  String get tapToMark => 'Tocca la mappa per segnare una puntura di zecca';

  @override
  String get locationLoading => 'Posizione in caricamento...';

  @override
  String get errorSaving => 'Errore durante il salvataggio';

  @override
  String get reportHere => 'Segnala qui';

  @override
  String get recognizeTicks => 'Riconoscere le zecche';

  @override
  String get recognizeTicksDesc =>
      'Le zecche sono piccoli aracnidi simili ai ragni (1-5 mm). Preferiscono zone del corpo calde e umide come ascelle, parte posteriore delle ginocchia e attaccatura dei capelli.';

  @override
  String get removeTick => 'Rimuovere la zecca';

  @override
  String get removeTickDesc =>
      '1. Usa una pinzetta o una pinza per zecche\n2. Afferra la zecca vicino alla pelle\n3. Tirala fuori lentamente e diritta\n4. Non torcere e non schiacciare\n5. Disinfetta la zona';

  @override
  String get whenToDoctor => 'Quando consultare un medico?';

  @override
  String get whenToDoctorDesc =>
      '• Il rossore si allarga in forma circolare (eritema migrante)\n• Sintomi simili all\'influenza dopo la puntura\n• Febbre, mal di testa o dolori muscolari\n• La zecca non può essere rimossa';

  @override
  String get prevention => 'Prevenzione';

  @override
  String get preventionDesc =>
      '• Indossa abiti lunghi in boschi e prati\n• Abiti chiari (le zecche sono più visibili)\n• Usa un repellente per zecche\n• Controlla il corpo dopo le attività all\'aperto\n• Vaccinazione TBE nelle aree a rischio';

  @override
  String get diseases => 'Malattie';

  @override
  String get diseasesDesc =>
      '• Malattia di Lyme: causata da batteri, curabile con antibiotici\n• TBE: causata da virus, è disponibile solo la protezione vaccinale\n• Non ogni puntura di zecca porta a una malattia';

  @override
  String get tickSize => 'Dimensioni: 1-5 mm (a digiuno) fino a 1 cm (gonfia)';

  @override
  String get tickLegs => '8 zampe (aracnide, non un insetto)';

  @override
  String get tickColor => 'Colore: da marrone a nero';

  @override
  String get tickPreferredSpots => 'Zone preferite: calde e umide';

  @override
  String get importantDontTwist => 'Importante: non torcere!';

  @override
  String get removeWithin24h => 'Tempo: rimuovere entro 24 ore';

  @override
  String get tickToolTweezer => 'Strumento: pinzetta o carta per zecche';

  @override
  String get disinfectAfterRemoval => 'Disinfetta dopo la rimozione';

  @override
  String get erythemaMigrans => '🔴 Eritema migrante (rossore circolare)';

  @override
  String get fluLikeSymptoms => '🔴 Sintomi simil-influenzali';

  @override
  String get jointPain => '🔴 Dolori articolari';

  @override
  String get paralysisSymptoms => '🔴 Sintomi di paralisi';

  @override
  String get feverAfterBite => '🔴 Febbre dopo la puntura di zecca';

  @override
  String get wearLongClothing => 'Indossa abiti lunghi e chiari';

  @override
  String get avoidTallGrass => 'Evita l\'erba alta';

  @override
  String get useRepellent => 'Usa un repellente';

  @override
  String get checkBody => 'Controlla il corpo';

  @override
  String get considerVaccination => 'Valuta la vaccinazione TBE';

  @override
  String get lymeDiseaseTitle => 'Malattia di Lyme';

  @override
  String get lymeDiseaseInfo =>
      '• Trasmissione: 12-24 ore dopo la puntura\n• Sintomo: eritema migrante\n• Trattamento: antibiotici\n• Vaccino: non disponibile';

  @override
  String get tbeTitle => 'TBE (encefalite da zecca)';

  @override
  String get tbeInfo =>
      '• Trasmissione: subito dopo la puntura\n• Sintomo: simil-influenzale, febbre\n• Trattamento: solo sintomatico\n• Vaccino: disponibile e raccomandato';

  @override
  String get riskAreasActivities => 'Aree a rischio e attività';

  @override
  String get highRisk => 'Rischio alto';

  @override
  String get mediumRisk => 'Rischio medio';

  @override
  String get lowRisk => 'Rischio basso';

  @override
  String get hikingTallGrass => 'Escursioni nell\'erba alta';

  @override
  String get forestEdges => 'Bordi del bosco e radure';

  @override
  String get undergrowth => 'Sottobosco e cespugli';

  @override
  String get parksGardens => 'Parchi e giardini';

  @override
  String get picnicMeadows => 'Picnic nei prati';

  @override
  String get joggingForest => 'Jogging nel bosco';

  @override
  String get maintainedLawns => 'Prati curati';

  @override
  String get pavedPaths => 'Sentieri asfaltati';

  @override
  String get indoors => 'Al chiuso';

  @override
  String get tickSeason => 'Stagione delle zecche';

  @override
  String get marchJune => 'Marzo - Giugno';

  @override
  String get mainSeason => 'Alta stagione';

  @override
  String get highestActivity => 'Attività massima';

  @override
  String get julyAugust => 'Luglio - Agosto';

  @override
  String get highSummer => 'Piena estate';

  @override
  String get mediumActivity => 'Attività media';

  @override
  String get septemberOctober => 'Settembre - Ottobre';

  @override
  String get autumn => 'Autunno';

  @override
  String get secondWave => 'Seconda ondata';

  @override
  String get novemberFebruary => 'Novembre - Febbraio';

  @override
  String get winter => 'Inverno';

  @override
  String get lowActivity => 'Attività bassa';

  @override
  String get inEmergencies => 'In caso di emergenza';

  @override
  String get medicalEmergency => 'Guardia medica: 116 117\nEmergenza: 112';

  @override
  String get seekHelpImmediately =>
      'Rivolgiti subito a un medico\nse sospetti TBE o sintomi gravi!';
}
