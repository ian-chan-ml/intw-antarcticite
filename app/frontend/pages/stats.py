import streamlit as st
import requests
import os
from utils import fetch_data

st.title("Operating System Stats")


cpu_data = fetch_data("/cpu")
memory_data = fetch_data("/memory")
network_data = fetch_data("/network")
uptime_data = fetch_data("/uptime")

st.subheader("CPU Data")
st.write(cpu_data)

st.subheader("Memory Data")
st.write(memory_data)

st.subheader("Network Data")
st.write(network_data)

st.subheader("Uptime Data")
st.write(uptime_data)
