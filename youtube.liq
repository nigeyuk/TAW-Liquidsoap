# Output to Youtube
ImageSource = single("path/to/your/image/yourimage.png")file="yourimage.png") # your image to display (you must have an image for youtube streaming)
key = string.trim(file.contents("youtube-key")) # create a file in the same directory as this script with the name youtube-key and put your youtube streaming key in there.
url = "rtmp://a.rtmp.youtube.com/live2/#{key}" # Youtube RTMP url (this is displayed in your youtube live control panel)
enc = %ffmpeg(format="flv",
%audio(codec="libmp3lame", samplerate=44100, q=3), 
%video(codec="libx264", width=1920, height=1080,
b="2500k", g=50, preset="veryfast"))
output.url(fallible=true, url=url, enc, mux_video(video=ImageSource, radio))