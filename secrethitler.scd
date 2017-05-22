// https:// secrethitler.online/
// https:// de.wikipedia.org/wiki/Secret_Hitler
(
~listOfPlayers = [NetAddr("scip0", 57120), NetAddr("scip1", 57120), NetAddr("scip2", 57120), NetAddr("scip3", 57120), NetAddr("scip4", 57120), NetAddr("scip5", 57120)];
//~listOfPlayers = ['192.168.178.26', '192.168.178.27', '192.168.178.28', '192.168.178.29', '192.168.178.30', '192.168.178.31'];		//contains ip addresses of players as symbols TEMPORARILY HARDCODED
~playerNicknames = ["Adolf", "Bertha", "Claus", "Dagmar", "Erich", "Franz"];		//contains nicknames of players as symbols TEMPORARILY HARDCODED
// ~listOfPlayers = List.new;
// ~playerNicknames = List.new;
)

(
//~nextFunction = ~initGame;

~initGame = {
    ~stack = List.new;		// Nachziehstapel (.at(0) --> oberste Karte)
    ~trash = List.new;		// Ablagestapel	(.at(0) --> unterste Karte)
    ~hand = List.new;		// Hand wird jede Runde überschrieben
    ~fasstack = List.new;	// Stapel der Faschistenkarten
    ~libstack = List.new;	// Stapel der Liberalenkarten
    ~listOfRoles = List.new;
    ~whoIsPresident = nil;
    ~possiblePresidentIndizes = List.new;
    ~presidentIndex = nil;
    ~lastPresident = nil;
    ~whoIsChancellor = nil;
    ~lastChancellor = nil;
    ~chancellorCandidate = nil;
    ~listOfVotes = nil ! ~listOfPlayers.size;
    ~unsuccessfulVoteCounter = 0;
    ~lastDepesche = nil;
    ~gamestart.value;
	~listOfPlayersSave = ~listOfPlayers.copy;
	~playerNicknamesSave = ~playerNicknames.copy;
	~isExtraTurn = false;
	~extraTurnPresident = nil;
};

~gamestart = {
    ~possiblePresidentIndizes = (..~listOfPlayers.size -1);
	~sendToAll.value("Die Weimarer Republik fährt auf den Abgrund zu und viele Kräfte kämpfen um das Steuer!");
    ~giveRoles.value;
    ~createStack.value;
    ~rolePresident.value;
    ~nextFunction = ~chooseChancellor;
};

// ~giveRoles.value
// roles the roles of the players
~giveRoles = {
    var numberOfPlayers, lib, fas;
    numberOfPlayers = ~listOfPlayers.size;
    if(numberOfPlayers.odd) {lib = numberOfPlayers + 1 / 2} {lib = numberOfPlayers +2 / 2};
    fas = numberOfPlayers - lib - 1;
    ~listOfRoles = (("Faschist" ! fas) ++ ("Liberaler" ! lib) ++ ["Hitler"]).scramble;
	// "Die Rollen wurden verteilt:".postln;
    //~listOfRoles.postln;
    for(0, (~listOfPlayers.size - 1), { arg i;
        var role;
		role = ~listOfRoles[i];
		~listOfPlayers[i].sendMsg(\depesche, ("Du bist" + role ++ "!").asString);
		if(role == "Faschist", {
			for(0, (~listOfPlayers.size - 1), { arg j;
				~listOfPlayers[i].sendMsg(\depesche, (~playerNicknames[j] + "ist" + ~listOfRoles[j] + "!").asString)
			});
		});
       /* ~net.sendMsg(\depesche, ("Du bist" + role ++ "!").asString);
        if(role == "Faschist", {
            for(0, (~listOfPlayers.size - 1), { arg j;
                ~net.sendMsg(\depesche, (~playerNicknames[j] + "ist" + ~listOfRoles[j] + "!").asString)
            });
        });*/

    });
};

~createStack = {
    // Erstellt gemischten Nachziehstapel (0 --> Faschistenkarte, 1 --> Lieberalenkarte)
    ~stack = [Ndef(\fascist1), Ndef(\fascist2), Ndef(\fascist3), Ndef(\fascist4), Ndef(\fascist5), Ndef(\fascist6), Ndef(\fascist7), Ndef(\fascist8), Ndef(\fascist9), Ndef(\fascist10), Ndef(\fascist11), Ndef(\liberal1), Ndef(\liberal2), Ndef(\liberal3), Ndef(\liberal4), Ndef(\liberal5), Ndef(\liberal6)].scramble;
    //"Ein neues Spiel hat begonnen: ".postln;
    ~check.value;
};

~rolePresident = {
    ~presidentIndex = ~possiblePresidentIndizes.choose;
    ~whoIsPresident = ~listOfPlayers[~presidentIndex];
    //("Der erste Präsident ist:" + ~playerNicknames[~listOfPlayers.indexOf(~whoIsPresident)]).postln;
    ~sendToAll.value((~playerNicknames[~listOfPlayers.indexOf(~whoIsPresident)] + "ist neuer Präsident!"));
	~sendToPresident.value("Du bist Präsident! Bitte wähle einen Kanzler!");
	~presidentAction.value;
	~askForCandidate.value;
};

~sendToPresident = { |msg|
	~lastDepesche = {~whoIsPresident.sendMsg(\depesche, msg.asString)};
	// ~lastDepesche = { ~net.sendMsg(\depesche, msg.asString)};
    ~lastDepesche.value;
};

~sendToChancellor = { |msg|
	~lastDepesche = {~whoIsChancellor.sendMsg(\depesche, msg.asString)};
	// ~lastDepesche = {~net.sendMsg(\depesche, msg.asString)};
    ~lastDepesche.value;
};

~sendToAll = { |msg|
    ~lastDepesche = {
        for(0, (~listOfPlayers.size - 1), { arg i;
			~listOfPlayers[i].sendMsg(\depesche, msg.asString)
			// ~net.sendMsg(\depesche, msg.asString)
        })
    };
    ~lastDepesche.value;
};

// actual president, last president and last chancellor can not be elected
// needs network test
~askForCandidate = {
	var candidates, candidatesIP, removeIndex;
	candidates = ~playerNicknames.copy;
	candidatesIP = ~listOfPlayers.copy;
	removeIndex = candidatesIP.indexOfEqual(~whoIsPresident);
	candidates.removeAt(removeIndex);
	candidatesIP.removeAt(removeIndex);
	if ( ~lastPresident != nil ) {
		removeIndex = candidatesIP.indexOfEqual(~lastPresident);
		candidates.removeAt(removeIndex);
		candidatesIP.removeAt(removeIndex);
	};
	if ( ~lastChancellor != nil) {
		removeIndex = candidatesIP.indexOfEqual(~lastChancellor);
		candidates.removeAt(removeIndex);
	};
	~whoIsPresident.sendMsg(\choose, *[candidates].foldOSC);
};

~chooseChancellor = { |chancellor|
    var chancellorNetAddr;
    chancellor = chancellor.asString;
    // präsident wählt kanzler, check1 ob spieler existiert, check2 ob spieler letzter kanzler oder präsident war (darf nicht wiedergewählt werden)
    //TODO: 5bis6 spieler darf letzter präsident gewählt werden
    if(~playerNicknames.includesEqual(chancellor)) {
        chancellorNetAddr = ~listOfPlayers[~playerNicknames.indexOfEqual(chancellor)];
		// if((~lastChancellor != chancellorNetAddr) && (~lastPresident != chancellorNetAddr) && (~whoIsPresident != chancellorNetAddr)) {
		~chancellorCandidate = chancellorNetAddr;
		~sendToAll.value((chancellor + "ist neuer Kanzlerkandidat! Stimme mit \"ja\" oder \"nein\"!"));
		~askForVotes.value;
		// set length of listOfVotes to the actual value shortly before the election
		~listOfVotes = nil ! ~listOfPlayers.size;
		~allAction.value;
		~nextFunction = ~getPolls;
		/*        } {
		//"This player is not electable!".postln
            ~sendToPresident.value(chancellor + "darf nicht gewählt werden! Wähle jemand anderen!");
        }*/
    } {
        // "This player doesn't exist!".postln
        ~sendToPresident.value(chancellor + "existiert nicht!");
    }
};

~askForVotes = {
	for ( 0, (~listOfPlayers.size - 1), { arg i; ~listOfPlayers[i].sendMsg(\choose, *[["ja", "nein"]].foldOSC) });
};

~getPolls = { |vote, playerNetAddr|
    var votes;
    //votes = ["ja", "ja", "ja", "nein", "nein", "nein"];
    //playerNetAddr.postln;
    if(~listOfPlayers.includesEqual(playerNetAddr), {
        if(or(vote.asString == "ja", vote.asString == "nein"), {
            ~listOfVotes.put(~listOfPlayers.indexOfEqual(playerNetAddr), vote);
            playerNetAddr.sendMsg(\depesche, "Deine Wahlentscheidung wurde registriert!");
            ~listOfVotes.postln;
        }, {
            playerNetAddr.sendMsg(\depesche, "Ungültige Stimmabgabe! Wähle \"ja\" oder \"nein\"!")
        })
    });
    if(~listOfVotes.includes(nil) == false, {~election.value(~chancellorCandidate, ~listOfVotes)});
};

~election = { |candidate, thePolls|
    // checks if the chancellor has been elected
    var ja = 0, nein = 0, results = String.new;
    (candidate.asString + thePolls.asString);
    thePolls.do({ arg item;
        if(item == "ja", {ja = ja + 1});
        if(item == "nein", {nein = nein + 1});
    });
    if(ja > nein, {
        ~sendToAll.value((~playerNicknames[~listOfPlayers.indexOfEqual(candidate)] + "wurde zum Kanzler gewählt!"));
		for(0, (~playerNicknames.size - 1), {arg i; results = results ++ ~playerNicknames[i] ++ ":" + thePolls[i] ++ "\r"});
		~sendToAll.value("So wurde abgestimmt:\r" ++ results);
        ~whoIsChancellor = candidate;
        ~unsuccessfulVoteCounter = 0;
		if(~fasstack.size > 2, {
			if(~listOfRoles[~listOfPlayers.indexOfEqual(~whoIsChancellor)] == "Hitler", {
				~sendToAll.value("Hitler wurde zum Kanzler gewählt und hat das Parlament aufgelöst! Die Faschisten haben gewonnen!");
				~nextFunction = ~initGame
			},{
				~draw.value
			});
		},{
			~draw.value
		});
    }, {
        ~sendToAll.value((~playerNicknames[~listOfPlayers.indexOfEqual(candidate)] + "wurde nicht zum Kanzler gewählt!"));
		for(0, (~playerNicknames.size - 1), {arg i; results = results ++ ~playerNicknames[i] ++ ":" + thePolls[i] ++ "\r"});
		~sendToAll.value("So wurde abgestimmt:\r" ++ results);
        //"Der Kanzler wurde nicht gewählt".postln;
        ~unsuccessfulVoteCounter = ~unsuccessfulVoteCounter + 1;
        ~sendToAll.value(("Anzahl der inaktiven Regierungen in Folge:" + ~unsuccessfulVoteCounter.asString));
		if((~unsuccessfulVoteCounter % 3) == 0, {~forcedReveal.value}, {~prepareNextTurn.value} );
    });
};

~draw = {
    // Zieht drei Karten vom Nachziehstapel und erstellt daraus eine Hand
    ~hand = ~stack.keep(3);
    ~stack = ~stack.drop(3);
	// "Drei Karten wurden gezogen: ".postln;
	~presidentAction.value;
    ~nextFunction = ~passTwo;
    ~sendToPresident.value("Wähle einen Sound und verwerfe ihn! Die verbleibenden Sounds werden dem Kanzler überreicht!");
	~whoIsPresident.sendMsg(\listen, ~hand[0].key, ~hand[1].key, ~hand[2].key);
    ~check.value;
};

~passTwo = {|discard = 0|
    // Legt eine Karte aus der Hand auf den Ablagestapel
    ~trash.add(~hand.removeAt(discard));
	~sendToChancellor.value("Wähle einen Sound und verwerfe ihn! Der verbleibende Sound wird Gesetz und für alle hörbar!");
	if(~fasstack.size == 5, {
		~sendToAll.value("Von nun an hat der Kanzler ein Veto-Recht!");
		~whoIsChancellor.sendMsg(\listen, ~hand[0].key, ~hand[1].key, "veto")
	}, {
		~whoIsChancellor.sendMsg(\listen, ~hand[0].key, ~hand[1].key)
	});
    // "Zwei Karten wurden weitergegeben, eine abgelegt: ".postln;
	~chancellorAction.value;
	~nextFunction = ~reveal;
	~check.value;
};

~reveal = {|discard = 0|
	// Legt von den verbleibenden zwei Karten eine auf den Ablagestapel und legt die andere entweder auf den Liberalenstapel oder den Faschistenstapel
	if (discard.asString == "veto", {
		2.do({~trash.add(~hand.removeAt(0))});
		~sendToAll.value("Der Kanzler hat von seinem Vetorecht Gebrauch gemacht! Kein Gesetz wurde umgesetzt und es wird neu gewählt!");
		~unsuccessfulVoteCounter = ~unsuccessfulVoteCounter + 1;
        ~sendToAll.value(("Anzahl der inaktiven Regierungen in Folge:" + ~unsuccessfulVoteCounter.asString));
		if((~unsuccessfulVoteCounter % 3) == 0, {~forcedReveal.value}, {~prepareNextTurn.value} );
	}, {
		~trash.add(~hand.removeAt(discard));
		// ~hand.at(0).play;
		~loopSound.value(~runTime, ~fadeTime, ~hand.at(0));
		if(~hand.at(0).key.asString.contains("fascist"), {
			~fasstack.add(~hand.at(0));
			~sendToAll.value("Ein faschistisches Gesetz wurde umgesetzt!\rAnzahl faschistischer Gesetze:" + ~fasstack.size + "\rAnzahl liberaler Gesetze:" + ~libstack.size);
			~action.value;
		}, {
			~libstack.add(~hand.at(0));
			~sendToAll.value("Ein liberales Gesetz wurde umgesetzt!\rAnzahl faschistischer Gesetze:" + ~fasstack.size + "\rAnzahl liberaler Gesetze:" + ~libstack.size);
			~prepareNextTurn.value;
		});
	});
	~hand = List.new;
	~check.value;
};

~action = {
	//long game win conditions
	~presidentAction.value;
	if(~libstack.size == 5, {
		~sendToAll.value("Die Liberalen haben gewonnen!");
		~listOfPlayers = ~listOfPlayersSave;
		~playerNicknames = ~playerNicknamesSave;
		~nextFunction = ~initGame
	},{
		if(~fasstack.size == 6, {
			~sendToAll.value("Die Faschisten haben gewonnen!");
			~listOfPlayers = ~listOfPlayersSave;
			~playerNicknames = ~playerNicknamesSave;
			~nextFunction = ~initGame
		},{
			// event section
			if(~fasstack.size == 5, { ~killSomeone.value; });
			if(~fasstack.size == 4, { ~killSomeone.value; });
			if(~fasstack.size == 3, {
				~sendToAll.value("Die Gesetze werden schärfer! Auf der Straße hört man Gerüchte über einen Putschversuch!");
				~chooseNextPresident.value;
			});
			if(~fasstack.size == 2, { ~investigateIdentity.value; });
			if(~fasstack.size < 2, { ~prepareNextTurn.value; });
		});
	});
};

~killSomeone = {
	~sendToAll.value("In dieser Gesellschaft ist kein Platz für jeden! Die Regierung muss handeln!");
	~sendToPresident.value("Es gibt keine Alternative! Ein Spieler muss sterben!");
	~whoIsPresident.sendMsg(\choose, *[~playerNicknames].foldOSC);
	~nextFunction = ~kill;
};

~kill = {|victim|
	var deathIndex;
	victim = victim.asString;
	if( ~playerNicknames.includesEqual(victim) , {
		if(~listOfRoles[~playerNicknames.indexOfEqual(victim)] == "Hitler" , {
			~sendToAll.value("Secret Hitler wurde erschossen und die Faschisten sind führerlos! Die Liberalen haben gewonnen! Vorerst...");
			~listOfPlayers[~playerNicknames.indexOfEqual(victim)].sendMsg(\youLose);
			~listOfPlayers = ~listOfPlayersSave;
			~playerNicknames = ~playerNicknamesSave;
			~nextFunction = ~initGame
		}, {
			~sendToAll.value(victim + "wurde zum Wohle der Nation hingerichtet! Dies soll eine Lehre für alle sein!");
			~listOfPlayers[~playerNicknames.indexOfEqual(victim)].sendMsg(\depesche, "Du wurdest hingerichtet! Mach dir nichts draus! Politik ist nicht für jeden was!\r\r¯\\_(ツ)_/¯\r");
			~listOfPlayers[~playerNicknames.indexOfEqual(victim)].sendMsg(\youLose);
			deathIndex = ~playerNicknames.indexOfEqual(victim);
			~listOfPlayers.removeAt(deathIndex);
			~playerNicknames.removeAt(deathIndex);
			~listOfRoles.removeAt(deathIndex);
			~possiblePresidentIndizes = ~possiblePresidentIndizes.keep(~possiblePresidentIndizes.size - 1);
			~listOfPlayers.postln;
			~playerNicknames.postln;
			~prepareNextTurn.value;
	})}, {
		~sendToPresident.value(victim + "existiert nicht!");
	});
};

~chooseNextPresident = {
	// president can't choose himself
	var targets;
	targets = ~playerNicknames.copy;
	targets.removeAt(~listOfPlayers.indexOfEqual(~whoIsPresident));
	~sendToAll.value("Aufgrund der akuten Bedrohungen ernennt der Präsident seinen Nachfolger per Dekret!");
	~sendToPresident.value("Wähle deinen Nachfolger!");
	~whoIsPresident.sendMsg(\choose, *[targets].foldOSC);
	~nextFunction = ~extraTurn;
};

~extraTurn = {|target|
	target = target.asString;
	~extraTurnPresident = ~listOfPlayers[~playerNicknames.indexOfEqual(target)];
	~isExtraTurn = true;
	~prepareNextTurn.value;
};

~investigateIdentity = {
	// president can't investigate himself
	var targets;
	targets = ~playerNicknames.copy;
	targets.removeAt(~listOfPlayers.indexOfEqual(~whoIsPresident));
	~sendToAll.value("Es wurde zum Schutze aller eine Institution zur Untersuchung von politischen Gefährdern ins Leben gerufen. Der Präsident leitet die erste Operation persönlich");
	~sendToPresident.value("Untersuche die Identität eines Spielers!");
	~whoIsPresident.sendMsg(\choose, *[targets].foldOSC);
	~nextFunction = ~investigation;
};

~investigation = {|target|
	target = target.asString;
	~sendToPresident.value(target + "ist" + ~listOfRoles[~playerNicknames.indexOfEqual(target)]);
	~prepareNextTurn.value;
};

~prepareNextTurn = {
	//sets new president and remembers who was the last one
	~presidentAction.value;
	~lastPresident = ~whoIsPresident;
	if(~whoIsChancellor != nil, {
		~lastChancellor = ~whoIsChancellor;
		~whoIsChancellor = nil;
	});
	if(~isExtraTurn == true, {
		~whoIsPresident = ~extraTurnPresident;
		~isExtraTurn == false;
	}, {
		~presidentIndex = ~presidentIndex + 1 % ~possiblePresidentIndizes.size;
		~whoIsPresident = ~listOfPlayers[~presidentIndex];
	});

	~sendToAll.value(~playerNicknames[~listOfPlayers.indexOfEqual(~whoIsPresident)] + "ist neuer Präsident!");
	~sendToPresident.value("Du bist Präsident! Bitte wähle einen Kanzler!");
	~askForCandidate.value;
	// (~whoIsPresident.asString + "ist neuer Präsident").postln;
	// Sollten im Nachziehstapel weniger als 3 Karten sein, wird der Ablagestapel wieder in den Nachziehstapel gemischt
	~shuffle.value;
	~nextFunction = ~chooseChancellor;
};

~forcedReveal = {
	// ~stack.at(0).play;
	~loopSound.value(~runTime, ~fadeTime, ~stack.at(0));
	~sendToAll.value("Es wurden drei Regierungen in Folge abgelehnt! Die Legislative muss reagieren!");
	if(~stack.at(0).key.asString.contains("fascist"), {
		~fasstack.add(~stack.removeAt(0));
		~sendToAll.value("Ein faschistisches Gesetz wurde umgesetzt!\rAnzahl faschistischer Gesetze:" + ~fasstack.size + "\rAnzahl liberaler Gesetze:" + ~libstack.size);
		~action.value;
	}, {
		~libstack.add(~stack.removeAt(0));
		~sendToAll.value("Ein liberales Gesetz wurde umgesetzt!\rAnzahl faschistischer Gesetze:" + ~fasstack.size + "\rAnzahl liberaler Gesetze:" + ~libstack.size);
		~prepareNextTurn.value;
	});

};

~shuffle = {
	if(~stack.size < 3, {
        ~stack = ~stack.addAll(~trash).scramble;
        ~trash.clear;
        "Der Ablagestapel wurde in den Nachziehstapel gemsicht:".postln;
        ~check.value;
    });
};

~allAction = {
/*	"allActionölkjöhöhöhöhöh".postln;
	OSCdef(\secrethitler).clear;
	OSCdef(\secrethitler, { |msg, time, addr|
		"____________________".postln;
		addr.postln;
		msg[1].postln;
		"____________________".postln;
		~nextFunction.value(msg[1], addr);
	}, \secrethitler);*/
};

~presidentAction = {
/*	"presidentActionölkjöhöhöhöhöh".postln;
	OSCdef(\secrethitler).clear;
	OSCdef(\secrethitler, { |msg, time, addr|
		"____________________".postln;
		addr.postln;
		msg[1].postln;
		"____________________".postln;
		~nextFunction.value(msg[1], addr);
	}, \secrethitler, ~whoIsPresident);*/
};

~chancellorAction = {
/*	"chancellorActionölkjöhöhöhöhöh".postln;
	OSCdef(\secrethitler).clear;
	OSCdef(\secrethitler, { |msg, time, addr|
		"____________________".postln;
		addr.postln;
		msg[1].postln;
		"____________________".postln;
		~nextFunction.value(msg[1], addr);
	}, \secrethitler, ~whoIsChancellor);*/
};

~check = {
    // Check the state!
    "\r------------------------------------------------".postln;
    "Nachziehstapel: ".postln;
    ~stack.postln;
    "Ablagestapel: ".postln;
    ~trash.postln;
    "Hand: ".postln;
    ~hand.postln;
    "Faschistenstapel:".postln;
    ~fasstack.postln;
    "Liberalenstapel:".postln;
    ~libstack.postln;
    "------------------------------------------------\r".postln;
};

)

/* TEST AREA

~nextFunction
~initGame.value;
~giveRoles.value;
~createStack.value;

~chooseChancellor.value(3);
~election.value(["ja", "ja", "ja", "nein", "nein", "nein"])
~draw.value;
~passTwo.value(0);
~reveal.value(0);

~check.value;

*/
