import requests
import os

# Define the URL of the Go backend server
ANTARCTICITE_BACKEND_HOST = os.getenv("ANTARCTICITE_BACKEND_HOST") if os.getenv("ANTARCTICITE_BACKEND_HOST") else "http://localhost:8080"

def fetch_data(route):
    url = f"{ANTARCTICITE_BACKEND_HOST}{route}"
    try:
        response = requests.get(url)
        if response.status_code == 200:
            return response.text  # Assuming the response is in JSON format
        else:
            return {"error": f"Failed to retrieve data from {route}. Status code: {response.status_code}"}
    except Exception as e:
        return {"error": str(e)}

