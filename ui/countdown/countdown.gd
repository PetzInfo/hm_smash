extends CanvasLayer

func _ready():
		$counter.play("321go")
		await $counter.animation_finished
		$counter.hide()
		Game.resume_game()
