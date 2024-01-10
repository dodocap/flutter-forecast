import 'dart:convert';

import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/data/data_source/api.dart';
import 'package:orm_forecast/data/data_source/http_api.dart';
import 'package:orm_forecast/data/dto/forecast_meteo_dto.dart';
import 'package:orm_forecast/data/mapper/meteo_mapper.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';
import 'package:orm_forecast/domain/repository/forecast_repository.dart';

class ForecastMeteoRepository implements ForecastRepository {
  final Api _api;

  ForecastMeteoRepository({required Api api}) : _api = api;

  @override
  Future<Result<List<ForecastModel>>> getForecasts(double latitude, double longitude) async {
    final Result<String> result = await _api.fetchApi(latitude, longitude);

    return result.when(
      success: (data) {
        final ForecastMeteoDto dto = ForecastMeteoDto.fromJson(jsonDecode(data));
        return Result.success(dto.toForecastModel());
      },
      error: (e) => Result.error(e),
    );
  }
}

void main() async {
  final result = await ForecastMeteoRepository(api: HttpApi()).getForecasts(37, 126);
  print(result);
}