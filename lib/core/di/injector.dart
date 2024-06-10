import 'package:dsplus_finance/core/di/injector.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(preferRelativeImports: true)
GetIt configInjector() => getIt.init();
