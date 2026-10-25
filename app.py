"""
CMR SCHOOL – Interface Streamlit
Assistant éducatif multimédia (PDF, images, audio, texte)
"""

import os
from pathlib import Path

import streamlit as st
from dotenv import load_dotenv

from cmr_school.config import LEVELS, UPLOADS_DIR
from cmr_school.ai import CMRSchoolAI
from cmr_school.readers import extract_content
from cmr_school.generators import save_audio, save_pdf, save_text

load_dotenv()

st.set_page_config(
    page_title="CMR SCHOOL",
    page_icon="🎓",
    layout="wide",
    initial_sidebar_state="expanded",
)

st.title("🎓 CMR SCHOOL")
st.caption(
    "Assistant intelligent exclusivement éducatif – "
    "Lecture, analyse et génération de fichiers multimédias"
)

if not os.getenv("OPENAI_API_KEY"):
    st.error(
        "⚠️ La variable **OPENAI_API_KEY** n'est pas configurée.\n\n"
        "Créez un fichier `.env` à la racine du projet avec :\n"
        "```\nOPENAI_API_KEY=votre_cle\nOPENAI_MODEL=gpt-4o-mini\n```"
    )
    st.stop()

@st.cache_resource
def get_ai():
    return CMRSchoolAI()

ai = get_ai()

if "document_content" not in st.session_state:
    st.session_state.document_content = ""
if "answer" not in st.session_state:
    st.session_state.answer = ""
if "last_filename" not in st.session_state:
    st.session_state.last_filename = ""

with st.sidebar:
    st.header("📁 Document")
    uploaded_file = st.file_uploader(
        "Importer un fichier éducatif",
        type=[
            "pdf", "txt", "md", "csv",
            "png", "jpg", "jpeg", "webp",
            "mp3", "wav", "m4a", "ogg", "flac",
        ],
        help="PDF, image (OCR), audio (transcription) ou texte",
    )

    if uploaded_file:
        file_path = UPLOADS_DIR / uploaded_file.name
        file_path.write_bytes(uploaded_file.getbuffer())
        st.session_state.last_filename = uploaded_file.name

        with st.spinner("Lecture et analyse du fichier..."):
            try:
                st.session_state.document_content = extract_content(str(file_path))
                st.success(f"✅ Fichier analysé : {uploaded_file.name}")
                with st.expander("Aperçu du contenu extrait"):
                    preview = st.session_state.document_content[:2000]
                    st.text(preview + ("..." if len(st.session_state.document_content) > 2000 else ""))
            except Exception as e:
                st.error(f"Erreur d'analyse : {e}")
                st.session_state.document_content = ""

    if st.session_state.document_content:
        if st.button("🗑️ Effacer le document"):
            st.session_state.document_content = ""
            st.session_state.last_filename = ""
            st.rerun()

    st.divider()
    st.markdown(
        """
        **Formats supportés**
        - 📄 PDF, TXT, MD, CSV
        - 🖼️ Images (OCR français)
        - 🎧 Audio (transcription)
        """
    )
    st.caption("Usage strictement éducatif")

col_q, col_level = st.columns([3, 1])

with col_q:
    question = st.text_area(
        "Votre question éducative",
        placeholder=(
            "Exemple : Explique-moi la photosynthèse avec un exemple simple.\n"
            "Ou : Résous cette équation et explique chaque étape."
        ),
        height=140,
    )

with col_level:
    niveau = st.selectbox(
        "Niveau de l'apprenant",
        LEVELS,
        index=2,
    )

if st.button("🧠 Répondre", type="primary", use_container_width=True):
    if not question.strip():
        st.warning("Veuillez saisir une question.")
    else:
        with st.spinner("CMR SCHOOL prépare une réponse pédagogique..."):
            try:
                answer = ai.answer(
                    question=question,
                    document=st.session_state.document_content,
                    level=niveau,
                )
                st.session_state.answer = answer
            except Exception as e:
                st.error(f"Erreur lors de la génération : {e}")

if st.session_state.answer:
    st.subheader("📖 Réponse de CMR SCHOOL")
    st.markdown(st.session_state.answer)

    st.divider()
    st.subheader("💾 Exporter la réponse")

    c1, c2, c3 = st.columns(3)

    with c1:
        if st.button("📄 Fichier texte", use_container_width=True):
            path = save_text(st.session_state.answer)
            st.success(f"Créé : `{path}`")
            with open(path, "rb") as f:
                st.download_button(
                    "Télécharger .txt",
                    f,
                    file_name="reponse_cmr_school.txt",
                    mime="text/plain",
                )

    with c2:
        if st.button("📕 PDF", use_container_width=True):
            path = save_pdf(st.session_state.answer)
            st.success(f"Créé : `{path}`")
            with open(path, "rb") as f:
                st.download_button(
                    "Télécharger .pdf",
                    f,
                    file_name="reponse_cmr_school.pdf",
                    mime="application/pdf",
                )

    with c3:
        if st.button("🎧 Audio (MP3)", use_container_width=True):
            with st.spinner("Génération audio..."):
                try:
                    path = save_audio(st.session_state.answer)
                    st.success(f"Créé : `{path}`")
                    with open(path, "rb") as f:
                        st.download_button(
                            "Télécharger .mp3",
                            f,
                            file_name="reponse_cmr_school.mp3",
                            mime="audio/mpeg",
                        )
                except Exception as e:
                    st.error(f"Erreur audio : {e}")

st.divider()
st.markdown(
    """
    <div style="text-align:center; color:#666; font-size:0.85rem;">
    CMR SCHOOL • Assistant éducatif camerounais • Usage pédagogique uniquement<br>
    Ne pas utiliser pour tricher aux examens.
    </div>
    """,
    unsafe_allow_html=True,
)
