extends Resource
class_name ThemeConstructor

# Look elsewhere if you don't like magic numbers. 
# This file creates a full theme with all of its custom styles, styleboxes and atlastextures.
# Values are referenced from files in "res://resources/theme/" folder.
# This setup is a solution to not being able to modify remapped theme files in an exported project.

const DATA_PATH := "user://"
const FILE_FORMAT := ".tres"

func create_theme(texture: Texture) -> Theme:
	var current_theme: Theme = Theme.new()
	
	setup_theme_styleboxes(current_theme, create_styleboxes(texture))
	setup_theme_atlases(current_theme, create_atlastextures(texture))
	
	return current_theme

func setup_theme_styleboxes(current_theme: Theme, styleboxes: Array) -> void:
	var theme_builtin_types: Array = [
		"Button",
		"HSlider",
		"VSlider",
		"OptionButton",
		"Panel",
		"PopupMenu",
		"ScrollContainer",
		"ColorPicker",
		"CheckBox",
		"ColorPickerButton",
		"TextEdit",
		"VScrollBar",
		"HScrollBar"]
	
	for style: StyleBoxTexture in styleboxes[0]: # 0 is buttons
		current_theme.add_type(style.resource_name)
		if not style.resource_name in theme_builtin_types:
			current_theme.set_type_variation(style.resource_name, "Button")
		current_theme.set_stylebox("hover", style.resource_name, style)
		current_theme.set_stylebox("normal", style.resource_name, style)
		current_theme.set_stylebox("pressed", style.resource_name, style)
	
	for style: StyleBoxTexture in styleboxes[1]: # 1 is panels
		current_theme.add_type(style.resource_name)
		if not style.resource_name in theme_builtin_types:
			current_theme.set_type_variation(style.resource_name, "Panel")
		current_theme.set_stylebox("panel", style.resource_name, style)
	
	for key in styleboxes[2].keys(): # 2 is edge cases
		var style: StyleBoxTexture = styleboxes[2][key]
		
		current_theme.add_type(style.resource_name)
		
		match style.resource_name:
			"HSlider":
				current_theme.set_stylebox("grabber_area", style.resource_name, style)
				current_theme.set_stylebox("grabber_area_highlight", style.resource_name, style)
				current_theme.set_stylebox("slider", style.resource_name, style)
			"VSlider":
				current_theme.set_stylebox("grabber_area", style.resource_name, style)
				current_theme.set_stylebox("grabber_area_highlight", style.resource_name, style)
				current_theme.set_stylebox("slider", style.resource_name, style)
			"VScrollBar":
				var empty := StyleBoxEmpty.new()
				current_theme.set_stylebox("grabber", style.resource_name, empty)
				current_theme.set_stylebox("grabber_highlight", style.resource_name, empty)
				current_theme.set_stylebox("grabber_pressed", style.resource_name, empty)
				current_theme.set_stylebox("scroll", style.resource_name, empty)
				current_theme.set_stylebox("scroll_focus", style.resource_name, empty)
			"HScrollBar":
				var empty := StyleBoxEmpty.new()
				current_theme.set_stylebox("grabber", style.resource_name, empty)
				current_theme.set_stylebox("grabber_highlight", style.resource_name, empty)
				current_theme.set_stylebox("grabber_pressed", style.resource_name, empty)
				current_theme.set_stylebox("scroll", style.resource_name, empty)
				current_theme.set_stylebox("scroll_focus", style.resource_name, empty)
			"OptionButton":
				var flat := StyleBoxFlat.new()
				flat.bg_color = Color(0.102, 0.102, 0.102, 0)
				flat.corner_radius_bottom_left = 3
				flat.corner_radius_bottom_right = 3
				flat.corner_radius_top_left = 3
				flat.corner_radius_top_right = 3
				flat.content_margin_left = 4
				flat.content_margin_right = 4
				flat.content_margin_bottom = 4
				flat.content_margin_top = 4
				current_theme.set_stylebox("disabled", style.resource_name, flat)
				current_theme.set_stylebox("disabled_mirrored", style.resource_name, flat)
				current_theme.set_stylebox("focus", style.resource_name, flat)
				current_theme.set_stylebox("hover", style.resource_name, style)
				current_theme.set_stylebox("hover_mirored", style.resource_name, flat)
				current_theme.set_stylebox("normal", style.resource_name, style)
				current_theme.set_stylebox("normal_mirrored", style.resource_name, flat)
				current_theme.set_stylebox("pressed", style.resource_name, style)
				current_theme.set_stylebox("pressed_mirrored", style.resource_name, flat)
			"PopupMenu":
				var empty := StyleBoxEmpty.new()
				current_theme.set_stylebox("panel", style.resource_name, empty)
			"PopupPanel":
				var empty := StyleBoxEmpty.new()
				current_theme.set_stylebox("panel", style.resource_name, empty)
				#current_theme.set_stylebox("panel", style.resource_name, style)
			"CheckBox":
				var empty := StyleBoxEmpty.new()
				current_theme.set_stylebox("disabled", style.resource_name, empty)
				current_theme.set_stylebox("focus", style.resource_name, empty)
				current_theme.set_stylebox("hover", style.resource_name, empty)
				current_theme.set_stylebox("hover_pressed", style.resource_name, empty)
				current_theme.set_stylebox("normal", style.resource_name, empty)
				current_theme.set_stylebox("pressed", style.resource_name, empty)
			"TextEdit":
				current_theme.set_stylebox("focus", style.resource_name, style)
				current_theme.set_stylebox("normal", style.resource_name, style)
				current_theme.set_stylebox("read_only", style.resource_name, style)
			"LineEdit":
				current_theme.set_stylebox("focus", style.resource_name, style)
				current_theme.set_stylebox("normal", style.resource_name, style)
				current_theme.set_stylebox("read_only", style.resource_name, style)
			"ScrollContainer":
				current_theme.set_stylebox("panel", style.resource_name, style)
			"ColorPicker":
				pass
			"ColorPickerButton":
				var flat := StyleBoxFlat.new()
				flat.bg_color = Color(0.102, 0.102, 0.102, 0.302)
				flat.corner_radius_bottom_left = 3
				flat.corner_radius_bottom_right = 3
				flat.corner_radius_top_left = 3
				flat.corner_radius_top_right = 3
				flat.content_margin_left = 4
				flat.content_margin_right = 4
				flat.content_margin_bottom = 4
				flat.content_margin_top = 4
				current_theme.set_stylebox("hover", style.resource_name, flat)
				current_theme.set_stylebox("normal", style.resource_name, flat)
				current_theme.set_stylebox("pressed", style.resource_name, flat)
				current_theme.set_stylebox("disabled", style.resource_name, flat)
				current_theme.set_stylebox("focus", style.resource_name, flat)

