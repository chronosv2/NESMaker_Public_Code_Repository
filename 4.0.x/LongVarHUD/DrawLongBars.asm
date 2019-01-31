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
	BMI GaugeLow 	;If Minus set, we have <8 HP, so empty var2 and write to var1
	STA var2		;Write the remaining amount to var2
	STA LongHudVar  ;Also write it here.
	LDA #$08 		;Load a full bar.
	STA var1		;Set var1 to full bar.
	JMP DrawHUDs

	GaugeLow:
	TYA				;We need the original number since it's < 8.
	STA var1		;Store that in var1
	LDA #$00		;Get an empty bar
	STA var2		;Store that in var2
	STA LongHudVar	;Also store in LongHudVar because we need that to properly draw to HUD.

	DrawHUDs:
		LDA var1					;Load var1
		STA hudElementTilesToLoad	;Save that to how many tiles we need to draw with active number.
		LDA #$00					;Let's clear the counter.
		STA hudElementTilesMax		;This value contains the counter for how many element segments to draw. Set it to 0 or it'll overflow!
		LDA DrawHudBytes			;The bytes representing HUD elements we need to update (Currently #$00 (Bin 00000000)
		ORA #var3					;var3 should be the first bar
		ORA #var4					;var4 should be the second bar (next to first bar on HUD screen (if var3 is element 2, var4 should be element 3)
		STA DrawHudBytes			;Save our change.

		LDY tempy

ENDM


