from flask import Flask, request, jsonify
import requests
import mysql.connector

app = Flask(__name__)

# Replace with your actual API keys and database credentials
GOOGLE_GEOCODING_API_KEY = "YOUR_GOOGLE_GEOCODING_API_KEY"
GOOGLE_WEATHER_API_KEY = "YOUR_GOOGLE_WEATHER_API_KEY"
MYSQL_HOST = "YOUR_MYSQL_HOST"
MYSQL_USER = "YOUR_MYSQL_USER"
MYSQL_PASSWORD = "YOUR_MYSQL_PASSWORD"
MYSQL_DATABASE = "YOUR_MYSQL_DATABASE"

@app.route('/', methods=['POST'])
def handle_weather_request():
    if not request.json or 'request' not in request.json:
        return jsonify({"error": "Invalid request body. 'request' key is missing."}), 400

    natural_language_request = request.json['request']

    try:
        # Step 3: Determine location using Google Maps Geocoding API
        geocode_url = f"https://maps.googleapis.com/maps/api/geocode/json?address={natural_language_request}&key={GOOGLE_GEOCODING_API_KEY}"
        geocode_response = requests.get(geocode_url)
        geocode_response.raise_for_status()  # Raise an exception for bad status codes
        geocode_data = geocode_response.json()

        if not geocode_data or geocode_data['status'] != 'OK' or not geocode_data['results']:
            return jsonify({"error": "Could not determine location from request."}), 400

        location = geocode_data['results'][0]['formatted_address']
        latitude = geocode_data['results'][0]['geometry']['location']['lat']
        longitude = geocode_data['results'][0]['geometry']['location']['lng']

        # Step 4: Get weather information using Google Weather API (Note: Google does not have a public Weather API, this is a placeholder)
        # You would typically use a weather API like OpenWeatherMap, WeatherAPI, etc.
        # For demonstration, we'll return a mock weather response.
        # weather_url = f"YOUR_WEATHER_API_ENDPOINT?lat={latitude}&lon={longitude}&key={GOOGLE_WEATHER_API_KEY}"
        # weather_response = requests.get(weather_url)
        # weather_response.raise_for_status()
        # weather_data = weather_response.json()

        # Mock weather data for demonstration
        weather_data = {
            "location": location,
            "temperature": "25°C",
            "conditions": "Sunny"
        }


        # Step 5: Insert original request and location into MySQL database
        conn = mysql.connector.connect(
            host=MYSQL_HOST,
            user=MYSQL_USER,
            password=MYSQL_PASSWORD,
            database=MYSQL_DATABASE
        )
        cursor = conn.cursor()
        insert_query = "INSERT INTO weather_requests (original_request, location) VALUES (%s, %s)"
        cursor.execute(insert_query, (natural_language_request, location))
        conn.commit()
        cursor.close()
        conn.close()

        # Step 6: Return the weather information as a JSON response
        return jsonify(weather_data), 200

    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"API request failed: {e}"}), 500
    except mysql.connector.Error as e:
        return jsonify({"error": f"Database error: {e}"}), 500
    except Exception as e:
        return jsonify({"error": f"An unexpected error occurred: {e}"}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')