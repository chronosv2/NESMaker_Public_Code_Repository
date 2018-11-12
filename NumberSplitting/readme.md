# Number Splitting

I recommend unpacking these scripts to your own folder in the UserScripts folder.
**_Do not overwrite the default Adventure Hurt Monster Script._**

## Warning:
This splitter is probably very slow.
I'm a novice with ASM and don't really know how to speed up the code.
It works by taking any number the accumulator can hold (#$00 to #$FF), subtract 100 until the number is <100, subtract 10 until the number is <10, then store the ones digit. This means that this code could have to loop as many as 10 times for a number between 190 and 199.

## How To Use:
First, we need to define a few scripts. Project Menu -> Project Settings, Script Settings Tab  
**Name:** Number Splitting  
**Define:** SCR_NUM_SPLIT  
**Script:** [Wherever-you-unpack-the-ASM-files]\SplitNumber.asm

If you want to use the Number Splitter code for displaying enemy HP:  
Change the following script to this:  
**Name:** Handle Monster Hurt  
**Script:** [Wherever-you-unpack-the-ASM-files]\Adventure_HandleHurtMonster.asm

Now Monster HP will be displayed in a HUD Element if you name one **EnemyHealth**

If you wish to use this script for any other purpose, you'll want to add and edit the following to **one script**:
```assembly
IFDEF SCR_NUM_SPLIT 		;;If you've defined the SCR_NUM_SPLIT define...
  .include SCR_NUM_SPLIT		;;Load the SCR_NUM_SPLIT script
  STA temp1					;;Store Monster Health in temp1
  SplitNumber EnemyHealth, temp1		;;Split Monster Health into individual numbers and store in EnemyHealth HUD Element
;;Syntax: SplitNumber [split_result_var], [number_to_split]
;Below is the usual HUD Update Code
LDA #$03 ;; amount of score places?
STA hudElementTilesToLoad
LDA DrawHudBytes
ORA #HUD_EnemyHealth ;HUD Element you want to update here
STA DrawHudBytes
ENDIF ;;Done drawing Monster HP to HUD
```
