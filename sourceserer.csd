<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;RT audio out
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o diskgrain.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr     = 44100
ksmps  = 32
nchnls = 2
0dbfs  = 1
seed    0

gisine  ftgen   0,0,4096,10,1

gaSend init 0

 instr 1 ; wgbow instrument
kamp     =        0.1
kfreq    =        p4
kpres    =        0.2
krat     rspline  0.006,0.988,0.1,0.4
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
aSig     wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,gisine,iminfreq
aSig     butlp     aSig,2000
aSig     pareq    aSig,80,6,0.707
         outs     aSig,aSig
gaSend   =        gaSend + aSig/3
 endin

 instr 2 ; reverb
aRvbL,aRvbR reverbsc gaSend,gaSend,0.9,7000
            outs     aRvbL,aRvbR
            clear    gaSend
 endin

instr 3

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

a1 diskgrain "assets/oud2.wav", 1, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
kenv      linen     1, p3/4, p3, p3/4
   outs   kenv*a1, kenv*a1
endin
</CsInstruments>
<CsScore>
f 1 0 8192 20 2 1  ;Hanning function
f 2 0 1024 10 1 ; sine

; wgbow instrument
i 1  0 480  20
i 1  0 480  40
i 1  0 480  80
i 1  0 480  160
i 1  0 480  320
i 1  0 480  640
i 1  0 480  1280
i 1  0 480  2460
; reverb instrument
i 2 0 480

;           timescale   pitchscale
i 3   10   25     0.5        1.5
i 3   + 25     1.1       0.75
i 3  + 50        0.5        1.0
i 3  + 20      0.01    1.0
i 3 + 50 0.25 0.77
i 3 + 30 0.77 1.6
i 3 + 100 0.17 0.6
i 3 + 30 0.77 1.1
i 3 + 30 1.3 1.1
i 3 + 30 0.23 0.23
e
</CsScore>
</CsoundSynthesizer>
