extends TabContainer
class_name ElementSelector
# Handles element selection in the UI

const ELEMENT_BUTTON: PackedScene = preload("res://main/ui/element_selector/CustomElementButton.tscn")
const PLACEHOLDER_LABEL: PackedScene = preload("res://main/ui/element_selector/PlaceholderLabel.tscn")

@export var simulation: Main
@export var eraser_button: Button
@export var tap_button: Button

var tap_on: bool = false
@export var last_button: Button
@export var selected_material: ShaderMaterial

@onready var edit_button: Button = get_tree().get_root().get_node("Main").get_node("%Edit")

var gem_idx: int = 0
var algae_idx: int = 0

func _ready() -> void:
	initialize_buttons()
	for button in $basic/Basic.get_children():
		if not button is ElementButton:
			continue
		# This is a remnant of a past decision to round the corners of some buttons
		# It would be a lot of work to reset it on ALL of the button styles, so 
		# for now it is OK to set it in the script
		for style in ["normal", "pressed", "hover", "disabled"]:
			if not button.get("theme_override_styles/" + style) == null:
				button.get("theme_override_styles/" + style).corner_radius_top_left = 0
				button.get("theme_override_styles/" + style).corner_radius_bottom_left = 0
				button.get("theme_override_styles/" + style).corner_radius_top_right = 0
				button.get("theme_override_styles/" + style).corner_radius_bottom_right = 0
	
	await get_tree().get_root().ready
	print($basic/Basic.get_child_count())
	update_custom_elements()

func _on_new_element_created() -> void:
	CommonReference.element_manager.create_new_element()
	update_custom_elements()

func initialize_buttons() -> void:
	var id: int = -1
	if is_instance_valid(last_button) and last_button is ElementButton:
		id = last_button.id
	if not eraser_button.button_down.is_connected(_on_eraser_selected):
		eraser_button.button_down.connect(_on_eraser_selected)
	if not tap_button.button_down.is_connected(_on_tap_selected):
		tap_button.button_down.connect(_on_tap_selected)
	if not %CreateNewButton.button_down.is_connected(_on_new_element_created):
		%CreateNewButton.button_down.connect(_on_new_element_created)
	
	var last_updated: bool = false
	for button in $basic/Basic.get_children() + %Custom.get_children():
		if not button is ElementButton:
			continue
		if not button.button_down.is_connected(_on_element_selected):
			button.button_down.connect(_on_element_selected.bind(button))
		if button.id == id:
			last_updated = true
			last_button = button
			bolden_button(button)
	if not last_updated:
		edit_button.visible = false
		CommonReference.painter.selected_element = 0

func update_custom_elements() -> void:
	for child in %Custom.get_children():
		if child.name != "CreateNewButton":
			%Custom.remove_child(child)
			child.queue_free()
	for element_id in Settings.custom_element_ordering:
		var custom_element: CustomElement = CommonReference.element_manager.custom_element_map[element_id]
		var new_button: CustomElementButton = ELEMENT_BUTTON.instantiate()
		new_button.initialize(custom_element)
		%Custom.add_child(new_button)
	# Fill up the space
	%Custom.move_child(%Custom.get_node("CreateNewButton"), -1)
	for i in range(24 - %Custom.get_child_count()):
		var label: Label = PLACEHOLDER_LABEL.instantiate()
		%Custom.add_child(label)
	initialize_buttons()

func _on_element_selected(button: ElementButton) -> void:
	get_tree().get_root().get_node("Main").get_node("%SelectInfo").show_element(button.text, button.description, button.get("theme_override_styles/normal").bg_color)
	edit_button.visible = button.id >= 2048
	
	tap_button.button_pressed = false
	CommonReference.painter.selected_element = button.id + (4097 if tap_on else 0)
	
	if is_instance_valid(last_button):
		unbolden_button(last_button)
	bolden_button(button)
	last_button = button
	
	# Algae can be different colors!
	if CommonReference.painter.selected_element == 7:
		CommonReference.painter.selected_element = [7, 54, 55][algae_idx]
		algae_idx = (algae_idx + 1) % 3
	
	# Algae can be different colors!
	if CommonReference.painter.selected_element == 27:
		CommonReference.painter.selected_element = [27, 78, 79, 80][gem_idx]
		gem_idx = (gem_idx + 1) % 4

func _on_eraser_selected() -> void:
	edit_button.visible = false
	
	if last_button == eraser_button:
		return
	
	bolden_button(eraser_button)
	if is_instance_valid(last_button):
		unbolden_button(last_button)
	unbolden_button(tap_button)
	tap_on = false
	last_button = eraser_button
	CommonReference.painter.selected_element = 0

func _on_tap_selected() -> void:
	if CommonReference.painter.selected_element == 0:
		return
	
	tap_on = !tap_on
	
	if tap_on:
		bolden_button(tap_button)
	else:
		unbolden_button(tap_button)
	
	CommonReference.painter.selected_element += 4097 if tap_on else -4097

func bolden_button(button: Button) -> void:
	if is_instance_valid(button):
		button.material = selected_material

func unbolden_button(button: Button) -> void:
	if is_instance_valid(button):
		button.material = null
