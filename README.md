My game is called KeyChords and it's basically piano tiles if you know that game. 

I called it KeyChords because you are pressing keys on the DE2 Board and Chords is just some music term.

So how it works is, switch 17 is your reset, or you could also call it an "on" switch for the game.

Switch 0 to 3 are used to select which precoded song you want to play. There are a total of 7 songs right. Each song consists of four 819 bit long binary sequences, with each sequence representing one of the 4 notes and when they should be drawn on the VGA. So there's a total of 4x819 bit long sequences for each song. Why 819? It's just some number I chose to represent max length of a song, but it can be any number. The way I generated all these binary sequences was with a python script.

Switches 13 to 17 control the speed of the song. Speed can be changed mid song if the player desires to practice a certain part at a reduced speed.

Hex 0 to 3 display the score in hexadeciaml.
Hex 4 displays the selected song.
Hex 6 shows 1 if the song is in progress, else 0 if song is over or when game is off.

When you click the corresponding key to the note, your score goes up if there is a note in the small zone at the bottom.

Each single note is a 4 by 4 square. Speaking in terms of height, you get 8 points if all 4 of the pixels are in the zone. 4 points if 3 are in the zone, 2 points if 2, and 1 point if 1. This discourages the player from simply holding down all 4 keys to get full points.

There are also long notes which again, speaking in terms of height, you will get 1 point per pixel when you are holding down the key. The way I diffrentiated single and long notes is by determining if there is a rest in the middle of an interval of notes as single notes are seperated by spaces. In short, determining the note type only happens at the end of each note so long notes don't switch to single notes midway through.
