import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Link Shortener'**
  String get appTitle;

  /// No description provided for @ls_inputHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type a URL'**
  String get ls_inputHint;

  /// No description provided for @ls_emptyState_title.
  ///
  /// In en, this message translates to:
  /// **'No links yet'**
  String get ls_emptyState_title;

  /// No description provided for @ls_emptyState_message.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t shortened any links yet. Start now!'**
  String get ls_emptyState_message;

  /// No description provided for @ls_errorInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get ls_errorInvalidUrl;

  /// No description provided for @ls_list_title.
  ///
  /// In en, this message translates to:
  /// **'Recently shortened URLs'**
  String get ls_list_title;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was canceled. Please try again.'**
  String get errorCancelled;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t process your request. Please review the information and try again.'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You don’t have permission to perform this action.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find what you’re looking for.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorHttpUnexpectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Unexpected response from the server.'**
  String get errorHttpUnexpectedStatus;

  /// No description provided for @errorMalformedResponse.
  ///
  /// In en, this message translates to:
  /// **'We received an unexpected response format.'**
  String get errorMalformedResponse;

  /// No description provided for @errorMissingFieldUrl.
  ///
  /// In en, this message translates to:
  /// **'The server response is missing the URL field.'**
  String get errorMissingFieldUrl;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorUnexpectedWithDetail.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorUnexpectedWithDetail;

  /// No description provided for @errorInvalidUrlEmpty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a URL.'**
  String get errorInvalidUrlEmpty;

  /// No description provided for @errorInvalidUrlFormat.
  ///
  /// In en, this message translates to:
  /// **'The URL format is invalid.'**
  String get errorInvalidUrlFormat;

  /// No description provided for @errorInvalidUrlScheme.
  ///
  /// In en, this message translates to:
  /// **'The URL must start with http:// or https://'**
  String get errorInvalidUrlScheme;

  /// No description provided for @errorInvalidUrlHostEmpty.
  ///
  /// In en, this message translates to:
  /// **'The URL must contain a valid host.'**
  String get errorInvalidUrlHostEmpty;

  /// No description provided for @errorInvalidUrlDomain.
  ///
  /// In en, this message translates to:
  /// **'The URL domain seems invalid.'**
  String get errorInvalidUrlDomain;

  /// No description provided for @errorInvalidUrlLocalhost.
  ///
  /// In en, this message translates to:
  /// **'Local URLs are not allowed.'**
  String get errorInvalidUrlLocalhost;

  /// No description provided for @errorInvalidUrlLength.
  ///
  /// In en, this message translates to:
  /// **'The URL length is invalid.'**
  String get errorInvalidUrlLength;

  /// No description provided for @errorOpenUrlFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the URL'**
  String get errorOpenUrlFailed;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt': {
  switch (locale.countryCode) {
    case 'BR': return AppLocalizationsPtBr();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
