<CsoundSynthesizer>
<CsOptions>
; Send audio output to your default soundcard
-odac 
</CsOptions>

<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

instr 1 ; Conch Trumpet / Horn Sound
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
; p1=instr, p2=start, p3=duration, p4=MIDI note, p5=Amplitude
; Plays the note twice (mimicking a live_loop cycle with sleep dur + 0.5)

; Start at 0s, dur 3.5s, Note 60, Amp 0.8
i 1 0.0 3.5 60 0.8

; Loop starts over at dur (3.5) + 0.5 = 4.0s
i 1 4.0 3.5 60 0.8
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
