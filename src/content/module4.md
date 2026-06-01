# Module 4 — Water Supply Systems

> **Estimated study time:** 60 minutes | **3-D Scene:** `module4_supply`

---

## Learning Outcomes

Upon completing this module, you will be able to:

1. Trace the path of potable water from a municipal treatment plant to an individual fixture.
2. Define static pressure, residual pressure, and flow pressure and explain how each is measured.
3. Size a simple residential water-supply system using velocity and pressure-loss principles.
4. Describe the purpose and operation of pressure-reducing valves (PRVs), backflow preventers, and expansion tanks.
5. Explain the differences between storage-tank, tankless (on-demand), and heat-pump water heaters and describe the required safety devices for each.

---

## Lesson 4.1 — From the Main to the Meter

### Municipal Water System Overview

Drinking water follows a long path before it reaches a faucet:

```
Water Source (reservoir, river, groundwater)
        │
        ▼
Treatment Plant (filtration, disinfection, pH adjustment)
        │
        ▼
Transmission Main (large-diameter, high-pressure trunk lines)
        │
        ▼
Distribution Main (street-level pipes, typically 4"–16")
        │
        ▼
Service Lateral (1"–2" line from main to property line)
        │
        ▼
Water Meter (owned by utility; measures consumption)
        │
        ▼
Main Shut-off Valve (customer-side; owned by property owner)
        │
        ▼
Building Water Service / House Main
        │
        ▼
Fixtures, appliances, hose bibs
```

**Diagram placeholder:** `[FIGURE 4-1: Municipal water supply path — animated 3-D cross-section of a neighborhood water main and service lateral]`

### Water Meter and Main Shut-Off

The **meter stop (curb stop)** is located at the property line and is controlled by the utility. The **meter** measures water flow in cubic feet or gallons. Immediately downstream of the meter is the **main shutoff valve** — typically a ball valve in modern installations — which allows the occupant or plumber to shut off all water to the building.

**Important:** Always locate the main shutoff valve on every new job. Verify it operates freely. A main shutoff valve that cannot be closed is a liability during emergency repairs.

---

## Lesson 4.2 — Water Pressure

### Pressure Concepts

- **Static pressure:** The pressure in the supply system when no water is flowing. Measured with a gauge at a hose bib or test port.
- **Residual pressure:** The pressure measured at a specific point while water is flowing elsewhere in the system (simulates demand conditions).
- **Flow pressure:** The pressure measured at the flowing outlet itself.

**Normal residential supply pressure:** 40–80 psi (per IPC Section 604.8 and UPC Section 604.1)
- **Minimum acceptable:** 15–20 psi (minimum dynamic pressure at fixtures per most codes; low-flush fixtures require 25 psi)
- **Maximum allowed:** 80 psi — above this, a **Pressure Reducing Valve (PRV)** is required

### Pressure Reducing Valve (PRV)

A PRV (also called a pressure regulator) is a self-contained valve that automatically reduces high supply pressure to a preset level (typically 50–60 psi). It contains a spring-loaded diaphragm and an adjustable set screw.

**When is a PRV required?**  
IPC 604.8: Required when the static pressure exceeds 80 psi.

**Diagram placeholder:** `[FIGURE 4-2: PRV cross-section — 3-D cutaway showing diaphragm, spring, and flow path]`

**PRV installation notes:**
- Install on the cold water supply line immediately downstream of the meter and main shutoff.
- Install a union on each side for serviceability.
- Downstream of a PRV, install a **thermal expansion tank** (see Lesson 4.5).
- PRVs should be tested annually; replace every 8–12 years.

---

## Lesson 4.3 — Pipe Sizing Fundamentals

### Why Sizing Matters
Undersized supply pipes cause:
- Low pressure at fixtures during simultaneous use
- Velocity erosion in copper above 8 ft/s (cold water) or 5 ft/s (hot water)
- Noise (water hammer, vibration)

Oversized pipes waste material cost and can lead to water stagnation (Legionella risk).

### Velocity-Based Sizing

Maximum recommended water velocity:
- **Cold water:** 8 ft/s (2.4 m/s)
- **Hot water:** 5 ft/s (1.5 m/s)

