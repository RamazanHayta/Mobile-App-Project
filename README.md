Kullanılan Paketler:

flutter/material.dart: Flutter'ın temel UI bileşenlerini içerir.
flutter/services.dart: Sistem ile ilgili işlemleri yapmak için kullanılır.
intl: Tarih ve saat formatlama işlemleri için kullanılır.
dio: HTTP isteklerini yapmak için kullanılır.
geocoding: Koordinatlardan adres bilgilerini almak için kullanılır.
geolocator: Kullanıcının konumunu almak için kullanılır.

Ana Sınıf ve Fonksiyonlar:
AnaSayfa Sınıfı:
AnaSayfa sınıfı, StatefulWidget sınıfından türetilmiştir ve uygulamanın ana ekranını temsil eder.

_AnaSayfaState Sınıfı:
Değişkenler:

_weathers: Hava durumu verilerini tutan bir liste.
_city: Kullanıcının bulunduğu şehri tutan bir değişken.
_pageController: Sayfa geçişlerini kontrol eden bir PageController.
_animationController ve _animation: Animasyon kontrolleri için kullanılır.
Fonksiyonlar:

_getWeatherData: Hava durumu verilerini ve şehir bilgilerini alır.
initState: Başlangıçta çağrılan fonksiyon, tarih formatını ve animasyonları başlatır, hava durumu verilerini alır.
dispose: Kullanılmayan kaynakları serbest bırakır.
build: Widget ağacını oluşturan fonksiyon. Hava durumu bilgilerini kullanıcıya gösterir.
_buildWeatherContent: Hava durumu kartlarını oluşturan yardımcı fonksiyon.
HavaDurumuServisi Sınıfı:
Bu sınıf, konum ve hava durumu bilgilerini almak için gerekli fonksiyonları içerir.

Fonksiyonlar:

getLocation: Kullanıcının konumunu alır ve şehir adını döndürür.
getWeatherData: Hava durumu API'sine istek yaparak hava durumu verilerini alır ve bir liste olarak döndürür.
Havadurumu Sınıfı:
Bu sınıf, hava durumu verilerini modellemek için kullanılır.

Değişkenler:

gun: Gün bilgisi.
ikon: Hava durumu ikonu URL'si.
durum: Hava durumu açıklaması.
derece: Sıcaklık derecesi.
min: En düşük sıcaklık.
max: En yüksek sıcaklık.
gece: Gece sıcaklığı.
nem: Nem oranı.

Yapıcılar:

Havadurumu: Doğrudan değişkenlerle nesne oluşturur.
Havadurumu.fromJson: JSON verisinden nesne oluşturur.
Genel Akış:
Başlangıçta: initState fonksiyonu çalıştırılır, tarih formatlama ve animasyonlar başlatılır, hava durumu verileri alınır (_getWeatherData).
Hava Durumu Verileri: HavaDurumuServisi sınıfının getLocation ve getWeatherData fonksiyonları kullanılarak API'den alınır.
UI: build fonksiyonu, hava durumu verilerini PageView ile gösterir. İlk ve son sayfa için animasyon eklenmiştir.
Veri Gösterimi: _buildWeatherContent fonksiyonu, her bir hava durumu bilgisini içeren kartları oluşturur ve gösterir.
Bu yapı, kullanıcıya dinamik ve animasyonlu bir hava durumu uygulaması sunar.
