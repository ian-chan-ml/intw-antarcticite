import streamlit as st
import requests
import os
from utils import fetch_data

st.title("Access Logs")

logs_data = fetch_data("/access/logs")

st.write(logs_data)
