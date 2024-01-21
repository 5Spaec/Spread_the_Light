extends Node2D

@export var plantNum: int = 1
var plantLitNum = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal plantsLit
signal levelWin
func _on_win_plant_plant_on():
	if(plantLitNum == plantNum):
		levelWin.emit()
		$RichTextLabel.visible = true
	plantLitNum += 1
	plantsLit.emit(plantLitNum)
	print("Emiited plantnum:",plantLitNum)
	pass




func _on_win_plant_plant_off():
	plantLitNum -= 1
	plantsLit.emit(plantLitNum)
	print("Emiited plantnum:",plantLitNum)
	pass

