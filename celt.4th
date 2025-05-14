\ Copyright 2025 Midnight Salmon.

\ This program is free software: you can redistribute it and/or modify it
\ under the terms of the GNU General Public License version 3 (or any later
\ version) as published by the Free Software Foundation.

\ This program is distributed without any warranty; without even the implied
\ warranty of merchantability or fitness for a particular purpose. See the GNU
\ General Public License for more details. 

\ Contact: mail@midnightsalmon.boo

20 CONSTANT GRID-HEIGHT
20 CONSTANT GRID-WIDTH
95 CONSTANT MAX-STATES
MAX-STATES 9 * CONSTANT RULE-TABLE-LENGTH
GRID-HEIGHT GRID-WIDTH * CONSTANT GRID-LENGTH
VARIABLE GRID GRID-LENGTH 1 - ALLOT
VARIABLE 'NEIGHBOURHOOD
VARIABLE CURRENT-GENERATION
VARIABLE RULE-TABLE RULE-TABLE-LENGTH 1 - ALLOT
VARIABLE SEED UTIME DROP SEED !
VARIABLE ALIVE

: PRINT-LIFE-CELL ( state -- )
  32 + EMIT 32 EMIT ;

: PRINT-GRID ( -- )
  PAGE ." Generation " CURRENT-GENERATION ?
  CR GRID-WIDTH 0 DO 45 EMIT 45 EMIT LOOP
  GRID-LENGTH 0 DO I GRID-WIDTH MOD 0= IF CR THEN GRID I + @
  PRINT-LIFE-CELL LOOP CR ;

: COORDS-TO-INDEX ( x y -- index )
  GRID-WIDTH * + ;

: INDEX-TO-COORDS ( index -- x y )
  DUP GRID-WIDTH MOD SWAP GRID-WIDTH / ;

: SET-CELL ( state x y -- )
  COORDS-TO-INDEX GRID + C! ;

: RULE-INDEX ( state neighbourhood -- index )
  MAX-STATES * + ;

: CHECK-RULE ( index -- state neighbourhood )
  DUP MAX-STATES MOD SWAP MAX-STATES / ;

: RULE? ( -- )
  PAGE ." Current Rule" CR ." ------------" CR
  RULE-TABLE-LENGTH 0 DO RULE-TABLE I + C@ DUP 0= INVERT
  IF ." To " . I CHECK-RULE SWAP ." if state = " . ." neighbourhood = " . CR
  ELSE DROP THEN LOOP ." Otherwise to 0" CR CR
  ." States considered alive: "
  ALIVE C@ DUP 0= INVERT IF 0 DO ALIVE I + 1+ C@ . LOOP ELSE DROP THEN CR ;

: LEFT ( index distance -- index )
  SWAP INDEX-TO-COORDS -ROT SWAP - GRID-WIDTH MOD SWAP COORDS-TO-INDEX ;

: RIGHT ( index distance -- index )
  SWAP INDEX-TO-COORDS -ROT SWAP + GRID-WIDTH MOD SWAP COORDS-TO-INDEX ;

: UP ( index distance -- index )
  SWAP INDEX-TO-COORDS ROT - GRID-HEIGHT MOD COORDS-TO-INDEX ;

: DOWN ( index distance -- index )
  SWAP INDEX-TO-COORDS ROT + GRID-HEIGHT MOD COORDS-TO-INDEX ;

: IS-ALIVE ( state -- )
  ALIVE C@ 1+ ALIVE C! ALIVE 1 ALLOT ALIVE C@ + C! ;

: ALIVE? ( state -- )
  ALIVE C@ 0= IF DROP 0 ELSE
  0 SWAP ALIVE C@ 0 DO DUP ALIVE I + 1+ C@ = ROT OR SWAP LOOP DROP
  THEN ;

: MOORE ( index -- neighbourhood )
  DUP 1 LEFT 1 UP GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 UP GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 UP 1 RIGHT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 LEFT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 RIGHT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 LEFT 1 DOWN GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 DOWN GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  1 DOWN 1 RIGHT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  R> R> R> R> R> R> R> R> + + + + + + + ;

: VON-NEUMANN ( index -- neighbourhood )
  DUP 1 UP GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 LEFT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 RIGHT GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  DUP 1 DOWN GRID + C@ ALIVE? IF 1 ELSE 0 THEN >R
  R> R> R> R> + + + ;

: RESET-GRID ( -- )
  0 CURRENT-GENERATION !
  GRID GRID-LENGTH 0 FILL ;

: RESET-RULE ( -- )
  RULE-TABLE RULE-TABLE-LENGTH 0 FILL ;

: RESET-ALIVE ( -- )
  ALIVE ALIVE C@ NEGATE ALLOT 0 SWAP ! ;

: RESET ( -- )
  RESET-ALIVE RESET-GRID RESET-RULE ['] MOORE 'NEIGHBOURHOOD ! ;

: SET-NEIGHBOURHOOD ( -- )
  ' 'NEIGHBOURHOOD ! ;

: NEIGHBOURHOOD ( index -- neighbourhood )
  'NEIGHBOURHOOD @ EXECUTE ;

: SET-RULE ( new-state old-state neighbourhood -- )
  RULE-INDEX RULE-TABLE + C! ;

: APPLY-RULE ( index -- state )
  DUP GRID + C@ SWAP NEIGHBOURHOOD RULE-INDEX RULE-TABLE + C@ ;

: NEW-GENERATION ( -- )
  GRID-LENGTH 0 DO I APPLY-RULE LOOP
  0 GRID-LENGTH 1 - DO I GRID + C! -1 +LOOP
  CURRENT-GENERATION @ 1+ CURRENT-GENERATION ! ;

: GENERATIONS ( generations -- )
  0 DO NEW-GENERATION PRINT-GRID 500 MS KEY? IF LEAVE THEN LOOP ;

: RANDOM ( -- random-number )
  SEED @ DUP 13 LSHIFT XOR DUP 17 RSHIFT XOR DUP 5 LSHIFT XOR DUP SEED ! ;

: SOUP ( state -- )
  RESET-GRID GRID-LENGTH 0 DO RANDOM 2 MOD IF DUP ELSE 0 THEN GRID I + C! LOOP
  DROP ;
