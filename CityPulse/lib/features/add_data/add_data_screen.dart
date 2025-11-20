import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:citypulse/core/theme/app_theme.dart';
import 'package:citypulse/widgets/custom_input_field.dart';
import 'package:citypulse/widgets/custom_dropdown_field.dart';
import 'package:gap/gap.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool isIOS = Platform.isIOS;

  String? _selectedCity;
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();

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

  @override
  void dispose() {
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Şehir Verisi Ekle')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Şehir Bilgisi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(16),

                CustomDropdownField<String>(
                  title: 'Şehir',
                  icon: Icons.location_city,
                  items: _turkishCities,
                  value: _selectedCity,
                  itemLabel: (city) => city,
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                  hintText: 'Şehir Seçin',
                ),

                const Gap(24),

                Text(
                  'Bilgiler',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const Gap(16),

                CustomInputField(
                  controller: _nameController,
                  label: 'İsim',
                  icon: Icons.person_outline,
                  // Validator ekle
                  // Eğer validator desteği eklenirse, buraya eklenebilir
                  hint: 'Adınızı girin',
                ),

                const Gap(16),

                CustomInputField(
                  controller: _messageController,
                  label: 'Mesaj',
                  icon: Icons.message_outlined,
                  hint: 'Mesajınızı girin',
                  maxLines: 4,
                ),

                const Gap(32),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // TODO: API entegrasyonu
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veri başarıyla gönderildi!'),
                          ),
                        );
                        _nameController.clear();
                        _messageController.clear();
                        setState(() {
                          _selectedCity = null;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload, size: 24),
                        Gap(12),
                        Text(
                          'Veriyi Gönder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Artık kullanılmayan eski dropdown metotları kaldırıldı
}
