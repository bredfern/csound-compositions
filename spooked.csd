<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

; Seed random generator
seed 0

;;====================================================================
;; INSTRUMENT 1: Bubbling Cauldron (Filtered Noise & Pitched Drops)
;;====================================================================
instr 1
    ; Low rumbling fire/brew base
    aNoise noise 0.15, 0
    aRumble reson aNoise, 120, 40, 1
    
    ; Bubble trigger rate using low-frequency random pulses
    kTrig metro 12 + randi:k(8, 2)
    
    ; Randomize bubble frequency and envelope
    kFreq = 300 + birnd(200)
    aEnv decay2 kTrig, 0.005, 0.04
    aBubble sine aEnv * 0.4, kFreq + (aEnv * 300)
    
    ; Bandpass filtering to sound liquid
    aLiquid butterbp aBubble + aRumble, 800, 400
    
    aOut = (aRumble * 0.6) + (aLiquid * 1.5)
    outs aOut, aOut
endin

;;====================================================================
;; INSTRUMENT 2: Cackling Witch (FM Vocal Tract Formant Sweep)
;;====================================================================
instr 2
    ; Formant pitch contour (rapid pitch jumps mimicking a laugh)
    kLfo LFO 6, 8, 0
    kPitch = p4 + (kLfo * 120) + randi:k(30, 10)
    
    ; FM Synthesis for raspiness
    aMod poscil kPitch * 2.5, kPitch * 1.5
    aCar poscil 0.3, kPitch + aMod
    
    ; Formant filtering for vocal "e-e-e-h-a-a" quality
    kFiltCut = 1200 + (kLfo * 800)
    aVocal reson aCar, kFiltCut, 150, 1
    aVocal balance aVocal, aCar
    
    ; Envelope
    aEnv linen aVocal, 0.05, p3, 0.2
    
    ; Stereo positioning
    kPan line p5, p3, p6
    aL, aR pan2 aEnv, kPan
    outs aL, aR
endin

;;====================================================================
;; INSTRUMENT 3: Howling Ghosts (Glissando Sine with Chorus/Reverb)
;;====================================================================
instr 3
    ; Pitch glissando sweeping up and down
    kPitch line p4, p3, p5
    kWobble poscil 15, 3
    
    ; Primary wind/ghost tone
    aGhost poscil 0.2, kPitch + kWobble
    
    ; Add noise layer for windy breath
    aWind noise 0.05, 0
    aWindFilt reson aWind, kPitch, 80, 1
    
    aMix = (aGhost + aWindFilt) * line(0, 0.5, 0.3)
    aEnv linen aMix, 1.0, p3, 1.5
    
    ; Simple stereo spread
    aL, aR pan2 aEnv, p6
    outs aL, aR
endin

;;====================================================================
;; INSTRUMENT 4: Moaning Monsters & Shaking Chains
;;====================================================================
instr 4
    ; --- MONSTER MOAN ---
    kLowPitch line p4, p3, p4 * 0.7
    aSaw vco2 0.25, kLowPitch, 0 ; Sawtooth for growl
    aLowPass butterlp aSaw, 350 + poscil(100, 0.5)
    
    ; --- SHAKING CHAINS ---
    ; High metallic frequencies using ring modulation & noise bursts
    aChainNoise noise 0.3, 0
    kChainTrig metro 8 + randi:k(4, 3)
    aChainEnv decay2 kChainTrig, 0.001, 0.05
    
    ; Inharmonic metal resonances
    aMetal1 reson aChainNoise * aChainEnv, 2400, 100, 1
    aMetal2 reson aChainNoise * aChainEnv, 4100, 120, 1
    aChains = (aMetal1 + aMetal2) * 0.4
    
    aTotal = aLowPass + aChains
    aEnv linen aTotal, 0.2, p3, 0.5
    
    outs aEnv, aEnv
endin

</CsInstruments>
<CsScore>

; f1: Standard Sine Wave
f 1 0 16384 10 1

; --- SCORE EVENTS ---

; i1: Cauldron bubbles continuously in the background
i 1 0 25

; i2: Witch Cackles (p4=base freq, p5=start pan, p6=end pan)
i 2 1.5  2.5 450 0.2 0.8
i 2 5.0  3.0 520 0.8 0.1
i 2 10.0 2.0 400 0.3 0.7
i 2 16.0 4.0 600 0.5 0.5

; i3: Howling Ghosts (p4=start freq, p5=end freq, p6=pan)
i 3 0.0  8.0 300 600 0.2
i 3 4.0 10.0 700 250 0.8
i 3 12.0 9.0 200 850 0.5

; i4: Moaning Monsters & Chains (p4=monster base freq)
i 4 2.0  6.0 65
i 4 9.0  7.0 55
i 4 15.0 8.0 48

e
</CsScore>
</CsSynthesizer>