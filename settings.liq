# ffmpeg settings
settings.ffmpeg.log.level := 3
settings.ffmpeg.log.verbosity := "warning"
settings.ffmpeg.scaling_algorithm := "bicubic"
settings.protocol.ffmpeg.path := "ffmpeg"
settings.protocol.ffmpeg.metadata := true
settings.protocol.ffmpeg.replaygain := false
settings.decoder.file_extensions.id3 := ["mp3", "wav"]
settings.decoder.file_extensions.mad := ["mp3", "mp2", "mp1"]
settings.decoder.file_extensions.taglib := ["mp3", "ogg", "mkv", "wav", "flac", "mp4", "m4a"]

settings.decoder.mime_types.id3 := ["audio/mpeg", "audio/x-wav"]
settings.decoder.mime_types.ogg := ["audio/opus", "application/ogg", "application/x-ogg", "audio/x-ogg", "audio/ogg", "video/ogg"]
settings.decoder.mime_types.ogg_metadata := ["audio/ogg"]
settings.decoder.mime_types.taglib := ["audio/mpeg", "audio/ogg", "video/ogg", "audio/wav", "audio/wave", "audio/flac", "audio/mp4", "video/mp4"]
settings.decoder.mime_types.wav := ["audio/vnd.wave", "audio/wav", "audio/wave", "audio/x-wav"]

# external decoder settings
settings.decoder.external.ffprobe.path := "ffprobe"
settings.decoder.external.ffmpeg.path := "ffmpeg"

# harbor settings
settings.harbor.accept_timeout := 3.
settings.harbor.bind_addrs := ["0.0.0.0"]
settings.harbor.icy_formats := ["audio/mpeg", "audio/aac", "audio/x-aac", "audio/wav", "audio/wave"]
settings.harbor.max_connections := 2
settings.harbor.reverse_dns := false
settings.harbor.timeout := 120.
settings.harbor.verbose := false
