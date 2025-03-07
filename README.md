# Ranger Group 42: Deadman’s Gulch

<!-- ![Game Logo](https://via.placeholder.com/150) <!-- Replace with your logo URL -->

**Welcome to Ranger Group 42: Deadman’s Gulch**, an open-source sci-fi adventure game built with Godot Engine 4.3. Set in a colonized galaxy, you play as a ranger navigating planets, trading resources, and upgrading your ship to survive and thrive in the treacherous Deadman’s Gulch region. Will you become a legendary trader or succumb to the void?

---

## Project Vision

Ranger Group 42 aims to blend exploration, trading, and survival in a procedurally generated galaxy. Starting with colonized planets like Earth and Epsilon Station, players will trade supplies (fuel, weapons, upgrades) at outposts, manage credits, and eventually explore uncharted worlds. The game is in early development, with a functional player controller and a basic trading UI as our foundation.

We’re seeking contributors to expand this vision—whether you’re a coder, artist, designer, or tester, your skills can shape this universe!

---

## Current Features

- **Player Movement**: Navigate planets with `WASD` controls, sprint, jump, and rotate (`Q/E`).
- **Trading UI**: A basic store system with `ItemList` for player and shop inventories, Buy/Sell buttons, and credits display (*work in progress*).
- **Inventory System**: Manage items like `supply_fuel.tres`, `weapon_laser.tres`, and `upgrade_engine.tres`.
- **Planet Scenes**: Earth scene (`earth.tscn`) with a trading outpost trigger.

### What Works
- Player can move and enter the trading outpost to open the UI.
- Inventories populate with items (Fuel, Laser Cannon, Engine Boost).

### What’s In Progress
- **Buy/Sell Functionality**: Transactions need to update credits and inventories correctly.
- **Exit Mechanism**: Escape key to close the UI and unpause the game.
- **Debugging**: Transitioning from print statements to a `DebugLogger` singleton.

---

## Getting Started

### Prerequisites
- **Godot Engine**: [Version 4.3](https://godotengine.org/download) (stable, mono build recommended).
- **Git**: For cloning and contributing ([install Git](https://git-scm.com/downloads)).

### Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/rorystouder/rg42dmg.git
   cd rg42dmg

## Project Structure

rg42dmg/
├── res://items/                # Item resources (.tres files)  
│   ├── supply_fuel.tres  
│   ├── weapon_laser.tres  
│   └── upgrade_engine.tres  
├── res://scenes/              # Game scenes  
│   ├── planet/                # Planet-specific scenes  
│   │   └── earth.tscn  
│   └── trading/               # Trading UI scenes  
│       └── TradingUI.tscn
├── res://scripts/             # GDScript files  
│   ├── debug/                 # Debugging utilities  
│   │   └── DebugLogger.gd  
│   ├── planet/                # Planet-related scripts  
│   │   └── player_controller.gd  
│   └── trading/               # Trading system scripts  
│       ├── TradingUI.gd  
│       ├── InventoryDisplay.gd  
│       ├── TransactionHandler.gd  
│       └── InputManager.gd  
└── project.godot              # Project configuration  

## How to Contribute

We’re building this game together! Here’s how you can help:

### Areas Needing Help
1. **Trading System**:
   - Fix Buy/Sell buttons to update credits and move items (`TransactionHandler.gd`).
   - Implement Escape key to exit the UI (`InputManager.gd`).
   - Enhance UI layout in `TradingUI.tscn`.

2. **Gameplay**:
   - Add ship mechanics (movement, fuel consumption).
   - Create more planets and outposts (extend `generate_planets.gd` if present).

3. **Art and Design**:
   - Design sprites for items (fuel, weapons, upgrades).
   - Create planet backgrounds and UI themes.

4. **Testing**:
   - Test `earth.tscn` for bugs, report issues with steps to reproduce.
   - Suggest UX improvements (e.g., tooltips, animations).

### Contribution Steps
1. **Fork the Repository**:
   - Click "Fork" on GitHub to create your own copy.
2. **Clone Your Fork**:
   ```bash
   git clone https://github.com/rorystouder/rg42dmg.git
3. **Create a Branch**:
   ```bash
   git checkout -b feature/your-feature-name

