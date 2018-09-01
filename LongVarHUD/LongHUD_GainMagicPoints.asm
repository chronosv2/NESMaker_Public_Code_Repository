;;; Long HUD 'Increase MP' Example
;;; works with User variable myMP
;;; macro edits variables myMagic and myMagicHi.
;;; works with HUD variable HUD_myMagic and HUD_myMagicHi.

	LDA myMP ;This is a User Variable so we can track our MP.
	CLC
	ADC #$01
	CMP #$11 ;Compare to 17. If we have 16 MP and +1, 17 is too high.
	BCS skipGettingMagic ;Jump over the code messing with myMP so we don't overflow.

	TXA
	STA tempx

	INC myMP
	LDA myMP

	;Here's the Macro. LongBar [low-byte],[high-byte],[HUD_update_bit_1],[HUD_update_bit_2]
	LongBar myMagic,myMagicHi,HUD_myMagic,HUD_myMagicHi
	
	LDX tempx

skipGettingMagic:
	PlaySound #SFX_INCREASE_HEALTH