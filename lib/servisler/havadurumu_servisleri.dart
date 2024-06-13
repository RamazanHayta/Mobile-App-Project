import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wheather/havadurumu/havadurumu.dart';

class HavaDurumuServisi {
  Future<String> getLocation() async {
    // Kullanıcının konumu açık mı kontrol ettik
    final bool servisAcik = await Geolocator.isLocationServiceEnabled();
    if (!servisAcik) {
      return Future.error("Konum servisiniz kapalı");
    }

    LocationPermission izinler = await Geolocator.checkPermission();
    if (izinler == LocationPermission.denied) {
      // Konum izni vermemişse tekrar izin istedik
      izinler = await Geolocator.requestPermission();
      if (izinler == LocationPermission.denied) {
        // Yine vermemişse hata döndürdük
        return Future.error("Konum izni vermelisiniz");
      }
    }

    // Kullanıcının pozisyonunu aldık
    final Position konum = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Kullanıcı pozisyonundan yerleşim noktasını bulduk
    final List<Placemark> placemark =
        await placemarkFromCoordinates(konum.latitude, konum.longitude);

    // Şehrimizi yerleşim noktasından kaydettik
    final String? city = placemark[0].administrativeArea;

    if (city == null) return Future.error("Bir sorun oluştu");

    return city;
  }

  Future<List<Havadurumu>> getWeatherData() async {
    final String city = await getLocation();
    final String url =
        "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=$city";
    const Map<String, String> headers = {
      "authorization": "apikey 088nhBFbZ6bXMowfNUOQua:6uCZjTNj9SsaxvUNi5Zf2C",
      "content-type": "application/json"
    };
    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));

    if (response.statusCode != 200) {
      return Future.error("Bir sorun oluştu");
    }
    final List list = response.data["result"];
    final List<Havadurumu> havaDurumuListesi =
        list.map((e) => Havadurumu.fromJson(e)).toList();
    return havaDurumuListesi;
  }
}
