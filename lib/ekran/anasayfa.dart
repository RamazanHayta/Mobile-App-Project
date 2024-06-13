import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wheather/havadurumu/havadurumu.dart';
import 'package:wheather/servisler/havadurumu_servisleri.dart';
import 'package:intl/intl.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa>
    with SingleTickerProviderStateMixin {
  List<Havadurumu> _weathers = [];
  String? _city; // Şehir bilgisini saklamak için bir değişken
  PageController _pageController = PageController();
  AnimationController? _animationController;
  Animation<double>? _animation;

  void _getWeatherData() async {
    try {
      String city =
          await HavaDurumuServisi().getLocation(); // Şehir bilgisini al
      List<Havadurumu> weathers = await HavaDurumuServisi().getWeatherData();
      setState(() {
        _city = city; // Şehir bilgisini state'e kaydet
        _weathers = weathers; // Hava durumu bilgilerini state'e kaydet
      });
    } catch (e) {
      print("Hata: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null); // Türkçe dil verilerini başlat
    _getWeatherData();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );

    _pageController.addListener(() {
      if (_pageController.page == _pageController.page!.roundToDouble()) {
        if (_pageController.page == 0 ||
            _pageController.page == _weathers.length - 1) {
          _animationController!.forward(from: 0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        DateFormat('d MMMM y, HH:mm', 'tr_TR').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: Text(_city != null ? '$_city Hava Durumu ' : 'Hava Durumu'),
      ),
      body: Center(
        child: _weathers.isEmpty
            ? CircularProgressIndicator()
            : PageView.builder(
                controller: _pageController,
                itemCount: _weathers.length,
                itemBuilder: (context, index) {
                  if (index == 0 || index == _weathers.length - 1) {
                    return AnimatedBuilder(
                      animation: _animation!,
                      builder: (context, child) {
                        return RotationTransition(
                          turns: _animation!,
                          child: _buildWeatherContent(
                              context, index, formattedDate),
                        );
                      },
                    );
                  } else {
                    return _buildWeatherContent(context, index, formattedDate);
                  }
                },
              ),
      ),
    );
  }

  Widget _buildWeatherContent(
      BuildContext context, int index, String formattedDate) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.network(_weathers[index].ikon, width: 200),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 60),
              child: Column(
                children: [
                  Text(
                    "${_weathers[index].gun}\n ${_weathers[index].durum.toUpperCase()} ${_weathers[index].derece}°",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "En Düşük: ${_weathers[index].min} °",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "En Yüksek: ${_weathers[index].max} °",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Gece: ${_weathers[index].gece} °",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Nem: ${_weathers[index].nem}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
