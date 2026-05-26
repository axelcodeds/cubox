from pydantic import BaseModel, Field


class AlgorithmNotation(BaseModel):
    clean: str = Field(..., min_length=1)
    grouped: str = Field(..., min_length=1)


class AlgorithmCase(BaseModel):
    id: str = Field(..., min_length=1)
    category: str = Field(..., min_length=1)
    name: str = Field(..., min_length=1)
    full_name_en: str = Field(..., min_length=1)
    full_name_es: str = Field(..., min_length=1)
    description_en: str = Field(..., min_length=1)
    description_es: str = Field(..., min_length=1)
    recognition_en: str = Field(..., min_length=1)
    recognition_es: str = Field(..., min_length=1)
    algorithm: AlgorithmNotation
    image_url: str | None = None
    source: str = Field(..., min_length=1)
    source_url: str = Field(..., min_length=1)


class CategoryResponse(BaseModel):
    id: str
    name: str
    full_name_en: str
    full_name_es: str
    case_count: int


class QuizAnswer(BaseModel):
    clean: str
    grouped: str


class QuizQuestion(BaseModel):
    case_id: str
    name: str
    prompt_en: str
    prompt_es: str
    image_url: str | None
    answer: QuizAnswer


class QuizResponse(BaseModel):
    category: str
    count: int
    questions: list[QuizQuestion]
