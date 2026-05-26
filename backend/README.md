# Cubox API Backend

## English

Cubox is a mobile-first speedcubing learning app for 3x3 Rubik's Cube algorithms. This backend-only MVP provides a simple FastAPI API for Fridrich/CFOP PLL algorithms.

This first version supports PLL only. It does not include OLL, F2L, COLL, authentication, users, roles, or a database. Algorithm data is stored in JSON files under `data/`. The frontend will be built later with Flutter.

## Español

Cubox es una app mobile-first para aprender algoritmos de speedcubing del cubo Rubik 3x3. Este MVP solo backend ofrece una API simple con FastAPI para algoritmos PLL de Fridrich/CFOP.

Esta primera versión solo soporta PLL. No incluye OLL, F2L, COLL, autenticación, usuarios, roles ni base de datos. Los algoritmos se guardan en archivos JSON dentro de `data/`. El frontend se construirá después con Flutter.

## Setup With venv / Configuración con venv

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run Locally / Ejecutar localmente

```bash
cd backend
source .venv/bin/activate
uvicorn app.main:app --reload
```

Open / Abrir:

- API: `http://127.0.0.1:8000`
- Docs: `http://127.0.0.1:8000/docs`

## Run Tests / Ejecutar pruebas

```bash
cd backend
source .venv/bin/activate
pytest
```

## Run With Docker / Ejecutar con Docker

```bash
cd backend
docker compose up --build
```

## API Endpoints / Endpoints de la API

- `GET /health`
  - EN: Health check for the API.
  - ES: Verifica el estado de la API.

- `GET /api/v1/categories`
  - EN: Lists available algorithm categories. Currently only `PLL`.
  - ES: Lista las categorías disponibles. Actualmente solo `PLL`.

- `GET /api/v1/cases`
  - EN: Lists PLL cases. Supports optional `category` and `search` query params.
  - ES: Lista casos PLL. Soporta los parámetros opcionales `category` y `search`.

- `GET /api/v1/cases/{case_id}`
  - EN: Gets one case by ID, for example `pll_t`.
  - ES: Obtiene un caso por ID, por ejemplo `pll_t`.

- `GET /api/v1/random?category=PLL`
  - EN: Returns one random PLL case.
  - ES: Devuelve un caso PLL aleatorio.

- `GET /api/v1/practice/random?category=PLL&count=5`
  - EN: Returns random cases without duplicates when possible. Default `count` is `1`; maximum is `21`.
  - ES: Devuelve casos aleatorios sin duplicados cuando sea posible. `count` por defecto es `1`; el máximo es `21`.

- `GET /api/v1/practice/quiz?category=PLL&count=5`
  - EN: Returns a simple quiz payload with prompts and answers.
  - ES: Devuelve un payload simple de quiz con preguntas y respuestas.

## Data Format / Formato de datos

PLL algorithms are stored in `data/pll_algorithms.json`.

Los algoritmos PLL se guardan en `data/pll_algorithms.json`.

```json
{
  "id": "pll_t",
  "category": "PLL",
  "name": "T Perm",
  "full_name_en": "T Permutation",
  "full_name_es": "Permutación T",
  "description_en": "Swaps two corners and two edges.",
  "description_es": "Intercambia dos esquinas y dos aristas.",
  "recognition_en": "Headlights on one side with a swapped edge pair.",
  "recognition_es": "Faros en un lado con un par de aristas intercambiadas.",
  "algorithm": {
    "clean": "R U R' U' R' F R2 U' R' U' R U R' F'",
    "grouped": "(R U R' U') (R' F R2) (U' R' U') (R U R' F')"
  },
  "image_url": null,
  "source": "SpeedCubeDB",
  "source_url": "https://speedcubedb.com/a/3x3/PLL"
}
```

## Notes / Notas

- EN: MVP only supports PLL.
- ES: El MVP solo soporta PLL.
- EN: Algorithms are stored in JSON files.
- ES: Los algoritmos se guardan en archivos JSON.
- EN: No database yet.
- ES: Todavía no hay base de datos.
- EN: No authentication yet.
- ES: Todavía no hay autenticación.
- EN: The frontend will be Flutter later.
- ES: El frontend será Flutter más adelante.
- EN: Algorithms were seeded from SpeedCubeDB's PLL reference page and should be manually reviewed/verified against SpeedCubeDB before production use.
- ES: Los algoritmos se cargaron usando la página de referencia PLL de SpeedCubeDB y deben revisarse/verificarse manualmente contra SpeedCubeDB antes de usarse en producción.
