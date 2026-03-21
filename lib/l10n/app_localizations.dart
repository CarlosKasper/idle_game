import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the i18n library's `Locale` values
/// in the app's `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(title: AppLocalizations.of(context)!.helloWorld),
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
///   # Internationalization and localization support.
///   intl: any # Use the pinned version from flutter_localizations
/// ```
///
/// ## iOS/macOS
///
/// For iOS/macOS, the language code needs to be updated in the
/// ios/Runner/Info.plist and macos/Runner/Info.plist files to include
/// the languages defined in `AppLocalizations.supportedLocales`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
      <LocalizationsDelegate<dynamic>>[delegate];

  /// A list of this localizations' supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  // App titles and basic
  String get appName;
  String get appTitle;

  // Home Screen
  String get homeScreenTitle;
  String get workButtonLabel;
  String get careerLevel;
  String get totalEarned;

  // Career
  String get careerTitle;
  String get currentLevel;
  String get incomePerClick;
  String get unlocked;
  String get locked;
  String get unlockAt;
  String get noUpgrades;
  String get noUpgradesDescription;
  String get upgrades;
  String get buy;
  String get purchased;
  String get maxAll;

  // Notebook
  String get notebookTitle;
  String get currentNotebook;
  String get level;
  String get nextEvolution;
  String get maxLevelReached;
  String get evolve;
  String get cost;

  // Stats
  String get statsTitle;
  String get sessionInfo;
  String get sessionDuration;
  String get totalClicks;
  String get totalEarnings;
  String get careerInfo;
  String get upgradeStats;

  // Shop
  String get shopTitle;
  String get buffsAndRewards;
  String get processing;
  String get success;
  String get activated;
  String get buyButton;

  // Bonuses
  String get incomeBonus;
  String get clickBonus;
  String get incomeBonusDescription;
  String get clickBonusDescription;

  // CEO
  String get becomeCEO;
  String get ceoTitle;
  String get ceoDescription;

  // Settings
  String get settingsTitle;
  String get appearance;
  String get darkMode;
  String get lightMode;
  String get systemDefault;
  String get about;
  String get version;
  String get developedWith;
  String get resetGame;
  String get resetGameConfirmation;
  String get cancel;
  String get confirm;

  // Errors and messages
  String get insufficientFunds;
  String get errorOccurred;
  String get successMessage;
  String get systemLatency;

  // Notebook Screen
  String get notebookExe;
  String get currentBonuses;
  String get perClick;
  String get perSecond;
  String get nextEvolutionLabel;
  String get costLabel;
  String get evolveNow;
  String get insufficientMoney;
  String get maxLevelLabel;
  String get allEvolutionsUnlocked;
  String get allEvolutions;

  // Notebook Evolutions
  String get notebookBasicName;
  String get notebookBasicDesc;
  String get notebookUpdatedName;
  String get notebookUpdatedDesc;
  String get notebookProfessionalName;
  String get notebookProfessionalDesc;
  String get workstationName;
  String get workstationDesc;
  String get superWorkstationName;
  String get superWorkstationDesc;
  String get gamingRigName;
  String get gamingRigDesc;
  String get serverRoomName;
  String get serverRoomDesc;
  String get dataCenterName;
  String get dataCenterDesc;
  String get quantumComputerName;
  String get quantumComputerDesc;
  String get superintelligenceName;
  String get superintelligenceDesc;
  String get systemBuild;
  String get systemAutomatic;
  String get systemFollowDevice;
  String get gameSection;
  String get multiplier;
  String get passiveIncomePerSecond;
  String get profileExe;
  String get noUnlockedCareers;
  String get resetGameDescription;
  String get lightModeDescription;
  String get darkModeDescription;

  // Home Screen - Additional
  String get levelShort;
  String get currentBalance;
  String get statusActive;
  String get online;
  String get clickToEarn;
  String get activeBonuses;
  String get earningsAndMultipliers;
  String get earnPerClick;
  String get autoEarningsPerSecond;
  String get totalEarnedLabel;

  // Bottom Navigation
  String get navHome;
  String get navNotebook;
  String get navCareer;
  String get navStats;
  String get navShop;

  // Additional Shop
  String get watchButton;

  // Theme Options
  String get automatic;
  String get bright;
  String get dark;
  String get followDeviceSetting;
  String get whiteBackgroundDarkText;
  String get blackBackgroundLightText;
  String get resetGameButtonTitle;
  String get resetGameButtonSubtitle;

  // Career Upgrades (Level 0-1)
  String get careerCourseName;
  String get careerCourseDesc;
  String get careerMonitorName;
  String get careerMonitorDesc;
  String get careerCoffeeName;
  String get careerCoffeeDesc;
  String get careerLampName;
  String get careerLampDesc;

  // Career Upgrades (Level 2-3)
  String get careerSecondMonitorName;
  String get careerSecondMonitorDesc;
  String get careerAppName;
  String get careerAppDesc;
  String get careerDeskName;
  String get careerDeskDesc;
  String get careerMentorshipName;
  String get careerMentorshipDesc;

  // Career Upgrades (Level 4-5)
  String get careerOfficeName;
  String get careerOfficeDesc;
  String get careerStockName;
  String get careerStockDesc;
  String get careerTeamName;
  String get careerTeamDesc;
  String get careerLabName;
  String get careerLabDesc;

  // Career Upgrades (Level 6-7)
  String get careerConsultingName;
  String get careerConsultingDesc;
  String get careerPatentName;
  String get careerPatentDesc;
  String get careerAutomationName;
  String get careerAutomationDesc;
  String get careerNetworkName;
  String get careerNetworkDesc;

  // Career Upgrades (Level 8-10)
  String get careerJetName;
  String get careerJetDesc;
  String get careerMarketName;
  String get careerMarketDesc;
  String get careerGlobalName;
  String get careerGlobalDesc;
  String get careerEmpireName;
  String get careerEmpireDesc;
  String get careerPrinterName;
  String get careerPrinterDesc;
  String get careerDominationName;
  String get careerDominationDesc;

  // Career Levels
  String get careerLevelIntern;
  String get careerLevelJunior;
  String get careerLevelPleno;
  String get careerLevelPlenoPlus;
  String get careerLevelSenior;
  String get careerLevelEngineeringLead;
  String get careerLevelArchitect;
  String get careerLevelProjectManager;
  String get careerLevelDirector;
  String get careerLevelExecutive;
  String get careerLevelCEO;

  // Stats Screen - Activity
  String get activity;
  String get purchasedUpgrades;
  String get bonuses;

  // Shop Screen
  String get watchAd;
  String get buyFor;
  String get watch;

  // Career Info
  String get next;

  // Shop Screen - Product Names & Descriptions
  String get multiplier2x;
  String get multiplier3x;
  String get multiplier5x;
  String get clicks2x;
  String get buffAllInOne;
  String get moneyBonus;
  String get purchaseSuccessful;

  // Shop Screen - Product Descriptions
  String get multiplier2xDesc;
  String get multiplier3xDesc;
  String get multiplier5xDesc;
  String get clicks2xDesc;
  String get buffAllInOneDesc;
  String get moneyBonusDesc;
  String get becomeCEODesc;

  // Shop Screen - Durations
  String get oneHour;
  String get twoHours;
  String get sixHours;
  String get thirtyMin;
  String get permanent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(_initializeMessages(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations _initializeMessages(Locale locale) {
  final String localeName = intl.Intl.canonicalizedLocale(locale.toString());
  intl.Intl.defaultLocale = localeName;

  switch (locale.languageCode) {
    case 'pt':
      return AppLocalizationsPt(localeName);
    case 'en':
    default:
      return AppLocalizationsEn(localeName);
  }
}
