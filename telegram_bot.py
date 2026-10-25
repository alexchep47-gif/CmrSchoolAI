"""
CMR SCHOOL – Bot Telegram
Commandes : /start, /aide, /niveau, /reset
Envoi de fichiers (PDF, image, audio) + questions textuelles.
"""

import logging
import os
from pathlib import Path

from telegram import Update, InlineKeyboardButton, InlineKeyboardMarkup
from telegram.ext import (
    Application,
    CommandHandler,
    MessageHandler,
    CallbackQueryHandler,
    ContextTypes,
    filters,
)
from dotenv import load_dotenv

from cmr_school.config import BOT_TOKEN, OWNER_ID, LEVELS, UPLOADS_DIR
from cmr_school.ai import CMRSchoolAI
from cmr_school.readers import extract_content

load_dotenv()
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    level=logging.INFO,
)
logger = logging.getLogger(__name__)

user_data: dict[int, dict] = {}


def get_user(uid: int) -> dict:
    if uid not in user_data:
        user_data[uid] = {
            "level": "Lycée",
            "document": "",
            "history": [],
        }
    return user_data[uid]


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    get_user(user.id)
    text = (
        f"Bonjour {user.first_name} ! 🎓\n\n"
        "Je suis **CMR SCHOOL**, ton assistant éducatif.\n\n"
        "Tu peux :\n"
        "• M'envoyer une question textuelle\n"
        "• M'envoyer un PDF, une image ou un audio éducatif\n"
        "• Changer ton niveau avec /niveau\n\n"
        "Exemple : *Explique-moi les fractions avec un exemple simple*\n\n"
        "Usage strictement pédagogique."
    )
    await update.message.reply_text(text, parse_mode="Markdown")


async def aide(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text(
        "📖 **Aide CMR SCHOOL**\n\n"
        "/start – Menu principal\n"
        "/niveau – Choisir ton niveau scolaire\n"
        "/reset – Effacer le document en cours\n"
        "/aide – Cette aide\n\n"
        "Envoie simplement ta question ou un fichier (PDF, image, audio).",
        parse_mode="Markdown",
    )


async def niveau(update: Update, context: ContextTypes.DEFAULT_TYPE):
    keyboard = [
        [InlineKeyboardButton(lvl, callback_data=f"level:{lvl}")]
        for lvl in LEVELS
    ]
    await update.message.reply_text(
        "Choisis ton niveau scolaire :",
        reply_markup=InlineKeyboardMarkup(keyboard),
    )


async def level_callback(update: Update, context: ContextTypes.DEFAULT_TYPE):
    query = update.callback_query
    await query.answer()
    level = query.data.split(":", 1)[1]
    ud = get_user(query.from_user.id)
    ud["level"] = level
    await query.edit_message_text(f"✅ Niveau défini : **{level}**", parse_mode="Markdown")


async def reset(update: Update, context: ContextTypes.DEFAULT_TYPE):
    ud = get_user(update.effective_user.id)
    ud["document"] = ""
    await update.message.reply_text("🗑️ Document effacé. Tu peux en envoyer un nouveau.")


async def handle_document(update: Update, context: ContextTypes.DEFAULT_TYPE):
    doc = update.message.document
    file = await context.bot.get_file(doc.file_id)
    dest = UPLOADS_DIR / (doc.file_name or f"doc_{doc.file_id}")
    await file.download_to_drive(str(dest))

    try:
        content = extract_content(str(dest))
        ud = get_user(update.effective_user.id)
        ud["document"] = content
        preview = content[:400] + ("..." if len(content) > 400 else "")
        await update.message.reply_text(
            f"✅ Fichier analysé ({len(content)} caractères).\n\n"
            f"Aperçu :\n```\n{preview}\n```\n\n"
            "Pose maintenant ta question sur ce document.",
            parse_mode="Markdown",
        )
    except Exception as e:
        await update.message.reply_text(f"❌ Erreur d'analyse : {e}")


async def handle_photo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    photo = update.message.photo[-1]
    file = await context.bot.get_file(photo.file_id)
    dest = UPLOADS_DIR / f"photo_{photo.file_id}.jpg"
    await file.download_to_drive(str(dest))

    try:
        content = extract_content(str(dest))
        ud = get_user(update.effective_user.id)
        ud["document"] = content
        preview = content[:400] + ("..." if len(content) > 400 else "")
        await update.message.reply_text(
            f"✅ Image analysée (OCR).\n\nAperçu :\n```\n{preview}\n```",
            parse_mode="Markdown",
        )
    except Exception as e:
        await update.message.reply_text(f"❌ Erreur OCR : {e}")


async def handle_audio(update: Update, context: ContextTypes.DEFAULT_TYPE):
    if update.message.voice:
        media = update.message.voice
        ext = ".ogg"
    else:
        media = update.message.audio
        ext = Path(media.file_name or "audio.mp3").suffix or ".mp3"

    file = await context.bot.get_file(media.file_id)
    dest = UPLOADS_DIR / f"audio_{media.file_id}{ext}"
    await file.download_to_drive(str(dest))

    await update.message.reply_text("🎧 Transcription en cours...")
    try:
        content = extract_content(str(dest))
        ud = get_user(update.effective_user.id)
        ud["document"] = content
        await update.message.reply_text(
            f"✅ Audio transcrit.\n\n```\n{content[:600]}\n```",
            parse_mode="Markdown",
        )
    except Exception as e:
        await update.message.reply_text(f"❌ Erreur transcription : {e}")


async def handle_text(update: Update, context: ContextTypes.DEFAULT_TYPE):
    text = update.message.text.strip()
    if not text:
        return

    ud = get_user(update.effective_user.id)
    await update.message.chat.send_action("typing")

    try:
        ai = CMRSchoolAI()
        answer = ai.answer(
            question=text,
            document=ud.get("document", ""),
            level=ud.get("level", "Lycée"),
        )
        if len(answer) > 4000:
            for i in range(0, len(answer), 4000):
                await update.message.reply_text(answer[i : i + 4000])
        else:
            await update.message.reply_text(answer)
    except Exception as e:
        logger.exception("Erreur IA")
        await update.message.reply_text(
            f"❌ Impossible de générer la réponse pour le moment.\n{e}"
        )


def main():
    if not BOT_TOKEN:
        raise SystemExit(
            "BOT_TOKEN manquant. Ajoutez-le dans le fichier .env"
        )

    app = Application.builder().token(BOT_TOKEN).build()

    app.add_handler(CommandHandler("start", start))
    app.add_handler(CommandHandler("aide", aide))
    app.add_handler(CommandHandler("help", aide))
    app.add_handler(CommandHandler("niveau", niveau))
    app.add_handler(CommandHandler("reset", reset))
    app.add_handler(CallbackQueryHandler(level_callback, pattern=r"^level:"))

    app.add_handler(MessageHandler(filters.Document.ALL, handle_document))
    app.add_handler(MessageHandler(filters.PHOTO, handle_photo))
    app.add_handler(MessageHandler(filters.VOICE | filters.AUDIO, handle_audio))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))

    logger.info("CMR SCHOOL Telegram bot démarré")
    app.run_polling(allowed_updates=Update.ALL_TYPES)


if __name__ == "__main__":
    main()
