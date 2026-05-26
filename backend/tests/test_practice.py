from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_random_returns_one_pll_case() -> None:
    response = client.get("/api/v1/random?category=PLL")

    assert response.status_code == 200
    case = response.json()
    assert case["category"] == "PLL"
    assert case["id"].startswith("pll_")


def test_practice_random_returns_unique_cases() -> None:
    response = client.get("/api/v1/practice/random?category=PLL&count=5")

    assert response.status_code == 200
    cases = response.json()
    ids = [case["id"] for case in cases]
    assert len(cases) == 5
    assert len(ids) == len(set(ids))


def test_practice_quiz_returns_questions_with_answers() -> None:
    response = client.get("/api/v1/practice/quiz?category=PLL&count=5")

    assert response.status_code == 200
    payload = response.json()
    assert payload["category"] == "PLL"
    assert payload["count"] == 5
    assert len(payload["questions"]) == 5

    for question in payload["questions"]:
        assert question["case_id"].startswith("pll_")
        assert question["prompt_en"] == "Which algorithm solves this PLL case?"
        assert question["prompt_es"] == "¿Qué algoritmo resuelve este caso PLL?"
        assert question["answer"]["clean"]
        assert question["answer"]["grouped"]


def test_practice_unsupported_category_returns_400() -> None:
    response = client.get("/api/v1/practice/random?category=OLL&count=5")

    assert response.status_code == 400
    assert response.json()["detail"]["error_es"].startswith("Categoría no soportada")
