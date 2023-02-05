extends Node2D
@onready var dirt1 = $CPUParticles2D
@onready var dirt2 = $CPUParticles2D2
@onready var dirt3 = $CPUParticles2D3

func emit_dirt():
	dirt1.set_emitting(true)
	dirt2.set_emitting(true)
	dirt3.set_emitting(true)