func setup_theme_atlases(current_theme: Theme, atlases: Array) -> void:
	for atlas: AtlasTexture in atlases:
		match atlas.resource_name:
			"hslider_grabber":
				current_theme.set_icon("grabber", "HSlider", atlas)
				current_theme.set_icon("grabber_disabled", "HSlider", atlas)
				current_theme.set_icon("grabber_highlight", "HSlider", atlas)
			"hslider_tick":
				current_theme.set_icon("tick", "HSlider", atlas)
			"vslider_grabber":
				current_theme.set_icon("grabber", "VSlider", atlas)
				current_theme.set_icon("grabber_disabled", "VSlider", atlas)
				current_theme.set_icon("grabber_highlight", "VSlider", atlas)
			#"vslider_tick":
				#pass
			"checkbox_checked":
				current_theme.set_icon("checked", "PopupMenu", atlas)
				current_theme.set_icon("radio_checked", "PopupMenu", atlas)
				current_theme.set_icon("checked", "CheckBox", atlas)
				current_theme.set_icon("checked_disabled", "CheckBox", atlas)
			"checkbox_unchecked":
				current_theme.set_icon("unchecked", "PopupMenu", atlas)
				current_theme.set_icon("radio_unchecked", "PopupMenu", atlas)
				current_theme.set_icon("unchecked", "CheckBox", atlas)
				current_theme.set_icon("unchecked_disabled", "CheckBox", atlas)
			"option_button_arrow":
				current_theme.set_icon("arrow", "OptionButton", atlas)
			"cursor_default":
				Input.set_custom_mouse_cursor(atlas)
			"cursor_pointing":
				Input.set_custom_mouse_cursor(atlas, Input.CURSOR_POINTING_HAND)
				Input.set_custom_mouse_cursor(atlas, Input.CURSOR_CAN_DROP)
				Input.set_custom_mouse_cursor(atlas, Input.CURSOR_FORBIDDEN)
			"cursor_beam":
				Input.set_custom_mouse_cursor(atlas, Input.CURSOR_IBEAM)

