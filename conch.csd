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
    aRevL, aRevR reverbsc gaSend, gaSend, 0.78, 8000
    
    ; Output the wet reverberated signal
    outs aRevL, aRevR
    
    ; Clear the global bus for the next control cycle
    clear gaSend
endin

</CsInstruments>
<CsScore>
; Start the reverb instrument first and leave it running to catch the echo tails
i 99 0 10.0

; Conch notes
i 1 0.0 2.0 0.25 292.00  ; G4
i 1 2.5 1.5 0.15 223.25  ; C5
i 1 4.5 3.0 0.15 202.00  ; G4
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
