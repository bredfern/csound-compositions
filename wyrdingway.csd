<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac     ;;;RT audio out
;-iadc    ;;;uncomment -iadc if RT audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o diskgrain.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
sr = 44100
ksmps  = 32
nchnls = 2

giSine    ftgen     0, 0, 2^10, 10, 1

instr 1

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

asig diskgrain "assets/oud2.wav", 0.3, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
; Vary the cutoff frequency from 30 to 300 Hz.
  kcutoff line 10, p3, 300
  kresonance = 0.5
  ; Apply the filter.
  a1 lowres asig, kcutoff, kresonance
kenv      linen     1, p3/4, p3, p3/4
   outs   kenv*a1, kenv*a1

endin

instr 2 ;nharmonic additive synthesis
ibasefrq  =         cpspch(p4)
ibaseamp  =         ampdbfs(p5)
;create 8 inharmonic partials
aOsc1     poscil    ibaseamp, ibasefrq, giSine
aOsc2     poscil    ibaseamp/2, ibasefrq*1.02, giSine
aOsc3     poscil    ibaseamp/3, ibasefrq*1.1, giSine
aOsc4     poscil    ibaseamp/4, ibasefrq*1.23, giSine
aOsc5     poscil    ibaseamp/5, ibasefrq*1.26, giSine
aOsc6     poscil    ibaseamp/6, ibasefrq*1.31, giSine
aOsc7     poscil    ibaseamp/7, ibasefrq*1.39, giSine
aOsc8     poscil    ibaseamp/8, ibasefrq*1.41, giSine
kenv      linen     1, p3/4, p3, p3/4
aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
          outs aOut*kenv, aOut*kenv
    endin

    instr 3
  ibps    = 1.6937
  iplaybackspeed = ibps/p5
  asource diskin p4, iplaybackspeed, 0, 1

  asig bbcutm asource, 2.6937, p6, 4, 4, p7, 2, 0.1, 1
 kenv      linen     1, p3/4, p3, p3/4
   outs   kenv*asig, kenv*asig
endin
</CsInstruments>
<CsScore>
f 1 0 1024 10 1 ; sine
f 2 0 1024 10 1 1 1; 3 harmonics
f 8 0 8192 10 1;


;           timescale   pitchscale
i 1   0   25     0.5        1.5
i 1   + 25     1.1       0.75
i 1  + 50        0.5        1.0
i 1  + 20      0.01    1.0
i 1 + 50 0.25 0.77
i 1 + 30 0.77 1.6
i 1 + 60 0.77 1.6

i 2 0   15 8.00 -28
i 2 13 15 9.00 -29
i 2 15 18 9.02 -28
i 2 16 19 7.01 -26
i 2 17 10 6.00 -21
i 2 25 20 8.01 -22
i 2 43 20 4.03 -21
i 2 60 20 8.00 -20
i 2 80 20 7.00 -28
i 2 100 16 8.00 -22
i 2 110 30 6.00 -21
i 2 180 20 7.00 -21
i 2 200 40 7.00 -22

;   source      bps cut repeats
i 3 10 10 "assets/amen-m.wav" 2.3 8   2
i 3 10 10 "assets/oud2.wav" 2.4 8   3
i 3 10 10 "assets/oud1.wav" 2.5 16  2
i 3 20  10 "assets/amen-m.wav" 2.3 8   12
i 3 20 10 "assets/oud2.wav" 2.4 8   3
i 3 20 10 "assets/oud1.wav" 2.5 16  2
i 3 30  10 "assets/amen-m.wav" 2.3 8   12
i 3 30  10 "assets/oud2.wav" 2.4 8   13
i 3 30  10 "assets/oud1.wav" 2.5 16  2
i 3 40  10 "assets/amen-m.wav" 2.3 8   2
i 3 40  10 "assets/oud2.wav" 2.4 8   3
i 3 40  10 "assets/oud1.wav" 2.5 16  12
i 3 50  10 "assets/amen-m.wav" 2.3 8   2
i 3 50 10 "assets/oud2.wav" 2.4 8   3
i 3 50  10 "assets/oud1.wav" 2.5 16  22
i 3 60  10 "assets/amen-m.wav" 2.3 8   2
i 3 60  10 "assets/oud2.wav" 2.4 8   33
i 3 60  10 "assets/oud1.wav" 2.5 16  2
i 3 70  10 "assets/amen-m.wav" 2.3 8   12
i 3 70  10 "assets/oud2.wav" 2.4 8   3
i 3 70  10 "assets/oud1.wav" 2.5 16  2
i 3 100  10 "assets/amen-m.wav" 2.3 8   2
i 3 100  10 "assets/oud2.wav" 2.4 8   3
i 3 100  10 "assets/oud1.wav" 2.5 16  12
i 3 110  10 "assets/amen-m.wav" 2.3 8   2
i 3 110  10 "assets/oud2.wav" 2.4 8   23
i 3 110  10 "assets/oud1.wav" 2.5 16  2
i 3 120  10 "assets/amen-m.wav" 2.3 8   2
i 3 120  10 "assets/oud2.wav" 2.4 8   3
i 3 120  10 "assets/oud1.wav" 2.5 16  2
i 3 130  10 "assets/amen-m.wav" 2.3 8   2
i 3 130  10 "assets/oud2.wav" 2.4 8   23
i 3 130  10 "assets/oud1.wav" 2.5 16  12
i 3 140  10 "assets/amen-m.wav" 2.3 8   12
i 3 140  10 "assets/oud2.wav" 2.4 8   3
i 3 140  10 "assets/oud1.wav" 2.5 16  22
i 3 150  10 "assets/amen-m.wav" 2.3 8   2
i 3 150  10 "assets/oud2.wav" 2.4 8   13
i 3 150  10 "assets/oud1.wav" 2.5 16  42
i 3 160  10 "assets/amen-m.wav" 2.3 8   2
i 3 160  10 "assets/oud2.wav" 2.4 8   3
i 3 160  10 "assets/oud1.wav" 2.5 16  32
i 3 170  10 "assets/amen-m.wav" 2.3 8   2
i 3 170  10 "assets/oud2.wav" 2.4 8   3
i 3 170  10 "assets/oud1.wav" 2.5 16  2
e
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="background">
  <r>240</r>
  <g>240</g>
  <b>240</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
