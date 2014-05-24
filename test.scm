(use openal)
(use al)
(use alc)
(use srfi-4)
(use stb-vorbis)

(use lolevel)
(define device (alc:OpenDevice #f))
(define context (alc:CreateContext device #f))
(define data (car (stbv:decode-file "test.ogg")))

(define (sound i)
  (/ (modulo i 60) 60))

#;(let loop ((i 0))
  (unless (>= i 600000)
  (s16vector-set! data i (inexact->exact (floor (max 0 (min 256 (* 256 (sound i)))))))
  (loop (+ 1 i))))

(alc:MakeContextCurrent context)
(define buffer (openal:make-buffer data #t 44100))
(define source (openal:make-source buffer))

(al:Sourcei source al:LOOPING 1)
(al:SourcePlay source)
(read-line)
(alc:MakeContextCurrent #f)
(alc:DestroyContext context)
(alc:CloseDevice device)
