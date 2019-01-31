;Addition to support "Long HUD" Items
	LDA LongHudVar
	STA hudElementTilesToLoad
	LDA #$00
	STA hudElementTilesMax
;End Addition

;;; So what does this stuff do?
;;; You can only update one HUD item at a time per frame.
;;; If you set both HUD bits to 1 and give this second variable, when the first HUD update completes
;;;     it'll update the second one with the value in LongHudVar on the next frame.
