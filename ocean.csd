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

instr 3 ; Conch Trumpet / Horn Sound
    iDur = p3          ; Duration (3.5 seconds)
    iBaseNote = p4     ; MIDI Note (60)
    iAmp = p5          ; Amplitude (0.8)
    
    ; --- Envelope ---
    ; sustain: dur * 0.8 (2.8s), release: dur * 0.2 (0.7s)
    iSustain = iDur * 0.8
    iRelease = iDur * 0.2
    aEnv linseg 0, 0.01, iAmp, iSustain - 0.01, iAmp, iRelease, 0
    
    ; --- Vibrato / Pitch Modulation ---
    ; depth: 0.15, rate: 5 Hz
    kVib poscil 0.15, 5
    
    ; Frequencies with vibrato offset applied
    kFreq1 = cpsmidinn(iBaseNote - 0.03 + kVib)
    kFreq2 = cpsmidinn(iBaseNote + 0.03 + kVib)
    kFreq3 = cpsmidinn(iBaseNote + kVib)
    
    ; --- Oscillators ---
    ; Osc 1: Primary Sawtooth (vco2 mode 0)
    a1 vco2 1.0, kFreq1, 0 
    
    ; Osc 2: Supersaw 
    ; Approximated with two slightly detuned sawtooth oscillators
    a2a vco2 0.5, cpsmidinn(iBaseNote + 0.03 + 0.06 + kVib), 0
    a2b vco2 0.5, cpsmidinn(iBaseNote + 0.03 - 0.06 + kVib), 0
    a2 = a2a + a2b
    
    ; Osc 3: Narrow Pulse (amp: 0.5, pulse width: 0.45, vco2 mode 2)
    a3 vco2 0.5, kFreq3, 2, 0.45 
    
    ; Mix the oscillators to prevent clipping
    aMix = (a1 + a2 + a3) / 3.0
    
    ; --- Low-Pass Filter Automation ---
    ; Sonic Pi cutoffs (20-88) are MIDI notes (approx 31Hz - 1.3kHz).
    ; We automate a sweep mimicking the 'cutoff_slide' through the horn.
    kCutoff expseg 1000, iDur, 400
    aFilt moogladder aMix, kCutoff, 0.2
    
    ; Apply amplitude envelope
    aOut = aFilt * aEnv
    
    ; --- Reverb ---
    ; room: 0.6, mix: 0.35 (Freeverb takes a dry/wet ratio)
    aRevL, aRevR freeverb aOut, aOut, 0.6, 0.5
    
    aMixL = (aOut * 0.65) + (aRevL * 0.35)
    aMixR = (aOut * 0.65) + (aRevR * 0.35)
    
    ; Stereo output
    outs aMixL, aMixR
endin
</CsInstruments>

<CsScore>
i 99 0 10.0
; Run both ocean waves and bird generators simultaneously for 60 seconds
i 1 0 800
i 2 0 800

i 3 0.00 1.40 0.15 289.99 ; G5
i 3 0.50 1.40 0.15 239.99 ; Gb5
i 3 1.00 0.40 0.15 289.99 ; G5
i 3 1.50 0.40 0.15 233.99 ; Gb5
i 3 2.00 0.40 0.15 283.99 ; G5
i 3 2.50 0.40 0.15 233.99 ; Gb5
i 3 3.00 0.40 0.15 283.99 ; G5
i 3 3.50 0.40 0.15 221.99 ; Gb5

; Measure 2: The descending run
i 3 4.00 1.40 0.15 198.46 ; F5
i 3 4.50 0.40 0.15 122.25 ; Eb5
i 3 5.00 0.40 0.15 122.33 ; D5
i 3 5.50 0.40 0.15 123.25 ; C5
i 3 6.00 0.40 0.15 193.88 ; B4
i 3 6.50 1.00 0.15 123.25 ; C5 (Held note)
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
