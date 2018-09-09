cpx player1_object
BNE dontDoWarp_tile
LDA warpMap
IFDEF CurrentLevel ;;If we've defined CurrentLevel
  STA CurrentLevel ;;Save warpMap to CurrentLevel (0 for overworld, 1 for underworld)
ENDIF			   ;;We use this because I designed my rom NOT to run the timer on the underworld.
clc
adc #$01

STA temp
GoToScreen warpToScreen, temp

dontDoWarp_tile
