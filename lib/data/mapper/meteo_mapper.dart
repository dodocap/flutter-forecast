import 'package:orm_forecast/data/dto/forecast_meteo_dto.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';

extension MeteoMapper on ForecastMeteoDto {
  List<ForecastModel> toForecastModel() {
    final int? length = hourly?.time?.length;

    List<ForecastModel> modelList = [];
    if (length == null) {
      return modelList;
    }

    for (int i=0; i<length; i++) {
      modelList.add(
          ForecastModel(
            time: DateTime.parse(hourly!.time!.elementAt(i)),
            temperature: hourly!.temperature2m!.elementAt(i),
            weather: _parseWeather(hourly!.weathercode!.elementAt(i)),
            humidity: hourly!.relativehumidity2m!.elementAt(i).toInt(),
            windSpeed: hourly!.windspeed10m!.elementAt(i),
            pressure: hourly!.pressureMsl!.elementAt(i),
          )
      );
    }
    return modelList;
  }

  String _parseWeather(num weatherCode) {
    switch (weatherCode) {
      case 0: return '맑은 하늘';
      case 1: return '구름이 낀 하늘';
      case 2: return '비';
      case 3: return '눈';
      default: return '알 수 없음';
    }
  }
}