Flow rate is calculated from fixture demand using **Water Supply Fixture Units (WSFU)** — a unit developed by Roy Hunter that accounts for frequency of use, probability of simultaneous demand, and flow rate.

**Common fixture WSFU values (IPC Table E103.3(3)):**

| Fixture | Cold WSFU | Hot WSFU | Total WSFU |
|---|---|---|---|
| Lavatory (private) | 0.5 | 0.5 | 1.0 |
| Kitchen sink (residential) | 1.0 | 1.0 | 1.5 |
| Bathtub | 1.0 | 1.0 | 1.4 |
| Shower | 1.0 | 1.0 | 1.4 |
| Clothes washer | 2.0 | 2.0 | 2.0 |
| Dishwasher | — | 1.4 | 1.4 |
| Water closet (flush tank) | 2.5 | — | 2.5 |
| Hose bib | 2.5 | — | 2.5 |

**Simplified pipe sizing procedure:**
1. Count the WSFU for all fixtures served by each pipe segment.
2. Enter a sizing chart (IPC Appendix E or UPC sizing tables) with total WSFU and available pressure.
3. Read the required pipe size.
4. Verify velocity does not exceed maximum (especially at reducing points).

**Diagram placeholder:** `[FIGURE 4-3: Residential water supply isometric drawing with WSFU annotations]`

---

## Lesson 4.4 — Backflow Prevention

### Cross-Connection Hazard

A **cross-connection** is any physical link between the potable water supply and a non-potable source. If a backflow event occurs (caused by back-pressure or back-siphonage), contaminants can be drawn into the drinking water supply.

**Examples of cross-connections:**
- Garden hose submerged in a pesticide bucket
- Boiler fill line without backflow protection
- Fire suppression system connected to potable supply without an RPZ
- Dental vacuum systems, lab sinks, irrigation systems

### Types of Backflow

| Type | Cause | Scenario |
|---|---|---|
| **Back-siphonage** | Negative pressure upstream | Main break, fire hydrant opened nearby |
| **Back-pressure** | Downstream pressure exceeds supply pressure | Boiler, pumped recirculation system |

### Backflow Preventer Devices (Least to Most Protection)

| Device | Application | Testable? |
|---|---|---|
| Air gap | Highest protection; physical separation | N/A |
| Atmospheric vacuum breaker (AVB) | Hose bibs, faucets | No |
| Pressure vacuum breaker (PVB) | Irrigation, lab | No |
| Double check valve assembly (DCVA) | Irrigation, low-hazard industrial | Yes |
| Reduced-pressure zone (RPZ) | High-hazard — boilers, chemical injection, fire suppression | Yes |

**Diagram placeholder:** `[FIGURE 4-4: RPZ backflow preventer — 3-D cross-section showing two check valves and relief port]`

> Most jurisdictions require backflow preventers on all irrigation systems, require annual testing of RPZs and DCVAs by a certified tester, and require permits for installation.

---

## Lesson 4.5 — Thermal Expansion

When water is heated in a closed system (one with a PRV, check valve, or backflow preventer), it expands. With nowhere to go, the pressure rises — potentially to levels that damage the water heater, valves, and piping.

**Thermal expansion tank:** A small pre-pressurized tank (bladder or diaphragm type) installed on the cold supply line near the water heater. The tank's air charge absorbs the expanding water volume, keeping system pressure within safe limits.

**Sizing:** The tank must be sized to the water heater volume, system pressure, and supply pressure — use manufacturer charts.

**IPC 607.3.2 / UPC 608.3:** Thermal expansion tanks are required whenever a pressure-reducing valve, check valve, or backflow preventer creates a closed system on the supply side of the water heater.

---

## Lesson 4.6 — Hot Water Systems

### Storage-Tank Water Heaters

The conventional storage-tank water heater (gas or electric) maintains a reservoir of hot water at a set temperature (code minimum 120 °F to prevent Legionella; code maximum at mixed point 120 °F to prevent scalding at fixtures per ASSE 1016/1070).

