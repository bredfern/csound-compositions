<CsoundSynthesizer>
<CsOptions>
  -odac
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 441
nchnls = 2
0dbfs = 1.0

; Seed random numbers for unpredictable bird calls
seed 540

; Global variable for the reverb send bus
gaSend init 0
; -------------------------------------------------------------
; INSTRUMENT 1: Ocean Background + Wave Crashes
; -------------------------------------------------------------
instr 1
  ; 1. Ambient Background Swells
  awhite unirand 12.0
  awhite = awhite
  apink pinkish awhite

  klfo_slow lfo 0.5, 0.12, 0
  

  kcutoff = 120 + (klfo_slow * 100)
  aocean butterlp apink, kcutoff
  aocean = aocean * 5 + ((klfo_slow * 0.4) + 0.05)

  ; 2. Periodic Wave Crashes (Slightly randomized trigger)
  kcrashtrig metro 0.1 ; Triggers roughly every 10 seconds
  kcrashenv expseg 0.001, 0.05, 1.0, 1.5, 0.1, 30.0, 0.001 ; Rapid attack, slow decay
  
  ; Filter for crash: bright/hissing white noise opening up dramatically
  kcrashfilter = kcrashenv
  acrash butterlp awhite, kcrashfilter
  acrash = acrash * kcrashenv

  ; Combine Ocean & Crashes
  amix = 0.5 * aocean + acrash

  ; Gentle panning
  kpan lfo 0.2, 0.07, 0
  outs amix * kpan, amix * kpan
endin

; -------------------------------------------------------------
; INSTRUMENT 2: Seagull / Bird Calls (FM Synthesis)
; -------------------------------------------------------------
instr 2
  ; Trigger a bird call every few seconds with varying probability
  kbirdtrig metro 0.35
  kchance random 0, 1

  if (kbirdtrig == 1 && kchance > 0.5) then
    reinit CALL_START
  endif

  CALL_START:
  ; Randomize fundamental pitch and chirp sweep duration
  iBaseFreq random 1800, 3200
  iDuration random 0.15, 0.4

  ; Amplitude envelope for brief chirps
  kenv transeg 0, 0.02, 0, 0.4, iDuration, -4, 0

  ; Pitch sweep down (classic bird chirp contour)
  kpitch line iBaseFreq, iDuration, iBaseFreq * 0.65

  ; Basic FM chirp generator
  amod oscili kpitch * 0.05, kpitch * 1.5
  abird oscili kenv * 0.15, kpitch + amod

  rireturn

  ; Pan bird calls randomly across the visual field
  ipan random 0.1, 0.9
  outs abird * ipan, abird * (1 - ipan)
endin



instr 99 ; Global Reverb (Dock Environment)
    ; reverbsc arguments: inputL, inputR, feedback_level, cutoff_frequency
    aRevL, aRevR reverbsc gaSend, gaSend, 0.78, 8000
    
    ; Output the wet reverberated signal
    outs aRevL, aRevR
    
    ; Clear the global bus for the next control cycle
    clear gaSend
endin

</CsInstruments>

<CsScore>
i 99 0 10.0
; Run both ocean waves and bird generators simultaneously for 60 seconds
i 1 0 800
i 2 0 800

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
