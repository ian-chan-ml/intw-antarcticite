import streamlit as st
import requests
import os

# Define the URL of the Go backend server
ANTARTICITE_BACKEND_HOST = os.getenv("ANTARTICITE_BACKEND_HOST") if os.getenv("ANTARTICITE_BACKEND_HOST") else "http://localhost:8080"

response = requests.get(ANTARTICITE_BACKEND_HOST)

# Display the response text from the Go backend server
if response.status_code == 200:
    st.write(response.text)
else:
    st.write("Failed to retrieve data from the backend server.")
