import streamlit as st
import requests
import os
from utils import fetch_data

st.title("Hello World")

data = fetch_data("/")

st.write(data)
