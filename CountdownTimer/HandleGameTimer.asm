HandleGameTimer:
	DEC gameTimer
	BEQ UpdateTimer
	JMP dontUpdateGameTimer
	UpdateTimer:
	LDA gameTimerLo
	CLC
	ADC #$01
	STA gameTimerLo
	LDA gameTimerHi
	ADC #$00
	STA gameTimerHi
;;;;;;;;;;;;;;;;;;;;;;;;;;; 
	;; DO WHATEVER READS OF THE GAMETIMER YOU MIGHT WANT HERE.
	JSR DoAlarm
	;;This is where we add any code we want to run every game tick. No idea how to change this interval!
	IFDEF SCR_COUNTDOWN_TIMER	;;If the script is defined...
	  .include SCR_COUNTDOWN_TIMER ;;Load the script
	  JSR HandleCountdown		;;Run it as a subroutine.
	ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDA #DayNightSpeed
	STA gameTimer
dontUpdateGameTimer:
	RTS
	
DoAlarm:
	
	;;; we're going to edge-load monsters one at a time if they are of edge type and are not active.
	LDX #$00
doLoadMonsterOnTimerLoop:

	LDA edgeLoaderInCue
	BEQ noEdgeMonstersInCue
	LDA currentBank
	STA prevBank
	LDY #$1C ;; data bank
	JSR bankswitchY
	JSR CreateTimedEdgeSpawner
	DEC edgeLoaderInCue
	LDY prevBank
	JSR bankswitchY

noEdgeMonstersInCue
	RTS
