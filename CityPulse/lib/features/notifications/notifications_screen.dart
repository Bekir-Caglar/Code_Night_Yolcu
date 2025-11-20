import 'package:flutter/material.dart';
import 'package:citypulse/core/theme/app_theme.dart';
import 'package:gap/gap.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uyarılar'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Şehir Verileri',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            _buildMetricCard(
              title: 'Trafik',
              value: 150.5,
              unit: 'GB',
              maxValue: 200.0,
              color: _getColorForTraffic(150.5),
            ),
            const Gap(12),
            _buildMetricCard(
              title: 'Sinyal',
              value: 85.0,
              unit: '%',
              maxValue: 100.0,
              color: _getColorForSignal(85.0),
            ),
            const Gap(12),
            _buildMetricCard(
              title: 'Hava Kalitesi',
              value: 72.0,
              unit: 'AQI',
              maxValue: 150.0,
              color: _getColorForAirQuality(72.0),
            ),
            const Gap(12),
            _buildMetricCard(
              title: 'Paycell Kullanımı',
              value: 45.0,
              unit: 'GB',
              maxValue: 100.0,
              color: _getColorForPaycell(45.0),
            ),
            const Gap(24),
            Text(
              'Öneriler',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(12),
            _buildRecommendationCard(
              icon: Icons.warning_amber_rounded,
              title: 'Yoğun Trafik Uyarısı',
              description:
                  'İstanbul merkezinde trafik sıkışıklığı tespit edildi. Alternatif rotaları değerlendirebilirsiniz.',
              color: AppColors.alertRed,
            ),
            const Gap(12),
            _buildRecommendationCard(
              icon: Icons.signal_cellular_alt,
              title: 'Sinyal Güçlendirme',
              description:
                  'Sinyal gücü orta seviyede. WiFi ağlarına bağlanarak daha stabil bağlantı sağlayabilirsiniz.',
              color: AppColors.primaryYellow,
            ),
            const Gap(12),
            _buildRecommendationCard(
              icon: Icons.air,
              title: 'Hava Kalitesi İyileştirme',
              description:
                  'Hava kalitesi orta seviyede. Dışarı çıkarken maske kullanmanızı öneririz.',
              color: AppColors.primaryYellow,
            ),
            const Gap(12),
            _buildRecommendationCard(
              icon: Icons.account_balance_wallet,
              title: 'Paycell Kullanım Optimizasyonu',
              description:
                  'Paycell kullanımı yüksek. Veri tasarrufu için sıkıştırma özelliklerini kullanabilirsiniz.',
              color: AppColors.alertRed,
            ),
            const Gap(12),
            _buildRecommendationCard(
              icon: Icons.emoji_events,
              title: 'Harika Performans',
              description:
                  'İstanbul genel olarak iyi performans gösteriyor. Mevcut trendleri koruyun!',
              color: AppColors.successGreen,
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForTraffic(double value) {
    if (value > 150) return AppColors.alertRed;
    if (value > 100) return AppColors.primaryYellow;
    return AppColors.successGreen;
  }

  Color _getColorForSignal(double value) {
    if (value < 50) return AppColors.alertRed;
    if (value < 80) return AppColors.primaryYellow;
    return AppColors.successGreen;
  }

  Color _getColorForAirQuality(double value) {
    if (value > 100) return AppColors.alertRed;
    if (value > 50) return AppColors.primaryYellow;
    return AppColors.successGreen;
  }

  Color _getColorForPaycell(double value) {
    if (value > 70) return AppColors.alertRed;
    if (value > 40) return AppColors.primaryYellow;
    return AppColors.successGreen;
  }

  Widget _buildMetricCard({
    required String title,
    required double value,
    required String unit,
    required double maxValue,
    required Color color,
  }) {
    double percentage = (value / maxValue).clamp(0.0, 1.0);
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${value.toStringAsFixed(1)} $unit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const Gap(12),
            LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: 20,
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.alertRed,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(color: AppColors.primaryYellow),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.successGreen,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        left: percentage * constraints.maxWidth - 1,
                        top: 0,
                        bottom: 0,
                        child: Container(width: 2, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
