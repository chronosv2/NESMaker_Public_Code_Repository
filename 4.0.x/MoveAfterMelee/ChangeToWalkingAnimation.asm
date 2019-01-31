
    LDX player1_object
    GetCurrentActionType player1_object
    CMP #$02 ;; attack
    BEQ +
	CMP #$01 ;; move
	BEQ +	;;If we're already moving, don't reset the state!
    ChangeObjectState #$01, #$10
 +
    RTS