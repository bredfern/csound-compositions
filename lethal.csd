<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
-odac -d -m0d --midi-key-cps=4 --midi-velocity-amp=5 -F assets/lethal.mid
; For Non-realtime ouput leave only the line below:
; -o midiin.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

massign 1, -1; prevent triggering of instrument with MIDI

instr 200
    kMode = 0
    kTempo = 8
    kNote, kTrigger midiarp kTempo
    kFilterFreq lfo 2000, .05, 1

    ;if kTrigger is 1 trigger instrument 300 to play
    if kTrigger==1 then         
        event "i", 300, 0, .5, .5, kNote, abs(kFilterFreq)+rnd(400)
    endif

endin

instr 300

    kEnv expon p4, p3, .001
    aOut vco2 kEnv, cpsmidinn(p5)               ;convert note number to cps
    aFilter moogladder aOut, p6, .2
    outs aFilter, aFilter
    
endin

</CsInstruments>
<CsScore>
i200 0 60
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
