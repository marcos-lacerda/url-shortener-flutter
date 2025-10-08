// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Link Shortener';

  @override
  String get ls_inputHint => 'Paste or type a URL';

  @override
  String get ls_emptyState_title => 'No links yet';

  @override
  String get ls_emptyState_message => 'You haven\'t shortened any links yet. Start now!';

  @override
  String get ls_errorInvalidUrl => 'Please enter a valid URL';

  @override
  String get ls_list_title => 'Recently shortened URLs';

  @override
  String get errorNetwork => 'No internet connection. Please check your network and try again.';

  @override
  String get errorTimeout => 'The request took too long. Please try again.';

  @override
  String get errorCancelled => 'The request was canceled. Please try again.';

  @override
  String get errorBadRequest => 'We couldn\'t process your request. Please review the information and try again.';

  @override
  String get errorUnauthorized => 'You don’t have permission to perform this action.';

  @override
  String get errorNotFound => 'We couldn’t find what you’re looking for.';

  @override
  String get errorServer => 'The service is currently unavailable. Please try again later.';

  @override
  String get errorHttpUnexpectedStatus => 'Unexpected response from the server.';

  @override
  String get errorMalformedResponse => 'We received an unexpected response format.';

  @override
  String get errorMissingFieldUrl => 'The server response is missing the URL field.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorUnexpectedWithDetail => 'Something went wrong';

  @override
  String get errorInvalidUrlEmpty => 'Please enter a URL.';

  @override
  String get errorInvalidUrlFormat => 'The URL format is invalid.';

  @override
  String get errorInvalidUrlScheme => 'The URL must start with http:// or https://';

  @override
  String get errorInvalidUrlHostEmpty => 'The URL must contain a valid host.';

  @override
  String get errorInvalidUrlDomain => 'The URL domain seems invalid.';

  @override
  String get errorInvalidUrlLocalhost => 'Local URLs are not allowed.';

  @override
  String get errorInvalidUrlLength => 'The URL length is invalid.';

  @override
  String get errorOpenUrlFailed => 'Could not open the URL';
}
