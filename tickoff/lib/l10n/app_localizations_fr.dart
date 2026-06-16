// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tickoff';

  @override
  String get home => 'Accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcome => 'Bienvenue 👋';

  @override
  String get welcomeSubtitle =>
      'Gardez un œil sur les morsures de tiques et restez en bonne santé.';

  @override
  String get myHistory => 'Mon Historique';

  @override
  String get riskMap => 'Carte des Risques';

  @override
  String get tipsAndInfo => 'Conseils & Infos';

  @override
  String get theme => 'Thème';

  @override
  String get selectTheme => 'Choisir le Thème';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Choisir la Langue';

  @override
  String get german => 'Allemand';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get italian => 'Italien';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationSettings => 'Paramètres de Notification';

  @override
  String get account => 'Compte';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createAccountSubtitle =>
      'Inscrivez-vous maintenant et utilisez toutes les fonctionnalités';

  @override
  String get login => 'Se connecter';

  @override
  String get loginSubtitle => 'Vous avez déjà un compte ? Connectez-vous ici';

  @override
  String get email => 'E-mail';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get logoutConfirmMessage => 'Voulez-vous vraiment vous déconnecter ?';

  @override
  String get editEmail => 'Modifier l\'e-mail';

  @override
  String get newEmail => 'Nouvel e-mail';

  @override
  String get editUsername => 'Modifier le nom d\'utilisateur';

  @override
  String get newUsername => 'Nouveau nom d\'utilisateur';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get minEightCharacters => 'Au moins 8 caractères';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordChangedSuccessfully => 'Mot de passe modifié avec succès';

  @override
  String get deleteAccountWarning =>
      'Cette action est irréversible. Veuillez saisir votre mot de passe pour confirmer.';

  @override
  String get emailOrUsername => 'E-mail ou nom d\'utilisateur';

  @override
  String get enterEmailOrUsername =>
      'Veuillez saisir votre e-mail ou votre nom d\'utilisateur';

  @override
  String get enterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get noAccountRegisterNow =>
      'Pas encore de compte ? Inscrivez-vous maintenant';

  @override
  String get continueWithoutLogin => 'Continuer sans se connecter';

  @override
  String get usernameOptional => 'Nom d\'utilisateur (facultatif)';

  @override
  String get usernameMinThree =>
      'Le nom d\'utilisateur doit contenir au moins 3 caractères';

  @override
  String get usernameAllowedChars =>
      'Seules les lettres, les chiffres et _ sont autorisés';

  @override
  String get enterEmail => 'Veuillez saisir votre e-mail';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get passwordMinEight =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get alreadyRegisteredLogin => 'Déjà inscrit ? Se connecter';

  @override
  String get emailAlreadyRegistered => 'E-mail déjà enregistré';

  @override
  String get usernameAlreadyTaken => 'Nom d\'utilisateur déjà utilisé';

  @override
  String get invalidCredentials => 'Identifiants invalides';

  @override
  String get usernameCannotBeEmpty =>
      'Le nom d\'utilisateur ne peut pas être vide';

  @override
  String get notLoggedIn => 'Non connecté';

  @override
  String get userNotFound => 'Utilisateur introuvable';

  @override
  String get currentPasswordIncorrect => 'Le mot de passe actuel est incorrect';

  @override
  String get wrongPassword => 'Mot de passe incorrect';

  @override
  String errorWithDetails(Object details) {
    return 'Erreur : $details';
  }

  @override
  String get aboutApp => 'À Propos';

  @override
  String get version => 'Version';

  @override
  String get aboutDescription =>
      'Tickoff vous aide à documenter les morsures de tiques et à identifier les zones à risque.';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get register => 'S\'inscrire';

  @override
  String get history => 'Historique';

  @override
  String get noEntries => 'Aucune entrée disponible';

  @override
  String get addEntry => 'Ajouter une Entrée';

  @override
  String get date => 'Date';

  @override
  String get location => 'Lieu';

  @override
  String get notes => 'Notes';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get tickBite => 'Morsure de Tique';

  @override
  String get symptoms => 'Symptômes';

  @override
  String get systemTheme => 'Système';

  @override
  String get newTickBiteTitle => 'Nouvelle Morsure de Tique Signalée';

  @override
  String get newTickBiteMessage =>
      'Une nouvelle morsure de tique a été enregistrée avec succès.';

  @override
  String get enableNotifications => 'Activer les Notifications';

  @override
  String get notificationsEnabledDesc =>
      'Recevez des notifications pour les nouvelles morsures de tiques';

  @override
  String get deleteEntryTitle => 'Supprimer l\'Entrée?';

  @override
  String get deleteEntryMessage =>
      'Voulez-vous vraiment supprimer cette entrée de morsure de tique?';

  @override
  String get entryDeleted => 'Entrée supprimée';

  @override
  String get errorDeleting => 'Erreur lors de la suppression';

  @override
  String get yourTickBites => 'Vos Morsures de Tiques';

  @override
  String timeAt(Object time) {
    return 'Heure : $time';
  }

  @override
  String coordinatesAt(Object coordinates) {
    return 'Coordonnées : $coordinates';
  }

  @override
  String get yourReportDescription =>
      'Il s\'agit de votre morsure de tique signalée. Vous pouvez la supprimer.';

  @override
  String get communityReportDescription =>
      'Cette morsure de tique a été signalée par une autre personne et ne peut pas être supprimée par vous.';

  @override
  String get deleteOwnTickBiteMessage =>
      'Voulez-vous vraiment supprimer votre morsure de tique signalée ?';

  @override
  String get deleteNotAllowed =>
      'Vous ne pouvez supprimer que vos propres marqueurs.';

  @override
  String get noEntriesDescription =>
      'Signalez une morsure de tique sur la carte des risques\npour la voir ici.';

  @override
  String get errorLoading => 'Erreur de chargement';

  @override
  String get successfullySaved => 'Enregistré avec succès!';

  @override
  String get tickBiteSavedMessage =>
      'La morsure de tique a été signalée avec succès et marquée sur la carte.';

  @override
  String get tapToMark =>
      'Appuyez sur la carte pour marquer une morsure de tique';

  @override
  String get locationLoading => 'Chargement de la localisation...';

  @override
  String get errorSaving => 'Erreur d\'enregistrement';

  @override
  String get reportHere => 'Signaler Ici';

  @override
  String get recognizeTicks => 'Reconnaître les Tiques';

  @override
  String get recognizeTicksDesc =>
      'Les tiques sont de petites créatures ressemblant à des araignées (1-5mm). Elles préfèrent les zones chaudes et humides du corps comme les aisselles, derrière les genoux et la racine des cheveux.';

  @override
  String get removeTick => 'Retirer la Tique';

  @override
  String get removeTickDesc =>
      '1. Utilisez une pince à tiques ou une pince\n2. Saisissez la tique près de la peau\n3. Tirez lentement et droit\n4. Ne pas tourner ou presser\n5. Désinfecter la zone';

  @override
  String get whenToDoctor => 'Quand Consulter un Médecin?';

  @override
  String get whenToDoctorDesc =>
      '• Rougeur se propage en cercle (érythème migrant)\n• Symptômes grippaux après la morsure\n• Fièvre, maux de tête ou douleurs corporelles\n• La tique ne peut pas être retirée';

  @override
  String get prevention => 'Prévention';

  @override
  String get preventionDesc =>
      '• Porter des vêtements longs en forêt et dans les prairies\n• Vêtements clairs (tiques plus visibles)\n• Utiliser un répulsif à tiques\n• Examiner le corps après une activité en plein air\n• Vaccination contre l\'encéphalite à tiques dans les zones à risque';

  @override
  String get diseases => 'Maladies';

  @override
  String get diseasesDesc =>
      '• Maladie de Lyme: Causée par des bactéries, traitable avec des antibiotiques\n• Encéphalite à tiques: Causée par des virus, seule la vaccination protège\n• Toutes les morsures de tiques ne conduisent pas à une maladie';

  @override
  String get tickSize => 'Taille: 1-5mm (non remplie) à 1cm (gorgée)';

  @override
  String get tickLegs => '8 pattes (arachnide, pas un insecte)';

  @override
  String get tickColor => 'Couleur: brun à noir';

  @override
  String get tickPreferredSpots => 'Endroits préférés: chaud & humide';

  @override
  String get importantDontTwist => 'Important: Ne pas tourner!';

  @override
  String get removeWithin24h => 'Temps: Retirer dans les 24h';

  @override
  String get tickToolTweezer => 'Outil: Pince à tiques ou carte';

  @override
  String get disinfectAfterRemoval => 'Désinfecter après retrait';

  @override
  String get erythemaMigrans => '🔴 Érythème migrant (rougeur circulaire)';

  @override
  String get fluLikeSymptoms => '🔴 Symptômes grippaux';

  @override
  String get jointPain => '🔴 Douleurs articulaires';

  @override
  String get paralysisSymptoms => '🔴 Symptômes de paralysie';

  @override
  String get feverAfterBite => '🔴 Fièvre après morsure';

  @override
  String get wearLongClothing => 'Porter des vêtements longs et clairs';

  @override
  String get avoidTallGrass => 'Éviter les hautes herbes';

  @override
  String get useRepellent => 'Utiliser un répulsif';

  @override
  String get checkBody => 'Examiner le corps';

  @override
  String get considerVaccination => 'Envisager la vaccination FSME';

  @override
  String get lymeDiseaseTitle => 'Maladie de Lyme';

  @override
  String get lymeDiseaseInfo =>
      '• Transmission: 12-24h après morsure\n• Symptôme: Érythème migrant\n• Traitement: Antibiotiques\n• Vaccin: Non disponible';

  @override
  String get tbeTitle => 'FSME (Encéphalite à tiques)';

  @override
  String get tbeInfo =>
      '• Transmission: Immédiatement après morsure\n• Symptôme: Grippal, fièvre\n• Traitement: Seulement symptomatique\n• Vaccin: Disponible & recommandé';

  @override
  String get riskAreasActivities => 'Zones à Risque & Activités';

  @override
  String get highRisk => 'Risque Élevé';

  @override
  String get mediumRisk => 'Risque Moyen';

  @override
  String get lowRisk => 'Risque Faible';

  @override
  String get hikingTallGrass => 'Randonnée dans hautes herbes';

  @override
  String get forestEdges => 'Lisières de forêt & clairières';

  @override
  String get undergrowth => 'Sous-bois & buissons';

  @override
  String get parksGardens => 'Parcs & jardins';

  @override
  String get picnicMeadows => 'Pique-nique dans les prairies';

  @override
  String get joggingForest => 'Jogging en forêt';

  @override
  String get maintainedLawns => 'Pelouses entretenues';

  @override
  String get pavedPaths => 'Chemins pavés';

  @override
  String get indoors => 'Intérieurs';

  @override
  String get tickSeason => 'Saison des Tiques';

  @override
  String get marchJune => 'Mars - Juin';

  @override
  String get mainSeason => 'Saison Principale';

  @override
  String get highestActivity => 'Activité Maximale';

  @override
  String get julyAugust => 'Juillet - Août';

  @override
  String get highSummer => 'Plein Été';

  @override
  String get mediumActivity => 'Activité Moyenne';

  @override
  String get septemberOctober => 'Septembre - Octobre';

  @override
  String get autumn => 'Automne';

  @override
  String get secondWave => 'Deuxième Vague';

  @override
  String get novemberFebruary => 'Novembre - Février';

  @override
  String get winter => 'Hiver';

  @override
  String get lowActivity => 'Activité Faible';

  @override
  String get inEmergencies => 'En Cas d\'Urgence';

  @override
  String get medicalEmergency =>
      'Service médical d\'urgence: 116 117\nUrgence: 112';

  @override
  String get seekHelpImmediately =>
      'Consultez immédiatement un médecin\nen cas de suspicion de FSME ou de symptômes graves!';
}
