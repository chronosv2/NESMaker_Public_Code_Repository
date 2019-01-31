MACRO CheckMultiByteZero arg0, arg1
;; arg0 = Variable to check
;; arg1 = Number of digits to check

STX tempX							;;Store X from previous actions
LDX arg1							;;Load number of digits into X
DEX										;;Offsets are 0-based. Decrease X once to compensate.
--:										;;Loop Start
	LDA arg0,x 					;;Load Byte offset by X
	SEC									;;Set Carry
	SBC #$01						;;Subtract 1
	BPL +								;;If we don't underflow, at least 1 byte is > 0
		LDA #$01					;;Load 01 to send out of macro.
		JMP ++						;;Exit the loop.
	+:									;;If we underflow... (Destination)
		CPX #$00					;;Check if X is 0.
		BEQ +AllZeroes		;;If so, we're done.
	DEX									;;Decrement X
	JMP --							;;Restart Loop
+AllZeroes:						;;X is 0 and all checks have underflowed.
	LDA #$00						;;Load 0 into Accumulator
++:										;;End of all loops
LDX tempX							;;Restore X to pre-macro state
