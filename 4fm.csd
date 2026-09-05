<CsoundSynthesizer>
<CsOptions>
; Output audio settings: produce a WAV file and render console output
;-o 4op_fm_output.wav -d -m0
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1.0

; Function Table 1: Standard Sine Wave (16384 points)
giSine ftgen 1, 0, 16384, 10, 1

; ====================================================================
; Instrument 1: 4-Operator FM Synthesizer
; ====================================================================
; p4 = Master Amplitude (0.0 - 1.0)
; p5 = Fundamental Frequency (Hz)
; p6 = FM Algorithm (1: Stack, 2: Parallel Pairs, 3: 3 Modulators to 1 Carrier, 4: Additive)
; p7, p8, p9, p10   = Frequency Ratios for Op1, Op2, Op3, Op4
; p11, p12, p13, p14 = Modulation Index / Amplitude for Op1, Op2, Op3, Op4
; p15 = Pan (0.0 = Left, 0.5 = Center, 1.0 = Right)

instr 1
    iAmp     = p4
    iFreq    = p5
    iAlgo    = p6
    
    iRat1    = p7
    iRat2    = p8
    iRat3    = p9
    iRat4    = p10
    
    iIdx1    = p11
    iIdx2    = p12
    iIdx3    = p13
    iIdx4    = p14
    
    iPan     = p15

    ; ----------------------------------------------------------------
    ; Envelopes for Operators (Simple EG with Attack, Decay, Sustain, Release)
    ; ----------------------------------------------------------------
    kEnv1 madsr 0.01, 0.2, 0.8, 0.3
    kEnv2 madsr 0.05, 0.3, 0.5, 0.4
    kEnv3 madsr 0.02, 0.1, 0.6, 0.2
    kEnv4 madsr 0.005, 0.15, 0.4, 0.5

    ; Calculate Operator Base Frequencies
    kFreq1 = iFreq * iRat1
    kFreq2 = iFreq * iRat2
    kFreq3 = iFreq * iRat3
    kFreq4 = iFreq * iRat4

    ; ----------------------------------------------------------------
    ; Operator Routing based on Selected Algorithm
    ; ----------------------------------------------------------------
    if iAlgo == 1 then
        ; Algorithm 1: Cascade / Stack (Op4 -> Op3 -> Op2 -> Op1 -> Out)
        aMod4 poscil iIdx4 * kFreq4 * kEnv4, kFreq4, giSine
        aMod3 poscil iIdx3 * kFreq3 * kEnv3, kFreq3 + aMod4, giSine
        aMod2 poscil iIdx2 * kFreq2 * kEnv2, kFreq2 + aMod3, giSine
        aCar1 poscil iAmp * kEnv1, kFreq1 + aMod2, giSine
        aOut  = aCar1

    elseif iAlgo == 2 then
        ; Algorithm 2: Parallel Pairs (Op4 -> Op3) + (Op2 -> Op1) -> Out
        aMod4 poscil iIdx4 * kFreq4 * kEnv4, kFreq4, giSine
        aCar3 poscil iAmp * 0.5 * kEnv3, kFreq3 + aMod4, giSine
        
        aMod2 poscil iIdx2 * kFreq2 * kEnv2, kFreq2, giSine
        aCar1 poscil iAmp * 0.5 * kEnv1, kFreq1 + aMod2, giSine
        
        aOut  = aCar3 + aCar1

    elseif iAlgo == 3 then
        ; Algorithm 3: 3 Modulators into 1 Carrier ( (Op4 + Op3 + Op2) -> Op1 -> Out )
        aMod4 poscil iIdx4 * kFreq4 * kEnv4, kFreq4, giSine
        aMod3 poscil iIdx3 * kFreq3 * kEnv3, kFreq3, giSine
        aMod2 poscil iIdx2 * kFreq2 * kEnv2, kFreq2, giSine
        
        aCar1 poscil iAmp * kEnv1, kFreq1 + aMod4 + aMod3 + aMod2, giSine
        aOut  = aCar1

    else
        ; Algorithm 4: Additive / 4 Parallel Carriers (Organ/Additive FM)
        aCar4 poscil iAmp * 0.25 * iIdx4 * kEnv4, kFreq4, giSine
        aCar3 poscil iAmp * 0.25 * iIdx3 * kEnv3, kFreq3, giSine
        aCar2 poscil iAmp * 0.25 * iIdx2 * kEnv2, kFreq2, giSine
        aCar1 poscil iAmp * 0.25 * iIdx1 * kEnv1, kFreq1, giSine
        
        aOut  = aCar4 + aCar3 + aCar2 + aCar1
    endif

    ; ----------------------------------------------------------------
    ; Stereo Output & Panning
    ; ----------------------------------------------------------------
    aLeft  = aOut * sqrt(1 - iPan)
    aRight = aOut * sqrt(iPan)
    
    outs aLeft, aRight
