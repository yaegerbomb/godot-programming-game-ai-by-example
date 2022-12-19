extends Panel

export (NodePath) var miners_node_path

onready var miner: Miner = get_node(miners_node_path);

onready var gold_label: Label = $VBoxContainer/GoldLabel
onready var banked_label: Label = $VBoxContainer/BankedLabel
onready var thirst_label: Label = $VBoxContainer/ThirstLabel
onready var fatigue_label: Label = $VBoxContainer/FatigueLabel

func _process(delta):
	gold_label.text = "Gold: %s" % [miner.get_gold()]
	banked_label.text = "Banked: %s" % [miner.get_banked()]
	thirst_label.text = "Thirst: %s" % [miner.get_thirst()]
	fatigue_label.text ="Fatigue: %s" % [miner.get_fatigue()]


