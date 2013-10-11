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

giSine    ftgen     0, 0, 2^10, 10, 1

instr 1

iolaps  = 2
igrsize = 0.04
ifreq   = iolaps/igrsize
ips     = 1/iolaps

istr = p4  /* timescale */
ipitch = p5 /* pitchscale */

a1 diskgrain "goth-guitar.wav", 1, ifreq, ipitch, igrsize, ips*istr, 1, iolaps
kenv      linen     1, p3/4, p3, p3/4
   outs   kenv*a1, kenv*a1

endin

instr 2
kamp     =        0.35
kfreq    =        p4
ipres1   =        p5
ipres2   =        p6
; kpres (bow pressure) defined using a random spline
kpres    rspline  p5,p6,0.5,2
krat     =        0.127236
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
; call the wgbow opcode
aSigL    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
; modulating delay time
kdel     rspline  0.01,0.1,0.1,0.5
; bow pressure parameter delayed by a varying time in the right channel
kpres    vdel_k   kpres,kdel,0.2,2
aSigR    wgbow    kamp,kfreq,kpres,krat,kvibf,kvibamp,giSine,iminfreq
         outs     aSigL,aSigR
endin
</CsInstruments>
<CsScore>
f 1 0 8192 20 2 1  ;Hanning function
f 2 0 1024 10 1 ; sine
;           timescale   pitchscale
i 1   0   25     0.5        1.5
i 1   + 25     1.1       0.75
i 1  + 50        0.5        1.0
i 1  + 20      0.01    1.0
i 1 + 50 0.25 0.77
i 1 + 30 0.77 1.6

i 2  10 180  70 0.03 0.1
i 2  10 180  85 0.03 0.1
i 2  10 180 100 0.03 0.09
i 2  10 180 135 0.03 0.09
i 2  10 180 170 0.02 0.09
i 2  10 180 202 0.04 0.1
i 2  10 180 233 0.05 0.11
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
  <r>231</r>
  <g>46</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider1</objectName>
  <x>5</x>
  <y>5</y>
  <width>20</width>
  <height>100</height>
  <uuid>{6c04530b-d163-43f4-85a5-5e85bf1b8635}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
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
ioView nobackground {59367, 11822, 65535}
ioSlider {5, 5} {20, 100} 0.000000 1.000000 0.000000 slider1
</MacGUI>
