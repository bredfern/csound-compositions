<CsoundSynthesizer>
<CsOptions>
-iadc -odac -+rtmidi=virtual -M0 -d
</CsOptions>
<CsInstruments>

sr     = 44100
ksmps  = 32
nchnls = 2
0dbfs  = 1

; Global variable to send the synth audio to the main outputs for master balancing
gachSynthMix init 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INSTRUMENT 1: Background Synth (Arpeggiator)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr SynthBackground
    kPitch    init 60                 
    kTrigger  metro 2                 ; 120 BPM
    
    if kTrigger == 1 then
        kCount init 0
        if kCount == 0 then kPitch = 50 
        elseif kCount == 1 then kPitch = 53 
        elseif kCount == 2 then kPitch = 57 
        elseif kCount == 3 then kPitch = 55 
        endif
        kCount = (kCount + 1) % 4
    endif

    aEnv   madsr 0.05, 0.2, 0.5, 0.3
    kFreq  = cpsmidinn(kPitch)
    aSaw   vco2 0.15, kFreq
    aLp    moogladder aSaw, 1200, 0.3
    aOut   = aLp * aEnv

    ; Route synth out to a global channel for mixing in the master block
    gachSynthMix = aOut
endin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INSTRUMENT 2: Live Looper with Volume Balance Tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
instr GuitarLooper
    aInCh1, aInCh2 inch 1, 2          
    aRawGuitar = (aInCh1 + aInCh2) * 0.5 

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; LIVE MIDI WHEEL & BALANCING CONTROLLERS
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; 1. Performance Wheels
    kModWheel ctrl7 1, 1, 0, 127
    kFeedback = (kModWheel / 127) * 0.85

    kPitchBend pchbend
    kReverbMix = 0.05 + ((kPitchBend / 16383) * 0.55)

    ; 2. Balance Mixing Sliders
    kGuitarVolCC ctrl7 1, 7, 0, 127         ; MIDI CC 7 (Standard Master Vol)
    kGuitarGain   = kGuitarVolCC / 127      ; Normalizes slider to scale (0.0 to 1.0)

    kSynthVolCC  ctrl7 1, 11, 0, 127        ; MIDI CC 11 (Expression Slider)
    kSynthGain    = kSynthVolCC / 127       ; Normalizes slider to scale (0.0 to 1.0)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; LIVE FX PROCESSING LAYER
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    kDelayTime = 0.5
    kDelayMix  = 0.3                  

    aDelayAlloc delayr 2.0            
    aDelayTap   deltap kDelayTime     
    delayw aRawGuitar + (aDelayTap * kFeedback) 

    aProcessedGuitar = (aRawGuitar * (1 - kDelayMix)) + (aDelayTap * kDelayMix)

    kFeedbackLvl = 0.85               
    kCutoffFreq  = 8000               

    aRevL, aRevR reverbsc aProcessedGuitar, aProcessedGuitar, kFeedbackLvl, kCutoffFreq

    aGuitarFinalL = (aProcessedGuitar * (1 - kReverbMix)) + (aRevL * kReverbMix)
    aGuitarFinalR = (aProcessedGuitar * (1 - kReverbMix)) + (aRevR * kReverbMix)

    aLoopInput = (aGuitarFinalL + aGuitarFinalR) * 0.5

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; CONTROL AND TRIGGER HANDLING
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    kKey sensekey
    kSpacePressed = (kKey == 32  ? 1 : 0) 
    kDKeyPressed  = (kKey == 100 ? 1 : 0) 
    kEKeyPressed  = (kKey == 101 ? 1 : 0) 
    kFKeyPressed  = (kKey == 102 ? 1 : 0) 

    kStatus, kChan, kData1, kData2 midiin
    kMidiRec1   init 0
    kMidiRec2   init 0
    kMidiClear1 init 0
    kMidiClear2 init 0

    if (kStatus == 144 && kData2 > 0) then
        if kData1 == 60 then kMidiRec1 = 1      
        elseif kData1 == 62 then kMidiRec2 = 1   
        elseif kData1 == 64 then kMidiClear1 = 1   
        elseif kData1 == 65 then kMidiClear2 = 1   
        endif
    elseif (kStatus == 128) || (kStatus == 144 && kData2 == 0) then
        if kData1 == 60 then kMidiRec1 = 0      
        elseif kData1 == 62 then kMidiRec2 = 0   
        elseif kData1 == 64 then kMidiClear1 = 0   
        elseif kData1 == 65 then kMidiClear2 = 0   
        endif
    endif

    kRecord1 = (kMidiRec1 == 1 || kSpacePressed == 1) ? 1 : 0
    kRecord2 = (kMidiRec2 == 1 || kDKeyPressed == 1)  ? 1 : 0
    kClear1  = (kMidiClear1 == 1 || kEKeyPressed == 1) ? 1 : 0
    kClear2  = (kMidiClear2 == 1 || kFKeyPressed == 1) ? 1 : 0

    kPitchFactor1 = (kClear1 == 1 ? 0 : 1)
    kPitchFactor2 = (kClear2 == 1 ? 0 : 1)

    ; Console Debug Logging
    kCh1Changed changed kRecord1
    kCh2Changed changed kRecord2
    kCl1Changed changed kClear1
    kCl2Changed changed kClear2
    
    if kCh1Changed == 1 then
        printf ">>> LOOP 1 STATUS: %s\n", kCh1Changed, (kRecord1 == 1 ? "[ REC 1 ]" : "[ PLAY 1 ]")
    endif
    if kCh2Changed == 1 then
        printf ">>> LOOP 2 STATUS: %s\n", kCh2Changed, (kRecord2 == 1 ? "[ REC 2 ]" : "[ PLAY 2 ]")
    endif
    if kCl1Changed == 1 && kClear1 == 1 then
        printf ">>> TRACK 1 MEMORY: [ CLEARED ]\n", kCl1Changed
    endif
    if kCl2Changed == 1 && kClear2 == 1 then
        printf ">>> TRACK 2 MEMORY: [ CLEARED ]\n", kCl2Changed
    endif

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; PARALLEL LOOPING ENGINES
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    idur         = 15     
    ifad         = 0.05   

    aLoop1, kStat1 sndloop aLoopInput, kPitchFactor1, kRecord1, idur, ifad
    aLoop2, kStat2 sndloop aLoopInput, kPitchFactor2, kRecord2, idur, ifad

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; MASTER MIX STAGE
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Combine the guitar signals and scale them via the master guitar gain fader
    aGuitarMixL = (aGuitarFinalL + aLoop1 + aLoop2) * kGuitarGain
    aGuitarMixR = (aGuitarFinalR + aLoop1 + aLoop2) * kGuitarGain

    ; Pull down the global background synth signal and apply the synth gain fader
    aSynthMix   = gachSynthMix * kSynthGain

    ; Finalize stereo soundstage
    outs aGuitarMixL + aSynthMix, aGuitarMixR + aSynthMix
endin

</CsInstruments>
<CsScore>
i "SynthBackground" 0 3600
i "GuitarLooper" 0 3600
e
</CsScore>
</CsoundSynthesizer>


