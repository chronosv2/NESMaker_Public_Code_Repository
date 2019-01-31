HandleCountdown:
;Check to make sure we're not displaying a text box.
LDA gameHandler
AND #%00100000	;We're drawing a text box, let's not mess with the timer.
BEQ +
JMP SkipWaterCheck
+
LDA CurrentLevel	;If the current map level is 0
BEQ RightMap		;Let's work with the timer.
JMP SkipWaterCheck	;Nope. No timer on underworld maps.

RightMap:
;; I think this code is broken and actually doesn't do anything.
;; I think I've got my bits reversed and am checking if Flag 07
;; is not set, which is the case for all my maps. I'm leaving
;; this here because I plan to debug and get it working.
LDA ScreenByte01	;;I've got this backward I think?
;STA #$07FE		;;Debug code.
AND #%10000000  ;; check if a Water screen flag
CMP #%10000000
BEQ WaterRightScreen
JMP SkipWaterCheck

WaterRightScreen:
;; This code checks to see if the timer (myWater in this case) is above 000.
LDX #$02	;;Checking Hundreds (myWater+2)
LDA myWater,x  ;;Load Hundreds Digit
BNE SubtractWater  ;;If not 0, we have more than 000 water.
DEX			;;Checking Tens (myWater+1) -- Decrease x so x is 1
LDA myWater,x  ;;Load Tens Digit
BNE SubtractWater  ;;If not 0, we have more than 000 water.
DEX			;;Checking Tens (myWater+0 (or just myWater)) -- Decrease x so x is 0
LDA myWater,x  ;;Load Ones Digit
;CMP #$01	;Uncomment this to make the timer time-up if it tries to tick at 001. (i.e. if the timer ticking to 0 kills the player)
BNE SubtractWater  ;;If not 0, we have more than 000 water.
JMP WaterHurtPlayer:

SubtractWater:
;;Subtract from the timer
	SubtractValue #$03, myWater, #$01, #$00	;;Subtract 1 from the Ones digit
	;;Usual HUD Update code
	LDA #$03 ;; amount of score places?
	STA hudElementTilesToLoad
	LDA DrawHudBytes
	ORA #HUD_myWater
	STA DrawHudBytes
	JMP SkipWaterCheck	;;We don't need to hurt the player so jump to the end.
	
;;No water. We get to hurt the player!

;;This block of code is used when the timer tries to tick when it's at zero!
;;If you want to outright kill the player when timer hits 0 (you uncommented the CMP above)
;;you might want to set myWater to 0 so the timer shows 0 while the death animation is playing.
	WaterHurtPlayer:
	LDX player1_object		;Load the Player Object ID
	LDA Object_status,x		;;We're going to set the player to flicker
	ORA #%00000001
	STA Object_status,x
	LDA #HURT_TIMER
	STA Object_timer_0,x	;;Set the hurt time to HURT_TIMER
	;; The below commented line would force the player to stop if they got hurt!
	;; We don't want this so I commented it out.
	;ChangeObjectState #$00,#$02 ;; uses idle for hurt state.
	LDA Object_health,x		;;Load Player Health
	SEC
	SBC #$01 ;; subtract 1
	CMP #$01 ;; Usual Death checks
	BCS -
	IFDEF SCR_HANDLE_PLAYER_DEATH
		.include SCR_HANDLE_PLAYER_DEATH
	ENDIF
	JMP ++
-

	STA Object_health,x
	;IFDEF SCR_LONG_BARS
    ;  .include SCR_LONG_BARS
	;ENDIF
	LongBar myHealth,myHealthHi,HUD_myHealth,HUD_myHealthHi
	
	PlaySound #sfx_ouch
;;End of "Timer Trigger" block here!
++
SkipWaterCheck:
RTS	;;Return from Subroutine
