<CsoundSynthesizer>
<CsOptions>
-o dac -m0d
</CsOptions>

<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

; Sine table for low bass and pad
giSine ftgen 1, 0, 16384, 10, 1

; Pulse wave for chiptune lead
giPulse ftgen 2, 0, 16384, 7, 1, 8192, 1, 0, -1, 8192, -1

; Saw wave for heavy distorted bass
giSaw ftgen 3, 0, 16384, 7, -1, 8192, 1, 8192, -1

; -------------------------------------------------------------------
; INSTRUMENT 4: Synthesized Drums (Kick, Snare, Hi-Hat)
; -------------------------------------------------------------------
instr 4
  itype = p4 ; 1 = Kick, 2 = Snare, 3 = Hi-Hat
  
  if itype == 1 then
    ; Kick (Fixed: expon)
    kEnv expon 1.0, 0.2, 0.001
    kPitch line 150, 0.15, 45
    aKick oscili kEnv * 0.8, kPitch, giSine
    outs aKick, aKick

  elseif itype == 2 then
    ; Snare (Fixed: expon)
    kEnv expon 1.0, 0.18, 0.001
    aNoise rand kEnv * 0.3
    aBody oscili kEnv * 0.4, 180, giSine
    aSnare = aNoise + aBody
    outs aSnare, aSnare

  elseif itype == 3 then
    ; Hi-Hat (Fixed: expon)
    kEnv expon 1.0, 0.05, 0.001
    aHat rand kEnv * 0.2
    aHatFilter butterhp aHat, 7000
    outs aHatFilter, aHatFilter
  endif
endin

</CsInstruments>
<CsScore>
t 0 60 ; Tempo set to 130 BPM

r 10
; ===================================================================
; DRUM PATTERN (4 Bars Loop)
; p4 values: 1=Kick, 2=Snare, 3=Hi-Hat
; ===================================================================
; Bar 1
i 4 0.0  0.2 1
i 4 0.0  0.1 3
i 4 0.5  0.1 3
i 4 1.0  0.2 2
i 4 1.0  0.1 3
i 4 1.5  0.1 3
i 4 2.0  0.2 1
i 4 2.5  0.1 3
i 4 3.0  0.2 2
i 4 3.5  0.1 3
i 4 3.8  0.1 2 
i 4 4.0  0.2 1
i 4 4.0  0.1 3
i 4 4.5  0.1 3
i 4 5.0  0.2 2
i 4 5.0  0.1 3
i 4 5.5  0.1 3
i 4 6.0  0.2 1
i 4 6.5  0.1 3
i 4 7.0  0.2 2
i 4 7.3  0.1 3
i 4 8.0  0.2 2
s
e

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
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
