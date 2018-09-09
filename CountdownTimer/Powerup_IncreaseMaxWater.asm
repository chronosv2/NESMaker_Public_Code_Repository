LDA MyWater1
ADC #$05
STA MyWater1
CMP #$0A
BCS +Inc10
JMP +End

+Inc10:
INC MyWater10
LDA #$00
STA MyWater1
LDA MyWater10
CMP #$0A
BCS +Inc100
JMP +End

+Inc100:
INC MyWater100
LDA #$00
STA MyWater10
	
+End:
	LDA MyWater100
	STA myWater+2
	LDA MyWater10
	STA myWater+1
	LDA MyWater1
	STA myWater
	
	LDA #$03 ;; amount of score places?
	STA hudElementTilesToLoad
	LDA DrawHudBytes
	ORA #HUD_myWater
	STA DrawHudBytes
	
	TriggerScreen screenType
	PlaySound #SFX_WATERSKIN_GET
