
	CLC
	AddValue #$03, myWater, #$03, #$00

	LDA myWater+2
	CMP MyWater100
	BCS +CheckTens
	JMP +End

	+CheckTens:
	LDA myWater+1
	CMP MyWater10
	BCS +CheckOnes
	JMP +End

	+CheckOnes:
	LDA myWater
	CMP MyWater1
	BCS +SetMax
	JMP +End

	+SetMax:
	LDA MyWater100
	STA myWater+2
	LDA MyWater10
	STA myWater+1
	LDA MyWater1
	STA myWater
	+End:
	

;;;;;;;;;;;;; UPDATE HUD
		LDA #$03 ;; amount of places
		STA hudElementTilesToLoad
		LDA DrawHudBytes
		ORA #HUD_myWater
		STA DrawHudBytes
	
	PlaySound #SFX_GET_COIN