func create_styleboxes(texture: Texture = preload("res://assets/textures/theme_ui_gothic.png")) -> Array:
	var stylebox_container: Array = []
	var button_styleboxes: Array[StyleBoxTexture] = []
	var panel_styleboxes: Array[StyleBoxTexture] = []
	var edge_cases: Dictionary = {}
	
	var AcceptButton := StyleBoxTexture.new()
	AcceptButton.resource_name = "AcceptButton"
	AcceptButton.region_rect = Rect2(256, 512, 64, 64)
	button_styleboxes.append(AcceptButton)
	
	var ArrowButton := StyleBoxTexture.new()
	ArrowButton.resource_name = "ArrowButton"
	ArrowButton.region_rect = Rect2(0, 512, 64, 64)
	button_styleboxes.append(ArrowButton)
	
	var ArrowRightButton := StyleBoxTexture.new()
	ArrowRightButton.resource_name = "ArrowRightButton"
	ArrowRightButton.region_rect = Rect2(64, 512, 64, 64)
	button_styleboxes.append(ArrowRightButton)
	
	var BackgroundPanel := StyleBoxTexture.new()
	BackgroundPanel.resource_name = "BackgroundPanel"
	BackgroundPanel.texture_margin_left = 32.0
	BackgroundPanel.texture_margin_top = 32.0
	BackgroundPanel.texture_margin_right = 32.0
	BackgroundPanel.texture_margin_bottom = 32.0
	BackgroundPanel.axis_stretch_horizontal = 2
	BackgroundPanel.axis_stretch_vertical = 2
	BackgroundPanel.region_rect = Rect2(512, 0, 256, 256)
	panel_styleboxes.append(BackgroundPanel)
	
	var BasicButton := StyleBoxTexture.new()
	BasicButton.resource_name = "Button"
	BasicButton.texture_margin_left = 64.0
	BasicButton.texture_margin_right = 64.0
	BasicButton.axis_stretch_horizontal = 2
	BasicButton.axis_stretch_vertical = 2
	BasicButton.region_rect = Rect2(384, 672, 384, 96)
	button_styleboxes.append(BasicButton)
	
	var ButtonGenericBackground := StyleBoxTexture.new()
	ButtonGenericBackground.resource_name = "ButtonGenericBackground"
	ButtonGenericBackground.texture_margin_left = 64.0
	ButtonGenericBackground.texture_margin_right = 64.0
	ButtonGenericBackground.axis_stretch_horizontal = 2
	ButtonGenericBackground.region_rect = Rect2(384, 576, 384, 96)
	panel_styleboxes.append(ButtonGenericBackground)
	
	var ButtonSlimBackground := StyleBoxTexture.new()
	ButtonSlimBackground.resource_name = "ButtonSlimBackground"
	ButtonSlimBackground.texture_margin_left = 64.0
	ButtonSlimBackground.texture_margin_right = 64.0
	ButtonSlimBackground.axis_stretch_horizontal = 2
	ButtonSlimBackground.region_rect = Rect2(768, 640, 256, 64)
	panel_styleboxes.append(ButtonSlimBackground)
	
	var ButtonSlimColor := StyleBoxTexture.new()
	ButtonSlimColor.resource_name = "ButtonSlimColor"
	ButtonSlimColor.texture_margin_left = 64.0
	ButtonSlimColor.texture_margin_right = 64.0
	ButtonSlimColor.axis_stretch_horizontal = 2
	ButtonSlimColor.region_rect = Rect2(768, 704, 256, 64)
	button_styleboxes.append(ButtonSlimColor)
	
	var CalendarButtonLeftBackground := StyleBoxTexture.new()
	CalendarButtonLeftBackground.resource_name = "CalendarButtonLeftBackground"
	CalendarButtonLeftBackground.region_rect = Rect2(768, 256, 128, 128)
	panel_styleboxes.append(CalendarButtonLeftBackground)
	
	var CalendarButtonLeftColor := StyleBoxTexture.new()
	CalendarButtonLeftColor.resource_name = "CalendarButtonLeftColor"
	CalendarButtonLeftColor.region_rect = Rect2(768, 384, 128, 128)
	button_styleboxes.append(CalendarButtonLeftColor)
	
	var CalendarButtonRightBackground := StyleBoxTexture.new()
	CalendarButtonRightBackground.resource_name = "CalendarButtonRightBackground"
	CalendarButtonRightBackground.region_rect = Rect2(896, 256, 128, 128)
	panel_styleboxes.append(CalendarButtonRightBackground)
	
	var CalendarButtonRightColor := StyleBoxTexture.new()
	CalendarButtonRightColor.resource_name = "CalendarButtonRightColor"
	CalendarButtonRightColor.region_rect = Rect2(896, 384, 128, 128)
	button_styleboxes.append(CalendarButtonRightColor)
	
	var CalendarPanel := StyleBoxTexture.new()
	CalendarPanel.resource_name = "CalendarPanel"
	CalendarPanel.region_rect = Rect2(0, 896, 1024, 128)
	panel_styleboxes.append(CalendarPanel)
	
	var CalendarPanelColor := StyleBoxTexture.new()
	CalendarPanelColor.resource_name = "CalendarPanelColor"
	CalendarPanelColor.region_rect = Rect2(0, 768, 1024, 128)
	panel_styleboxes.append(CalendarPanelColor)
	
	var CancelButton := StyleBoxTexture.new()
	CancelButton.resource_name = "CancelButton"
	CancelButton.region_rect = Rect2(320, 512, 64, 64)
	button_styleboxes.append(CancelButton)
	
	var GenericCheckBox := StyleBoxTexture.new()
	GenericCheckBox.resource_name = "CheckBox"
	edge_cases["CheckBox"]= GenericCheckBox
	
	var GenericColorPickerButton := StyleBoxTexture.new()
	GenericColorPickerButton.resource_name = "ColorPickerButton"
	edge_cases["ColorPickerButton"]= GenericColorPickerButton
	
	var DecorationBottomPanel := StyleBoxTexture.new()
	DecorationBottomPanel.resource_name = "DecorationBottomPanel"
	DecorationBottomPanel.region_rect = Rect2(768, 0, 256, 32)
	panel_styleboxes.append(DecorationBottomPanel)
	
	var DecorationLeftPanel := StyleBoxTexture.new()
	DecorationLeftPanel.resource_name = "DecorationLeftPanel"
	DecorationLeftPanel.region_rect = Rect2(768, 32, 128, 128)
	panel_styleboxes.append(DecorationLeftPanel)
	
	var DecorationPanel := StyleBoxTexture.new()
	DecorationPanel.resource_name = "DecorationPanel"
	DecorationPanel.region_rect = Rect2(800, 32, 192, 96)
	panel_styleboxes.append(DecorationPanel)
	
	var DecorationRightPanel := StyleBoxTexture.new()
	DecorationRightPanel.resource_name = "DecorationRightPanel"
	DecorationRightPanel.region_rect = Rect2(896, 32, 128, 128)
	panel_styleboxes.append(DecorationRightPanel)
	
	var DecorationTopLeftPanel := StyleBoxTexture.new()
	DecorationTopLeftPanel.resource_name = "DecorationTopLeftPanel"
	DecorationTopLeftPanel.region_rect = Rect2(768, 160, 128, 32)
	panel_styleboxes.append(DecorationTopLeftPanel)
	
	var DecorationTopRightPanel := StyleBoxTexture.new()
	DecorationTopRightPanel.resource_name = "DecorationTopRightPanel"
	DecorationTopRightPanel.region_rect = Rect2(896, 160, 128, 32)
	panel_styleboxes.append(DecorationTopRightPanel)
	
	var MinimizeButton := StyleBoxTexture.new()
	MinimizeButton.resource_name = "MinimizeButton"
	MinimizeButton.region_rect = Rect2(128, 512, 64, 64)
	button_styleboxes.append(MinimizeButton)
	
	var EditButton := StyleBoxTexture.new()
	EditButton.resource_name = "EditButton"
	EditButton.region_rect = Rect2(192, 512, 64, 64)
	button_styleboxes.append(EditButton)
	
	var GoldEdgePanel := StyleBoxTexture.new()
	GoldEdgePanel.resource_name = "GoldEdgePanel"
	GoldEdgePanel.texture_margin_left = 8.0
	GoldEdgePanel.texture_margin_top = 8.0
	GoldEdgePanel.texture_margin_right = 8.0
	GoldEdgePanel.texture_margin_bottom = 10.0
	GoldEdgePanel.axis_stretch_horizontal = 1
	GoldEdgePanel.axis_stretch_vertical = 1
	GoldEdgePanel.region_rect = Rect2(512, 256, 256, 256)
	panel_styleboxes.append(GoldEdgePanel)
	
	var GenericHSlider := StyleBoxTexture.new()
	GenericHSlider.resource_name = "HSlider"
	GenericHSlider.texture_margin_left = 8.0
	GenericHSlider.texture_margin_top = 12.0
	GenericHSlider.texture_margin_right = 8.0
	GenericHSlider.texture_margin_bottom = 12.0
	GenericHSlider.axis_stretch_horizontal = 1
	GenericHSlider.region_rect = Rect2(416, 480, 64, 32)
	edge_cases["HSlider"]= GenericHSlider
	
	var GenericOptionButton := StyleBoxTexture.new()
	GenericOptionButton.resource_name = "OptionButton"
	GenericOptionButton.texture_margin_left = 8.0
	GenericOptionButton.texture_margin_top = 4.0
	GenericOptionButton.texture_margin_right = 8.0
	GenericOptionButton.texture_margin_bottom = 4.0
	GenericOptionButton.axis_stretch_horizontal = 2
	GenericOptionButton.region_rect = Rect2(416, 480, 64, 32)
	edge_cases["OptionButton"]= GenericOptionButton
	
	var GenericPanel := StyleBoxTexture.new()
	GenericPanel.resource_name = "Panel"
	GenericPanel.texture_margin_left = 108.0
	GenericPanel.texture_margin_top = 192.0
	GenericPanel.texture_margin_right = 108.0
	GenericPanel.texture_margin_bottom = 64.0
	GenericPanel.axis_stretch_horizontal = 1
	GenericPanel.axis_stretch_vertical = 2
	GenericPanel.region_rect = Rect2(0, 0, 512, 352)
	panel_styleboxes.append(GenericPanel)
	
	var DefaultPopupMenu := StyleBoxTexture.new()
	DefaultPopupMenu.resource_name = "PopupMenu"
	edge_cases["PopupMenu"]= DefaultPopupMenu
	
	var DefaultPopupPanel := StyleBoxTexture.new()
	DefaultPopupPanel.resource_name = "PopupPanel"
	DefaultPopupPanel.texture_margin_left = 8.0
	DefaultPopupPanel.texture_margin_top = 8.0
	DefaultPopupPanel.texture_margin_right = 8.0
	DefaultPopupPanel.texture_margin_bottom = 10.0
	DefaultPopupPanel.axis_stretch_horizontal = 1
	DefaultPopupPanel.axis_stretch_vertical = 1
	DefaultPopupPanel.region_rect = Rect2(512, 256, 256, 256)
	edge_cases["PopupPanel"]= DefaultPopupPanel
	
	var ProjectButtonColor := StyleBoxTexture.new()
	ProjectButtonColor.resource_name = "ProjectButtonColor"
	ProjectButtonColor.texture_margin_left = 30.0
	ProjectButtonColor.texture_margin_top = 28.0
	ProjectButtonColor.texture_margin_right = 28.0
	ProjectButtonColor.texture_margin_bottom = 20.0
	ProjectButtonColor.axis_stretch_horizontal = 1
	ProjectButtonColor.axis_stretch_vertical = 1
	ProjectButtonColor.region_rect = Rect2(0, 672, 384, 96)
	button_styleboxes.append(ProjectButtonColor)
	
	var ScrollContainerPanel := StyleBoxTexture.new()
	ScrollContainerPanel.resource_name = "ScrollContainer"
	ScrollContainerPanel.texture_margin_left = 8.0
	ScrollContainerPanel.texture_margin_top = 8.0
	ScrollContainerPanel.texture_margin_right = 8.0
	ScrollContainerPanel.texture_margin_bottom = 10.0
	ScrollContainerPanel.axis_stretch_horizontal = 1
	ScrollContainerPanel.axis_stretch_vertical = 1
	ScrollContainerPanel.region_rect = Rect2(512, 256, 256, 256)
	edge_cases["ScrollContainer"]= ScrollContainerPanel
	
	var SmallButtonBackground := StyleBoxTexture.new()
	SmallButtonBackground.resource_name = "SmallButtonBackground"
	SmallButtonBackground.region_rect = Rect2(0, 448, 64, 64)
	panel_styleboxes.append(SmallButtonBackground)
	
	var TabBackgroundColor := StyleBoxTexture.new()
	TabBackgroundColor.resource_name = "TabBackgroundColor"
	TabBackgroundColor.texture_margin_left = 108.0
	TabBackgroundColor.texture_margin_right = 108.0
	TabBackgroundColor.axis_stretch_horizontal = 1
	TabBackgroundColor.axis_stretch_vertical = 2
	TabBackgroundColor.region_rect = Rect2(0, 352, 512, 96)
	panel_styleboxes.append(TabBackgroundColor)
	
	var TabNewTaskPanel := StyleBoxTexture.new()
	TabNewTaskPanel.resource_name = "TabNewTaskPanel"
	TabNewTaskPanel.texture_margin_left = 48.0
	TabNewTaskPanel.texture_margin_top = 16.0
	TabNewTaskPanel.texture_margin_right = 56.0
	TabNewTaskPanel.texture_margin_bottom = 18.0
	TabNewTaskPanel.axis_stretch_horizontal = 2
	TabNewTaskPanel.region_rect = Rect2(394, 522, 362, 44)
	panel_styleboxes.append(TabNewTaskPanel)
	
	var TabPanel := StyleBoxTexture.new()
	TabPanel.resource_name = "TabPanel"
	TabPanel.texture_margin_left = 108.0
	TabPanel.texture_margin_top = 192.0
	TabPanel.texture_margin_right = 108.0
	TabPanel.texture_margin_bottom = 64.0
	TabPanel.axis_stretch_horizontal = 1
	TabPanel.axis_stretch_vertical = 2
	TabPanel.region_rect = Rect2(0, 0, 512, 352)
	panel_styleboxes.append(TabPanel)
	
	var TaskButton := StyleBoxTexture.new()
	TaskButton.resource_name = "TaskButton"
	TaskButton.texture_margin_left = 30.0
	TaskButton.texture_margin_top = 28.0
	TaskButton.texture_margin_right = 28.0
	TaskButton.texture_margin_bottom = 20.0
	TaskButton.axis_stretch_horizontal = 1
	TaskButton.axis_stretch_vertical = 1
	TaskButton.region_rect = Rect2(0, 672, 384, 96)
	button_styleboxes.append(TaskButton)
	
	var TaskDeleteButton := StyleBoxTexture.new()
	TaskDeleteButton.resource_name = "TaskDeleteButton"
	TaskDeleteButton.region_rect = Rect2(256, 448, 64, 64)
	button_styleboxes.append(TaskDeleteButton)
	
	var TaskEditButton := StyleBoxTexture.new()
	TaskEditButton.resource_name = "TaskEditButton"
	TaskEditButton.region_rect = Rect2(192, 448, 64, 64)
	button_styleboxes.append(TaskEditButton)
	
	var TaskPanel := StyleBoxTexture.new()
	TaskPanel.resource_name = "TaskPanel"
	TaskPanel.texture_margin_left = 30.0
	TaskPanel.texture_margin_top = 28.0
	TaskPanel.texture_margin_right = 28.0
	TaskPanel.texture_margin_bottom = 20.0
	TaskPanel.axis_stretch_horizontal = 1
	TaskPanel.axis_stretch_vertical = 1
	TaskPanel.region_rect = Rect2(0, 576, 384, 96)
	panel_styleboxes.append(TaskPanel)
	
	var TaskPanelHover := StyleBoxTexture.new()
	TaskPanelHover.resource_name = "TaskPanelHover"
	TaskPanelHover.texture_margin_left = 30.0
	TaskPanelHover.texture_margin_top = 28.0
	TaskPanelHover.texture_margin_right = 28.0
	TaskPanelHover.texture_margin_bottom = 20.0
	TaskPanelHover.axis_stretch_horizontal = 1
	TaskPanelHover.axis_stretch_vertical = 1
	TaskPanelHover.region_rect = Rect2(0, 672, 384, 96)
	panel_styleboxes.append(TaskPanelHover)
	
	var TextEditPanel := StyleBoxTexture.new()
	TextEditPanel.resource_name = "TextEdit"
	TextEditPanel.texture_margin_left = 8.0
	TextEditPanel.texture_margin_top = 8.0
	TextEditPanel.texture_margin_right = 8.0
	TextEditPanel.texture_margin_bottom = 10.0
	TextEditPanel.axis_stretch_horizontal = 1
	TextEditPanel.axis_stretch_vertical = 1
	TextEditPanel.region_rect = Rect2(512, 256, 256, 256)
	edge_cases["TextEdit"]= TextEditPanel
	
	var LineEditPanel := StyleBoxTexture.new()
	LineEditPanel.resource_name = "LineEdit"
	LineEditPanel.texture_margin_left = 8.0
	LineEditPanel.texture_margin_top = 8.0
	LineEditPanel.texture_margin_right = 8.0
	LineEditPanel.texture_margin_bottom = 10.0
	LineEditPanel.axis_stretch_horizontal = 1
	LineEditPanel.axis_stretch_vertical = 1
	LineEditPanel.region_rect = Rect2(512, 256, 256, 256)
	edge_cases["LineEdit"]= LineEditPanel
	
	var TopBarPanel := StyleBoxTexture.new()
	TopBarPanel.resource_name = "TopBarPanel"
	TopBarPanel.texture_margin_left = 100.0
	TopBarPanel.texture_margin_top = 16.0
	TopBarPanel.texture_margin_right = 100.0
	TopBarPanel.texture_margin_bottom = 20.0
	TopBarPanel.axis_stretch_horizontal = 2
	TopBarPanel.axis_stretch_vertical = 1
	TopBarPanel.region_rect = Rect2(0, 0, 512, 352)
	panel_styleboxes.append(TopBarPanel)
	
	var TopBarPanelBackground := StyleBoxTexture.new()
	TopBarPanelBackground.resource_name = "TopBarPanelBackground"
	TopBarPanelBackground.texture_margin_left = 92.0
	TopBarPanelBackground.texture_margin_right = 96.0
	TopBarPanelBackground.axis_stretch_horizontal = 1
	TopBarPanelBackground.axis_stretch_vertical = 1
	TopBarPanelBackground.region_rect = Rect2(16, 364, 480, 72)
	panel_styleboxes.append(TopBarPanelBackground)
	
	var WindowBarBackground := StyleBoxTexture.new()
	WindowBarBackground.resource_name = "WindowBarBackground"
	WindowBarBackground.texture_margin_left = 8.0
	WindowBarBackground.texture_margin_top = 8.0
	WindowBarBackground.texture_margin_right = 8.0
	WindowBarBackground.texture_margin_bottom = 8.0
	WindowBarBackground.axis_stretch_horizontal = 1
	WindowBarBackground.axis_stretch_vertical = 1
	WindowBarBackground.region_rect = Rect2(768, 512, 256, 32)
	panel_styleboxes.append(WindowBarBackground)
	
	var WindowBarBackgroundColor := StyleBoxTexture.new()
	WindowBarBackgroundColor.resource_name = "WindowBarBackgroundColor"
	WindowBarBackgroundColor.texture_margin_left = 8.0
	WindowBarBackgroundColor.texture_margin_right = 8.0
	WindowBarBackgroundColor.axis_stretch_horizontal = 1
	WindowBarBackgroundColor.region_rect = Rect2(768, 544, 256, 32)
	panel_styleboxes.append(WindowBarBackgroundColor)
	
	var GenericVScrollBar := StyleBoxTexture.new()
	GenericVScrollBar.resource_name = "VScrollBar"
	edge_cases["VScrollBar"]= GenericVScrollBar
	
	var GenericHScrollBar := StyleBoxTexture.new()
	GenericHScrollBar.resource_name = "HScrollBar"
	edge_cases["HScrollBar"]= GenericHScrollBar
	
	var GenericVSlider := StyleBoxTexture.new()
	GenericVSlider.resource_name = "VSlider"
	GenericVSlider.region_rect = Rect2(0, 512, 64, 64)
	edge_cases["VSlider"]= GenericVSlider
	
	
	for stylebox: StyleBoxTexture in button_styleboxes:
		stylebox.texture = texture
	
	for stylebox: StyleBoxTexture in panel_styleboxes:
		stylebox.texture = texture
		
	for key in edge_cases.keys():
		var stylebox: StyleBoxTexture = edge_cases[key]
		stylebox.texture = texture
	
	stylebox_container.append(button_styleboxes)
	stylebox_container.append(panel_styleboxes)
	stylebox_container.append(edge_cases)
	
	return stylebox_container

