CPX player1_object
	BNE +finishedWithRefillWater
	;; This below code has inspired a feature request for multi-bite User Variables.
	;; This code is messy but the only way for it to work right now!
	
	LDA myWater+2	;;Load our water value hudrends digit
	CMP MyWater100	;;Check versus max hundreds digit
	BCS +CheckTens	;;If >= check tens.
	JMP +RefillWater ;;If < then refill water.

	+CheckTens:
	LDA myWater+1	;;Load our water value tens digit
	CMP MyWater10	;;Check versus max tens digit
	BCS +CheckOnes	;;If >= check ones.
	JMP +RefillWater ;;If < then refill water.

	+CheckOnes:
	LDA myWater		;;Load our water ones digit
	CMP MyWater1	;;Check versus max ones digit
	BCS +finishedWithRefillWater ;;If >= then we're at or above max water.

+RefillWater	
	LDA MyWater100	;;Load Max Hundreds
	STA myWater+2	;;Save Timer Hundreds
	LDA MyWater10	;;Load Max Tens
	STA myWater+1	;;Save Timer Tens
	LDA MyWater1	;;Load max Ones
	STA myWater		;;Save Timer Ones
	
	;; The usual HUD update code.
	LDA #$03 ;; amount of score places?
	STA hudElementTilesToLoad
	LDA DrawHudBytes
	ORA #HUD_myWater
	STA DrawHudBytes
	PlaySound #SFX_GET_COIN

;;Why not play a sound to indicate you filled your water?	
+finishedWithRefillWater:
