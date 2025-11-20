from pydantic import BaseModel, Field
from typing import Optional


class ItemBase(BaseModel):
    """Item için temel şema"""
    name: str = Field(..., min_length=1, max_length=100, description="Ürün adı")
    description: Optional[str] = Field(None, max_length=500, description="Ürün açıklaması")
    price: float = Field(..., gt=0, description="Ürün fiyatı (0'dan büyük olmalı)")
    is_available: bool = Field(True, description="Ürün stokta mı?")


class ItemCreate(ItemBase):
    """Yeni item oluştururken kullanılan şema"""
    pass


class ItemUpdate(BaseModel):
    """Item güncellerken kullanılan şema (tüm alanlar opsiyonel)"""
    name: Optional[str] = Field(None, min_length=1, max_length=100)
    description: Optional[str] = Field(None, max_length=500)
    price: Optional[float] = Field(None, gt=0)
    is_available: Optional[bool] = None


class ItemResponse(ItemBase):
    """API'den dönen item response şeması"""
    id: int

    class Config:
        from_attributes = True  # SQLAlchemy modellerinden otomatik dönüşüm için
