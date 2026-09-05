<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

;----------------------------------------------------
; Instrument 1: Dynamic White Noise & Swept Filter
; (Simulates ocean waves and wind swells)
;----------------------------------------------------
instr 1
  iAmp    = p4
  iFreq   = p5
  
  ; Generate white noise
  aNoise  noise iAmp, 0
  
  ; Slow LFO to sweep a lowpass filter over time
  kCutoff lfo 800, 0.15, 0
  kCutoff = kCutoff + 1000
  
  ; Low-pass filter the noise
  aFiltered lowpass2 aNoise, kCutoff, 2
  
  ; Stereo panning modulated by a slow sine LFO
  kPan    lfo 0.4, 0.1, 0
  aL, aR  pan2 aFiltered, kPan + 0.5
  
  outs aL, aR
endin

;----------------------------------------------------
; Instrument 2: Sub-Bass Drone & Resonant Tones
; (Provides the deep rumble and atmospheric tones)
;----------------------------------------------------
instr 2
  iAmp  = p4
  iFreq = p5
  
  ; Envelope for gradual fade-in and fade-out
  aEnv  linen iAmp, p3*0.3, p3, p3*0.3
  
  ; Deep sine oscillator
  aSub  poscil aEnv, iFreq
  
  ; Filtered resonant sawtooth overlay for texture
  aSaw  poscil aEnv * 0.3, iFreq * 1.5
  aRes  reson aSaw, 350, 40
  
  aMix  = aSub + aRes
  
  outs aMix, aMix
endin

</CsInstruments>
<CsScore>

; Score Events (p1=Inst, p2=Start, p3=Duration, p4=Amp, p5=Freq)

; Continuous background ambient swell
i 1 0 30 0.2 0

; Overlapping low-frequency sub drone and resonant tones
i 2 0  10 0.4 45
i 2 5  15 0.5 55
i 2 12 18 0.4 40
i 2 20 10 0.3 50

</CsScore>
</CsoundSynthesizer>
