;;; what should we do with the monster?
		;;; monster is loaded in x
		LDA Object_vulnerability,x
		AND #%00000100 ;; is it weapon immune?
		BEQ notWeaponImmune
		PlaySound #SFX_MISS
		JMP skipHurtingMonsterAndSound
	notWeaponImmune:
		
		LDA Object_status,x
		AND #HURT_STATUS_MASK
		BEQ dontskipHurtingMonster
		JMP skipHurtingMonster
	dontskipHurtingMonster:
		LDA Object_status,x
		ORA #%00000001
		STA Object_status,x
		LDA #HURT_TIMER
		STA Object_timer_0,x
		;;; assume idle is in step 0
		ChangeObjectState #$00,#$02
		;;;; unfortunately this recoil is backwards
		LDA Object_status,x
		AND #%00000100
		BNE skipRecoilBecauseOnEdge
		LDA Object_vulnerability,x
		AND #%00001000 
		BNE skipRecoilBecauseOnEdge ;; skip recoil because bit is flipped to ignore recoil
		
		LDA selfCenterX
		STA recoil_otherX
		LDA selfCenterY
		STA recoil_otherY
		LDA otherCenterX
		STA recoil_selfX
		LDA otherCenterY
		STA recoil_selfY
		JSR DetermineRecoilDirection
	skipRecoilBecauseOnEdge:
		LDA Object_health,x
		SEC
		SBC #$01
		CMP #$01
		BCS notMonsterDeath
			LDA #$00			;;Load 00 into Accumulator
			STA EnemyHealth+2	;;Set Monster HP Display to 0 - Hundreds
			STA EnemyHealth+1	;;Set Monster HP Display to 0 - Tens
			STA EnemyHealth		;;Set Monster HP Display to 0 - Ones
			;;The usual HUD updates
			LDA #$03 ;; amount of score places?
			STA hudElementTilesToLoad
			LDA DrawHudBytes
			ORA #HUD_EnemyHealth
			STA DrawHudBytes
			;;Back to the normal code
		DeactivateCurrentObject
		
		;;;;;;;;;;;;;;;;;; ok, so now we also add points to score
		;LDY Object_type,x
		;LDA ObjectWorth,y
		;STA temp
;		AddValue #$03, GLOBAL_Player1_Score, temp
				;arg0 = how many places this value has.
				;arg1 = home variable
				;arg2 = amount to add ... places?
		;; and this should trip the update hud flag?
		
		;;;; 
	
;		LDA #$05 ;; amount of score places?
;		STA hudElementTilesToLoad
;		LDA DrawHudBytes
;		ORA HUD_updateScore	
;		STA DrawHudBytes

		JSR HandleDrops
		
		
		JMP skipHurtingMonster
	notMonsterDeath
		STA Object_health,x
		IFDEF SCR_NUM_SPLIT 		;;If you've defined the SCR_NUM_SPLIT define...
		  .include SCR_NUM_SPLIT		;;Load the SCR_NUM_SPLIT script
		  STA temp1					;;Store Monster Health in temp1
		  SplitNumber EnemyHealth, temp1		;;Split Monster Health into individual numbers and store in EnemyHealth HUD Element
		;Below is the usual HUD Update Code
		LDA #$03 ;; amount of score places?
		STA hudElementTilesToLoad
		LDA DrawHudBytes
		ORA #HUD_EnemyHealth
		STA DrawHudBytes
		ENDIF ;;Done drawing Monster HP to HUD
	skipHurtingMonster:	
		PlaySound #SFX_MONSTER_HURT
	
	skipHurtingMonsterAndSound:
		LDX tempx
		;; what should we do with the projectile?
		DeactivateCurrentObject