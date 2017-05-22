
a = { ReplaceOut.ar(0, CombL.ar(In.ar(0, 2), 0.3, 0.3, 2)) }.play;
b = { Dust.ar(1) }.play;
c = { ReplaceOut.ar(0, CombL.ar(In.ar(0, 2), 1/250, 1/250, 1)) }.play;
c.moveAfter(b);
b.release;
b.release;
b = { Dust.ar(1 ! 2) }.play;

Ndef(\c, { CombL.ar(Ndef.ar(\b), 0.3, 0.3, 5) }).play;
Ndef(\b, { CombL.ar(Ndef.ar(\a), 1/250, 1/520, 2) });
Ndef(\a, { Dust.ar([1, 300], [1, 0.04]) });
NdefMixer(s);


ProxySpace.push;

~c = { CombL.ar(Ndef.ar(\b), 0.3, 0.3, 5) };
~c.play;


(
Ndef(\c, { |sustain = 1, freq = 440, amp = 0.1|

	var sound, env;
	env = EnvGen.ar(Env.perc(0.01, sustain, amp * 4), Impulse.ar(1));
	sound = ring1(SinOsc.ar(freq/2), SinOsc.ar(Line.kr(freq*2, freq/3, sustain)));
	sound = sound * env;

}).play;
)

(
Ndef(\c, { |sustain = 1, freq = 440, amp = 0.1|

	var sound, env;
	env = EnvGen.ar(Env.perc(0.01, sustain, amp * 4), Impulse.ar(1));
	sound = ring1(SinOsc.ar(freq), SinOsc.ar(env.linexp(0, 0.4, freq*2, freq/3)));
	sound = sound * env;

}).play;
)

Ndef(\c).set(\freq, 150);
Ndef(\c).fadeTime = 3;

Ndef(\c).xset(\freq, 950);

Ndef(\b, { CombL.ar(Ndef.ar(\c), 0.3, 0.3, 2) * 0.4 }).play;




(
SynthDef(\x, { |out, sustain = 1, freq = 440, amp = 0.1|

	var sound, env;
	env = EnvGen.ar(Env.perc(0.01, sustain, amp * 4), doneAction:2);
	sound = ring1(SinOsc.ar(freq), SinOsc.ar(Line.kr(freq, freq/2, sustain)));
	//sound = SinOsc.ar(freq);
	sound = sound * env;
	Out.ar(out, sound)

}).add
)


(instrument:\x, sustain: 20).play;
(instrument:\x, freq: [200, 600, 1992], sustain: 0.02).play;


(
Tdef(\x, {

	loop {
		//"hallo".postln;
		(instrument:\x, freq: [100, 300, 992], sustain: 0.57).play;
		0.5.wait;
		(instrument:\x, freq: [200, 600, 1992], sustain: 0.17).play;
		1.0.rand.wait;
	}

}).play
)


(
Tdef(\y, {

	loop {
		//"hallo".postln;
		(instrument:\x, freq: [100, 300, 992]/2, sustain: 0.57, out:1).play;
		0.5.wait;
		(instrument:\x, freq: [200, 600, 1992]*2.5, sustain: 0.17, out:Ndef(\k).index).play;
		1.0.rand.wait;
	}

}).play
)

Ndef(\k).mold(2, \audio);

Ndef(\k).stop;
Ndef(\c, { CombL.ar(Ndef.ar(\k), 0.3, 0.03, 0.2) }).play;





(
Tdef(\x, {

	(0..15).do { |i|
		i = i.asInteger;
		(instrument:\x, freq: (i.nthPrime / (i + 1).nthPrime).postln * 700 , sustain: 0.2, amp: 0.04).play;
		(1/(i+1)).wait;
	}

}).play
)


(
Tdef(\x, {

	(0..15).do { |i|
		i = i.asInteger;
		(instrument:\x, freq: (i.nthPrime / (i + 1).nthPrime).postln * 700 , sustain: 0.2, amp: 0.04).play;
		([0.015, 0.01, 0.06].wrapAt(i) * 10).wait;
	}

}).play
)



f = { Ndef(\c).objects[0].synthDef.name };

NodeProxy


(
Tdef(\x, {

	(0..15).do { |i|
		i = i.asInteger;
		(instrument:f.value, freq: (i.nthPrime / (i + 1).nthPrime).postln * 700 , sustain: 0.2, amp: 0.04).play;
		([0.015, 0.01, 0.06].wrapAt(i) * 10).wait;
	}

}).play
)



(
Ndef(\c, { |sustain = 1, freq = 440, amp = 0.1|

	var sound, env;
	env = EnvGen.ar(Env.perc(0.01, sustain, amp), Impulse.ar(2));
	sound = ring1(SinOsc.ar(freq / [8, 7]), SinOsc.ar(env.linexp(0, 0.4, freq*2, freq/3)));
	sound = sound.distort * env;

}).play;
)



(
Tdef(\x, {
	loop {
	(0..15).do { |i|
		Ndef(\c).set(\freq, exprand(200, 9000));
		0.1.wait;
	}
	}

}).play
)



(
w = Window("hello").front;
w.addFlowLayout;
Slider(w, Rect(0, 0, 300, 50)).action_({ |sl| Ndef(\c).set(\freq, sl.value.linexp(0, 1, 20, 10000)) });
Button(w).action_({ Ndef(\c).play });
)


(instrument:\x, note: 5).play;


