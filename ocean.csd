<CsoundSynthesizer>
<CsOptions>
  -odac
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

; Seed random numbers for unpredictable bird calls
seed 0

; -------------------------------------------------------------
; INSTRUMENT 1: Ocean Background + Wave Crashes
; -------------------------------------------------------------
instr 1
  ; 1. Ambient Background Swells
  awhite unirand 2.0
  awhite = awhite - 1.0
  apink pinkish awhite

  klfo_slow lfo 0.5, 0.12, 0
  klfo_slow = (klfo_slow + 0.5)

  kcutoff = 120 + (klfo_slow * 800)
  aocean butterlp apink, kcutoff
  aocean = aocean * ((klfo_slow * 0.4) + 0.05)

  ; 2. Periodic Wave Crashes (Slightly randomized trigger)
  kcrashtrig metro 0.1 ; Triggers roughly every 10 seconds
  kcrashenv expseg 0.001, 0.05, 1.0, 1.5, 0.1, 3.0, 0.001 ; Rapid attack, slow decay
  
  ; Filter for crash: bright/hissing white noise opening up dramatically
  kcrashfilter = 800 + (kcrashenv * 3500)
  acrash butterlp awhite, kcrashfilter
  acrash = acrash * kcrashenv * 0.3

  ; Combine Ocean & Crashes
  amix = aocean + acrash

  ; Gentle panning
  kpan lfo 0.2, 0.07, 0
  outs amix * (0.5 + kpan) * 5, amix * (0.5 - kpan) * 5
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
  iBaseFreq random 2000, 3200
  iDuration random 0.15, 0.4

  ; Amplitude envelope for brief chirps
  kenv transeg 0, 0.02, 0, 0.4, iDuration, -4, 0

  ; Pitch sweep down (classic bird chirp contour)
  kpitch line iBaseFreq, iDuration, iBaseFreq * 0.65

  ; Basic FM chirp generator
  amod oscili kpitch * 0.5, kpitch * 1.5
  abird oscili kenv * 0.15, kpitch + amod

  rireturn

  ; Pan bird calls randomly across the visual field
  ipan random 0.1, 0.9
  outs abird * ipan, abird * (1 - ipan)
endin

</CsInstruments>

<CsScore>
; Run both ocean waves and bird generators simultaneously for 60 seconds
i 1 0 60
i 2 0 60
e
</CsScore>
</CsoundSynthesizer>

