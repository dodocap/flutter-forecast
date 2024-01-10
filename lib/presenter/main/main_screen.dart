import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:orm_forecast/domain/model/forecast_model.dart';
import 'package:orm_forecast/presenter/main/main_state.dart';
import 'package:orm_forecast/presenter/main/main_view_model.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MainViewModel viewModel = context.watch<MainViewModel>();
    final MainState state = viewModel.state;
    return Scaffold(
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _setMainView()
    );
  }

  Widget _setMainView() {
    final List<ForecastModel> forecastModelList = context.read<MainViewModel>().state.forecastModelList;
    if(forecastModelList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final ForecastModel currentTimeModel = forecastModelList.first;
    return Container(
      padding: const EdgeInsets.only(top: kToolbarHeight + 8.0, left: 16.0, right: 16.0, bottom: 32.0),
      color: _setBackgroundColor(currentTimeModel.time.hour),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${currentTimeModel.temperature}°',
                      style: const TextStyle(fontSize: 64),
                    ),
                    Text(
                      currentTimeModel.weather,
                      style: const TextStyle(fontSize: 28),
                    )
                  ],
                ),
                Expanded(child: _setLottie(currentTimeModel))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: forecastModelList.length,
              itemBuilder: (context, index) {
                final ForecastModel model = forecastModelList[index];
                return ListTile(
                  minLeadingWidth: 56,
                  title: Text('${model.temperature}°', style: const TextStyle(fontSize: 32.0),),
                  subtitle: Text('💧${model.humidity}%\t\t|\t\t💨️${model.windSpeed}km/h\t\t|\t\t${model.pressure}hPa', style: const TextStyle(fontSize: 14),),
                  leading: Column(
                    children: [
                      Expanded(child: _setLottie(model)),
                      Text(_formatHour(model.time.hour), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _setBackgroundColor(int currentHour) {
    if (currentHour >= 5 && currentHour < 12) {
      return Colors.lightBlueAccent.withOpacity(0.4);
    } else if (currentHour >= 12 && currentHour < 18) {
      return Colors.green.withOpacity(0.7);
    } else {
      return Colors.deepPurple.withOpacity(0.7);
    }
  }

  Widget _setLottie(ForecastModel model) {
    String fileName =
      (model.time.hour >= 6 && model.time.hour < 18) ? 'assets/forecast/day_' : 'assets/forecast/night_';
    switch (model.weather) {
      case '맑은 하늘': fileName += 'normal.json';
      case '구름이 낀 하늘': fileName += 'cloudy.json';
      case '비': fileName += 'rainy.json';
      case '눈': fileName += 'snowy.json';
      default: fileName += 'normal.json';
    }
    return Lottie.asset(fileName);
  }


  String _formatHour(int hour) => hour > 12 ? '오후 ${hour-12}시' : '오전 $hour시';


  Future<void> _getCurrentPosition() async {
    Position position = await _determinePosition();
    Future.microtask(() {
      final MainViewModel viewModel = context.read<MainViewModel>();
      viewModel.getForecastInformation(position.latitude, position.longitude);
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
