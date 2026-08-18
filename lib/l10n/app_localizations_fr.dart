// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Retro';

  @override
  String get home_createOption => 'Créer un OTR / O2R';

  @override
  String get home_createOptionSubtitle => 'Créer un OTR / O2R pour SoH';

  @override
  String get home_inspectOption => 'Inspecter un OTR / O2R';

  @override
  String get home_inspectOptionSubtitle =>
      'Inspecter le contenu d\'un OTR / O2R';

  @override
  String get createSelectionScreen_title => 'Création d\'un OTR / O2R';

  @override
  String get createSelectionScreen_subtitle =>
      'Sélectionnez le type d\'OTR / O2R que vous souhaitez créer';

  @override
  String get createSelectionScreen_nonHdTex => 'Remplacer les textures';

  @override
  String get createSelectionScreen_customSequences =>
      'Séquences personnalisées';

  @override
  String get createSelectionScreen_custom => 'Personnalisé';

  @override
  String get createReplaceTexturesScreen_Option => 'Remplacer les textures';

  @override
  String get createReplaceTexturesScreen_OptionDescription =>
      'Remplacer les textures d\'un OTR / O2R par des textures personnalisées';

  @override
  String get questionContentView_mainQuestion =>
      'Avez-vous déjà un dossier de remplacement de texture?';

  @override
  String get questionContentView_mainText =>
      'Si vous avez déjà un dossier de remplacement généré par cet outil, sélectionnez Oui.\nSi vous n\'en avez pas, sélectionnez Non et nous vous aiderons à générer un dossier.';

  @override
  String get questionContentView_yes => 'Oui';

  @override
  String get questionContentView_no => 'Non';

  @override
  String get otrContentView_otrPath => 'Chemin de l\'OTR / O2R';

  @override
  String get otrContentView_otrSelect => 'Sélectionner';

  @override
  String get otrContentView_details => 'Details';

  @override
  String get otrContentView_step1 =>
      '1. Sélectionnez l\'OTR / O2R à partir duquel vous souhaitez remplacer les textures.';

  @override
  String get otrContentView_step2 =>
      '2. Nous extrayons les assets de texture en PNG avec une structure de dossier correcte.';

  @override
  String get otrContentView_step3 =>
      '3. Vous remplacez les textures dans ce dossier d\'extraction';

  @override
  String get otrContentView_step4 =>
      '4. Exécutez à nouveau l\'opération et choisissez votre dossier d\'extraction';

  @override
  String get otrContentView_step5 =>
      '5. Nous générons un OTR / O2R avec les textures modifiées! 🚀';

  @override
  String get otrContentView_processing => 'Traitement en cours...';

  @override
  String get folderContentView_customTexturePath =>
      'Dossier de remplacements de textures personnalisées';

  @override
  String get folderContentView_prependAltToggle =>
      'Ajouter un dossier `alt/` à votre OTR / O2R. Permet aux joueurs d\'activer ou désactiver les assets en jeu.';

  @override
  String get folderContentView_compressToggle =>
      'Compresser les fichiers. Cela réduira la taille de l\'OTR / O2R.';

  @override
  String get folderContentView_keepFolderOpenToggle =>
      'Garder le dossier ouvert après l\'indexation. Retro recherchera à nouveau les modifications au lieu de revenir au menu principal.';

  @override
  String get folderContentView_selectButton => 'Sélectionner';

  @override
  String get folderContentView_stageTextures => 'Indexer les textures';

  @override
  String get createCustomSequences_addCustomSequences =>
      'Ajouter des séquences personnalisées';

  @override
  String get createCustomSequences_addCustomSequencesDescription =>
      'Sélectionnez un dossier contenant des séquences et des fichiers méta';

  @override
  String get createCustomSequences_SequencesFolderPath =>
      'Chemin du dossier des séquences';

  @override
  String get createCustomSequences_selectButton => 'Sélectionner';

  @override
  String get createCustomSequences_stageFiles => 'Indexer les fichiers';

  @override
  String get createCustomSequences_keepFolderOpenToggle =>
      'Garder le dossier ouvert après l\'indexation. Retro recherchera à nouveau les modifications au lieu de revenir au menu principal.';

  @override
  String get createFinishScreen_finish => 'Terminer';

  @override
  String get createFinishScreen_finishSubtitle =>
      'Vérifiez les détails de votre OTR / O2R';

  @override
  String get createFinishScreen_generateOtr => 'Générer l\'OTR / O2R';

  @override
  String get components_ephemeralBar_finalizeOtr => 'Finaliser l\'OTR / O2R ⚡️';

  @override
  String get createCustomScreen_title => 'OTR / O2R Personnalisé par le chemin';

  @override
  String get createCustomScreen_subtitle =>
      'Sélectionnez les fichiers à placer dans le chemin';

  @override
  String get createCustomScreen_labelPath => 'Chemin';

  @override
  String get createCustomScreen_selectButton => 'Sélectionnez les fichiers';

  @override
  String get createCustomScreen_fileToInsert => 'Fichiers à ajouter: ';

  @override
  String get createCustomScreen_stageFiles => 'Indexer les fichiers';

  @override
  String get createCustomScreen_keepFolderOpenToggle =>
      'Garder le dossier ouvert après l\'indexation. Retro recherchera à nouveau les modifications au lieu de revenir au menu principal.';

  @override
  String get inspectOtrScreen_inspectOtr => 'Inspecter un OTR / O2R';

  @override
  String get inspectOtrScreen_inspectOtrSubtitle =>
      'Inspecter le contenu d\'un OTR / O2R';

  @override
  String get inspectOtrScreen_noOtrSelected => 'Aucun OTR / O2R sélectionné';

  @override
  String get inspectOtrScreen_selectButton => 'Sélectionner';

  @override
  String get inspectOtrScreen_search => 'Rechercher';

  @override
  String get gameSelectionScreen_title => 'Outils Spécifiques au Jeu';

  @override
  String get gameSelectionScreen_subtitle =>
      'Sélectionnez le jeu pour lequel vous souhaitez créer une sélection';

  @override
  String get gameSelectionScreenSoh_title => 'Ship of Harkinian';

  @override
  String get gameSelectionScreenSoh_subtitle =>
      'Sélectionnez l\'outil que vous souhaitez utiliser';

  @override
  String get sohCreateDebugFontScreen_title =>
      'Générateur de Police de Débogage';

  @override
  String get sohCreateDebugFontScreen_subtitle =>
      'Convertit et génère des polices pour le sélecteur de cartes du soh';

  @override
  String get gameSelectionScreen2Ship_title => '2 Ship 2 Harkinian';

  @override
  String get gameSelectionScreen2Ship_subtitle =>
      'Sélectionnez l\'outil que vous souhaitez utiliser';

  @override
  String get gameSelection2ShipComingSoon_text =>
      'Les outils 2 Ship 2 Harkinian arrivent bientôt!';

  @override
  String get extractModsWarning_part1 => 'Extraire des mods déjà existants';

  @override
  String get extractModsWarning_part2 => 'Ça pourrait ne pas fonctionner.';
}
