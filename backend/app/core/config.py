from pathlib import Path


APP_NAME = "Cubox API"
APP_VERSION = "0.1.0"
DATA_DIR = Path(__file__).resolve().parents[2] / "data"
PLL_DATA_FILE = DATA_DIR / "pll_algorithms.json"
SUPPORTED_CATEGORIES = {"PLL"}
MAX_PRACTICE_COUNT = 21
