from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import date

from ..database import get_db
from .. import models, schemas
from ..utils import success_response, error_response


router = APIRouter(
    prefix="/api/feedback",
    tags=["feedback"]
)


# NOT: CREATE/UPDATE/DELETE endpoint'leri kaldırıldı - sadece READ işlemleri


@router.get("/")
def get_all_feedback(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Tüm feedback'leri listele"""
    try:
        feedbacks = db.query(models.CityFeedback).offset(skip).limit(limit).all()
        feedback_list = [
            {
                "id": f.id,
                "city_id": f.city_id,
                "user": f.user,
                "message": f.message,
                "category": f.category,
                "timestamp": str(f.timestamp)
            }
            for f in feedbacks
        ]
        return success_response(
            data=feedback_list,
            message=f"{len(feedback_list)} feedback bulundu"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=error_response(f"Feedback'ler getirilirken hata: {str(e)}", "FETCH_ERROR")
        )


@router.get("/{feedback_id}")
def get_feedback(feedback_id: int, db: Session = Depends(get_db)):
    """Belirli bir feedback'i getir"""
    try:
        feedback = db.query(models.CityFeedback).filter(models.CityFeedback.id == feedback_id).first()
        if feedback is None:
            raise HTTPException(
                status_code=404,
                detail=error_response(f"Feedback ID {feedback_id} bulunamadı", "NOT_FOUND")
            )
        
        return success_response(
            data={
                "id": feedback.id,
                "city_id": feedback.city_id,
                "user": feedback.user,
                "message": feedback.message,
                "category": feedback.category,
                "timestamp": str(feedback.timestamp)
            },
            message="Feedback bulundu"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=error_response(f"Feedback getirilirken hata: {str(e)}", "FETCH_ERROR")
        )


@router.get("/city/{city_id}")
def get_city_feedback(city_id: str, db: Session = Depends(get_db)):
    """Belirli bir şehrin tüm feedback'lerini getir"""
    try:
        feedbacks = db.query(models.CityFeedback).filter(
            models.CityFeedback.city_id == city_id
        ).all()
        
        feedback_list = [
            {
                "id": f.id,
                "city_id": f.city_id,
                "user": f.user,
                "message": f.message,
                "category": f.category,
                "timestamp": str(f.timestamp)
            }
            for f in feedbacks
        ]
        
        return success_response(
            data=feedback_list,
            message=f"{len(feedback_list)} feedback bulundu"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=error_response(f"Feedback'ler getirilirken hata: {str(e)}", "FETCH_ERROR")
        )


# DELETE kaldırıldı - READ-ONLY mod


# ==================== FEEDBACK CATEGORIES ====================
categories_router = APIRouter(
    prefix="/api/categories",
    tags=["categories"]
)

# CREATE kaldırıldı - READ-ONLY mod


@categories_router.get("/")
def get_all_categories(db: Session = Depends(get_db)):
    """Tüm kategorileri listele"""
    try:
        categories = db.query(models.FeedbackCategory).all()
        category_list = [
            {
                "category": c.category,
                "description": c.description
            }
            for c in categories
        ]
        return success_response(
            data=category_list,
            message=f"{len(category_list)} kategori bulundu"
        )
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=error_response(f"Kategoriler getirilirken hata: {str(e)}", "FETCH_ERROR")
        )


@categories_router.get("/{category_name}")
def get_category(category_name: str, db: Session = Depends(get_db)):
    """Belirli bir kategoriyi getir"""
    try:
        category = db.query(models.FeedbackCategory).filter(
            models.FeedbackCategory.category == category_name
        ).first()
        
        if category is None:
            raise HTTPException(
                status_code=404,
                detail=error_response(f"Kategori '{category_name}' bulunamadı", "NOT_FOUND")
            )
        
        return success_response(
            data={
                "category": category.category,
                "description": category.description
            },
            message="Kategori bulundu"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=error_response(f"Kategori getirilirken hata: {str(e)}", "FETCH_ERROR")
        )


# DELETE kaldırıldı - READ-ONLY mod
