<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

; By Bjrn Houdorf, April 2012

sr = 44100
ksmps = 8
nchnls = 2
0dbfs = 1



; Global initializations ("Instrument 0")

          seed      0;  New pitches, 
gkfreq1   init      0;  every time you
gkfreq2   init      0;  run this file
gkfreq3   init      0
gkfreq4   init      0
gimidia1  init      60; The 4 voices start
gimidib1  init      60; at differen
gimidia2  init      64; MIDI frequencies
gimidib2  init      64
gimidia3  init      67
gimidib3  init      67
gimidia4  init      70
gimidib4  init      70

; Function Table

giFt1     ftgen     0, 0, 16384, 10, 1; Sine wave



instr 1; Master control pitch for instrument 2
test:

idurtest  poisson   20; Duration of each test loop
          timout    0, idurtest, execute
          reinit    test

execute:
gimidia1  =         gimidib1
ital1     random    -4, 4
gimidib1  =         gimidib1 + ital1
gimidia2  =         gimidib2
ital2     random    -4, 4
gimidib2  =         gimidib2 + ital2
gimidia3  =         gimidib3
ital3     random    -4, 4
gimidib3  =         gimidib3 + ital3
gimidia4  =         gimidib4
ital4     random    -4, 4
gimidib4  =         gimidib4 + ital4 
idiv      poisson   4
idurx     =         0.01; Micro end segment to create
                                        ;a held final frequency value                                     
ifreq1a   =         cpsmidinn(gimidia1)*rnd(100)
ifreq1b   =         cpsmidinn(gimidib1)*rnd(100)
; Portamento frequency amp:
gkfreq1   linseg    ifreq1a, idurtest/idiv, ifreq1b, idurx, ifreq1b 
ifreq2a   =         cpsmidinn(gimidia2)*rnd(440)
ifreq2b   =         cpsmidinn(gimidib2)*rnd(66)
gkfreq2   linseg    ifreq2a, idurtest/idiv, ifreq2b, idurx, ifreq2b
ifreq3a   =         cpsmidinn(gimidia3)*rnd(100)
ifreq3b   =         cpsmidinn(gimidib3)*rnd(200)
gkfreq3   linseg    ifreq3a, idurtest/idiv, ifreq3b, idurx, ifreq3b
ifreq4a   =         cpsmidinn(gimidia4)*rnd(100)
ifreq4b   =         cpsmidinn(gimidib4)*rnd(100)
gkfreq4   linseg    ifreq4a, idurtest/idiv, ifreq4b, idurx, ifreq4b
endin

instr 2 ; Oscillators
iamp      =         p4
irise     =         p5
idur      =         p3
idec      =         p6
kamp      =         p7
imodfrq   =         p8
iharm     =         p9 ; Number of harmonics
ky        linen     iamp, irise, idur, idec
kampfreq  =         2
kampa     oscili    kamp, kampfreq, giFt1
; Different phase for the 4 voices
klfo1     oscili    kampa, imodfrq, giFt1, 0
klfo2     oscili    kampa, imodfrq, giFt1, 0.25
klfo3     oscili    kampa, imodfrq, giFt1, 0.50
klfo4     oscili    kampa, imodfrq, giFt1, 0.75
kzfrq     =         0.1; Velocity of amplitude oscillation
kampvoice =         0.5; Amplitude of each voice
; Amplitude between -0.5 and 0.5
kx1       oscili    0.5, kzfrq, giFt1, 0
kx2       oscili    0.5, kzfrq, giFt1, 0.25
kx3       oscili    0.5, kzfrq, giFt1, 0.50
kx4       oscili    0.5, kzfrq, giFt1, 0.75
; Add 0.5 so amplitude oscillates between 0 and 1
k1        =         kx1+0.5
k2        =         kx2+0.5
k3        =         kx3+0.5
k4        =         kx4+0.5
; Minimize interference between chorus oscillators
itilf     random    -5, 5
asig11    buzz      ky*k1, (2.02*gkfreq1)+itilf+klfo1, iharm, giFt1
asig12    buzz      ky*k1, gkfreq1 +klfo1, iharm, giFt1; Voice 1
asig13    buzz      ky*k1, (1.51*gkfreq1)+itilf+klfo1, iharm, giFt1
aa1       =         asig11+asig12+asig13
asig21    buzz      ky*k2, (2.01*gkfreq2)+itilf+klfo2, iharm, giFt1
asig22    buzz      ky*k2, gkfreq2 +klfo2, iharm, giFt1; Voice 2
asig23    buzz      ky*k2, (1.51*gkfreq2)+itilf+klfo2, iharm, giFt1
aa2       =         asig21+asig22+asig23
asig31    buzz      ky*k3, (2.01*gkfreq3)+itilf+klfo3, iharm, giFt1
asig32    buzz      ky*k3, gkfreq3 +klfo3, iharm, giFt1; Voice 3
asig33    buzz      ky*k3, (1.51*gkfreq3)+itilf+klfo3, iharm, giFt1
aa3       =         asig31+asig32+asig33
asig41    buzz      ky*k4, (2.01*gkfreq4)+itilf+klfo4, iharm, giFt1
asig42    buzz      ky*k4, gkfreq4 +klfo4, iharm, giFt1; Voice 4
asig43    buzz      ky*k4, (1.51*gkfreq4)+itilf+klfo4, iharm, giFt1
aa4       =         asig41+asig42+asig43
          outs      aa1+aa3, aa2+aa4
endin
</CsInstruments>
<CsScore>
; Master control instrument
; Inst start dur
i1       0   3600

; Oscillators
; inst start idur iamp irise idec kamp imodfrq iharm

i2      0    480  0.3   4    20  0.10    7     16
e
</CsScore>
</CsoundSynthesizer><bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>880</x>
 <y>71</y>
 <width>396</width>
 <height>861</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: ioObject
Listing: Window
WindowBounds: 880 71 396 861
CurrentView: io
IOViewEdit: On
Options:
</MacOptions>

<MacGUI>
ioView nobackground {65535, 65535, 65535}
</MacGUI>
