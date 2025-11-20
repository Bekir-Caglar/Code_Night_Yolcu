from sqlalchemy import Column, Integer, String, Float, Boolean
from .database import Base


class Item(Base):
    """Örnek bir Item modeli - Ürün, Kullanıcı vb. için uyarlayabilirsiniz"""
    __tablename__ = "items"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True, nullable=False)
    description = Column(String, nullable=True)
    price = Column(Float, nullable=False)
    is_available = Column(Boolean, default=True)
