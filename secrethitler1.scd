// https:// secrethitler.online/
// https:// de.wikipedia.org/wiki/Secret_Hitler

(

~init = {
	~initgame = {
		~stack = List.new;		// Nachziehstapel (.at(0) --> oberste Karte)
		~trash = List.new;		// Ablagestapel	(.at(0) --> unterste Karte)
		~hand = List.new;		// Hand wird jede Runde überschrieben
		~amountf = 11;			// Anzahl Faschistenkarten
		~amountl = 6;			// Anzahl Liberalenkarten
		~fasstack = List.new;	// Stapel der Faschistenkarten
		~libstack = List.new;	// Stapel der Liberalenkarten
		~listOfPlayers = (0..5);	//provisorisch, später ip-liste
		~whoHasHand = nil;
		~whoIsPresident = ~listOfPlayers.choose;
		~whoIsChancellor = nil;
		~status = -1;			// Gibt der OSCdef vor, in welcher Phase sich das Spiel befindet
	};

	~createstack = {
		// Erstellt gemischten Nachziehstapel (0 --> Faschistenkarte, 1 --> Lieberalenkarte)
		// Später können hier statt 0 und 1 Ndefs abgelegt werden
		~initgame.value;
		//~stack = ((0 ! ~amountf) ++ (1 ! ~amountl)).scramble;
		~stack = [Ndef(\fascist01), Ndef(\fascist02), Ndef(\fascist03), Ndef(\fascist04), Ndef(\fascist05), Ndef(\fascist06), Ndef(\fascist07), Ndef(\fascist08), Ndef(\fascist09), Ndef(\fascist10), Ndef(\fascist11), Ndef(\liberal01), Ndef(\liberal02), Ndef(\liberal03), Ndef(\liberal04), Ndef(\liberal05), Ndef(\liberal06)].scramble;
		"Ein neues Spiel hat begonnen: ".postln;
		~check.value;
	};


	~chooseChancellor = { |chancellor|
		//präsident wählt kanzler, check1 ob spieler existiert, check2 ob spieler letzter kanzler oder präsident war (darf nicht wiedergewählt werden)
		//TODO: 5bis6 spieler darf letzter präsident gewählt werden
		if(~listOfPlayers.includes(chancellor.asInteger)) {
			if(and(~whoIsChancellor != chancellor, ~whoIsPresident != chancellor)) {
				~whoIsChancellor = chancellor;
				chancellor.asString.postln;
				"is new chancellor".postln;
				~status = 1;
			} {
				"This player is not electable!".postln
			}
		} {
			"This player doesn't exist!".postln
		}
	};


	~draw = {
		// Zieht drei Karten vom Nachziehstapel und erstellt daraus eine Hand
		~hand = ~stack.keep(3);
		~stack = ~stack.drop(3);
		"Drei Karten wurden gezogen: ".postln;
		~status = 2;
		~status.postln;
		~check.value;
	};

	~passTwo = {|discard = 0|
		// Legt eine Karte aus der Hand auf den Ablagestapel
		~trash.add(~hand.removeAt(discard));
		"Zwei Karten wurden weitergegeben, eine abgelegt: ".postln;
		~check.value;
		~status = 3;
	};

	~reveal = {|discard = 0|
		// Legt von den verbleibenden zwei Karten eine auf den Ablagestapel und legt die andere entweder auf den Liberalenstapel oder den Faschistenstapel
		~trash.add(~hand.removeAt(discard));
		if(~hand.at(0) == 0, {~fasstack.add(~hand.at(0))}, {~libstack.add(~hand.at(0))});
		~hand.at(0).play;
		~hand = List.new;
		"Eine Karte wurde aufgedeckt, eine abgelegt: ".postln;
		~check.value;
		// Sollten im Nachziehstapel weniger als 3 Karten sein, wird der Ablagestapel wieder in den Nachziehstapel gemischt
		if(~stack.size < 3, {
			~stack = ~stack.addAll(~trash).scramble;
			~trash.clear;
			"Der Ablagestapel wurde in den Nachziehstapel gemsicht:".postln;
			~check.value;
		});
		~status = 0;
	};

	~check = {
		// Check the state!
		"------------------------------------------------".postln;
		"Nachziehstapel: ".postln;
		~stack.postln;
		"Ablagestapel: ".postln;
		~trash.postln;
		"Hand: ".postln;
		~hand.postln;
		"Faschistenstapel".postln;
		~fasstack.postln;
		"Liberalenstapel".postln;
		~libstack.postln;
		"------------------------------------------------".postln;
	};
	~createstack.value;
	~status = 0;
};
)

/* TEST AREA

~init.value;

~createstack.value;
~chooseChancellor.value(0);
~draw.value;
~passTwo.value(0);
~reveal.value(0);

~check.value;

*/

