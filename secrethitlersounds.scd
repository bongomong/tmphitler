
(
~options = Server.local.options;
~options.memSize_(4096*16);
s.boot;
)
(
// load buffers
// eleganter:
// ~paths = ["sounddata/Breaking Glass Sounds [High Quality Free Download].wav”]; // hier die anderen namen rein
// ~fascists = paths.collect { |x| Buffer.read(s, x.resolveRelative) };
Ndef.clear;
~fascist1 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Breaking Glass Sounds [High Quality Free Download].wav"));
~fascist2 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Cartoon Sound Effect - Group of Children Laughing.wav"));
~fascist3 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Clockwork.wav"));
~fascist4 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Fireplace sound effects.wav"));
~fascist5 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Flag in wind sound effect.wav"));
~fascist6 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Hammer SOUND EFFECT.wav"));
~fascist7 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Metal chains rattling - Sound effects.wav"));
~fascist8 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Military Marching Sound Effect.wav"));
~fascist9 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/snare drum march snare solo field march drum line snare drum solo.wav"));
~fascist10 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/Tank moving sound effect.wav"));
~fascist11 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/The Great Dictator Speech- Charlie Chaplin.wav"));
~liberal1 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal1.wav"));
~liberal2 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal2.wav"));
~liberal3 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal3.wav"));
~liberal4 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal4.wav"));
~liberal5 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal5.wav"));
~liberal6 = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/liberal6.wav"));
~theRules = Buffer.read(s, Document.current.path.replace("secrethitlersounds.scd", "sounddata/youKnowTheRulesAndSoDoI.wav"));

// preparation for ndef generation
~ndefNames = List.new;
~bufferNames = [~fascist1, ~fascist2, ~fascist3, ~fascist4, ~fascist5, ~fascist6, ~fascist7, ~fascist8, ~fascist9, ~fascist10, ~fascist11, ~liberal1, ~liberal2, ~liberal3, ~liberal4, ~liberal5, ~liberal6].postln;

for(1, 11, {arg i;
	~ndefNames.add("fascist" ++ i.asString).asSymbol.postln
});
for(1, 6, {arg i;
	~ndefNames.add("liberal" ++ i.asString).asSymbol.postln
});


// chooses 3 randomized effects out of 6 for the buffer
for(0, 10, {arg i;
	Ndef(~ndefNames[i].asSymbol).clear;
	Ndef.new(~ndefNames[i].asSymbol, {
		var sig, delay, clip, volosc, gverb, eq, effects, choice;
		//sig = Out.ar(0, PlayBuf.ar(1, b));
		sig = PlayBuf.ar(2, ~bufferNames[i], 1, loop: 1);

		delay = {
			sig = AllpassN.ar(sig, 0.7, rrand(0.1, 0.5), rrand(1.0, 3.0))
		};

		clip = {
			sig = sig.clip;
		};

		volosc = {
			sig = sig * SinOsc.ar(rrand(0.4, 3));
		};

		gverb = {
			sig = GVerb.ar(sig, rrand(3, 15), revtime: rrand(1.0, 4.0));
			sig * 0.7;
		};

		eq = {
			sig = BLowShelf.ar(sig, rrand(400, 1500), 1, rrand(-24, 6));
			sig = BPeakEQ.ar(sig, rrand(1700, 5000), 1, rrand(-24, 6));
			sig = BHiShelf.ar(sig, rrand(5200, 12000), 1, rrand(-24, 6));
		};

		effects = [delay, clip, volosc, gverb, eq];
		3.do({
			choice = effects.choose;
			choice.value;
			effects.removeAt(effects.indexOf(choice));
		});

		sig = Limiter.ar(sig, 1, 0.01);
	});
	Ndef(~ndefNames[i]).fadeTime = 5;
});

for(11, 16, {arg i;
	Ndef(~ndefNames[i].asSymbol).clear;
	Ndef.new(~ndefNames[i].asSymbol, {
		var sig, delay, clip, volosc, gverb, eq, effects, choice;
		//sig = Out.ar(0, PlayBuf.ar(1, b));
		sig = PlayBuf.ar(2, ~bufferNames[i], 1, loop: 1);

		delay = {
			sig = AllpassN.ar(sig, 0.7, rrand(0.1, 0.5), rrand(1.0, 3.0))
		};

		volosc = {
			sig = sig * SinOsc.ar(rrand(0.4, 3));
		};

		gverb = {
			sig = GVerb.ar(sig, rrand(3, 15), revtime: rrand(1.0, 4.0));
		};

		eq = {
			sig = BLowShelf.ar(sig, rrand(400, 1500), 1, rrand(-12, 6));
			sig = BPeakEQ.ar(sig, rrand(1700, 5000), 1, rrand(-12, 6));
			sig = BHiShelf.ar(sig, rrand(5200, 12000), 1, rrand(-12, 6));
		};

		effects = [delay, volosc, gverb, eq];
		3.do({
			choice = effects.choose;
			choice.value;
			effects.removeAt(effects.indexOf(choice));
		});

		sig = Limiter.ar(sig, 1, 0.01);
	});
	Ndef(~ndefNames[i]).fadeTime = 5;
});


~rollRandom = {
	~runTime = rrand(0.3, 5);
	~fadeTime = rrand(2, 5);
};
~rollRandom.value;

~playSample = {|runTime, fadeTime, sound|
	var sample;
	sample = Task({
		sound.play;
		"run".postln;
		runTime.wait.postln;
		"fade".postln;
		sound.stop(fadeTime).postln;
	});
	sample.play;
};

~loopSound = {|runTime, fadeTime, sound|
	~fascist01Loop = Task.new({
		{
			fadeTime.class.postln;
			~rollRandom.value;
			~playSample.value(runTime, fadeTime, sound);
			rrand(fadeTime + 10, 20).wait;
		}.loop;
	});
	~fascist01Loop.play;
};
)






