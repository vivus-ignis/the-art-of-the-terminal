import os
import traceback
from datetime import datetime
from urllib.parse import quote_plus

from loguru import logger
from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse, FileResponse

from sqlmodel import Field, Session, SQLModel, create_engine, select, text
from pydantic import BaseModel
from openai import OpenAI

app = FastAPI()

OPENAI_PROMPT = """
You are the President of the United States Donald Trump. Rewrite the following phrase as a part of your own speech
(but do not enclose your response in quotes):
""".replace("\n", "").strip()


class BrokenOpenAIResponse(Exception):
    pass


class BrokenDB(Exception):
    pass


class PhraseRequest(BaseModel):
    phrase: str


class Phrase(SQLModel, table=True):
    original_phrase: str = Field(primary_key=True)
    converted_phrase: str
    inserted_at: datetime = Field(default_factory=datetime.utcnow)


class PhraseResponse(BaseModel):
    original_phrase: str
    converted_phrase: str

    class Config:
        from_attributes = True


def read_secret_file(path):
    with open(path) as file:
        return file.read().strip()


def error_message(error, code=500):
    raise HTTPException(
        status_code=code,
        detail=f"""
Folks, believe me, something went wrong, bigly wrong with '{error}', 
but I’ve got the best people, tremendous people, 
and we’re fixing it faster than anyone else could, nobody does it better!
                """.replace("\n", "").strip()
    )


OPENAI_TOKEN = read_secret_file(os.environ['OPENAI_TOKEN_FILE'])

DB_USER = os.environ['DB_USER']
DB_HOST = os.environ['DB_HOST']
DB_PASSWORD = quote_plus(
        read_secret_file(os.environ['DB_PASSWORD_FILE'])
)
DB_CONNECTION_URL = f'postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:5432/postgres'

engine = create_engine(DB_CONNECTION_URL, echo=True)
SQLModel.metadata.create_all(engine)


@app.get("/")
async def frontend() -> HTMLResponse:
    with open("frontend/index.html", "r") as file:
        content = file.read()
    return HTMLResponse(content=content)


@app.get("/health")
async def healthcheck():
    try:
        with Session(engine) as session:
            session.execute(text("SELECT 1"))
        return {"status": "OK"}
    except Exception as exn:
        logger.error(f"Unhandled exception {exn}\n{traceback.format_exc()}")
        error_message(exn)


@app.get("/img/{image_name}")
async def get_image(image_name: str):
    image_path = os.path.join("frontend", image_name)
    if not os.path.isfile(image_path):
        error_message("Image not found", 404)
    return FileResponse(image_path)


@app.post("/api/trump")
async def trump_speech(request: PhraseRequest):
    try:
        with Session(engine) as session:
            stmt = select(Phrase).where(Phrase.original_phrase == request.phrase)
            phrase = session.exec(stmt).first()
            if phrase:
                logger.info(f"Cache hit for '{request.phrase}'")
                return PhraseResponse.from_orm(phrase)

        client = OpenAI(api_key=OPENAI_TOKEN)

        response = client.chat.completions.create(
            model="gpt-4o-mini",
            messages=[
                {"role": "user", "content": f"{OPENAI_PROMPT} {request}"}
            ]
        )
        trump_style_text = response.choices[0].message.content
        if not trump_style_text:
            raise BrokenOpenAIResponse

        phrase_db = Phrase(original_phrase=request.phrase, converted_phrase=trump_style_text)
        with Session(engine) as session:
            session.add(phrase_db)
            session.commit()

            return PhraseResponse.from_orm(phrase_db)

    except Exception as exn:
        logger.error(f"Unhandled exception {exn}\n{traceback.format_exc()}")
        error_message(exn)
