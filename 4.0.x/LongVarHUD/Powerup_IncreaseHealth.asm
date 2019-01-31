;;; Increase Health code for player.
;;; works with variable myHealth
;;; works with HUD variable HUD_myHealth.
	TXA
	STA tempx
    LDX player1_object
	LDA Object_health,x
	CLC
	ADC #$01
	CMP #$11 ;16 HP max so check for 17
	BCS skipGettingHealth
	
	;;;you may want to test against a MAX HEALTH.
	;;; this could be a static number in which case you could just check against that number
	;;; or it could be a variable you set up which may change as you go through the game.
	STA Object_health,x
    IFDEF SCR_LONG_BARS	;If the script is defined
      .include SCR_LONG_BARS	;Load the script
	  LongBar myHealth,myHealthHi,HUD_myHealth,HUD_myHealthHi	;Run the code. Change these to the names of your Health HUD Variables.
	ENDIF
	
	LDX tempx
	
skipGettingHealth:
	PlaySound #SFX_INCREASE_HEALTH