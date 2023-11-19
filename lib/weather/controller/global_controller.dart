import 'package:four_in_one_app/weather/api/fetch_weather.dart';
import 'package:four_in_one_app/weather/model/weather_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class GlobalController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    checkLocationStatus();
    super.onInit();
  }

  checkLocationStatus() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      _askToEnableLocationService();
      return;
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      _showLocationPermissionError("Location permissions are denied forever");
      return;
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        _showLocationPermissionError("Location permissions are denied");
        return;
      }
    }

    getLocation();
  }

  getLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((value) {
      _latitude.value = value.latitude;
      _longitude.value = value.longitude;
      FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }

  _askToEnableLocationService() {
    Get.snackbar(
      'Location Services',
      'Please enable location services to use this app.',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
    );
  }

  _showLocationPermissionError(String message) {
    Get.snackbar(
      'Location Permission',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 5),
    );
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
