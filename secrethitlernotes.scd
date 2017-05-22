/*
Ndef.clear
(
~listOfPlayers.postln;
~listOfPlayers[0].sendMsg(\secrethitler, 0);
~playerNicknames.postln;
~listOfRoles.postln;
)

~listOfPlayers[5];
~playerNicknames[5];

~unsuccessfulVoteCounter
~election.value(1, ("nein"!3)
~listOfVotes = "nein"!7
~listOfVotes = "ja"!7
~listOfVotes.postln

~net = NetAddr.new("192.168.178.58", 57120);
~net = NetAddr.new("255.255.255.255", 57120);

(
~initGame.value;
~listOfPlayers[0].sendMsg(\depesche, [1].asOSCArgArray);
~net.sendMsg(\master, 1);
~net.sendMsg(\secrethitler, 1)
~net.sendMsg(\secrethitler, "Adolf")
~net.sendMsg(\secrethitler, "nein")
~election.value(1, ["ja", "ja", "ja", "nein", "nein", "nein"])

~net.sendMsg(\listen, ~stack[3].key, ~stack[2].key, ~stack[0].key);
~whoIsPresident.sendMsg(\choose, *[["Adolf", "Bertha", "Claus", "Dagmar", "Erich", "Franz"]].foldOSC)



)




~whoIsChancellor = ~net
~whoIsPresident
~lastPresident
~lastChancellor
~lastDepesche.value

~nextFunction.value(0)

~listOfPlayers.indexOfEqual(NetAddr("192.168.178.27", 57120))

NdefMixer(s)
*/


/*o = Server.local.options;
o.numOutputBusChannels.postln;

Ndef(~ndefNames[1].asSymbol).play
NdefMixer(s)
Ndef.clear
*/

/*

fackel
charlie chaplin
marschieren
wehende fahne
glasbruch
militärtrommel
zahnräder
jugend -> kinderlachen

mitläufertum?

rhythmisch
geordnet

*/

/* TEST AREA

~initGame.value;
~net.sendMsg(\secrethitler, 2)		//Standardmessage mit der die Spieler mit dem Spiel kommunizieren
b.sendMsg(\secrethitler, 0)


~whoIsChancellor
~whoIsPresident

*/

/* TODO

-> Initiales ermitteln der Spieler-IPs (Wir haben etwas ähnliches mal irgendwann mit Tobias und den Arduinos  gemacht)
DONE	-> Aufforderung an Spieler, etwas zu tun: Wie sende ich OSC-messages an einzelne Spieler?
-> Election: Alle Spieler müssen einmal "ja" oder "nein" wählen (ohne Enthaltungen). Wie finde ich heraus, von wem eine Nachricht ist? Wie fange ich es ab, wenn ein Client nicht antwortet oder einen Disconnect hat?
-> Soundlogik: Ich möchte auf jeden Fall final generative "faschistische" und "liberale" Sounds haben, sodass das Spiel jedes Mal anders klingt. Zunächst code ich einfach ein paar Testsounds hart. Ich weiß nur noch nicht, ob ich Ndefs oder SynthDefs oder vielleicht was ganz anderes nehmen sollte...
-> Soundrouting: Wie kann ich einzelnen Spielern über das Netzwerk meine Sounds zum Prelistening zur Verfügung stellen?
-> Ereignisse definieren: Was passiert, wenn eine Karte aufgedeckt wird?
-> Spiellogik verfeinern (z.B. wird dreimal eine Wahl verloren, wird die oberste karte aufgedeckt)

-> node proxy

*/

/* FRAGEN

-> .includes gibt bei strings immer false. warum?
ANTWORT: .includes checkt nach identity (===), nicht equality (==)

*/