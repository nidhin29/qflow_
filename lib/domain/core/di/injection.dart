import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:qflow/domain/core/di/injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureInjection() async {
  getIt.init();
}
