import 'package:flutter/material.dart';
import 'package:citypulse/core/theme/app_theme.dart';
import 'package:citypulse/widgets/city_map_widget.dart';
import 'package:citypulse/widgets/score_card_widget.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentCity = 'İstanbul'; // Default city
  Position? _currentPosition;
  bool _isLoadingLocation = false;
  LocationPermission? _permissionStatus;

  final List<String> _turkishCities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bartın',
    'Batman',
    'Bayburt',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Karaman',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kilis',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Şanlıurfa',
    'Siirt',
    'Sinop',
    'Şırnak',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak',
  ];

  // Bazı büyük şehirlerin koordinatları
  final Map<String, List<double>> _cityCoordinates = {
    'İstanbul': [41.0082, 28.9784],
    'Ankara': [39.9334, 32.8597],
    'İzmir': [38.4192, 27.1287],
    'Bursa': [40.1885, 29.0610],
    'Antalya': [36.8969, 30.7133],
    'Adana': [37.0000, 35.3213],
    'Konya': [37.8714, 32.4846],
    'Gaziantep': [37.0662, 37.3833],
    'Şanlıurfa': [37.1591, 38.7969],
    'Kayseri': [38.7312, 35.4787],
    'Mersin': [36.8121, 34.6415],
    'Eskişehir': [39.7767, 30.5206],
    'Diyarbakır': [37.9144, 40.2306],
    'Samsun': [41.2867, 36.3300],
    'Denizli': [37.7765, 29.0864],
    'Trabzon': [41.0027, 39.7168],
    'Erzurum': [39.9000, 41.2700],
    'Malatya': [38.3552, 38.3095],
    'Kahramanmaraş': [37.5858, 36.9371],
    'Van': [38.4891, 43.4089],
  };

  @override
  void initState() {
    super.initState();
    // Konum iznini hemen isteme, widget build edildikten sonra iste
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Widget build edildikten sonra konum izni iste
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Tüm platformlarda Geolocator kullanarak izin yönetimi
      LocationPermission permission = await Geolocator.checkPermission();
      setState(() {
        _permissionStatus = permission;
      });
      print('Konum izni durumu: $permission');

      if (permission == LocationPermission.denied) {
        print('Konum izni isteniyor...');
        permission = await Geolocator.requestPermission();
        setState(() {
          _permissionStatus = permission;
        });
        print('İzin sonucu: $permission');

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          setState(() {
            _isLoadingLocation = false;
          });
          if (permission == LocationPermission.deniedForever) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Konum izni kalıcı olarak reddedildi.'),
                action: SnackBarAction(
                  label: 'Ayarlar',
                  onPressed: () async => await Geolocator.openAppSettings(),
                ),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Konum izni kalıcı olarak reddedildi.'),
            action: SnackBarAction(
              label: 'Ayarlar',
              onPressed: () async => await Geolocator.openAppSettings(),
            ),
          ),
        );
        return;
      }

      // Konum servisi açık mı kontrolü
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('Konum servisi açık: $serviceEnabled');

      if (!serviceEnabled) {
        // Konum servisi kapalı, kullanıcıya dialog göster
        print('Konum servisi kapalı');
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationServiceDialog();
        return;
      }

      // Konum alma
      print('Konum alınıyor...');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Konumunuz alınıyor...')));

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Konum alındı: ${position.latitude}, ${position.longitude}');

      setState(() {
        _currentPosition = position;
      });

      // En yakın şehri bulma
      String? nearestCity = _findNearestCity(
        position.latitude,
        position.longitude,
      );
      print('En yakın şehir: $nearestCity');

      if (nearestCity != null) {
        setState(() {
          _currentCity = nearestCity;
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Konumunuz tespit edildi: $nearestCity')),
        );
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konumunuz tespit edilemedi')),
        );
      }
    } catch (e) {
      print('Konum alma hatası: $e');
      setState(() {
        _isLoadingLocation = false;
      });
      // Hata durumunda sessizce devam et
    }
  }

  String? _findNearestCity(double latitude, double longitude) {
    String? nearestCity;
    double minDistance = double.infinity;

    _cityCoordinates.forEach((city, coords) {
      double distance = _calculateDistance(
        latitude,
        longitude,
        coords[0],
        coords[1],
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = city;
      }
    });

    return nearestCity;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // km
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(1 - a), sqrt(a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  void _showCitySelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'İptal',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text(
                    'Şehir Seçin',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Tamam',
                      style: TextStyle(color: AppColors.primaryBlue),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _turkishCities.length,
                itemBuilder: (context, index) {
                  final city = _turkishCities[index];
                  final isSelected = city == _currentCity;
                  return ListTile(
                    title: Text(city),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.primaryBlue)
                        : null,
                    onTap: () {
                      setState(() {
                        _currentCity = city;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Özel modal izin diyalogları kaldırıldı. Kalıcı reddedilme durumunda SnackBar ile 'Ayarlar' açılacak.

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konum Servisleri Kapalı'),
          content: const Text(
            'Haritada konumunuzu göstermek için konum servislerinin açık olması gerekir. '
            'Lütfen konum servislerini etkinleştirin.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Daha Sonra'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Geolocator.openLocationSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Konum Ayarları'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Şehrin Nabzı'),
        actions: [
          Row(
            children: [
              TextButton.icon(
                onPressed: _showCitySelectionBottomSheet,
                icon: const Icon(Icons.location_on, color: Colors.white),
                label: Text(
                  _currentCity,
                  style: const TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
              if (_isLoadingLocation)
                Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(right: 8),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.0,
                  ),
                ),
              const Gap(8),
              // Permission indicator / action
              if (_permissionStatus == null ||
                  _permissionStatus == LocationPermission.denied)
                IconButton(
                  icon: const Icon(
                    Icons.location_searching,
                    color: Colors.white,
                  ),
                  tooltip: 'Konum izni iste',
                  onPressed: () async => await _initializeLocation(),
                ),
              if (_permissionStatus == LocationPermission.deniedForever)
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  tooltip: 'Ayarlar',
                  onPressed: () async => await Geolocator.openAppSettings(),
                ),
            ],
          ),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // City Selector in Top Bar removed from body because we have AppBar selector

            // Map Section
            CityMapWidget(
              currentCity: _currentCity,
              userPosition: _currentPosition,
            ),

            const Gap(16),

            // Scores Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Şehir Skorları',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  _buildScoreCards(),
                ],
              ),
            ),

            const Gap(24),

            // Recommendations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Öneriler',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(12),
                  _buildRecommendationCards(),
                ],
              ),
            ),

            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ScoreCardWidget(
                title: 'Trafik',
                value: 150.5,
                unit: 'GB',
                icon: Icons.traffic,
                color: AppColors.primaryBlue,
                trend: 12.5,
              ),
            ),
            const Gap(12),
            Expanded(
              child: ScoreCardWidget(
                title: 'Sinyal',
                value: 85.0,
                unit: '%',
                icon: Icons.signal_cellular_alt,
                color: AppColors.accentBlue,
                trend: 5.2,
              ),
            ),
          ],
        ),
        const Gap(12),
        Row(
          children: [
            Expanded(
              child: ScoreCardWidget(
                title: 'Hava Kalitesi',
                value: 72.0,
                unit: 'AQI',
                icon: Icons.air,
                color: AppColors.successGreen,
                trend: -3.1,
              ),
            ),
            const Gap(12),
            Expanded(
              child: ScoreCardWidget(
                title: 'Eko Skor',
                value: 88.0,
                unit: '%',
                icon: Icons.eco,
                color: AppColors.successGreen,
                trend: 8.7,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationCards() {
    return Column(
      children: [
        _buildRecommendationCard(
          icon: Icons.warning_amber_rounded,
          title: 'Yoğun Trafik Uyarısı',
          description:
              '${_currentCity} merkezinde trafik sıkışıklığı tespit edildi. Alternatif rotaları değerlendirebilirsiniz.',
          color: AppColors.alertRed,
        ),
        const Gap(12),
        _buildRecommendationCard(
          icon: Icons.tips_and_updates,
          title: 'Ağ Optimizasyonu',
          description:
              '${_currentCity} bölgesinde ek baz istasyonları ile sinyal gücü artırılabilir.',
          color: AppColors.primaryYellow,
        ),
        const Gap(12),
        _buildRecommendationCard(
          icon: Icons.emoji_events,
          title: 'Harika Performans',
          description:
              '${_currentCity} mükemmel eko-skor gösteriyor. Sürdürülebilir uygulamalara devam edin!',
          color: AppColors.successGreen,
        ),
      ],
    );
  }

  Widget _buildRecommendationCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
