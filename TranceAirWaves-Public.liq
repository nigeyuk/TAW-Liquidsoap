# TranceAirWaves-Public.liq v 1.0.0
# This is the public version of the liquidsoap
# script that runs on TranceAirwaves Radio.
# The script assumes you have a working liquidsoap installation
# See the liquidsoap website (www.liquidsoap.info)
# or the Liquidsoap github for more info on Liquidsoap
# https://github.com/savonet/liquidsoap.
#
# Script by Nigel Smart (ngsmart1979@gmail.com)
# Latest version always on github.
# https://github.com/nigeyuk/TAW-Liquidsoap

#!/usr/bin/liquidsoap

# Existing settings
%include "autocue.cue_file.liq"
%include "cuesettings.liq"
%include "settings.liq"

# log settings
settings.log.file.path :=("/path/to/your/radio.log")
settings.log.file := true
settings.log.file.append := false
settings.log.file.perms := 384
settings.log.level := 4
settings.log.unix_timestamps := false
settings.log.recode := false
settings.scheduler.log := true

# telnet settings
settings.server.telnet := true
settings.server.telnet.bind_addr := "0.0.0.0"
settings.server.telnet.revdns := false
settings.server.timeout := 120.
settings.server.telnet.port := 9500

# general settings
settings.console.colorize := "auto"
settings.init.catch_exn := true
settings.init.daemon := false
settings.init.daemon.pidfile := true
settings.init.daemon.pidfile.path := "/path/to/your/liquidsoap.pid"
settings.init.daemon.pidfile.perms := 416

# Check Autocue setup, print result, shutdown if problems
ignore(check_autocue_setup(shutdown=true, print=true))

enable_autocue_metadata()

# Flag to control playback switching
playlist_playing = ref(false)

# Initialize the external playlist queue and buffer
external_playlist_queue = request.queue(id="external_playlist_queue")
external_playlist_buffer = request.queue(id="external_playlist_buffer")

# Function to load the external playlist URI into the buffer without starting playback
def load_external_playlist(file) =
  external_playlist_buffer.set_queue([])  # Clear the buffer queue

  # Load tracks from the playlist file into the buffer
  external_tracks = playlist(file, mode="normal").remaining_files()
  list.iter(fun(track) ->
    external_playlist_buffer.push(request.create(track))
  , external_tracks)
end

# Function to start playing the buffered playlist
def start_external_playlist() =
  playlist_playing := true  # Set the flag to start the external playlist
  external_playlist_queue.set_queue([])  # Clear the main queue
  buffer_tracks = external_playlist_buffer.queue()  # Get all tracks from the buffer
  list.iter(fun(track) ->
    external_playlist_queue.push(track)
  , buffer_tracks)
end

# Automatically switch back to the main playlist when the external playlist is finished
def check_playlist_completion() =
  if external_playlist_queue.queue() == [] then  # Check if the queue is empty
    playlist_playing := false  # Switch back to the main playlist
  end
  1.0  # Check again in 1 second
end

add_timeout(1.0, check_playlist_completion)

# Register HTTP endpoint to load the playlist
def load_handler(_, response) =
  load_external_playlist("/path/to/externalplaylist.m3u8")
  response.html("<html><body><h1>Playlist loaded successfully!</h1></body></html>")
end

# Register HTTP endpoint to start playing the playlist
def play_handler(_, response) =
  start_external_playlist()
  response.html("<html><body><h1>Playlist started successfully!</h1></body></html>")
end

# register the endpoints with harbor

harbor.http.register("/load_playlist", load_handler)
harbor.http.register("/start_playlist", play_handler)

# Define your main radio content
singles = playlist("/path/to/singles", mode="randomize", reload_mode="watch", reload=3600)
mixes = playlist("/path/to/mixes", mode="randomize", reload_mode="watch", reload=3600)
jingles = playlist("/path/to/jingles")
security = single("/path/to/security.mp3")

# Combine the playlists as desired
radio = random(weights = [8, 1], [singles, mixes])
radio = random(weights = [1, 8], [jingles, radio])
radio = fallback(track_sensitive=false, [radio, security])

# Use fallback to dynamically choose between the external playlist and the regular radio
dynamic_radio = fallback(track_sensitive=false,
  [external_playlist_queue, radio])  # Fallback from external playlist to the regular radio

# Output using dynamic_radio at 192kbps
output.icecast(
  %mp3(bitrate=192),
  host = "localhost",
  port = 9000,
  password = "Password",
  mount = "output_192.mp3",
  name = "Your Radio Name",
  description = "Your Radio Description",
  genre = "Trance",
  url = "Your-url.com",
  dynamic_radio  # Use dynamic_radio as the source
)

# Output using dynamic_radio at 128kbps
output.icecast(
  %mp3(bitrate=128),
  host = "localhost",
  port = 9000,
  password = "Password",
  mount = "output_192.mp3",
  name = "Your Radio Name",
  description = "Your Radio Description",
  genre = "Trance",
  url = "Your-url.com",
  dynamic_radio  # Use dynamic_radio as the source
)

