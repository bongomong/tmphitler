(
~catchAll = NetAddr.new("255.255.255.255", 57120);
~catchAll.sendMsg(\master);

NetAddr.broadcastFlag = true;
// get your actual network ip via shell command
//~net = NetAddr.new(Pipe.new("ifconfig en1 | grep \"inet \" | awk '{print $2}'" , "r").getLine, 57120);
//~net = NetAddr.new("192.168.178.25", 57120);

//main communication unit for the clients
OSCdef(\secrethitler).clear;
OSCdef(\secrethitler, { |msg, time, addr|
    "____________________".postln;
    addr.postln;
    msg[1].postln;
    "____________________".postln;
    ~nextFunction.value(msg[1], addr);		//geht das so für die wahl?
}, \secrethitler);

//gathers the ip-addresses and nicknames in the start of the game from the clients
OSCdef(\newPlayer, { |msg, time, addr|
    if(~listOfPlayers.includesEqual(addr) == false) {
        ~listOfPlayers = ~listOfPlayers.add(addr);
        ~playerNicknames = ~playerNicknames.add(msg[1].asString);
    }
}, \newPlayer);

)


