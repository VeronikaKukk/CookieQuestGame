extends Control

func _ready():
	$UpgradeParticles.emitting = true
	$UpgradeParticles2.emitting = true
	$Panel/Label2.text = "Time taken: "+str(Inventory.time_end).pad_decimals(2)+" seconds"
