<CsoundSynthesizer>
<CsOptions>
-odac ; Output to audio soundcard
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

; Global variable for the reverb send bus
gaSend init 0

instr 1 ; Conch Shell Synthesizer
    iAmp = p4
    iFreq = p5
    
    kEnv = madsr(0.02, 0.1, 0.8, 0.2)
    
    ; Pitch variation
    kVib = poscil(0.015, 4.5) 
    kPitch = iFreq * (1 + kVib)

    ; 1. INCREASED FM INDEX: Drives the synthesis harder to create 
    ; bright, brassy upper harmonics that mimic a stiff lip buzz.
    kModIndex = 2.0 + (kEnv * 4.0)
    aModulator = poscil(iFreq * kModIndex, kPitch)
    aCarrier = poscil(iAmp, kPitch + aModulator)
    
    ; 2. REDUCED NOISE: Dropped the amplitude from 0.1 to 0.015.
    ; Shifted the resonance up to 2500Hz to sound like lip sizzle rather than wind.
    aNoise = noise(iAmp * 0.015, 0)
    aBreath = reson(aNoise, 2500, 500)
    
    aSignal = aCarrier + aBreath
    
    ; 3. OPENED FILTER: Raised the cutoff drastically to 6500Hz so the 
    ; new upper frequencies can actually be heard.
    aFiltered = moogladder(aSignal, 6500, 0.1)
    
    aOut = aFiltered * kEnv
    
    outs aOut * 0.7, aOut * 0.7
    
    ; Send to global reverb (if you are still using instr 99)
    gaSend = gaSend + (aOut * 0.5)
endin
instr 99 ; Global Reverb (Dock Environment)
    ; reverbsc arguments: inputL, inputR, feedback_level, cutoff_frequency
    aRevL, aRevR reverbsc gaSend, gaSend, 0.48, 8000
    
    ; Output the wet reverberated signal
    outs aRevL, aRevR

    ; Clear the global bus for the next control cycle
    clear gaSend
endin

</CsInstruments>
<CsScore>
; Set tempo to 160 Beats Per Minute
t 0 70 

; Start the global reverb and let it run long enough for the tail
i 99 0 28

; p1: instr, p2: start (beats), p3: dur (beats), p4: amp, p5: freq (Hz)

; Measure 1: The famous alternating trill
i 1 0.00 1.40 0.25 789.99 ; G5
i 1 0.50 1.40 0.25 739.99 ; Gb5
i 1 1.00 0.40 0.25 789.99 ; G5
i 1 1.50 0.40 0.25 733.99 ; Gb5
i 1 2.00 0.40 0.25 783.99 ; G5
i 1 2.50 0.40 0.25 733.99 ; Gb5
i 1 3.00 0.40 0.25 783.99 ; G5
i 1 3.50 0.40 0.25 739.99 ; Gb5

; Measure 2: The descending run
i 1 4.00 1.40 0.25 798.46 ; F5
i 1 4.50 0.40 0.25 722.25 ; Eb5
i 1 5.00 0.40 0.25 722.33 ; D5
i 1 5.50 0.40 0.25 723.25 ; C5
i 1 6.00 0.40 0.25 793.88 ; B4
i 1 6.50 1.00 0.25 723.25 ; C5 (Held note)
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
