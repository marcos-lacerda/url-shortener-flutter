import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class UrlLauncherLinkOpener {
  const UrlLauncherLinkOpener();

  Future<bool> open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
