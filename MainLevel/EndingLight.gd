extends PointLight2D

@export var treeSprite: AnimatedSprite2D
@export var worldLight: DirectionalLight2D
@export var winSound: AudioStreamPlayer
@export var dialogBox: Control
func _on_big_shroom_finish_game():
	var tween = create_tween()
	tween.tween_property(self, "energy", 400, 2).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(reverse.bind())
	
	

func reverse():
	var tween2 = create_tween()	
	treeSprite.set_frame(0)
	tween2.tween_property(self, "energy", 0, 3).set_trans(Tween.TRANS_SINE)
	tween2.finished.connect(banishLight.bind())

signal gameOver
func banishLight():
	var tween3 = create_tween()	
	winSound.play()
	tween3.tween_property(worldLight, "energy", 0, 2)
	dialog()
	gameOver.emit()
	#tween2.finished.connect(banishLight.bind())
	
func dialog():
	#dialogBox.dialog_complete.disconnect(dialog.bind())
	dialogBox.set_actor_name("Tree")
	dialogBox.queue_lines("Thank you for waking me my children! … And who is this little one?")
	dialogBox.dialog_complete.connect(dialog1.bind())
	
func dialog1():
	dialogBox.dialog_complete.disconnect(dialog1.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Why does everyone keep calling me little one, I’m already 12!")
	dialogBox.dialog_complete.connect(dialog2.bind())
	
func dialog2():
	dialogBox.dialog_complete.disconnect(dialog2.bind())
	dialogBox.set_actor_name("Tree")
	dialogBox.queue_lines("Oh my! I am sorry my good man. You truly are a soldier of the Light.")
	dialogBox.dialog_complete.connect(dialog3.bind())
	
func dialog3():
	dialogBox.dialog_complete.disconnect(dialog3.bind())
	dialogBox.set_actor_name("You")
	dialogBox.queue_lines("Now will somebody answer my questions?")
	dialogBox.dialog_complete.connect(dialog4.bind())
	
func dialog4():
	dialogBox.dialog_complete.disconnect(dialog4.bind())
	dialogBox.set_actor_name("Everyone")
	dialogBox.queue_lines("NO!")
	dialogBox.dialog_complete.connect(dialog5.bind())

func dialog5():
	dialogBox.dialog_complete.disconnect(dialog5.bind())
	dialogBox.set_actor_name("Justin Spere & Shlok Bhakta")
	dialogBox.queue_lines("Btw! We are the devs of this game, and this is our first ever game in our first ever jam! Hope yall liked it. It was a ton of fun to make! Have fun playing the rest of the Jam Games!! From the bottom of our hearts, Thanks for Playing!!! (feel free to explore the map now)")

