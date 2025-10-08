// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../core/services/link_opener.dart' as _i61;
import '../../core/services/log_service.dart' as _i357;
import '../../features/link_shortener/data/repositories/alias_repository_impl.dart'
    as _i700;
import '../../features/link_shortener/domain/repositories/alias_repository.dart'
    as _i142;
import '../../features/link_shortener/domain/usecases/get_alias.dart' as _i959;
import '../../features/link_shortener/domain/usecases/shorten_url.dart'
    as _i929;
import '../../features/link_shortener/presentation/controllers/link_shortener_controller.dart'
    as _i244;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final dioInjectableModule = _$DioInjectableModule();
  gh.factory<_i61.UrlLauncherLinkOpener>(
    () => const _i61.UrlLauncherLinkOpener(),
  );
  gh.factory<_i361.BaseOptions>(() => dioInjectableModule.options);
  gh.lazySingleton<_i357.LogService>(() => const _i357.LogService());
  gh.lazySingleton<_i361.Dio>(() => dioInjectableModule.dio);
  gh.lazySingleton<_i142.IAliasRepository>(
    () => _i700.AliasRepositoryImpl(
      dio: gh<_i361.Dio>(),
      log: gh<_i357.LogService>(),
    ),
  );
  gh.factory<_i959.GetAlias>(
    () => _i959.GetAlias(gh<_i142.IAliasRepository>()),
  );
  gh.factory<_i929.ShortenUrl>(
    () => _i929.ShortenUrl(gh<_i142.IAliasRepository>()),
  );
  gh.factory<_i244.LinkShortenerController>(
    () => _i244.LinkShortenerController(
      gh<_i929.ShortenUrl>(),
      gh<_i61.UrlLauncherLinkOpener>(),
    ),
  );
  return getIt;
}

class _$DioInjectableModule extends _i464.DioInjectableModule {}
