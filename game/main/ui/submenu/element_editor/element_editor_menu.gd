extends Submenu
class_name ElementEditorMenu
# Submenu for simulation settings

var current: CustomElement

func _ready() -> void:
	super._ready()
	visible = false
	modulate.a = 0.0
	for node in get_tree().get_nodes_in_group("color_picker"):
		var color_picker_button: ColorPickerButton = node as ColorPickerButton
		var color_picker: ColorPicker = color_picker_button.get_picker()
		color_picker.sampler_visible = false
		color_picker.color_modes_visible = false
		color_picker.sliders_visible = false
		color_picker.hex_visible = false
		color_picker.presets_visible = false
	%Style.item_selected.connect(_on_style_selected)
	%State.item_selected.connect(_on_state_selected)

func _on_style_selected(idx: int) -> void:
	match idx:
		0:
			%FancyColorGrouping.visible = false
		1:
			%FancyColorGrouping.visible = true

func _on_state_selected(idx: int) -> void:
	%PowerGrouping.visible = false
	%ViscosityGrouping.visible = false
	match idx:
		2:
			%ViscosityGrouping.visible = true
		4:
			%PowerGrouping.visible = true

func edit_element(element: CustomElement) -> void:
	current = element
	initialize()

func initialize() -> void:
	%Name.text = current.display_name
	%Style.selected = current.style
	%ColorA.color = current.color_a
	%ColorB.color = current.color_b
	%ColorC.color = current.color_c
	%State.selected = current.state
	%Density.value = current.density
	%Viscosity.value = current.viscosity
	%Conductivity.value = current.conductivity
	%Flammability.value = current.flammability
	%Reactivity.value = current.reactivity
	%Durability.value = current.durability
	%Power.value = current.power
	%Explosive.button_pressed = current.explosive
	%Alive.button_pressed = current.alive
	%Toxic.button_pressed = current.toxic
	%Evaporable.button_pressed = current.evaporable
	
	_on_state_selected(%State.selected)
	_on_style_selected(%Style.selected)

func save_changes() -> void:
	current.display_name =  %Name.text
	current.style = %Style.selected
	current.color_a = %ColorA.color 
	current.color_b = %ColorB.color
	current.color_c = %ColorC.color
	if current.style == 0:
		current.color_b = current.color_a
		current.color_c = current.color_a
	
	current.state = %State.selected 
	current.density = %Density.value 
	current.viscosity = %Viscosity.value
	current.conductivity = %Conductivity.value
	current.flammability = %Flammability.value
	current.reactivity = %Reactivity.value
	current.durability = %Durability.value
	current.power = %Power.value
	current.explosive = %Explosive.button_pressed
	current.alive = %Alive.button_pressed
	current.toxic = %Toxic.button_pressed
	current.evaporable = %Evaporable.button_pressed
