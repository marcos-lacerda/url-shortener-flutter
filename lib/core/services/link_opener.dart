import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: one_member_abstracts, Necessário para o contrato de Injeção de Dependência
abstract class ILinkOpener {
  Future<bool> open(Uri uri);
}

@Injectable(as: ILinkOpener)
class UrlLauncherLinkOpener implements ILinkOpener {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
