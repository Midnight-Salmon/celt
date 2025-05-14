# celt
Celt is a tool for simulating various kinds of cellular automata in toroidal space. It supports generational rules with up to 95 states, and both Moore and Von-Neumann neighbourhoods.

## Usage
Celt is written in Forth (and was tested in Gforth, specifically), so you will need a Forth system to run it. With the source file included:
1. RESET to initialise the system.
2. *n* IS-ALIVE to add *n* to the list of states considered alive for the purpose of neighbourhood calculation.
3. *n* *x* *y* SET-RULE to add to the rule table. Cells in state *x* with neighbourhood *y* will transition to state *n*.
4. *n* SOUP to generate a soup using state *n*.
5. *n* GENERATIONS to simulate and display *n* generations.
6. RULE? to check the current rule table.
7. RESET-GRID to set all cells to state 0.
8. RESET-ALIVE to clear the list of states considered alive.
9. RESET-RULE to clear the rule table. Cells in any state will transition to state 0 regardless of neighbourhood.
10. SET-NEIGHBOURHOOD VON-NEUMANN to switch to Von-Neumann neighbourhoods.
11. SET-NEIGHBOURHOOD MOORE to return to the default Moore neighbourhood calculation.
