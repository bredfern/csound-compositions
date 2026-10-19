<CsoundSynthesizer>
<CsInstruments>

instr 1

iamp = ampdb(p4)
icps = cpspch(p5)

kenv linen 1, .1, 2, .3               

a1 oscil iamp*kenv, icps, 1           

out a1

endin

</CsInstruments>
<CsScore>
f1 0 16384 10 1

;inst no     start     duration    amp   pitch
i1			 0 		   2           70    7.00

</CsScore>

</CsoundSynthesizer>
<MacOptions>
Version: 3
Render: Real
Ask: Yes
Functions: Window
Listing: Window
WindowBounds: 126 44 807 615
CurrentView: sco
IOViewEdit: Off
Options: -b128 -A -s -m167 -R --midi-velocity-amp=4 --midi-key-cps=5 
</MacOptions>
<MacGUI>
ioView nobackground {65535, 65535, 65535}
</MacGUI>
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
