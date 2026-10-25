"""
API web CMR SCHOOL (FastAPI)
Permet de connecter le site HTML ou d'autres clients.
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional

from cmr_school.ai import CMRSchoolAI
from cmr_school.config import LEVELS

app = FastAPI(
    title="CMR SCHOOL API",
    description="API éducative – questions pédagogiques uniquement",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class QuestionRequest(BaseModel):
    question: str = Field(..., min_length=3, max_length=4000)
    level: str = Field(default="Lycée")
    document: Optional[str] = Field(default="", max_length=50000)


class QuestionResponse(BaseModel):
    answer: str
    level: str


@app.get("/")
def root():
    return {
        "service": "CMR SCHOOL API",
        "status": "ok",
        "levels": LEVELS,
        "endpoints": {
            "POST /api/question": "Poser une question éducative",
        },
    }


@app.post("/api/question", response_model=QuestionResponse)
def ask_question(data: QuestionRequest):
    if data.level not in LEVELS:
        raise HTTPException(
            status_code=400,
            detail=f"Niveau invalide. Choix possibles : {LEVELS}",
        )
    try:
        ai = CMRSchoolAI()
        answer = ai.answer(
            question=data.question,
            document=data.document or "",
            level=data.level,
        )
        return QuestionResponse(answer=answer, level=data.level)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("web_api:app", host="0.0.0.0", port=8000, reload=True)
