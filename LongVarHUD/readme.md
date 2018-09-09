# Long VarTiles HUD (ADVANCED)
This is labeled as "Advanced" because there's a little setup involved.
First, you CAN have multiple Long HUD Elements, so long as you put those elements **next to each other.**
So if myHealth is Element 3, myHealthHi ***_has to be_*** Element 4.
Second, you have to make a single change to the HUD code. This means that **any future updates that edit the HUD code will require you to make the change again, and could even undo your edits.**
I do have plans to keep it updated, though, so if a problem arises I'll do my best to fix it.
Third, the number we're checking against **needs to be in the accumulator** when you call the Macro.
Finally, you'll need to write *a little* code to make this work.

# How To Use:
First, we need to define a few scripts. Project Menu -> Project Settings, Script Settings Tab
**Name:** Long Bar Macro
**Define:** SCR_LONG_BARS
**Script:** [Wherever-you-unpack-the-ASM-files]\DrawLongBars.asm

**Name:** Long HUD Support
**Define:** SCR_LONGHUD
**Script:** [Wherever-you-unpack-the-ASM-files]\HudUpdate_LongHudSupport.asm

We also need a User Variable (and you'll need more if you plan on doing more than player HP!)
**Variable Name:** LongHudVar
**Default Value:** 0

Now that that's done, we need to make our change to the HandleHudData.asm file in GameEngineData\Routines\System\
Go to line 471. Hit enter **at the start of the line so that 471 is blank and 472 is "LDA #$00"**.
Place this line at Line 471:
```assembly
IFDEF SCR_LONGHUD
.include SCR_LONGHUD  ;This DEFINE is used to implement long Var Tile support.
ENDIF
```

Now we can write our modifications to HurtPlayer, Health Power-Up and those scripts:
In **Only one of those** we need to add the Macro.
```assembly
	.include SCR_LONG_BARS
```
After doing that, where the HUD Update code would normally be, just use the Macro. In this case I'm updating our Hurt Player Code.
This code
```assembly
	STA Object_health,x
	STA myHealth

	STA hudElementTilesToLoad
		LDA #$00
		STA hudElementTilesMax
		LDA DrawHudBytes
		ora #HUD_myHealth
		STA DrawHudBytes
```
becomes this if you're using a Long Bar:
```assembly
	STA Object_health,x
	LongBar myHealth,myHealthHi,HUD_myHealth,HUD_myHealthHi
```

If you're wanting a long bar for any value that isn't stored somewhere already, you'll need another User Variable for it. In the case of a Magic gauge you'd need a variable to store your MP since one HUD item isn't going to do the job anymore.
So I made a "MP Power-Up" script that took the code for Health and changed it for our custom variable:
```assembly
;;; Long HUD 'Increase MP' Example
;;; works with variable myMP
;;; macro edits variables myMagic and myMagicHi.
;;; works with HUD variable HUD_myMagic and HUD_myMagicHi.

	LDA myMP ;This is a User Variable so we can track our MP.
	CLC
	ADC #$01

	;;;you may want to test against a MAX HEALTH.
	;;; this could be a static number in which case you could just check against that number
	;;; or it could be a variable you set up which may change as you go through the game.
	CMP #$11 ;Compare to 17. If we have 16 MP and +1, 17 is too high.
	BCS skipGettingMagic ;Jump over the code messing with myMP so we don't overflow.
	
	TXA
	STA tempx
	inc myMP
	LDA myMP

	;Here's the Macro. LongBar [low-byte],[high-byte],[HUD_update_bit_1],[HUD_update_bit_2]
	LongBar myMagic,myMagicHi,HUD_myMagic,HUD_myMagicHi
	
	LDX tempx
	
skipGettingMagic:
	PlaySound #SFX_INCREASE_HEALTH
```

## Quirks:
If you try to call the HUD updates too quickly you might catch a HUD update, which will visibly show the HUD redraw. It's a little jarring but still perfectly functional. I'm not sure how, if at all, this can be fixed.