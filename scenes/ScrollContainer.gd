extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var invisible_scrollbar_theme = Theme.new()
	var empty_stylebox = StyleBoxEmpty.new()
	invisible_scrollbar_theme.set_stylebox("scroll", "VScrollBar", empty_stylebox)
	invisible_scrollbar_theme.set_stylebox("scroll", "HScrollBar", empty_stylebox)
	get_v_scroll_bar().theme = invisible_scrollbar_theme
	get_h_scroll_bar().theme = invisible_scrollbar_theme

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
