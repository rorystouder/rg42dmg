extends Node

signal mission_updated(mission)

var missions = []
var active_mission = null

class Mission:
	var type: String  # "delivery" or "exploration"
	var description: String
	var objective: String
	var reward: int
	var completed: bool = false
	
	func _init(_type, _desc, _obj, _rew):
		type = _type
		description = _desc
		objective = _obj
		reward = _rew

func _ready():
	# Example missions
	missions.append(Mission.new("delivery", "Deliver supplies to Orion 4", "Reach (20, 0, 20)", 100))
	missions.append(Mission.new("exploration", "Scout Beta Ceti", "Visit (15, 0, 15)", 50))
	active_mission = missions[0]  # Start with first mission
	emit_signal("mission_updated", active_mission)

func complete_mission():
	if active_mission:
		active_mission.completed = true
		print("Mission completed! Reward: ", active_mission.reward)
		active_mission = missions[missions.find(active_mission) + 1] if missions.find(active_mission) + 1 < missions.size() else null
		emit_signal("mission_updated", active_mission)
