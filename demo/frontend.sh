#! /bin/bash
# Optional: Create virtual env
python -m venv .venv


source venv/bin/activate

streamlit run main.py

deactivate
