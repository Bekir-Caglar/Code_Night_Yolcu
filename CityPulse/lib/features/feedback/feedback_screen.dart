import 'package:flutter/material.dart';
import 'package:citypulse/core/theme/app_theme.dart';
import 'package:gap/gap.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  // Mock feedback data
  static const List<Map<String, dynamic>> mockFeedbacks = [
    {
      "city": "Ankara",
      "user": "Ali",
      "message": "Trafik çok yoğun, sabah saatlerinde toplu taşıma yetersiz",
      "timestamp": "2025-11-10T08:45:00Z",
      "category": "trafik",
    },
    {
      "city": "İstanbul",
      "user": "Ayşe",
      "message": "Hava kalitesi çok kötü, maske takmadan çıkamıyorum",
      "timestamp": "2025-11-09T14:20:00Z",
      "category": "çevre",
    },
    {
      "city": "İzmir",
      "user": "Mehmet",
      "message":
          "İnternet bağlantısı çok yavaş, çalışma saatlerinde kesintiler oluyor",
      "timestamp": "2025-11-08T16:30:00Z",
      "category": "bağlantı",
    },
    {
      "city": "Ankara",
      "user": "Fatma",
      "message":
          "Park alanları artırılmalı, şehir merkezinde otopark sorunu büyük",
      "timestamp": "2025-11-07T12:15:00Z",
      "category": "öneri",
    },
    {
      "city": "İstanbul",
      "user": "Ahmet",
      "message":
          "Toplu taşıma sefer sayısı artırılmalı, özellikle akşam saatlerinde",
      "timestamp": "2025-11-06T19:00:00Z",
      "category": "trafik",
    },
  ];

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'trafik':
        return AppColors.alertRed;
      case 'çevre':
        return AppColors.successGreen;
      case 'bağlantı':
        return AppColors.primaryBlue;
      case 'öneri':
        return AppColors.primaryYellow;
      default:
        return AppColors.textPrimary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'trafik':
        return Icons.traffic;
      case 'çevre':
        return Icons.air;
      case 'bağlantı':
        return Icons.signal_cellular_alt;
      case 'öneri':
        return Icons.lightbulb;
      default:
        return Icons.message;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vatandaş Geri Bildirimleri'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BiP Vatandaş Bildirimleri',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(8),
            Text(
              'Şehir sakinlerinin geri bildirimleri ve önerileri',
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const Gap(16),
            ...mockFeedbacks.map((feedback) => _buildFeedbackCard(feedback)),
            const Gap(24),
            _buildWordCloudSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      feedback['category'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(feedback['category']),
                    color: _getCategoryColor(feedback['category']),
                    size: 20,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback['user'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        feedback['city'],
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      feedback['category'],
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    feedback['category'],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getCategoryColor(feedback['category']),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(12),
            Text(
              feedback['message'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              _formatTimestamp(feedback['timestamp']),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCloudSection() {
    // Simple word frequency analysis
    final words = <String, int>{};
    for (final feedback in mockFeedbacks) {
      final message = feedback['message'] as String;
      final wordList = message.toLowerCase().split(RegExp(r'\s+'));
      for (final word in wordList) {
        if (word.length > 3) {
          // Filter short words
          words[word] = (words[word] ?? 0) + 1;
        }
      }
    }

    final sortedWords = words.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'En Çok Konuşulan Konular',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBlue,
          ),
        ),
        const Gap(12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sortedWords.take(10).map((entry) {
            final fontSize = 12.0 + (entry.value * 2.0);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '${entry.key} (${entry.value})',
                style: TextStyle(
                  fontSize: fontSize.clamp(12, 20),
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }
}
