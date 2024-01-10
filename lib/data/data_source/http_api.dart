import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/data/data_source/api.dart';
import 'package:http/http.dart' as http;

class HttpApi implements Api {
  static const String _url =  'https://api.open-meteo.com/v1/forecast?hourly=temperature_2m,weathercode,relativehumidity_2m,windspeed_10m,pressure_msl';
  @override
  Future<Result<String>> fetchApi(double latitude, double longitude) async {
    try {
      print('$_url&latitude=$latitude&longitude=$longitude');
      final http.Response response = await http.get(Uri.parse('$_url&latitude=$latitude&longitude=$longitude'));
      if (response.statusCode == 200) {
        return Result.success(response.body);
      }
      return Result.error('Error occurred: ${response.statusCode}');
    } catch (e) {
      return Result.error(e.toString());
    }
  }
}
