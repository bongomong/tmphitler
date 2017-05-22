

(
Ndef(\x8, {
	var input = Dust.ar(4);
	GVerb.ar(input, revtime:3);


}).play
)

s.options.memSize = 2 ** 16;
s.reboot;
(
Ndef(\x8, {
	var input = LPF.ar(Dust.ar(4), 5000);
	{ GVerb.ar(input, revtime: max(\time.kr(1), 0.001) * rrand(0.1, 1.0)) } ! 8 * 0.4
}).play
)

Ndef(\x8).set(\time, 2);
Ndef(\x8).set(\time, 8);
Ndef(\x8).set(\time, 0.02);
Ndef(\x8).set(\time, 0);


(
Ndef(\x8, {
	{
		var input = LPF.ar(Dust.ar(4), 5000);
		GVerb.ar(input, revtime: max(\time.kr(1), 0.001) * rrand(0.1, 1.0))
	} ! 8 * 0.4
}).play
)

(
Ndef(\x8, {
	{
		var input = BPF.ar(CombL.ar(Impulse.ar(6), 0.01, LFNoise1.kr(4).range(0.03, 0.01), 0.1) * LFNoise0.kr(8).max(0), 1000, 0.2);
		GVerb.ar(input, revtime: max(\time.kr(1), 0.001) * rrand(0.1, 1.0))
	} ! 8 * 0.4
}).play
)


(
Ndef(\x8, {
	{
		var input = BPF.ar(CombL.ar(Impulse.ar(6), 0.01, LFNoise1.kr(4).range(0.03, 0.01), 0.1) * LFNoise0.kr(8).max(0), 1000, 0.2);
	} ! 8 * 0.4
}).play
)




