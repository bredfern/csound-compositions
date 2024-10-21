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

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

a1 diskgrain "assets/oud-master.wav", 1, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
   outs   a1, a1

endin

instr 2

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

a1 diskgrain "assets/goth-guitar.wav", 0.60, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
   outs   a1, a1

endin

</CsInstruments>
<CsScore>
f 1 0 8192 20 2 1  ;Hanning function

;           timescale   pitchscale
i 1   0   50     1           1.3
i 1   +   50     2           0.8
i 1   +   50     1          0.75
i 1   +   50     1.5        1.5
i 1   +   150    0.5        1.5

i 2   0   50     1           0.6
i 2   +   50     2           0.8
i 2   +   50     1          0.75
i 2   +   50     1.5        1.5
i 2   +   150    0.5        1.5
e
</CsScore>
</CsoundSynthesizer>
