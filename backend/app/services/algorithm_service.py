import json
import random
from pathlib import Path

from pydantic import ValidationError

from app.core.config import MAX_PRACTICE_COUNT, PLL_DATA_FILE, SUPPORTED_CATEGORIES
from app.models.algorithm import AlgorithmCase, CategoryResponse, QuizQuestion, QuizResponse


class AlgorithmDataError(RuntimeError):
    pass


class AlgorithmService:
    def __init__(self, data_file: Path = PLL_DATA_FILE) -> None:
        self.data_file = data_file
        self._cases = self._load_cases()

    def _load_cases(self) -> list[AlgorithmCase]:
        try:
            raw_data = json.loads(self.data_file.read_text(encoding="utf-8"))
        except FileNotFoundError as exc:
            raise AlgorithmDataError(f"Algorithm data file not found: {self.data_file}") from exc
        except json.JSONDecodeError as exc:
            raise AlgorithmDataError(f"Algorithm data file contains invalid JSON: {exc}") from exc

        if not isinstance(raw_data, list):
            raise AlgorithmDataError("Algorithm data must be a JSON list.")

        try:
            cases = [AlgorithmCase.model_validate(item) for item in raw_data]
        except ValidationError as exc:
            raise AlgorithmDataError(f"Algorithm data validation failed: {exc}") from exc

        ids = [case.id for case in cases]
        if len(ids) != len(set(ids)):
            raise AlgorithmDataError("Algorithm data contains duplicate case IDs.")

        unsupported = sorted({case.category for case in cases} - SUPPORTED_CATEGORIES)
        if unsupported:
            raise AlgorithmDataError(f"Algorithm data contains unsupported categories: {unsupported}")

        return cases

    def list_categories(self) -> list[CategoryResponse]:
        pll_count = len([case for case in self._cases if case.category == "PLL"])
        return [
            CategoryResponse(
                id="PLL",
                name="PLL",
                full_name_en="Permutation of the Last Layer",
                full_name_es="Permutación de la Última Capa",
                case_count=pll_count,
            )
        ]

    def validate_category(self, category: str | None) -> str | None:
        if category is None:
            return None
        normalized = category.upper()
        if normalized not in SUPPORTED_CATEGORIES:
            raise ValueError("Unsupported category.")
        return normalized

    def list_cases(self, category: str | None = None, search: str | None = None) -> list[AlgorithmCase]:
        normalized_category = self.validate_category(category)
        cases = self._cases

        if normalized_category:
            cases = [case for case in cases if case.category == normalized_category]

        if search:
            query = search.casefold()
            cases = [
                case
                for case in cases
                if query in case.id.casefold()
                or query in case.name.casefold()
                or query in case.full_name_en.casefold()
                or query in case.full_name_es.casefold()
            ]

        return cases

    def get_case(self, case_id: str) -> AlgorithmCase | None:
        normalized_id = case_id.casefold()
        return next((case for case in self._cases if case.id.casefold() == normalized_id), None)

    def get_random_cases(self, category: str = "PLL", count: int = 1) -> list[AlgorithmCase]:
        normalized_category = self.validate_category(category) or "PLL"
        safe_count = max(1, min(count, MAX_PRACTICE_COUNT))
        cases = self.list_cases(category=normalized_category)
        return random.sample(cases, min(safe_count, len(cases)))

    def generate_quiz(self, category: str = "PLL", count: int = 1) -> QuizResponse:
        cases = self.get_random_cases(category=category, count=count)
        questions = [
            QuizQuestion(
                case_id=case.id,
                name=case.name,
                prompt_en="Which algorithm solves this PLL case?",
                prompt_es="¿Qué algoritmo resuelve este caso PLL?",
                image_url=case.image_url,
                answer={
                    "clean": case.algorithm.clean,
                    "grouped": case.algorithm.grouped,
                },
            )
            for case in cases
        ]
        return QuizResponse(category=category.upper(), count=len(questions), questions=questions)


algorithm_service = AlgorithmService()
