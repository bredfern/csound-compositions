<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;RT audio out
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o diskgrain.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr     = 48000
ksmps  = 32
nchnls = 2
0dbfs  = 1

instr 1

iolaps  = 10
igrsize = 1
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = 1 /* timescale */
ipitch = rnd(127) /* pitchscale */

kenv linen 1, .1, 2, .3

a1 diskgrain "assets/oud1.wav", 1, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
   outs   a1*kenv, a1*kenv

endin

instr 2

iolaps  = rnd(100)
igrsize = rnd(200)
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = rnd(100)  /* timescale */
ipitch = rnd(127) /* pitchscale */

kenv linen 1, .1, 2, .3

a1 diskgrain "assets/oud2.wav", 0.420, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
   outs   a1*kenv, a1*kenv
   
endin

</CsInstruments>
<CsScore>
f 1 0 8192 20 2 1  ;Hanning function

{1000 CNT 
i1 [0.1 * $CNT] 0.5
} 

{1000 CNT 
i2 [0.1 * $CNT] 0.5
}


e
</CsScore>
</CsoundSynthesizer>
