; Make sure your fishing pole is equipped, AND bound to the '1' key.
; If you have a weather beaten fishing hat, put it on! It will auto apply your lure

SetKeyDelay, 80
WinActivate, World of Warcraft
Winmove,World of Warcraft,,0,0,1820, 1051
Sleep, 1500

loop,75
{
send , /use 1
send {enter}
sleep, 6000
loop, 50
{
WinActivate, World of Warcraft
send, 1
sleep, 2000
gosub fish
sleep, 2000
}
}
exitapp

fish:
gosub alive
PixelSearch, Px, Py, 514, 474, 1315, 820, 0xFAE6E6, 60, fast
Mousemove, %Px%,%Py%,50
sleep, 8000
mouseclick, right
return


alive:
Pixelgetcolor, color, 202,78
if  color <> 0x00B600
{
exitapp
}
return