# TrackLogger.py v 1.06
# This script will periodically check an icecast 
# url and get the meta data of the current track
# playing and log this to a log file.
# best run on cron every 2 minutes.
#
# Script by Nigel Smart (ngsmart1979@gmail.com)
# Latest version always on github.
# https://www.github.com/nigeyuk/TAW-Liquidsoap


import os
import requests
from datetime import datetime, timedelta
import time

# Icecast server details
ICECAST_URL = 'http://localhost:8000/status-json.xsl'
LOG_DIR = 'logs'
DUPLICATE_CHECK_INTERVAL = 60  # in minutes
RETRY_COUNT = 3  # Number of times to retry on failure
RETRY_DELAY = 5  # Delay between retries in seconds

# Ensure the logs directory exists
if not os.path.exists(LOG_DIR):
    os.makedirs(LOG_DIR)

def get_log_filename():
    # Generate the log file name based on the current date
    current_date = datetime.now().strftime('%Y-%m-%d')
    log_filename = os.path.join(LOG_DIR, f"{current_date}.log")
    return log_filename

def get_metadata():
    for attempt in range(RETRY_COUNT):
        try:
            response = requests.get(ICECAST_URL, timeout=10)
            response.raise_for_status()
            data = response.json()
            
            # Check if 'icestats' and 'source' exist in the response
            if 'icestats' not in data or 'source' not in data['icestats']:
                print("Expected keys not found in the response.")
                return []

            sources = data['icestats']['source']
            if not isinstance(sources, list):
                sources = [sources]

            metadata_list = []
            for source in sources:
                artist = source.get('artist', 'Unknown Artist')
                title = source.get('title', 'Unknown Title')
                metadata_list.append((artist, title))

            return metadata_list
        except requests.exceptions.RequestException as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            if attempt < RETRY_COUNT - 1:
                print(f"Retrying in {RETRY_DELAY} seconds...")
                time.sleep(RETRY_DELAY)
            else:
                print("Max retries reached. Exiting.")
                return []

def is_duplicate(artist, title):
    log_filename = get_log_filename()
    try:
        with open(log_filename, 'r') as log_file:
            lines = log_file.readlines()
            now = datetime.now()

            for line in reversed(lines):
                log_time_str, log_artist_title = line.split(' - ', 1)
                log_time = datetime.strptime(log_time_str, '%Y-%m-%d %H:%M:%S')

                if now - log_time > timedelta(minutes=DUPLICATE_CHECK_INTERVAL):
                    break

                if f"Artist: {artist}, Title: {title}" in log_artist_title:
                    return True

    except FileNotFoundError:
        # If the log file doesn't exist, no duplicates exist
        return False
    except Exception as e:
        print(f"Error reading log file: {e}")
        return False

    return False

def log_metadata(artist, title):
    log_filename = get_log_filename()
    try:
        with open(log_filename, 'a') as log_file:
            current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            log_file.write(f"{current_time} - Artist: {artist}, Title: {title}\n")
            print(f"Logged: {current_time} - Artist: {artist}, Title: {title}")
    except Exception as e:
        print(f"Error writing to log file: {e}")

def main():
    metadata_list = get_metadata()
    if not metadata_list:
        print("No metadata fetched. Either the Icecast server is down or unreachable.")
    else:
        for artist, title in metadata_list:
            if artist and title and not is_duplicate(artist, title):
                log_metadata(artist, title)

if __name__ == '__main__':
    main()
