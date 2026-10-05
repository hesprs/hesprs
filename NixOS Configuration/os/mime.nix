{
  xdg.mime.defaultApplications = {
    # Browser
    "text/html" = "zen-beta.desktop";
    "application/xhtml+xml" = "zen-beta.desktop";
    "application/vnd.mozilla.xul+xml" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/about" = "zen-beta.desktop";
    "x-scheme-handler/unknown" = "zen-beta.desktop";

    # File manager
    "inode/directory" = "org.gnome.Nautilus.desktop";

    # Image viewer
    "image/png" = "org.gnome.Loupe.desktop";
    "image/jpeg" = "org.gnome.Loupe.desktop";
    "image/gif" = "org.gnome.Loupe.desktop";
    "image/bmp" = "org.gnome.Loupe.desktop";
    "image/webp" = "org.gnome.Loupe.desktop";
    "image/tiff" = "org.gnome.Loupe.desktop";
    "image/svg+xml" = "org.gnome.Loupe.desktop";
    "image/svg+xml-compressed" = "org.gnome.Loupe.desktop";
    "image/avif" = "org.gnome.Loupe.desktop";
    "image/heic" = "org.gnome.Loupe.desktop";
    "image/jxl" = "org.gnome.Loupe.desktop";
    "image/apng" = "org.gnome.Loupe.desktop";
    "image/jp2" = "org.gnome.Loupe.desktop";
    "image/vnd.microsoft.icon" = "org.gnome.Loupe.desktop";
    "image/x-portable-anymap" = "org.gnome.Loupe.desktop";
    "image/x-portable-bitmap" = "org.gnome.Loupe.desktop";
    "image/x-portable-graymap" = "org.gnome.Loupe.desktop";
    "image/x-portable-pixmap" = "org.gnome.Loupe.desktop";
    "image/x-xbitmap" = "org.gnome.Loupe.desktop";
    "image/x-xpixmap" = "org.gnome.Loupe.desktop";

    # Video player
    "video/mp4" = "org.gnome.Showtime.desktop";
    "video/webm" = "org.gnome.Showtime.desktop";
    "video/x-matroska" = "org.gnome.Showtime.desktop";
    "video/ogg" = "org.gnome.Showtime.desktop";
    "video/quicktime" = "org.gnome.Showtime.desktop";
    "video/mpeg" = "org.gnome.Showtime.desktop";
    "video/x-msvideo" = "org.gnome.Showtime.desktop";
    "video/x-avi" = "org.gnome.Showtime.desktop";
    "video/x-flv" = "org.gnome.Showtime.desktop";
    "video/x-m4v" = "org.gnome.Showtime.desktop";
    "video/x-theora+ogg" = "org.gnome.Showtime.desktop";
    "video/3gp" = "org.gnome.Showtime.desktop";
    "video/3gpp" = "org.gnome.Showtime.desktop";
    "video/dv" = "org.gnome.Showtime.desktop";
    "video/x-ms-wmv" = "org.gnome.Showtime.desktop";
    "video/x-ms-asf" = "org.gnome.Showtime.desktop";

    # Audio player
    "audio/mpeg" = "org.gnome.Decibels.desktop";
    "audio/x-flac" = "org.gnome.Decibels.desktop";
    "audio/wav" = "org.gnome.Decibels.desktop";
    "audio/x-wav" = "org.gnome.Decibels.desktop";
    "audio/x-aac" = "org.gnome.Decibels.desktop";
    "audio/x-m4a" = "org.gnome.Decibels.desktop";
    "audio/x-mp3" = "org.gnome.Decibels.desktop";
    "audio/x-opus+ogg" = "org.gnome.Decibels.desktop";
    "audio/x-vorbis+ogg" = "org.gnome.Decibels.desktop";
    "audio/x-speex" = "org.gnome.Decibels.desktop";
    "audio/x-ape" = "org.gnome.Decibels.desktop";
    "audio/x-wavpack" = "org.gnome.Decibels.desktop";

    # PDF & documents
    "application/pdf" = "org.gnome.Papers.desktop";
    "application/vnd.comicbook-rar" = "org.gnome.Papers.desktop";
    "application/vnd.comicbook+zip" = "org.gnome.Papers.desktop";
    "image/vnd.djvu" = "org.gnome.Papers.desktop";

    # Email
    "x-scheme-handler/mailto" = "betterbird.desktop";
    "message/rfc822" = "betterbird.desktop";
    "text/calendar" = "betterbird.desktop";
    "text/x-vcard" = "betterbird.desktop";

    # Markdown & plain text & code
    "text/markdown" = "codium.desktop";
    "text/x-markdown" = "codium.desktop";
    "text/plain" = "codium.desktop";
    "text/csv" = "codium.desktop";
    "text/xml" = "codium.desktop";
    "application/json" = "codium.desktop";
    "application/x-code-workspace" = "codium.desktop";

    # Office — word processing (LibreOffice Writer)
    "application/msword" = "writer.desktop";
    "application/vnd.ms-word" = "writer.desktop";
    "application/vnd.oasis.opendocument.text" = "writer.desktop";
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "writer.desktop";
    "application/rtf" = "writer.desktop";

    # Office — spreadsheets (LibreOffice Calc)
    "application/vnd.ms-excel" = "calc.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "calc.desktop";
    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "calc.desktop";

    # Office — presentations (LibreOffice Impress)
    "application/vnd.ms-powerpoint" = "impress.desktop";
    "application/vnd.oasis.opendocument.presentation" = "impress.desktop";
    "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "impress.desktop";

    # Office — graphics (LibreOffice Draw)
    "application/vnd.oasis.opendocument.graphics" = "draw.desktop";
    "application/vnd.ms-publisher" = "draw.desktop";
    "application/vnd.visio" = "draw.desktop";

    # Office — formulas (LibreOffice Math)
    "application/mathml+xml" = "math.desktop";
    "application/vnd.oasis.opendocument.formula" = "math.desktop";

    # Archives (Nautilus handles these)
    "application/zip" = "org.gnome.Nautilus.desktop";
    "application/x-tar" = "org.gnome.Nautilus.desktop";
    "application/x-7z-compressed" = "org.gnome.Nautilus.desktop";
    "application/gzip" = "org.gnome.Nautilus.desktop";
    "application/x-xz" = "org.gnome.Nautilus.desktop";
    "application/zstd" = "org.gnome.Nautilus.desktop";
    "application/x-bzip" = "org.gnome.Nautilus.desktop";
    "application/x-bzip-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-xz-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-zstd-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-7z-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-lzip-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-lzma-compressed-tar" = "org.gnome.Nautilus.desktop";
    "application/x-tarz" = "org.gnome.Nautilus.desktop";
    "application/x-cpio" = "org.gnome.Nautilus.desktop";
    "application/x-xar" = "org.gnome.Nautilus.desktop";
    "application/vnd.rar" = "org.gnome.Nautilus.desktop";
  };
}
