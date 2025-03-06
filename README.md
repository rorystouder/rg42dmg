Welcome to Ranger Group 42: Deadman’s Gulch, an open-source sci-fi adventure game built with Godot Engine 4.3. Set in a colonized galaxy, you play as a ranger navigating planets, trading resources, and upgrading your ship to survive and thrive in the treacherous Deadman’s Gulch region. Will you become a legendary trader or succumb to the void?
Project Vision
Ranger Group 42 aims to blend exploration, trading, and survival in a procedurally generated galaxy. Starting with colonized planets like Earth and Epsilon Station, players will trade supplies (fuel, weapons, upgrades) at outposts, manage credits, and eventually explore uncharted worlds. The game is in early development, with a functional player controller and a basic trading UI as our foundation.
We’re seeking contributors to expand this vision—whether you’re a coder, artist, designer, or tester, your skills can shape this universe!
Current Features
Player Movement: Navigate planets with WASD controls, sprint, jump, and rotate (Q/E).
Trading UI: A basic store system with ItemList for player and shop inventories, Buy/Sell buttons, and credits display (work in progress).
Inventory System: Manage items like supply_fuel.tres, weapon_laser.tres, and upgrade_engine.tres.
Planet Scenes: Earth scene (earth.tscn) with a trading outpost trigger.
What Works
Player can move and enter the trading outpost to open the UI.
Inventories populate with items (Fuel, Laser Cannon, Engine Boost).
What’s In Progress
Buy/Sell Functionality: Transactions need to update credits and inventories correctly.
Exit Mechanism: Escape key to close the UI and unpause the game.
Debugging: Transitioning from print statements to a DebugLogger singleton.
Getting Started
Prerequisites
Godot Engine: Version 4.3 (stable, mono build recommended).
Git: For cloning and contributing to the repository.
Installation
Clone the Repository:
bash
git clone https://github.com/rorystouder/rg42dmg.git
cd rg42dmg
Open in Godot:
Launch Godot 4.3.
Click "Import," navigate to the project folder, and open project.godot.
Run the Game:
Set res://scenes/planet/earth.tscn as the main scene (Project > Project Settings > Run).
Press F6 to play, move to the outpost at (-10, 2.5, -10) to open the trading UI.
Project Structure
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
How to Contribute
We’re building this game together! Here’s how you can help:
Areas Needing Help
Trading System:
Fix Buy/Sell buttons to update credits and move items (TransactionHandler.gd).
Implement Escape key to exit the UI (InputManager.gd).
Enhance UI layout in TradingUI.tscn.
Gameplay:
Add ship mechanics (movement, fuel consumption).
Create more planets and outposts (extend generate_planets.gd if present).
Art and Design:
Design sprites for items (fuel, weapons, upgrades).
Create planet backgrounds and UI themes.
Testing:
Test earth.tscn for bugs, report issues with steps to reproduce.
Suggest UX improvements (e.g., tooltips, animations).
Contribution Steps
Fork the Repository:
Click "Fork" on GitHub to create your own copy.
Clone Your Fork:
bash
git clone https://github.com/rorystouder/rg42dmg.git
Create a Branch:
bash
git checkout -b feature/your-feature-name
Make Changes:
Edit scripts, scenes, or assets in Godot.
Test locally with F6.
Commit and Push:
bash
git add .
git commit -m "Add feature: describe your change"
git push origin feature/your-feature-name
Submit a Pull Request:
Go to your fork on GitHub, click "Pull Request," describe your changes, and submit.
Development Guidelines
Code Style: Follow GDScript conventions (e.g., snake_case for variables, clear naming).
Debugging: Use DebugLogger (autoloaded at res://scripts/debug/DebugLogger.gd) instead of print().
Commits: Write clear, concise messages (e.g., "Fix Sell button connection in TransactionHandler.gd").
Known Issues
Buy/Sell Not Working: Buttons connect but don’t trigger transactions—needs debugging in TransactionHandler.gd.
Exit Not Functional: Escape key doesn’t close UI—check InputManager.gd and input map.
Scene Type Mismatch: Ensure ItemList nodes are used in TradingUI.tscn.
Report bugs or suggest fixes via GitHub Issues!
Roadmap
Short-Term: Complete basic store (buy, sell, exit).
Mid-Term: Add ship upgrades, multiple planets.
Long-Term: Procedural galaxy, missions, NPC traders.
Contact
Lead Developer: rorystouder
GitHub: https://github.com/rorystouder

License
This project is licensed under the MIT License—see LICENSE for details.
Let’s make Ranger Group 42: Deadman’s Gulch a reality together! Clone, explore, and contribute today!
