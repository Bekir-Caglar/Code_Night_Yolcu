from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine
from app import models
from app.routers import items

# Veritabanı tablolarını oluştur
models.Base.metadata.create_all(bind=engine)

# FastAPI uygulamasını oluştur
app = FastAPI(
    title="Turkcell Proje API",
    description="FastAPI ile geliştirilmiş örnek bir REST API - Flutter Frontend ile entegrasyon",
    version="1.0.0"
)

# CORS ayarları - Flutter mobil uygulamanın API'ye erişebilmesi için
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Geliştirme için tüm origin'lere izin ver
    allow_credentials=True,
    allow_methods=["*"],  # Tüm HTTP metodlarına izin ver (GET, POST, PUT, DELETE)
    allow_headers=["*"],  # Tüm header'lara izin ver
)

# Router'ları ekle
app.include_router(items.router)


@app.get("/")
def read_root():
    """Ana sayfa endpoint'i"""
    return {
        "message": "Turkcell Proje API'ye hoş geldiniz!",
        "docs": "/docs",
        "redoc": "/redoc"
    }


@app.get("/health")
def health_check():
    """Sağlık kontrolü endpoint'i"""
    return {"status": "healthy"}


# Uygulamayı çalıştırmak için:
# uvicorn main:app --reload
