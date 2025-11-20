# Turkcell Proje - Backend API

## Hızlı Başlangıç

### 1. Uygulamayı Çalıştır
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 2. API Endpoints

**Base URL:** `http://localhost:8000`

#### Ana Endpoint'ler
- `GET /` - API bilgisi
- `GET /health` - Sağlık kontrolü
- `GET /docs` - Swagger UI (interaktif API dokümantasyonu)

#### Items CRUD Endpoints
- `POST /api/items/` - Yeni item oluştur
- `GET /api/items/` - Tüm itemları listele
- `GET /api/items/{id}` - Tek item getir
- `PUT /api/items/{id}` - Item güncelle
- `DELETE /api/items/{id}` - Item sil

### 3. Flutter İçin Response Formatı

Tüm endpoint'ler standart bir format döner:

**Başarılı Response:**
```json
{
  "success": true,
  "message": "İşlem başarılı",
  "data": { ... }
}
```

**Hata Response:**
```json
{
  "success": false,
  "message": "Hata mesajı",
  "data": null,
  "error_code": "ERROR_CODE"
}
```

### 4. Flutter İçin Örnek Request'ler

#### Item Oluştur
```
POST http://localhost:8000/api/items/
Content-Type: application/json

{
  "name": "Ürün Adı",
  "description": "Açıklama",
  "price": 99.99,
  "is_available": true
}
```

#### Tüm Itemları Getir
```
GET http://localhost:8000/api/items/
```

#### Tek Item Getir
```
GET http://localhost:8000/api/items/1
```

#### Item Güncelle
```
PUT http://localhost:8000/api/items/1
Content-Type: application/json

{
  "name": "Yeni Ürün Adı",
  "price": 149.99
}
```

#### Item Sil
```
DELETE http://localhost:8000/api/items/1
```

### 5. Flutter İçin Önemli Notlar

- ✅ CORS aktif - Flutter'dan direkt istek atabilirsin
- ✅ Tüm response'lar standart formatta
- ✅ Error handling düzgün yapılmış
- ✅ SQLite kullanıldığı için kolay deployment

### 6. Geliştirme İpuçları

**Hızlı test için:**
```bash
# API'yi test et
curl http://localhost:8000/health

# Item oluştur
curl -X POST http://localhost:8000/api/items/ \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","description":"Test item","price":50.0,"is_available":true}'

# Tüm itemları getir
curl http://localhost:8000/api/items/
```

**Flutter'da Kullanım:**
```dart
// Dart/Flutter örnek
final response = await http.get(
  Uri.parse('http://YOUR_IP:8000/api/items/')
);

if (response.statusCode == 200) {
  final Map<String, dynamic> data = json.decode(response.body);
  if (data['success']) {
    final items = data['data'];
    // items listesini kullan
  }
}
```

### 7. Veritabanı

- SQLite kullanılıyor (`sql_app.db`)
- İlk çalıştırmada otomatik oluşturulur
- Tablolar otomatik migrate edilir

### 8. Proje Yapısı

```
├── main.py                   # Ana uygulama dosyası
├── sql_app.db               # SQLite veritabanı
└── app/
    ├── database.py          # DB bağlantısı
    ├── models.py            # SQLAlchemy modelleri
    ├── schemas.py           # Pydantic şemaları
    ├── utils.py             # Yardımcı fonksiyonlar
    └── routers/
        └── items.py         # CRUD endpoints
```

### 9. Production İçin (İleride)

```bash
# Gunicorn ile production
pip install gunicorn
gunicorn main:app -w 4 -k uvicorn.workers.UvicornWorker
```

### 10. Troubleshooting

**Flutter'dan bağlanamıyorum:**
- Backend'i `--host 0.0.0.0` ile çalıştırdığından emin ol
- Flutter'da `localhost` yerine bilgisayarın IP adresini kullan
- Emülatörde: `10.0.2.2:8000` kullan (Android)

**CORS hatası:**
- CORS zaten aktif, sorun olmamalı
- Gerekirse `main.py`'deki `allow_origins` ayarını kontrol et
