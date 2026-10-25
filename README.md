# 🎓 CMR SCHOOL

**Assistant éducatif multimédia pour le Cameroun**

CMR SCHOOL lit, analyse et génère des fichiers éducatifs (PDF, images, audio, texte)  
et répond aux questions des apprenants de façon pédagogique.

> **Usage strictement éducatif** – le bot refuse d’aider à tricher ou à des activités non pédagogiques.

---

## Fonctionnalités

| Fonctionnalité              | Description                                      |
|-----------------------------|--------------------------------------------------|
| Lecture PDF                 | Extraction de texte                              |
| OCR images                  | Français (+ anglais) via Tesseract               |
| Transcription audio         | faster-whisper (mp3, wav, m4a, ogg, flac)        |
| Réponses IA                 | OpenAI / Groq (modèle configurable)              |
| Génération                  | Texte, PDF (ReportLab), Audio (gTTS)             |
| Interface Streamlit         | Application web locale                           |
| Bot Telegram                | Questions + fichiers                             |
| API FastAPI                 | Pour connecter un site web                       |

---

## Installation rapide

```bash
# 1. Cloner / décompresser le projet
cd cmr_school

# 2. Environnement virtuel
python -m venv .venv
source .venv/bin/activate          # Linux / macOS
# .venv\Scripts\activate           # Windows

# 3. Dépendances
pip install -r requirements.txt

# 4. Configuration
cp .env.example .env
# Éditez .env et mettez votre OPENAI_API_KEY
```

### Dépendances système (Linux)

```bash
# OCR
sudo apt install tesseract-ocr tesseract-ocr-fra

# Audio (ffmpeg pour certains formats)
sudo apt install ffmpeg
```

---

## Lancement

### Interface Streamlit (recommandé pour commencer)

```bash
streamlit run app.py
```

Ouvre généralement : http://localhost:8501

### Bot Telegram

1. Créez un bot avec [@BotFather](https://t.me/BotFather) → récupérez le token  
2. Ajoutez dans `.env` :
   ```
   BOT_TOKEN=123456:ABC...
   OWNER_ID=votre_id_telegram
   ```
3. Lancez :
   ```bash
   python telegram_bot.py
   ```

### API web (pour un site HTML)

```bash
uvicorn web_api:app --host 0.0.0.0 --port 8000
```

Endpoint : `POST /api/question`

```json
{
  "question": "Explique la photosynthèse simplement",
  "level": "Collège"
}
```

---

## Déploiement sur Render

1. Va sur [https://render.com](https://render.com) et connecte ton compte GitHub.
2. **New → Web Service** → sélectionne le dépôt `CmrSchoolAI`.
3. Configure :
   - **Name** : `cmr-school`
   - **Runtime** : Python 3
   - **Build Command** : `pip install -r requirements.txt`
   - **Start Command** : `streamlit run app.py --server.port $PORT --server.address 0.0.0.0 --server.headless true`
4. Dans **Environment** ajoute :
   - `OPENAI_API_KEY` = ta clé (OpenAI ou Groq)
   - `OPENAI_MODEL` = `gpt-4o-mini` (ou autre)
   - (optionnel) `OPENAI_BASE_URL` si tu utilises Groq
5. Clique **Create Web Service**.

Le fichier `render.yaml` est déjà présent dans le dépôt pour un déploiement Blueprint automatique.

> Note : sur le plan gratuit Render, le service s’endort après inactivité.  
> Tesseract et ffmpeg ne sont pas installés par défaut sur Render free → l’OCR et la transcription audio avancée peuvent nécessiter un Docker / plan payant. Les questions textuelles + PDF fonctionnent immédiatement.

---

## Structure du projet

```
cmr_school/
├── app.py                 # Interface Streamlit
├── telegram_bot.py        # Bot Telegram
├── web_api.py             # API FastAPI
├── requirements.txt
├── .env.example
├── README.md
├── render.yaml            # Config Render
├── Procfile
├── cmr_school/
│   ├── __init__.py
│   ├── config.py          # Configuration + prompt système
│   ├── readers.py         # PDF / OCR / audio / texte
│   ├── ai.py              # Appels OpenAI / Groq
│   └── generators.py      # Texte / PDF / audio
└── data/
    ├── uploads/           # Fichiers reçus
    └── outputs/           # Fichiers générés
```

---

## Niveaux supportés

- Primaire  
- Collège  
- Lycée  
- Université  
- Enseignant  
- Général  

---

## Paiement / version complète (Telegram + WhatsApp)

La version de base ci-dessus est gratuite et locale.  
Pour une version production avec :

- Essai gratuit 2 jours  
- Paiement Mobile Money (MTN / Orange) 500 FCFA  
- Admin panel  
- WhatsApp via Infobip  

→ contactez le développeur ou étendez `telegram_bot.py` + base SQLite.

---

## Règles de sécurité éducative

Le prompt système impose :

- Réponses uniquement pédagogiques  
- Adaptation au niveau de l’élève  
- Refus de toute aide à la triche ou à des activités illégales  
- Encouragement de la compréhension  

---

## Licence

Projet éducatif – libre d’usage et de modification pour l’enseignement au Cameroun et ailleurs.