func create_atlastextures(texture: Texture = preload("res://assets/textures/theme_ui_gothic.png")) -> Array:
	var atlastexture_container: Array[AtlasTexture] = []
	
	var checkbox_checked := AtlasTexture.new()
	checkbox_checked.resource_name = "checkbox_checked"
	checkbox_checked.region = Rect2(320, 448, 32, 32)
	atlastexture_container.append(checkbox_checked)
	
	var checkbox_unchecked := AtlasTexture.new()
	checkbox_unchecked.resource_name = "checkbox_unchecked"
	checkbox_unchecked.region = Rect2(320, 480, 32, 32)
	atlastexture_container.append(checkbox_unchecked)
	
	var cursor_beam := AtlasTexture.new()
	cursor_beam.resource_name = "cursor_beam"
	cursor_beam.region = Rect2(896, 192, 64, 64)
	atlastexture_container.append(cursor_beam)
	
	var cursor_default := AtlasTexture.new()
	cursor_default.resource_name = "cursor_default"
	cursor_default.region = Rect2(768, 192, 64, 64)
	atlastexture_container.append(cursor_default)
	
	var cursor_pointing := AtlasTexture.new()
	cursor_pointing.resource_name = "cursor_pointing"
	cursor_pointing.region = Rect2(832, 192, 64, 64)
	atlastexture_container.append(cursor_pointing)
	
	var hslider_grabber := AtlasTexture.new()
	hslider_grabber.resource_name = "hslider_grabber"
	hslider_grabber.region = Rect2(480, 448, 32, 32)
	atlastexture_container.append(hslider_grabber)
	
	var hslider_tick := AtlasTexture.new()
	hslider_tick.resource_name = "hslider_tick"
	hslider_tick.region = Rect2(416, 480, 64, 32)
	atlastexture_container.append(hslider_tick)
	
	var option_button_arrow := AtlasTexture.new()
	option_button_arrow.resource_name = "option_button_arrow"
	option_button_arrow.region = Rect2(416, 448, 32, 32)
	atlastexture_container.append(option_button_arrow)
	
	var vslider_grabber := AtlasTexture.new()
	vslider_grabber.resource_name = "vslider_grabber"
	vslider_grabber.region = Rect2(448, 448, 32, 32)
	atlastexture_container.append(vslider_grabber)
	
	for atlastexture: AtlasTexture in atlastexture_container:
		atlastexture.atlas = texture
	
	return atlastexture_container

