extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var p1Hits = Game.p1_hits
	var p2Hits = Game.p2_hits
	
	match p1Hits:
		0:
			$powerP1.play("0")
		3:
			$powerP1.play("3")
		6:
			$powerP1.play("6")
		10:
			$powerP1.play("10")
			
	match p2Hits:
		0:
			$powerP2.play("0")
		3:
			$powerP2.play("3")
		6:
			$powerP2.play("6")
		10:
			$powerP2.play("10")
