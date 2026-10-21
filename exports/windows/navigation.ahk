#Requires AutoHotkey v2.0

; =============================================================================
; Modifier keys
; =============================================================================

SetCapsLockState "AlwaysOff"

LCtrl::LAlt
LAlt::LCtrl
RCtrl::RAlt
RAlt::RCtrl
CapsLock::LAlt

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

; A regular hotkey accepts Ctrl produced by the Alt remap; Send releases it.
^[::Send "{Escape}"

; Map Alt-hjkl to arrow keys
<!h::Send "{Left}"
<!j::Send "{Down}"
<!k::Send "{Up}"
<!l::Send "{Right}"
