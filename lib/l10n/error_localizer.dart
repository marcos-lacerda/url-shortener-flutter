import 'package:url_shortener/l10n/app_localizations.dart';

class ErrorLocalizer {
  const ErrorLocalizer(this.l10n);
  final AppLocalizations l10n;

  String byCode(String code, {Map<String, String>? args}) {
    switch (code) {
      case 'errorNetwork':
        return l10n.errorNetwork;
      case 'errorTimeout':
        return l10n.errorTimeout;
      case 'errorCancelled':
        return l10n.errorCancelled;
      case 'errorBadRequest':
        return l10n.errorBadRequest;
      case 'errorUnauthorized':
        return l10n.errorUnauthorized;
      case 'errorNotFound':
        return l10n.errorNotFound;
      case 'errorServer':
        return l10n.errorServer;
      case 'errorMalformedResponse':
        return l10n.errorMalformedResponse;
      case 'errorMissingFieldUrl':
        return l10n.errorMissingFieldUrl;
      case 'errorInvalidUrlEmpty':
        return l10n.errorInvalidUrlEmpty;
      case 'errorInvalidUrlFormat':
        return l10n.errorInvalidUrlFormat;
      case 'errorInvalidUrlScheme':
        return l10n.errorInvalidUrlScheme;
      case 'errorInvalidUrlHostEmpty':
        return l10n.errorInvalidUrlHostEmpty;
      case 'errorInvalidUrlDomain':
        return l10n.errorInvalidUrlDomain;
      case 'errorInvalidUrlLocalhost':
        return l10n.errorInvalidUrlLocalhost;
      case 'errorInvalidUrlLength':
        return l10n.errorInvalidUrlLength;
      case 'errorHttpUnexpectedStatus':
        return l10n.errorHttpUnexpectedStatus;
      case 'errorUnexpectedWithDetail':
        return l10n.errorUnexpectedWithDetail;
      case 'errorOpenUrlFailed':
        return l10n.errorOpenUrlFailed;
      default:
        return l10n.errorUnexpected;
    }
  }
}
