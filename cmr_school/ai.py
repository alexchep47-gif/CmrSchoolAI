"""
Intelligence artificielle éducative pour CMR SCHOOL.
Compatible OpenAI et fournisseurs OpenAI-compatible (Groq, etc.).
"""

import os
from typing import Optional

from openai import OpenAI

from .config import OPENAI_API_KEY, OPENAI_MODEL, OPENAI_BASE_URL, SYSTEM_PROMPT


class CMRSchoolAI:
    """Assistant éducatif CMR SCHOOL."""

    def __init__(
        self,
        api_key: Optional[str] = None,
        model: Optional[str] = None,
        base_url: Optional[str] = None,
    ):
        key = api_key or OPENAI_API_KEY
        if not key:
            raise ValueError(
                "OPENAI_API_KEY manquante. "
                "Définissez-la dans le fichier .env"
            )
        kwargs = {"api_key": key}
        if base_url or OPENAI_BASE_URL:
            kwargs["base_url"] = base_url or OPENAI_BASE_URL
        self.client = OpenAI(**kwargs)
        self.model = model or OPENAI_MODEL

    def answer(
        self,
        question: str,
        document: str = "",
        level: str = "Général",
        max_document_chars: int = 50000,
    ) -> str:
        """
        Génère une réponse pédagogique.

        Args:
            question: Question de l'apprenant
            document: Contenu extrait d'un fichier (optionnel)
            level: Niveau scolaire (Primaire, Collège, etc.)
            max_document_chars: Limite de caractères pour le contexte
        """
        doc_snippet = (document or "")[:max_document_chars]

        user_prompt = f"""
Niveau de l'apprenant : {level}

Question de l'apprenant :
{question}

Contenu documentaire disponible (si fourni) :
{doc_snippet if doc_snippet else "(aucun document fourni)"}

Réponds de manière claire, progressive et pédagogique.
Adapte le vocabulaire et la profondeur au niveau indiqué.
"""

        response = self.client.chat.completions.create(
            model=self.model,
            temperature=0.3,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": user_prompt},
            ],
        )
        return response.choices[0].message.content.strip()

    def generate_quiz(
        self,
        topic: str,
        level: str = "Lycée",
        n_questions: int = 5,
    ) -> str:
        """Génère un quiz éducatif sur un sujet."""
        prompt = f"""
Crée un quiz de {n_questions} questions à choix multiples (4 options)
sur le sujet suivant, adapté au niveau {level}.

Sujet : {topic}

Format strict :
Question 1 : ...
A) ...
B) ...
C) ...
D) ...
Réponse correcte : X
Explication courte : ...

(et ainsi de suite)
"""
        return self.answer(question=prompt, level=level)
