# Cubox

Cubox is a bilingual 3x3 speedcubing learning app built with FastAPI and Flutter, focused on helping cubers learn, review, and practice Fridrich/CFOP algorithms, starting with PLL.

## Project Overview

Cubox is organized as a monorepo with a FastAPI backend and a Flutter mobile client. The current MVP focuses on PLL, the Permutation of the Last Layer step in the Fridrich/CFOP method.

The backend provides a JSON-backed API for PLL algorithm data, including case listings, case details, random case selection, and simple practice/quiz payloads. The mobile app consumes that API to display PLL cases and support a lightweight recall-based practice flow.

This project is intended as a portfolio-ready foundation and may later evolve into a production mobile app for Play Store and App Store distribution.

## Features

### Implemented

- FastAPI backend for Cubox algorithm data
- PLL-only algorithm library with 21 cases
- Algorithm data stored in `backend/data/pll_algorithms.json`
- Bilingual backend fields for names, descriptions, recognition notes, and API errors
- Category listing endpoint
- PLL case listing with optional category and search filters
- Case detail endpoint by case ID
- Random PLL case endpoint
- Practice endpoints for random cases and quiz-style payloads
- Pytest coverage for health, case, and practice endpoints
- Docker and Docker Compose support for the backend
- Flutter mobile client using Material Design
- Mobile home screen with navigation to PLL algorithms and practice mode
- PLL algorithm list screen
- Algorithm detail screen with clean and grouped notation
- Practice mode that hides/reveals the algorithm and loads another random PLL case
- Null-safe image placeholder UI for cases without images
- Configurable mobile API base URL through `CUBOX_API_BASE_URL`
- Android, iOS, and web Flutter project targets

### Planned / In Progress

- Full OLL support
- Expanded CFOP algorithm library beyond PLL
- Timed practice sessions
- Favorites
- Progress tracking
- Offline mode
- User accounts and authentication
- Production database integration
- App Store / Play Store release
- Manual review of seeded PLL algorithms before production use

## Tech Stack

| Area | Technologies |
| --- | --- |
| Backend | Python, FastAPI, Pydantic, Uvicorn, Pytest, HTTPX, Docker, Docker Compose |
| Mobile | Flutter, Dart, Material Design, HTTP package |
| Platforms | Android, iOS, Web |

## Monorepo Structure

```text
cubox/
  backend/
  mobile/
  README.md
```

- `backend/`: FastAPI API, PLL data, backend tests, and Docker configuration.
- `mobile/`: Flutter mobile app, API client, screens, shared widgets, and platform projects.
- `README.md`: Root project documentation for the full Cubox monorepo.

## Backend Setup

From the project root:

```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

Backend URLs:

- API root: `http://127.0.0.1:8000`
- Interactive docs: `http://127.0.0.1:8000/docs`
- Health check: `http://127.0.0.1:8000/health`

Run backend tests:

```bash
cd backend
source .venv/bin/activate
pytest
```

Run with Docker Compose:

```bash
cd backend
docker compose up --build
```

## Backend API

The current API is versioned under `/api/v1`.

| Method | Endpoint | Description |
| --- | --- | --- |
| `GET` | `/health` | Returns API health, service name, and version. |
| `GET` | `/api/v1/categories` | Lists available algorithm categories. Currently only `PLL`. |
| `GET` | `/api/v1/cases` | Lists PLL cases. Supports optional `category` and `search` query parameters. |
| `GET` | `/api/v1/cases/{case_id}` | Returns a single case by ID, such as `pll_t`. |
| `GET` | `/api/v1/random?category=PLL` | Returns one random PLL case. |
| `GET` | `/api/v1/practice/random?category=PLL&count=5` | Returns random PLL cases without duplicates when possible. |
| `GET` | `/api/v1/practice/quiz?category=PLL&count=5` | Returns quiz-style prompts with answers. |

The backend currently supports PLL only. Requests for unsupported categories such as OLL return a `400` response.

## Mobile Setup

From the project root:

```bash
cd mobile
flutter pub get
flutter run
```

The mobile app uses `http://localhost:8000` as the default API base URL. You can override it at run time:

```bash
cd mobile
flutter run --dart-define=CUBOX_API_BASE_URL=http://localhost:8000
```

Use the backend URL that is reachable from your selected Flutter target. For example, a physical device or emulator may need a host address that differs from `localhost`.

Run Flutter tests:

```bash
cd mobile
flutter test
```

## Mobile App

The Flutter app currently includes:

- A Cubox home screen
- Navigation to PLL algorithm browsing
- Navigation to practice mode
- API client integration with the FastAPI backend
- Loading and error states for backend requests
- Algorithm cards with image placeholders
- Algorithm detail pages with clean notation, grouped notation, description, and recognition notes when available
- Practice flow with hidden answer, reveal/hide controls, and next-case loading

The visible mobile UI is currently English. The backend data model already includes English and Spanish fields for future bilingual UI work.

## Data Source

PLL cases are stored in:

```text
backend/data/pll_algorithms.json
```

The data includes case IDs, category, English and Spanish names/descriptions, recognition notes, clean notation, grouped notation, optional image URLs, and source metadata. The backend README notes that the algorithms were seeded from SpeedCubeDB's PLL reference page and should be manually reviewed before production use.

## Current Limitations

- Only PLL is implemented.
- No OLL, F2L, COLL, or full CFOP library yet.
- No database yet; algorithm data is loaded from JSON.
- No authentication, users, roles, or saved progress.
- Mobile practice is recall-based and does not yet track timing, accuracy, or history.
- Case image URLs are currently nullable, so the mobile app displays placeholders when images are missing.

## Portfolio Notes

Cubox demonstrates a practical full-stack mobile architecture:

- A typed FastAPI backend with validated Pydantic response models
- A clean API boundary between backend and mobile client
- A Flutter app with feature-based screens and shared states/widgets
- Dockerized backend development support
- Automated backend tests for core API behavior

The project is intentionally scoped as an MVP: stable PLL browsing and practice first, with a clear path toward a larger CFOP learning platform.
