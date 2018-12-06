;cpx player1_object
;BNE dontWintGame_idol
	LDA #$FF				;;Code to disable timer updates. We only update timer on #$00 so clear it here.
	STA CurrentLevel		;;CurrentLevel now equals 255.
	LDA #STATE_WIN_GAME
	STA change_state
	LDA #$01
	STA newScreen
	
dontWintGame_idol
	