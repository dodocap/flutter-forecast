import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';
import 'package:orm_forecast/domain/repository/forecast_repository.dart';

class GetForecastUseCase {
  final ForecastRepository _forecastRepository;

  GetForecastUseCase({required ForecastRepository forecastRepository}) : _forecastRepository = forecastRepository;

  Future<Result<List<ForecastModel>>> execute(double latitude, double longitude) async {
    final Result<List<ForecastModel>> result = await _forecastRepository.getForecasts(latitude, longitude);

    return result.when(
      success: (data) {
        final DateTime now = DateTime.now();
        final DateTime tomorrow = now.add(const Duration(days: 1));
        final dailyForecastList = data.where((model) {
          return now.isBefore(model.time) && tomorrow.isAfter(model.time);
        }).toList();
        return Result.success(dailyForecastList);
      },
      error: (e) => Result.error(e),
    );
  }
}
