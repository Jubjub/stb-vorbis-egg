(foreign-declare  "#ifndef STB_VORBIS_C\n
                   #define STB_VORBIS_C\n 
                   #include \"stb_vorbis.c\"
                   #endif")

(module stb-vorbis *
        (import chicken scheme foreign lolevel)
        (use srfi-4)

        (define stb:vorbis-open-filename
          (foreign-lambda* c-pointer ((c-string path))
            "C_return(stb_vorbis_open_filename(path, 0, 0));"))

        #;(define stb:vorbis-get-info
          (foreign-lambda* c-pointer ((c-pointer object))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_get_info(stb_vorbis_object));"))

        (define stb:vorbis-sample-rate
          (foreign-lambda* integer ((c-pointer object))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_object->sample_rate);"))

        (define stb:vorbis-channels
          (foreign-lambda* integer ((c-pointer object))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_object->channels);"))

        (define stb:vorbis-stream-length-in-samples
          (foreign-lambda* integer ((c-pointer object))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_stream_length_in_samples(object));"))

        (define stb:vorbis-stream-length-in-seconds
          (foreign-lambda* float ((c-pointer object))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_stream_length_in_seconds(object));"))

        (define stb:vorbis-get-samples-short-interleaved
          (foreign-lambda* integer ((c-pointer object)
                                    (integer channels)
                                    (c-pointer buffer)
                                    (integer num_shorts))
            "stb_vorbis *stb_vorbis_object = object;
            C_return(stb_vorbis_get_samples_short_interleaved(stb_vorbis_object, channels,
                                                              buffer, num_shorts));"))

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
