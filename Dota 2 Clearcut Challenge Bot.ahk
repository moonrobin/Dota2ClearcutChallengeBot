#SingleInstance force
#InstallMouseHook
#NoEnv

SetMouseDelay, 0
coordinatesAreValid := false
topLeftX := -1 
topLeftY := -1 
botRightX := -1 
botRightY := -1
MsgBox, , ClearCutBot, Please bring the Dota 2 window in focus and using the middle mouse button, drag select the ClearCut forest.

return

CutClear(topLeftX, topLeftY, botRightX, botRightY)
{
    deltaX := botRightX - topLeftX
    deltaY := botRightY - topLeftY

    stepsPerLength := 20

    StepSizeX := deltaX / stepsPerLength
    StepSizeY := deltaY / stepsPerLength

    startX := topLeftX + StepSizeX
    startY := topLeftY + StepSizeY
    currentX := startX
    currentY := startY    
    iterator := stepsPerLength - 1

    Loop {
        Loop, 19 {
            currentX := startX
            Loop, 19 {
                Click %currentX% %currentY%
                Click right %currentX% %currentY%
                currentX += StepSizeX
            }  

            currentY += StepSizeY
        }

        currentX := startX
        currentY := startY
    }
}


SelectArea(Options="")
{
    CoordMode, Mouse, Screen
    MouseGetPos, MX, MY
    CoordMode, Mouse, Relative
    MouseGetPos, rMX, rMY
    CoordMode, Mouse, Screen
    loop, parse, Options, %A_Space%
    {
        Field := A_LoopField
        FirstChar := SubStr(Field,1,1)

        if FirstChar contains c,t,g,m
        {
            StringTrimLeft, Field, Field, 1
            %FirstChar% := Field
        }
    }
    c := (c = "") ? "Blue" : c, t := (t = "") ? "50" : t, g := (g = "") ? "99" : g , m := (m = "") ? "s" : m
    Gui %g%: Destroy
    Gui %g%: +AlwaysOnTop -caption +Border +ToolWindow +LastFound
    WinSet, Transparent, %t%
    Gui %g%: Color, %c%
    Hotkey := RegExReplace(A_ThisHotkey,"^(\w* & |\W*)")
    While, (GetKeyState(Hotkey, "p"))
    {
        Sleep, 10
        MouseGetPos, MXend, MYend
        w := abs(MX - MXend), h := abs(MY - MYend)
        X := (MX < MXend) ? MX : MXend
        Y := (MY < MYend) ? MY : MYend
        Gui %g%: Show, x%X% y%Y% w%w% h%h% NA
    }
    Gui %g%: Destroy
    CoordMode, Mouse, Relative
    MouseGetPos, rMXend, rMYend
    If ( rMX > rMXend )
        temp := rMX, rMX := rMXend, rMXend := temp
    If ( rMY > rMYend )
        temp := rMY, rMY := rMYend, rMYend := temp

    topLeftX := rMX 
    topLeftY := rmY 
    botRightX := rMXend 
    botRightY := rMYend
    
    if ((topLeftX > botRightX) OR (topLeftY > botRightY)) {
        MsgBox, , ClearCutBot, Coordinates are invalid. please use the middle mouse button to drag select the ClearCut forest from the top left corner to the bottom right corner
        Return 1
    }   

    MsgBox, , ClearCutBot, Press Okay to begin the bot. CTRL + C at any time will close the program.
    CutClear(topLeftX, topLeftY, botRightX, botRightY)
}

Mbutton::
    SelectArea("c00ff99 t25 g99 mr")
    
    Return

^C::ExitApp