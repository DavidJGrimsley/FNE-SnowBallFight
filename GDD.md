# Snowball Fight

**Tagline:** A 12‑player FFA snowball showdown in UEFN.

## Overview
A snowball fight on an icy island with dynamic snow/ice phases. Players interact with grind rails and NPCs for bonuses, earn coins through eliminations, and race to end the round.

**Pregame lobby:** Yes (in the sky)
**Postgame lobby:** No
**Multiple rounds:** Yes

## Key Features
- Collect snowballs from snow piles.
- Use coins from eliminations to upgrade.
- Explore the island for hidden features.
- Reach the elimination target to end the round.

## Rules & Scoring
### Player Eliminations
- Eliminated players can respawn up to 3 times.
- Eliminator gains 2 gold and +1 elimination toward victory (5 per round).
- Elimination accolade awarded.
- Score: +3 for eliminations, +1 for assists.

### Guards
- Eliminator gains 1 gold.
- Guard accolade awarded.
- 2 guards spawn at once; 10 total per round (per guard spawner).

### Castle Boss
- Eliminator gains super powers (with VFX) for 60 seconds.
- Castle Boss accolade awarded.

### Wolves
- On defeat, eliminator loses 1 gold.
- Warning message: “Are you scared of the wolves?”
- Taming a wolf grants the Tame Wolf accolade.

## Round & Win Conditions
**Round end condition:** 10 player eliminations (3 while testing).

**HUD/Tracking:**
- Eliminations
- Spawns left (out of 3)
- Score

**Game win condition:** Most round wins (out of 3?)

## Gameplay Systems
### Storms
Rounds should not exceed 10 minutes. Target storm timeline:
- 0:00–2:30: No storm visible (first snow phase).
- 2:30–5:00: Storm begins to form.
- 5:00–7:30: Storm closes toward center.
- 7:30: Final storm size at island center.

### Snow Cycle
- Snowing: 1.5 minutes.
- Snowpile formation: 7 seconds.
- Snowpile melt: 5 seconds.
- No snow: 30 seconds.
- Repeat.

## TODO (Work Items)
### Design / Decisions
- [ ] Decide “Stat value to end” and whether it affects elimination end conditions.
- [ ] Define a last‑man‑standing win condition after 10 minutes.
- [ ] Prevent tiebreakers (design and code rules).

### Content / Features
- [ ] Create opening cutscene: snow + blizzard bomb + moving snowmen + Ice Queen on throne + wolves + guards + Slushy Soldier.
- [ ] Link accolades to NPC interaction (no `interactedWith` event; only `spawned`/`eliminated`).
- [ ] Replace single vending machine cycling with multiple machines (per location as needed).
- [ ] Add extra vending machines in remaining areas.

### Bugs / Issues
- [ ] Snow device does not stop VFX spawners (verify and fix).
- [ ] Ice effect persists after leaving ice (known engine issue; track workaround).
- [ ] Second and third vending machines can’t be bought from (investigate).
- [ ] Game can get stuck at ~1:30 left on storm timer (investigate).
- [ ] Game does not end when last player remains (investigate).

## Done (Completed)
- [x] Configure vending machines (initial setup).
- [x] Confirm vending machine cycling every 5 seconds is intended behavior; use multiple machines instead.
- [x] Adjust no‑snow time from 60s to 30s.
- [x] Add HUD message for “not snowing.”
- [x] Increase grind rail healing to 10 HP every 3 seconds (3s cooldown).
- [x] Add more vending machines: 4 in each of 4 buildings.
- [x] Remove gold from middle creatures; give small XP instead.
- [x] Place gold/silver/bronze coins along path from center to vending machines.
- [x] Increase snow from snow piles.
- [x] Creatures not spawning correctly (self‑resolved).
- [x] Ice missing (fixed).

## Playtest Notes (Session Logs Only)
> Use this section only for observations and raw notes. Convert items into TODOs above.

### 2/12/2024 — John
- Game stuck around 1:30 left on storm timer.
- No last‑man‑standing win after 10 minutes; eliminations were not happening.

### Kelsey & Mom (date TBD)
- Game stuck around 1:30 left on storm timer.
- No last‑man‑standing win after 10 minutes; eliminations were not happening.

### 2/21/2025 — Ian S.
- Game didn’t end when I was the last player alive.