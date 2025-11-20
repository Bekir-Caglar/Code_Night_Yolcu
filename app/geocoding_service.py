"""
Koordinat (enlem/boylam) ile şehir bulma servisi
Geopy kütüphanesi kullanılarak reverse geocoding yapılır
"""
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import time


def koordinattan_sehir_bul(lat: float, lon: float, retry_count: int = 3) -> dict:
    """
    Verilen koordinattan şehir (il) ismini bul
    
    Args:
        lat: Enlem (latitude)
        lon: Boylam (longitude)
        retry_count: Hata durumunda tekrar deneme sayısı
        
    Returns:
        dict: {
            'success': bool,
            'city_name': str veya None,
            'full_address': str,
            'error': str veya None
        }
    """
    print(f"\n📍 Koordinat: {lat}, {lon}")
    
    # Nominatim geolocator başlat
    geolocator = Nominatim(user_agent="turkcell_citypulse_api_v1", timeout=10)
    
    for attempt in range(retry_count):
        try:
            # Reverse geocoding yap
            location = geolocator.reverse(f"{lat}, {lon}", language='tr', exactly_one=True)
            
            if not location:
                return {
                    'success': False,
                    'city_name': None,
                    'full_address': None,
                    'error': 'Konum bulunamadı'
                }
            
            address = location.raw.get('address', {})
            full_address = location.address
            
            # --- İYİLEŞTİRİLMİŞ ALGORİTMA ---
            # Türkiye haritasında il isminin gelebileceği TÜM alanları sırayla deniyoruz
            aranacak_keys = [
                'province',       # En standart il alanı
                'state',          # Ankara gibi bazı şehirler state olarak geçer
                'city',           # Büyükşehir merkezleri
                'administrative'  # Nadiren genel idari bölge adı
            ]
            
            bulunan_deger = None
            bulunan_key = None
            
            for key in aranacak_keys:
                if address.get(key):
                    bulunan_deger = address.get(key)
                    bulunan_key = key
                    break
            
            if bulunan_deger:
                # Temizlik (Ankara Valiliği, Ankara İli, Ankara Province vb. temizle)
                temiz_sehir = bulunan_deger\
                    .replace(" İli", "")\
                    .replace(" Province", "")\
                    .replace(" Valiliği", "")\
                    .replace(" Belediyesi", "")\
                    .strip()
                
                print(f"✅ Şehir (İl): {temiz_sehir} (kaynak: {bulunan_key})")
                
                return {
                    'success': True,
                    'city_name': temiz_sehir,
                    'full_address': full_address,
                    'district': address.get('town') or address.get('county'),
                    'country': address.get('country'),
                    'error': None
                }
            else:
                print("⚠️ Şehir ismi (İl) ayrıştırılamadı.")
                print(f"   İlçe/Detay: {address.get('town') or address.get('county')}")
                
                return {
                    'success': False,
                    'city_name': None,
                    'full_address': full_address,
                    'error': 'İl bilgisi bulunamadı, sadece ilçe tespit edildi'
                }
        
        except GeocoderTimedOut:
            if attempt < retry_count - 1:
                print(f"⏱️ Timeout, tekrar deneniyor... ({attempt + 1}/{retry_count})")
                time.sleep(1)
                continue
            else:
                return {
                    'success': False,
                    'city_name': None,
                    'full_address': None,
                    'error': 'Geocoder zaman aşımı'
                }
        
        except GeocoderServiceError as e:
            return {
                'success': False,
                'city_name': None,
                'full_address': None,
                'error': f'Geocoder servisi hatası: {str(e)}'
            }
        
        except Exception as e:
            return {
                'success': False,
                'city_name': None,
                'full_address': None,
                'error': f'Beklenmeyen hata: {str(e)}'
            }
    
    return {
        'success': False,
        'city_name': None,
        'full_address': None,
        'error': 'Maksimum deneme sayısı aşıldı'
    }


def get_city_id_from_name(city_name: str, db) -> str:
    """
    Şehir adından city_id (plaka kodu) bul
    
    Args:
        city_name: Şehir adı (örn: "Ankara", "İstanbul")
        db: Database session
        
    Returns:
        str: city_id (plaka kodu) veya None
    """
    from app import models
    
    # Şehir adıyla eşleşen city'yi bul
    city = db.query(models.City).filter(
        models.City.name.ilike(f"%{city_name}%")
    ).first()
    
    if city:
        return city.city_id
    
    return None


# Manuel test fonksiyonu
if __name__ == "__main__":
    print("🧪 Koordinat -> Şehir Test Scripti\n")
    print("=" * 50)
    
    test_coordinates = [
        (39.9414, 32.8687, "Altındağ/Ankara"),
        (39.9208, 32.8541, "Kızılay/Ankara"),
        (41.0422, 29.0067, "Kadıköy/İstanbul"),
        (38.4237, 27.1428, "İzmir"),
        (41.0082, 28.9784, "İstanbul Merkez")
    ]
    
    for lat, lon, aciklama in test_coordinates:
        print(f"\n📌 Test: {aciklama}")
        sonuc = koordinattan_sehir_bul(lat, lon)
        print(f"Sonuç: {sonuc}")
        print("-" * 50)
        time.sleep(1)  # Rate limiting için bekleme
