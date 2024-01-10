import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';

abstract interface class ForecastRepository {
  Future<Result<List<ForecastModel>>> getForecasts(double latitude, double longitude);
}