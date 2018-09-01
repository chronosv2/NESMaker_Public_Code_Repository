MACRO LongBar var1,var2,var3,var4
; Arguments
; Accumulator: The number we're working with
; var1: The memory address of the first gauge.
; var2: The memory address of the second gauge.
; var3: The memory address of the fist HUD Element.
; var4: The memory address of the second HUD Element.

	STY tempy
	TAY
	SEC
	SBC #$08 		;Let's see if HP > 8.
	BMI GaugeLow 	;If carry set, we have >=8 HP, so jump to both.
	STA var2
	STA LongHudVar
	LDA #$08 		;Load a full bar into 8. We have 8 or more HP.
	STA var1		;Set myHealth var to Accumulator
	JMP DrawHUDs

	GaugeLow:
	TYA
	STA var1
	LDA #$00
	STA var2
	STA LongHudVar

	DrawHUDs:
		LDA var1
		STA hudElementTilesToLoad
		LDA #$00
		STA hudElementTilesMax		;This value contains the counter for how many element segments to draw. Set it to 0 or it'll overflow!
		LDA DrawHudBytes			;The bytes representing HUD elements we need to update (Currently #$00 (Bin 00000000)
		ORA #var3			;myHealth is Element 3, so set bit 3 (00100000)
		ORA #var4
		STA DrawHudBytes			;Save our change.

		LDY tempy

ENDM