**Key components:**
- **Dip tube:** Brings cold supply to the bottom of the tank
- **Anode rod (sacrificial anode):** A magnesium or aluminum rod that corrodes preferentially to protect the tank lining; must be inspected and replaced periodically
- **Temperature & Pressure Relief Valve (T&P valve):** Opens if temperature exceeds 210 °F or pressure exceeds 150 psi; **must** be piped to a safe discharge location (not over a gas appliance, not into an occupied space, within 6" of the floor)
- **Flue/vent:** Gas water heaters require proper combustion air and a code-approved vent

**Diagram placeholder:** `[FIGURE 4-5: Gas storage water heater — labeled 3-D cutaway showing dip tube, anode rod, burner, flue, T&P valve]`

### Tankless (On-Demand) Water Heaters

Tankless heaters activate only when hot water is demanded — there is no standby heat loss. They heat water as it flows through a heat exchanger.

**Sizing key:** Tankless heaters are rated in **gallons per minute (GPM)** at a given **temperature rise (ΔT)**. A heater rated 5 GPM at 70 °F rise can deliver 5 GPM of 70 °F-warmer water.

**Example:** Incoming water = 50 °F; desired 120 °F output → ΔT = 70 °F.

**Advantages:**
- No standby losses (energy savings of 24–34 % in homes that use < 41 gallons/day)
- Longer equipment life (20+ years vs. 10–12 for tank)
- Space savings

**Limitations:**
- Higher upfront cost
- Requires high gas or electric capacity
- Flow-activation minimum (typically 0.5 GPM) — slow flow may not activate heater
- "Cold water sandwich" effect in systems without recirculation

### Heat-Pump Water Heaters

Heat-pump water heaters (HPWHs) use refrigerant-cycle technology to move heat from surrounding air into the water. They are 2–3× more energy-efficient than electric resistance heaters.

- **Installation requirement:** Need 700–1,000 cubic feet of surrounding air space; exhaust cooler air (works well in warm climates, may increase heating load in cold climates)
- **T&P valve still required**, same as tank heater

### Hot Water Recirculation

In large homes and commercial buildings, hot water recirculation loops maintain hot water close to every fixture, reducing wait time and water waste.

**Types:**
- **Dedicated return line:** A small return pipe runs from the far end of the hot water system back to the water heater; a pump circulates continuously or on a timer/thermostat.
- **Comfort system (Metlund/Watts):** Uses the cold supply as a return; a thermostatic bypass valve under the far fixture bypasses flow to the cold line until hot water arrives.

---

## Module 4 Summary

- Potable water travels from treatment plant → transmission main → distribution main → service lateral → meter → building
- Normal supply pressure is 40–80 psi; a PRV is required above 80 psi
- Pipe sizing uses WSFU and velocity limits (≤ 8 ft/s cold, ≤ 5 ft/s hot)
- Cross-connections require backflow prevention devices scaled to the hazard level
- Thermal expansion tanks are required in closed hot-water systems
- Water heater types: storage tank, tankless, heat pump — all require T&P valves

---

## Module 4 Quiz

> Answer all five questions. A score of **4/5 (80 %)** is recommended before advancing.

**Question 1.**
At what static supply pressure does the IPC require the installation of a pressure-reducing valve?

- A) Greater than 60 psi
- B) Greater than 80 psi ✅
- C) Greater than 100 psi
- D) Greater than 120 psi

---

**Question 2.**
What is the maximum recommended water velocity for a hot water supply pipe?

- A) 3 ft/s
- B) 5 ft/s ✅
- C) 8 ft/s
- D) 12 ft/s

---

**Question 3.**
Which backflow preventer type provides the highest level of protection and is required for high-hazard cross-connections?

- A) Atmospheric vacuum breaker (AVB)
- B) Double check valve assembly (DCVA)
- C) Reduced-pressure zone (RPZ) ✅
- D) Pressure vacuum breaker (PVB)

---

**Question 4.**
What is the purpose of the sacrificial anode rod inside a storage-tank water heater?

- A) To regulate water temperature
- B) To prevent the buildup of mineral scale on the heating element
- C) To corrode preferentially and protect the tank lining from corrosion ✅
- D) To prevent back-siphonage

---

**Question 5.**
A thermal expansion tank is required on the cold supply line feeding a water heater when:

- A) The water heater is gas-fired
- B) The water heater is taller than 60 inches
- C) A PRV, check valve, or backflow preventer creates a closed system on the supply side ✅
- D) The supply pressure is below 40 psi

---

*Proceed to [Midterm Exam](./midterm.md) before continuing to Module 5.*
