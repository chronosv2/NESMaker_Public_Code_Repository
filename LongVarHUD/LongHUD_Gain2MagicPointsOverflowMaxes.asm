;;; Long HUD 'Increase MP' Example
;;; works with User variable myMP
;;; macro edits variables myMagic and myMagicHi.
;;; works with HUD variable HUD_myMagic and HUD_myMagicHi.

	LDA myMP ;This is a User Variable so we can track our MP.
	CLC
	ADC #$01

	;;;you may want to test against a MAX HEALTH.
	;;; this could be a static number in which case you could just check against that number
	;;; or it could be a variable you set up which may change as you go through the game.
	CMP #$11 ;Compare to 17. If we have 16 MP and +1, 17 is too high.
	BCS mpFull ;Jump over the code messing with myMP so we don't overflow.
	
	TXA
	STA tempx

	LDA myMP
	ADC #$02
	STA myMP
	;inc myMP
	;LDA myMP

MagicUpdateHud:
	;Here's the Macro. LongBar [low-byte],[high-byte],[HUD_update_bit_1],[HUD_update_bit_2]
	LongBar myMagic,myMagicHi,HUD_myMagic,HUD_myMagicHi
	
	LDX tempx
	JMP skipGettingMagic2

mpFull:
	LDA #$10
	STA myMP
	JMP MagicUpdateHud
	
skipGettingMagic2:
	PlaySound #SFX_INCREASE_HEALTH