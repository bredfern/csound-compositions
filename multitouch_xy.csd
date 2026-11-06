<CsoundSynthesizer>
<CsOptions>
-o dac -d -b512 -B2048
</CsOptions>
<CsInstruments>
nchnls=2
0dbfs=1
ksmps=32
sr = 44100

ga1 init 0

instr 1

itie tival
i_instanceNum = p4
S_xName sprintf "touch.%d.x", i_instanceNum
S_yName sprintf "touch.%d.y", i_instanceNum

kx chnget S_xName
ky chnget S_yName

kenv linsegr 0, .1, 1, .1, 1, .25, 0

kcps = kx*1000*rnd(25)
kcar = 1
kmod = 7
kndx line 1, 30, 11	;intensivity sidebands

kamp = 6
itype = 4

klfo lfo kamp, 1 + ky*rnd(50), itype
a1 foscili .2, kcps + klfo, kcar, kmod, kndx, 1

ga1 = ga1 + a1

endin

instr 2

aL, aR reverbsc ga1, ga1, .62, 50000

outs aL, aR

ga1 = 0

endin


</CsInstruments>
<CsScore>
f1 0 16384 10 1

i2 0 360000
 
</CsScore>
</CsoundSynthesizer>

