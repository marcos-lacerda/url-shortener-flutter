import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:url_shortener/app/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  initGetIt(getIt);
}

@module
abstract class DioInjectableModule {
  final options = BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  );

  @lazySingleton
  Dio get dio => Dio(options);
}
