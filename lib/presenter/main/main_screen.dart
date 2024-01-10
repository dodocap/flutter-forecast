import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
      appBar: AppBar(title: const Text('날씨 정보')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.forecastModelList.length,
              itemBuilder: (context, index) {
                final ForecastModel model = state.forecastModelList[index];
                return Text(
                  model.toString(),
                );
              },
            ),
    );
  }

  Future<void> _getCurrentPosition() async {
    await _determinePosition().then((position) {
      print('${position.latitude} / ${position.longitude}');
      Future.microtask(() {
        final MainViewModel viewModel = context.read<MainViewModel>();
        viewModel.getForecastInformation(position.latitude, position.longitude);
      });
    }).onError((error, stackTrace) {
      print('onError $error');
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
