# Logging Configuration
settings.log.file.path := "/home/nigel/liquidsoap/logs/taw-radio.log"
settings.log.file := true
settings.log.file.append := false
settings.log.file.perms := 384
settings.log.level := 4
settings.log.unix_timestamps := false
settings.log.recode := false
settings.scheduler.log := true

# Telnet Configuration
settings.server.telnet := true
settings.server.telnet.bind_addr := "192.168.0.187"
settings.server.telnet.revdns := false
settings.server.timeout := 120.
settings.server.telnet.port := 9500

# General Settings
settings.console.colorize := "auto"
settings.init.catch_exn := true
settings.init.daemon := false
settings.init.daemon.pidfile := true
settings.init.daemon.pidfile.path := "/home/nigel/liquidsoap/liquidsoap.pid"
settings.init.daemon.pidfile.perms := 416

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