func create_label_settings(font_color: Color = Color(1, 1, 1, 1)) -> Dictionary:
	var label_settings_container: Dictionary = {}
	
	var button_label_settings := LabelSettings.new()
	button_label_settings.resource_name = "button_label_settings"
	button_label_settings.font_color = font_color
	button_label_settings.font_size = 22
	button_label_settings.shadow_size = 3
	button_label_settings.shadow_color = Color(0, 0, 0, 0.470588)
	label_settings_container["button_label_settings"] = button_label_settings
	
	var default_label_settings := LabelSettings.new()
	default_label_settings.resource_name = "default_label_settings"
	default_label_settings.font_color = font_color
	default_label_settings.font_size = 32
	default_label_settings.shadow_size = 4
	default_label_settings.shadow_color = Color(0, 0, 0, 0.509804)
	default_label_settings.shadow_offset = Vector2(0, 2)
	label_settings_container["default_label_settings"] = default_label_settings
	
	var medium_label_settings := LabelSettings.new()
	medium_label_settings.resource_name = "medium_label_settings"
	medium_label_settings.font_color = font_color
	medium_label_settings.font_size = 24
	medium_label_settings.shadow_size = 3
	medium_label_settings.shadow_color = Color(0, 0, 0, 0.470588)
	label_settings_container["medium_label_settings"] = medium_label_settings
	
	var small_label_settings := LabelSettings.new()
	small_label_settings.resource_name = "small_label_settings"
	small_label_settings.font_color = font_color
	label_settings_container["small_label_settings"] = small_label_settings
	
	var tab_title_label_settings := LabelSettings.new()
	tab_title_label_settings.resource_name = "tab_title_label_settings"
	tab_title_label_settings.font_color = font_color
	tab_title_label_settings.font_size = 32
	tab_title_label_settings.shadow_size = 3
	tab_title_label_settings.shadow_color = Color(0, 0, 0, 0.470588)
	label_settings_container["tab_title_label_settings"] = tab_title_label_settings
	
	var title_label_settings := LabelSettings.new()
	title_label_settings.resource_name = "title_label_settings"
	title_label_settings.font_color = font_color
	title_label_settings.font_size = 32
	title_label_settings.shadow_size = 3
	title_label_settings.shadow_color = Color(0, 0, 0, 0.470588)
	label_settings_container["title_label_settings"] = title_label_settings
	
	var top_bar_label_settings := LabelSettings.new()
	top_bar_label_settings.resource_name = "top_bar_label_settings"
	top_bar_label_settings.font_color = font_color
	top_bar_label_settings.font_size = 28
	top_bar_label_settings.shadow_size = 3
	top_bar_label_settings.shadow_color = Color(0, 0, 0, 0.470588)
	label_settings_container["top_bar_label_settings"] = top_bar_label_settings
	
	return label_settings_container
	
	
