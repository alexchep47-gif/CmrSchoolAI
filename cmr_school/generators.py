"""
Génération de fichiers éducatifs : texte, PDF, audio.
"""

from pathlib import Path
from typing import Optional

from gtts import gTTS
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm

from .config import OUTPUTS_DIR


def save_text(content: str, filename: str = "reponse_cmr_school.txt") -> str:
    """Enregistre un fichier texte UTF-8."""
    path = OUTPUTS_DIR / filename
    path.write_text(content, encoding="utf-8")
    return str(path)


def save_pdf(
    content: str,
    filename: str = "reponse_cmr_school.pdf",
    title: str = "CMR SCHOOL – Réponse éducative",
) -> str:
    """
    Génère un PDF simple (A4) à partir du texte.
    Gère le retour à la ligne automatique.
    """
    path = OUTPUTS_DIR / filename
    pdf = canvas.Canvas(str(path), pagesize=A4)
    width, height = A4

    left = 20 * mm
    right = width - 20 * mm
    top = height - 20 * mm
    bottom = 20 * mm
    line_height = 14
    max_width = right - left

    y = top
    pdf.setFont("Helvetica-Bold", 14)
    pdf.drawString(left, y, title)
    y -= 25

    pdf.setFont("Helvetica", 11)

    for paragraph in content.splitlines():
        if not paragraph.strip():
            y -= line_height
            if y < bottom:
                pdf.showPage()
                pdf.setFont("Helvetica", 11)
                y = top
            continue

        words = paragraph.split()
        line = ""
        for word in words:
            candidate = f"{line} {word}".strip()
            if pdf.stringWidth(candidate, "Helvetica", 11) <= max_width:
                line = candidate
            else:
                if line:
                    pdf.drawString(left, y, line)
                    y -= line_height
                    if y < bottom:
                        pdf.showPage()
                        pdf.setFont("Helvetica", 11)
                        y = top
                line = word
        if line:
            pdf.drawString(left, y, line)
            y -= line_height
            if y < bottom:
                pdf.showPage()
                pdf.setFont("Helvetica", 11)
                y = top

    pdf.save()
    return str(path)


def save_audio(
    content: str,
    filename: str = "reponse_cmr_school.mp3",
    language: str = "fr",
) -> str:
    """
    Synthèse vocale (gTTS) – français par défaut.
    Note : gTTS nécessite une connexion internet.
    """
    text = content[:4000] if len(content) > 4000 else content
    path = OUTPUTS_DIR / filename
    tts = gTTS(text=text, lang=language, slow=False)
    tts.save(str(path))
    return str(path)
