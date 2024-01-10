import 'package:flutter/material.dart';
import 'package:orm_forecast/core/result.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';
import 'package:orm_forecast/domain/use_case/get_forecast_use_case.dart';
import 'package:orm_forecast/presenter/main/main_state.dart';

class MainViewModel extends ChangeNotifier {
  final GetForecastUseCase _getForecastUseCase;

  MainViewModel({required GetForecastUseCase getForecastUseCase}) : _getForecastUseCase = getForecastUseCase;

  MainState _state = const MainState();
  MainState get state => _state;

  Future<void> getForecastInformation(double latitude, double longitude) async {
    _state = state.copyWith(isLoading: true);
    notifyListeners();

    final Result<List<ForecastModel>> result = await _getForecastUseCase.execute(latitude, longitude);
    result.when(
      success: (data) {
        _state = state.copyWith(isLoading: false, forecastModelList: data);
      },
      error: (e) {
        _state = state.copyWith(isLoading: false, forecastModelList: []);
      },
    );
    notifyListeners();
  }
}