from fastapi import APIRouter, HTTPException, Query

from app.models.algorithm import AlgorithmCase, CategoryResponse, QuizResponse
from app.services.algorithm_service import algorithm_service


router = APIRouter()


def unsupported_category_error() -> HTTPException:
    return HTTPException(
        status_code=400,
        detail={
            "error_en": "Unsupported category. Only PLL is available for now.",
            "error_es": "Categoría no soportada. Por ahora solo PLL está disponible.",
        },
    )


@router.get("/categories", response_model=list[CategoryResponse])
def list_categories() -> list[CategoryResponse]:
    return algorithm_service.list_categories()


@router.get("/cases", response_model=list[AlgorithmCase])
def list_cases(category: str | None = None, search: str | None = None) -> list[AlgorithmCase]:
    try:
        return algorithm_service.list_cases(category=category, search=search)
    except ValueError as exc:
        raise unsupported_category_error() from exc


@router.get("/cases/{case_id}", response_model=AlgorithmCase)
def get_case(case_id: str) -> AlgorithmCase:
    case = algorithm_service.get_case(case_id)
    if case is None:
        raise HTTPException(
            status_code=404,
            detail={
                "error_en": "Case not found.",
                "error_es": "Caso no encontrado.",
            },
        )
    return case


@router.get("/random", response_model=AlgorithmCase)
def get_random_case(category: str = "PLL") -> AlgorithmCase:
    try:
        return algorithm_service.get_random_cases(category=category, count=1)[0]
    except ValueError as exc:
        raise unsupported_category_error() from exc


@router.get("/practice/random", response_model=list[AlgorithmCase])
def get_practice_random(
    category: str = "PLL",
    count: int = Query(default=1, ge=1, le=21),
) -> list[AlgorithmCase]:
    try:
        return algorithm_service.get_random_cases(category=category, count=count)
    except ValueError as exc:
        raise unsupported_category_error() from exc


@router.get("/practice/quiz", response_model=QuizResponse)
def get_practice_quiz(
    category: str = "PLL",
    count: int = Query(default=1, ge=1, le=21),
) -> QuizResponse:
    try:
        return algorithm_service.generate_quiz(category=category, count=count)
    except ValueError as exc:
        raise unsupported_category_error() from exc
