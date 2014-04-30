(foreign-declare  "#include \"stb_vorbis.c\"")

(module stb-vorbis *
        (import chicken scheme foreign lolevel)
        (use srfi-4)
        (define stb:vorbis-decode-filename
          (foreign-lambda* c-pointer ((c-string path)
                                      ((c-pointer integer) channels)
                                      ((c-pointer integer) size))
          "short *buffer;
          int read = stb_vorbis_decode_filename(path, channels, &buffer);
          *size = read;
          C_return(buffer);"))

          (define (stbv:decode-file path)
            (let-location
              ((channels integer)
               (size integer))
              (let* ((data (stb:vorbis-decode-filename path
                                                       (location channels)
                                                       (location size)))
                     (buffer (make-s16vector size)))
                (move-memory! data buffer (* 2 size))
                (free data)
                (list buffer channels)))))
