(use openal)
(use al)
(use alc)
(use srfi-4)
(use stb-vorbis)

(define device (alc:OpenDevice #f))
(define context (alc:CreateContext device #f))
(define ogg (stb:vorbis-open-filename "broken.ogg"))
;(define data (car ogg))
(define rate (stb:vorbis-sample-rate ogg))
(define channels (stb:vorbis-channels ogg))
(define samples (stb:vorbis-stream-length-in-samples ogg))
(print "loaded ogg with " channels " channels, sample rate:" rate " "
       samples " samples, " (stb:vorbis-stream-length-in-seconds ogg) " seconds")

(define data (make-s16vector (* channels (stb:vorbis-stream-length-in-samples ogg))))
(define samples-read
  (stb:vorbis-get-samples-short-interleaved ogg channels (make-locative data) (* samples channels)))
(print "read " samples-read " samples")

(define (sound i)
  (/ (modulo i 60) 60))

#;(let loop ((i 0))
(unless (>= i 600000)
  (s16vector-set! data i (inexact->exact (floor (max 0 (min 256 (* 256 (sound i)))))))
  (loop (+ 1 i))))

(alc:MakeContextCurrent context)
(define buffer (openal:make-buffer data (= channels 2) rate))
(define source (openal:make-source buffer))

(al:Sourcei source al:LOOPING 1)
(al:SourcePlay source)
(read-line)
(alc:MakeContextCurrent #f)
(alc:DestroyContext context)
(alc:CloseDevice device)