endin

</CsInstruments>
<CsScore>

; ====================================================================
; SCORE SECTION
; Demonstrating Parameter Changes across different FM Algorithms
; ====================================================================

; Field Definitions:
; p1: Instr | p2: Start | p3: Dur | p4: Amp | p5: Freq(Hz) | p6: Algo
; p7..p10: Ratios (Op1, Op2, Op3, Op4)
; p11..p14: Mod Indices / Levels (Op1, Op2, Op3, Op4)
; p15: Pan

; --------------------------------------------------------------------
; SECTION 1: Algorithm 1 (Serial Cascade Stack: Op4 -> Op3 -> Op2 -> Op1)
; Demonstrating changes in Modulation Index (Bright / Metallic Timbre)
; --------------------------------------------------------------------
; i1  Start  Dur   Amp   Freq   Algo  R1  R2  R3  R4   I1    I2    I3    I4   Pan
i 1   0.0    2.0   0.6   220    1     1.0 1.0 1.0 1.0  1.0   0.5   0.5   0.2  0.5 ; Soft stack
i 1   2.2    2.0   0.6   220    1     1.0 1.0 1.0 1.0  1.0   2.0   1.5   1.0  0.5 ; Medium bright stack
i 1   4.4    2.5   0.6   220    1     1.0 1.0 1.0 1.0  1.0   5.0   4.0   3.0  0.5 ; Complex, harsh/bright stack

; --------------------------------------------------------------------
; SECTION 2: Non-integer Ratios (Metallic / Bell / Gong Timbres)
; --------------------------------------------------------------------
i 1   7.2    3.0   0.7   110    1     1.0 1.414 2.73 3.14  1.0 3.0   2.5   1.8  0.3 ; Tubular bell/gong
i 1   10.5   3.0   0.7   146.83 1     1.0 0.5   3.5  7.1   1.0 4.0   2.0   1.2  0.7 ; Metallic chime

; --------------------------------------------------------------------
; SECTION 3: Algorithm 2 (Parallel Pairs: [Op4->Op3] + [Op2->Op1])
; Electric Piano / Dual Tone Sounds
; --------------------------------------------------------------------
i 1   14.0   2.0   0.7   261.63 2     1.0 1.0 1.0 14.0  1.0 1.0   1.0   3.0  0.5 ; FM E-Piano C4
i 1   16.2   2.0   0.7   329.63 2     1.0 1.0 1.0 14.0  1.0 1.0   1.0   3.0  0.5 ; FM E-Piano E4
i 1   18.4   2.5   0.7   392.00 2     1.0 1.0 1.0 14.0  1.0 1.0   1.0   3.0  0.5 ; FM E-Piano G4

; --------------------------------------------------------------------
; SECTION 4: Algorithm 3 (3 Modulators into 1 Carrier: [Op4+Op3+Op2] -> Op1)
; Rich Brass / Multi-harmonic Modulation
; --------------------------------------------------------------------
i 1   21.2   2.5   0.8   130.81 3     1.0 2.0 3.0 4.0   1.0 1.5   1.0   0.8  0.4 ; FM Brass C3
i 1   24.0   2.5   0.8   196.00 3     1.0 2.0 3.0 4.0   1.0 1.5   1.0   0.8  0.6 ; FM Brass G3

; --------------------------------------------------------------------
; SECTION 5: Algorithm 4 (Additive / 4 Parallel Operators)
; Organ / Additive Harmonics
; --------------------------------------------------------------------
i 1   27.0   3.0   0.7   220.00 4     1.0 2.0 3.0 4.0   1.0 0.8   0.6   0.4  0.5 ; Harmonic Organ Drawbars

e
</CsScore>
</CsoundSynthesizer>