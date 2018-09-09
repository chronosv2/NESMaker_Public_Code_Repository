;; As a warning, this code is probably VERY VERY VERY SLOW.
;; I couldn't think of a better way to do this. If someone
;; finds a better way and changes this script could you
;; please make a Pull Request out of it?
MACRO SplitNumber arg0, arg1
;;arg0: The variable to store the number into
;;arg1: The number to split
LDA #$00 ;Load 0 into accumulator
TAX ;Transfer accumulator to X
STA arg0,x ;Store the accumulator (0) into number 1
INX ;Increase X
STA arg0,x ;Store the accumulator (0) into number 2
INX ;Increase X
STA arg0,x ;Store the accumulator (0) into number 3

LDA arg1 ;Load the number we want to split into the accumulator
TestNumbers:
    CLC
    CMP #$64 ;Decimal 100
    BCS Deduct100
    CMP #$0A ;Decimal 10
    BCS Deduct10
    CMP #$01 ;...
    BCS Store1s
JMP EndSplit

Deduct100:
    SBC #$64 ;Subtract 100
    LDX #$02 ;We need the 3rd number
    INC arg0,x ;Add 1 to the 3rd number.
JMP TestNumbers
Deduct10:
    SBC #$0A ;Subtract 10
    LDX #$01 ;We need the 2nd number
    INC arg0,x ;Add 1 to the 2nd number
JMP TestNumbers
Store1s:
    LDX #$00 ;We need the 1st number
    STA arg0,x ;Store the ones digit in the base number.
JMP TestNumbers
EndSplit:

ENDM