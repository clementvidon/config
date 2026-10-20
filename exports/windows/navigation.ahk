#Requires AutoHotkey v2.0

; Swap Ctrl and Alt keys

LCtrl::LAlt
LAlt::LCtrl
RCtrl::RAlt
RAlt::RCtrl

; Cycle through applications

LWin & Tab::AltTab

; Maximize / Restore

#Enter::
{
    hwnd := WinExist("A")

    if WinGetMinMax(hwnd) = 1
        WinRestore(hwnd)
    else
        WinMaximize(hwnd)
}

; Map Alt-hjkl to arrow keys

<!h::Send "{Left}"
<!j::Send "{Down}"
<!k::Send "{Up}"
<!l::Send "{Right}"

; A regular hotkey accepts Ctrl produced by the Alt remap; Send releases it.
^[::Send "{Escape}"
