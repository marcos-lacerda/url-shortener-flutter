// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Encurtador de Links';

  @override
  String get ls_inputHint => 'Cole ou digite uma URL';

  @override
  String get ls_emptyState_title => 'Nenhum link ainda';

  @override
  String get ls_emptyState_message => 'Você ainda não encurtou nenhum link. Comece agora mesmo!';

  @override
  String get ls_errorInvalidUrl => 'Informe uma URL válida';

  @override
  String get ls_list_title => 'URLs encurtadas recentemente';

  @override
  String get errorNetwork => 'Sem ligação à internet. Verifique a sua rede e tente novamente.';

  @override
  String get errorTimeout => 'O pedido demorou demasiado tempo. Tente novamente.';

  @override
  String get errorCancelled => 'O pedido foi cancelado. Tente novamente.';

  @override
  String get errorBadRequest => 'Não foi possível processar o seu pedido. Reveja a informação e tente novamente.';

  @override
  String get errorUnauthorized => 'Não tem permissão para realizar esta ação.';

  @override
  String get errorNotFound => 'Não encontrámos o que procura.';

  @override
  String get errorServer => 'O serviço está indisponível de momento. Tente novamente mais tarde.';

  @override
  String get errorHttpUnexpectedStatus => 'Resposta inesperada do servidor.';

  @override
  String get errorMalformedResponse => 'Recebemos um formato de resposta inesperado.';

  @override
  String get errorMissingFieldUrl => 'A resposta do servidor não contém o campo de URL.';

  @override
  String get errorUnexpected => 'Ocorreu um erro. Tente novamente.';

  @override
  String get errorUnexpectedWithDetail => 'Ocorreu um erro';

  @override
  String get errorInvalidUrlEmpty => 'Introduza um URL.';

  @override
  String get errorInvalidUrlFormat => 'O formato do URL é inválido.';

  @override
  String get errorInvalidUrlScheme => 'O URL deve começar por http:// ou https://';

  @override
  String get errorInvalidUrlHostEmpty => 'O URL deve conter um host válido.';

  @override
  String get errorInvalidUrlDomain => 'O domínio do URL parece inválido.';

  @override
  String get errorInvalidUrlLocalhost => 'URLs locais não são permitidas.';

  @override
  String get errorInvalidUrlLength => 'O tamanho do URL é inválido.';

  @override
  String get errorOpenUrlFailed => 'Não foi possível abrir o URL';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr(): super('pt_BR');

  @override
  String get appTitle => 'Encurtador de Links';

  @override
  String get ls_inputHint => 'Cole ou digite uma URL';

  @override
  String get ls_emptyState_title => 'Nenhum link ainda';

  @override
  String get ls_emptyState_message => 'Você ainda não encurtou nenhum link. Comece agora mesmo!';

  @override
  String get ls_errorInvalidUrl => 'Informe uma URL válida';

  @override
  String get ls_list_title => 'URLs encurtadas recentemente';

  @override
  String get errorNetwork => 'Sem conexão com a internet. Verifique sua rede e tente novamente.';

  @override
  String get errorTimeout => 'A requisição demorou demais. Tente novamente.';

  @override
  String get errorCancelled => 'A requisição foi cancelada. Tente novamente.';

  @override
  String get errorBadRequest => 'Não foi possível processar sua solicitação. Revise as informações e tente novamente.';

  @override
  String get errorUnauthorized => 'Você não tem permissão para realizar esta ação.';

  @override
  String get errorNotFound => 'Não encontramos o que você procura.';

  @override
  String get errorServer => 'O serviço está indisponível no momento. Tente novamente mais tarde.';

  @override
  String get errorHttpUnexpectedStatus => 'Resposta inesperada do servidor.';

  @override
  String get errorMalformedResponse => 'Recebemos um formato de resposta inesperado.';

  @override
  String get errorMissingFieldUrl => 'A resposta do servidor não contém o campo de URL.';

  @override
  String get errorUnexpected => 'Algo deu errado. Tente novamente.';

  @override
  String get errorUnexpectedWithDetail => 'Algo deu errado:';

  @override
  String get errorInvalidUrlEmpty => 'Informe uma URL.';

  @override
  String get errorInvalidUrlFormat => 'O formato da URL é inválido.';

  @override
  String get errorInvalidUrlScheme => 'A URL deve começar com http:// ou https://';

  @override
  String get errorInvalidUrlHostEmpty => 'A URL deve conter um host válido.';

  @override
  String get errorInvalidUrlDomain => 'O domínio da URL parece inválido.';

  @override
  String get errorInvalidUrlLocalhost => 'URLs locais não são permitidas.';

  @override
  String get errorInvalidUrlLength => 'O tamanho da URL é inválido.';

  @override
  String get errorOpenUrlFailed => 'Não foi possível abrir a URL';
}
