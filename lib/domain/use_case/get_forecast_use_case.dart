import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';
import 'package:orm_forecast/domain/repository/forecast_repository.dart';

class GetForecastUseCase {
  final ForecastRepository _forecastRepository;

  GetForecastUseCase({required ForecastRepository forecastRepository}) : _forecastRepository = forecastRepository;

  Future<Result<List<ForecastModel>>> execute(double latitude, double longitude) {
    return _forecastRepository.getForecasts(latitude, longitude);
  }
}