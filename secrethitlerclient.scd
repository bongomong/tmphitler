(

~nickname = "Blondie";

NetAddr.broadcastFlag = true;
// get your actual network ip via shell command
// ~net = NetAddr.new(Pipe.new("ifconfig en1 | grep \"inet \" | awk '{print $2}'" , "r").getLine, 57120);
~net = NetAddr.new("192.168.178.69", 57120); //temporarily hard coded

// this OSCdef initially sends ip and nickname to the server
OSCdef(\master, { |msg, time, addr|
    "ip versandt".postln;
    ~net.sendMsg(\newPlayer, ~nickname);
}, \master, ~net);

// this OSCdef prints all commands from the server
OSCdef(\depesche, { |msg|
    msg[1].postln;
}, \depesche, ~net);

// this OSCdef opens a gui for the sounds that can be selected as president or chancellor
OSCdef(\listen, { |msg|
	var selection;
	selection = msg.drop(1);
	{~listen.value(selection)}.defer;
}, \listen, ~net);

// this OSCdef opens a gui for the sounds that can be selected as president or chancellor
OSCdef(\choose, { |msg|
	var selection;
	selection = msg.unfoldOSC[1];
	{~choose.value(selection)}.defer;
}, \choose, ~net);

OSCdef(\youLose, { |msg|
	Ndef(\theRules, {
		var sig;
		sig = sig = PlayBuf.ar(2, ~theRules, 1, loop: 1);
	});
	Ndef(\theRules).play;
}, \youLose, ~net);



// listen gui
~listen = { |selection|
	var win, but1, but2, but3, but11, but22, but33;
	selection.postln;
	win = Window.new("Gesetzentwürfe", Rect(200,200,360,160));

	but1 = Button.new(win,Rect(30,40,80,30)).states_([["Play"],["Stop"]]);
	StaticText.new(win,Rect(53,15,80,30)).string_("Gesetz 1");
	but1.action = { if (but1.value.asBoolean) { Ndef(selection[0]).play } { Ndef(selection[0]).stop } };

	but11 = Button.new(win,Rect(30,100,80,30)).states_([["Ablehnen!"]]);
	but11.action = { ~net.sendMsg(\secrethitler, 0); win.close };

	but2 = Button.new(win,Rect(140,40,80,30)).states_([["Play"],["Stop"]]);
	StaticText.new(win,Rect(163,15,80,30)).string_("Gesetz 2");
	but2.action = { if (but2.value.asBoolean) { Ndef(selection[1]).play } { Ndef(selection[1]).stop } };

	but22 = Button.new(win,Rect(140,100,80,30)).states_([["Ablehnen!"]]);
	but22.action = { ~net.sendMsg(\secrethitler, 1); win.close };

	if (selection.size == 3) {
		if (selection[2].asString == "veto", {
			but22 = Button.new(win,Rect(250,100,80,30)).states_([["Veto!"]]);
			but22.action = { ~net.sendMsg(\secrethitler, "veto"); win.close };
		},{
			but3 = Button.new(win,Rect(250,40,80,30)).states_([["Play"],["Stop"]]);
			StaticText.new(win,Rect(273,15,80,30)).string_("Gesetz 3");
			but3.action = { if (but3.value.asBoolean) { Ndef(selection[2]).play } { Ndef(selection[2]).stop } };

			but22 = Button.new(win,Rect(250,100,80,30)).states_([["Ablehnen!"]]);
			but22.action = { ~net.sendMsg(\secrethitler, 2); win.close };
		});
	};

	// disable the following lines if client is on same device as server and stop the sounds via the buttons
	win.onClose = {
		Ndef(selection[0]).stop;
		Ndef(selection[1]).stop;
		Ndef(selection[2]).stop;
	};

	win.front;
};

// choose gui
~choose = { |selection|
	selection.postln;
	w = Window.new("Triff eine Wahl!", Rect(200, 400, 30 + (110 * selection.size), 100));

	a = Button.new(w,Rect(30,40,80,30)).states_([[selection[0]]]);
	a.action = {~net.sendMsg(\secrethitler, selection[0]); Window.closeAll};

	b = Button.new(w,Rect(140,40,80,30)).states_([[selection[1]]]);
	b.action = {~net.sendMsg(\secrethitler, selection[1]); Window.closeAll};

	if (selection.size > 2) {
		c = Button.new(w,Rect(250,40,80,30)).states_([[selection[2]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[2]); Window.closeAll};
	};

	if (selection.size > 3) {
		c = Button.new(w,Rect(360,40,80,30)).states_([[selection[3]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[3]); Window.closeAll};
	};

	if (selection.size > 4) {
		c = Button.new(w,Rect(470,40,80,30)).states_([[selection[4]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[4]); Window.closeAll};
	};

	if (selection.size > 5) {
		c = Button.new(w,Rect(580,40,80,30)).states_([[selection[5]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[5]); Window.closeAll};
	};

	if (selection.size > 6) {
		c = Button.new(w,Rect(690,40,80,30)).states_([[selection[6]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[6]); Window.closeAll};
	};

	if (selection.size > 7) {
		c = Button.new(w,Rect(800,40,80,30)).states_([[selection[7]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[7]); Window.closeAll};
	};

	if (selection.size > 8) {
		c = Button.new(w,Rect(910,40,80,30)).states_([[selection[8]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[8]); Window.closeAll};
	};

	if (selection.size > 9) {
		c = Button.new(w,Rect(1020,40,80,30)).states_([[selection[9]]]);
		c.action = {~net.sendMsg(\secrethitler, selection[9]); Window.closeAll};
	};

	w.front;
};

)




