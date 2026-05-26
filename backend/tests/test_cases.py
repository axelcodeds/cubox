from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_categories_returns_pll() -> None:
    response = client.get("/api/v1/categories")

    assert response.status_code == 200
    categories = response.json()
    assert categories == [
        {
            "id": "PLL",
            "name": "PLL",
            "full_name_en": "Permutation of the Last Layer",
            "full_name_es": "Permutación de la Última Capa",
            "case_count": 21,
        }
    ]


def test_cases_returns_21_cases() -> None:
    response = client.get("/api/v1/cases")

    assert response.status_code == 200
    assert len(response.json()) == 21


def test_cases_filters_by_pll_category() -> None:
    response = client.get("/api/v1/cases?category=PLL")

    assert response.status_code == 200
    cases = response.json()
    assert len(cases) == 21
    assert {case["category"] for case in cases} == {"PLL"}


def test_cases_search_matches_name() -> None:
    response = client.get("/api/v1/cases?search=t")

    assert response.status_code == 200
    assert any(case["id"] == "pll_t" for case in response.json())


def test_get_case_by_id_returns_t_perm() -> None:
    response = client.get("/api/v1/cases/pll_t")

    assert response.status_code == 200
    case = response.json()
    assert case["id"] == "pll_t"
    assert case["name"] == "T Perm"
    assert case["algorithm"]["clean"] == "R U R' U' R' F R2 U' R' U' R U R' F'"


def test_unknown_case_returns_404() -> None:
    response = client.get("/api/v1/cases/pll_unknown")

    assert response.status_code == 404
    assert response.json()["detail"] == {
        "error_en": "Case not found.",
        "error_es": "Caso no encontrado.",
    }


def test_unsupported_category_returns_400() -> None:
    response = client.get("/api/v1/cases?category=OLL")

    assert response.status_code == 400
    assert response.json()["detail"]["error_en"].startswith("Unsupported category")
