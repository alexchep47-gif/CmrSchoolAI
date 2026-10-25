import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()

BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data"
UPLOADS_DIR = DATA_DIR / "uploads"
OUTPUTS_DIR = DATA_DIR / "outputs"

UPLOADS_DIR.mkdir(parents=True, exist_ok=True)
OUTPUTS_DIR.mkdir(parents=True, exist_ok=True)

# IA
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
OPENAI_BASE_URL = os.getenv("OPENAI_BASE_URL")  # None = OpenAI officiel

# Telegram
BOT_TOKEN = os.getenv("BOT_TOKEN")
OWNER_ID = int(os.getenv("OWNER_ID", "0") or "0")

# Infobip WhatsApp
INFOBIP_BASE_URL = os.getenv("INFOBIP_BASE_URL")
INFOBIP_API_KEY = os.getenv("INFOBIP_API_KEY")
INFOBIP_SENDER = os.getenv("INFOBIP_SENDER")

# Prix et essai
TRIAL_DAYS = 2
MONTHLY_PRICE_FCFA = 500
MTN_NUMBER = "+237 677 152 300"
ORANGE_NUMBER = "+237 698 877 771"

# Niveaux supportés
LEVELS = [
    "Primaire",
    "Collège",
    "Lycée",
    "Université",
    "Enseignant",
    "Général",
]

SYSTEM_PROMPT = """
Tu es CMR SCHOOL, un assistant éducatif destiné aux apprenants,
enseignants et parents, notamment au Cameroun.

Règles strictes :
- Réponds UNIQUEMENT dans un objectif éducatif.
- Explique avec un niveau adapté à l'âge / niveau indiqué.
- Structure les réponses avec des titres, listes et exemples concrets.
- Ne présente jamais une information incertaine comme une vérité.
- Si la question concerne une activité dangereuse, illégale, non éducative
  ou du piratage / triche à un examen, refuse poliment et propose
  une alternative pédagogique.
- N'aide PAS à tricher pendant un examen.
- Encourage la compréhension plutôt que la copie.
- Utilise principalement le français. Accepte l'anglais si demandé.
- Sois bienveillant, patient et motivant.
"""
