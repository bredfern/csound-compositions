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
; INSTRUMENT 1: Heavy Distorted Bass Line
; -------------------------------------------------------------------
instr 1
  icps = cpsmidinn(p4)
  iamp = p5
  
  ; Amp envelope
  kenv madsr 0.01, 0.1, 0.8, 0.1
  
  ; Layered saw/square oscillators with slight detune
  a1 oscili iamp, icps * 0.998, giSaw
  a2 oscili iamp, icps * 1.002, giPulse
  aMix = (a1 + a2) * kenv
  
  ; Resonant low-pass filter (Fixed: moogladder)
  aFilt moogladder aMix, icps * 4, 0.4
  
  ; Waveshaping distortion (Fixed: distort1)
  aDist distort1 aFilt, 2.0, 0.5, 0, 0
  
  outs aDist * 0.4, aDist * 0.4
endin

; -------------------------------------------------------------------
; INSTRUMENT 2: Chiptune / Arpeggiated Lead
; -------------------------------------------------------------------
instr 2
  icps = cpsmidinn(p4)
  
  kenv madsr 0.005, 0.05, 0.4, 0.05
  
  ; Pulse wave synthesis
  aLead oscili 0.25 * kenv, icps, giPulse
  
  ; Bitcrusher effect for 8-bit chiptune sound
  aFold fold aLead, 16
  
  outs aFold, aFold
endin

; -------------------------------------------------------------------
; INSTRUMENT 3: Ambient Pad / Vox Backing
; -------------------------------------------------------------------
instr 3
  icps = cpsmidinn(p4)
  
  ; Slow swell envelope
  kenv madsr 0.4, 0.3, 0.7, 0.5
  
  ; Detuned sine/saw mix for soft vocal/pad texture
  a1 oscili 0.15, icps, giSine
  a2 oscili 0.10, icps * 1.005, giSaw
  
  aPad = (a1 + a2) * kenv
  aFiltered butterlp aPad, 1200
  
  outs aFiltered, aFiltered
endin

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
t 0 80 ; Tempo set to 130 BPM

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

; Bar 2
i 4 4.0  0.2 1
i 4 4.0  0.1 3
i 4 4.5  0.1 3
i 4 5.0  0.2 2
i 4 5.0  0.1 3
i 4 5.5  0.1 3
i 4 6.0  0.2 1
i 4 6.5  0.1 3
i 4 7.0  0.2 2
i 4 7.5  0.1 3

; ===================================================================
; BASS LINE (Distorted Driving Synth)
; p4 = MIDI Pitch, p5 = Velocity/Amp
; ===================================================================
i 1 0.0 0.4 36 0.8
i 1 0.5 0.4 36 0.8
i 1 1.0 0.4 36 0.8
i 1 1.5 0.4 38 0.8
i 1 2.0 0.4 36 0.8
i 1 2.5 0.4 41 0.8
i 1 3.0 0.4 36 0.8
i 1 3.5 0.4 34 0.8

i 1 4.0 0.4 36 0.8
i 1 4.5 0.4 36 0.8
i 1 5.0 0.4 36 0.8
i 1 5.5 0.4 38 0.8
i 1 6.0 0.4 36 0.8
i 1 6.5 0.4 41 0.8
i 1 7.0 0.4 36 0.8
i 1 7.5 0.4 43 0.8

; ===================================================================
; CHIPTUNE LEAD
; ===================================================================
i 2 0.00 0.2 60
i 2 0.25 0.2 63
i 2 0.50 0.2 67
i 2 0.75 0.2 72
i 2 1.00 0.2 60
i 2 1.25 0.2 63
i 2 1.50 0.2 67
i 2 1.75 0.2 70

i 2 2.00 0.2 60
i 2 2.25 0.2 63
i 2 2.50 0.2 67
i 2 2.75 0.2 72
i 2 3.00 0.2 60
i 2 3.25 0.2 63
i 2 3.50 0.2 67
i 2 3.75 0.2 65

; ===================================================================
; PAD / VOX
; ===================================================================
i 3 0.0 3.8 60
i 3 0.0 3.8 63
i 3 0.0 3.8 67

i 3 4.0 3.8 58
i 3 4.0 3.8 62
i 3 4.0 3.8 65

e
</CsScore>
</CsoundSynthesizer>

