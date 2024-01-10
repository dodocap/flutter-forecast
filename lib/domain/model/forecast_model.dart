import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'forecast_model.freezed.dart';

part 'forecast_model.g.dart';

@freezed
class ForecastModel with _$ForecastModel {
  const factory ForecastModel({
    required DateTime time,
    required num temperature,
    required String weather,
    required int humidity,
    required num windSpeed,
    required num pressure,
  }) = _ForecastModel;

  factory ForecastModel.fromJson(Map<String, Object?> json) => _$ForecastModelFromJson(json);
}