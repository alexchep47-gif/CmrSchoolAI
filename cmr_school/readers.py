"""
Lecture et extraction de contenu depuis fichiers multimédias
(PDF, images, audio, texte) – usage exclusivement éducatif.
"""

from pathlib import Path
from typing import Optional

from PIL import Image
import pytesseract
from pypdf import PdfReader

try:
    from faster_whisper import WhisperModel
    WHISPER_AVAILABLE = True
except ImportError:
    WHISPER_AVAILABLE = False


def read_text_file(path: str) -> str:
    """Lit un fichier texte (.txt, .md, .csv)."""
    return Path(path).read_text(encoding="utf-8", errors="ignore")


def read_pdf(path: str) -> str:
    """Extrait le texte d'un PDF."""
    reader = PdfReader(path)
    pages = []
    for page in reader.pages:
        text = page.extract_text() or ""
        pages.append(text)
    return "\n".join(pages).strip()


def read_image(path: str, language: str = "fra") -> str:
    """OCR sur une image (français par défaut)."""
    image = Image.open(path)
    lang = language if language else "fra"
    return pytesseract.image_to_string(image, lang=lang).strip()


def transcribe_audio(path: str, model_size: str = "small") -> str:
    """
    Transcription audio avec faster-whisper.
    model_size: tiny, base, small, medium, large-v3
    """
    if not WHISPER_AVAILABLE:
        raise RuntimeError(
            "faster-whisper n'est pas installé. "
            "Installez-le avec : pip install faster-whisper"
        )
    model = WhisperModel(model_size, device="cpu", compute_type="int8")
    segments, _ = model.transcribe(path, language="fr")
    return " ".join(segment.text.strip() for segment in segments).strip()


def extract_content(path: str, ocr_lang: str = "fra") -> str:
    """
    Point d'entrée unique : détecte le type de fichier et extrait le contenu.
    Formats supportés :
    - Texte : .txt, .md, .csv
    - PDF : .pdf
    - Images : .png, .jpg, .jpeg, .webp, .bmp, .tiff
    - Audio : .mp3, .wav, .m4a, .ogg, .flac
    """
    path_obj = Path(path)
    if not path_obj.exists():
        raise FileNotFoundError(f"Fichier introuvable : {path}")

    extension = path_obj.suffix.lower()

    if extension in {".txt", ".md", ".csv"}:
        return read_text_file(path)

    if extension == ".pdf":
        return read_pdf(path)

    if extension in {".png", ".jpg", ".jpeg", ".webp", ".bmp", ".tiff"}:
        return read_image(path, language=ocr_lang)

    if extension in {".mp3", ".wav", ".m4a", ".ogg", ".flac"}:
        return transcribe_audio(path)

    raise ValueError(
        f"Format non pris en charge : {extension}. "
        "Formats acceptés : txt, md, csv, pdf, png, jpg, jpeg, webp, "
        "mp3, wav, m4a, ogg, flac."
    )
