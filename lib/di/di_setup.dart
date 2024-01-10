import 'package:get_it/get_it.dart';
import 'package:orm_forecast/data/data_source/api.dart';
import 'package:orm_forecast/data/data_source/http_api.dart';
import 'package:orm_forecast/data/repository/forecast_meteo_repository.dart';
import 'package:orm_forecast/domain/repository/forecast_repository.dart';
import 'package:orm_forecast/domain/use_case/get_forecast_use_case.dart';
import 'package:orm_forecast/presenter/main/main_view_model.dart';

final getIt = GetIt.instance;

void diSetup() {
  getIt.registerSingleton<Api>(HttpApi());
  getIt.registerSingleton<ForecastRepository>(ForecastMeteoRepository(api: getIt<Api>()));
  getIt.registerSingleton<GetForecastUseCase>(GetForecastUseCase(forecastRepository: getIt<ForecastRepository>()));
  getIt.registerFactory<MainViewModel>(() => MainViewModel(getForecastUseCase: getIt<GetForecastUseCase>()));
}