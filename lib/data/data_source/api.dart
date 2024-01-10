import 'package:orm_forecast/core/result.dart';

abstract interface class Api {
  Future<Result<String>> fetchApi(double latitude, double longitude);
}