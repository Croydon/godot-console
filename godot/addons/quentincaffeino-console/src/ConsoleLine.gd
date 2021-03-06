
extends LineEdit

# @var  RegExLib
var RegExLib = preload('../addons/quentincaffeino-regexlib/src/RegExLib.gd').new() setget _set_protected


# @const  String
const COMMANDS_SEPARATOR = ';'

# @const  String
const RECOMMANDS_SEPARATOR = '(?<!\\\\)' + COMMANDS_SEPARATOR

# @const  String
const COMMAND_PARTS_SEPARATOR = ' '

# @const  PoolStringArray
const QUOTES = [ '"', "'" ]

# @const  PoolStringArray
const SCREENERS = [ '\\/' ]

# @var  String|null
var _tmpUsrEnteredCmd

# @var  String
var _currCmd


func _ready():
	# Console keyboard control
	self.set_process_input(true)

	self.connect('text_entered', self, 'execute')

func _gui_input(event):
	if Console.consume_input and self.has_focus():
		accept_event()

# @param  Event  e
func _input(e):
	# Don't process input if console is not visible
	if !is_visible_in_tree():
		return
	
	# Show next line in history
	if Input.is_action_just_pressed(Console.action_history_up):
		self._currCmd = Console.History.current()
		Console.History.previous()

		if self._tmpUsrEnteredCmd == null:
			self._tmpUsrEnteredCmd = self.text

	# Show previous line in history
	if Input.is_action_just_pressed(Console.action_history_down):
		self._currCmd = Console.History.next()

		if !self._currCmd and self._tmpUsrEnteredCmd != null:
			self._currCmd = self._tmpUsrEnteredCmd
			self._tmpUsrEnteredCmd = null

	# Autocomplete on TAB
	if e is InputEventKey and e.pressed and e.scancode == KEY_TAB:
		var commands = Console.get_command_service().find(self.text)
		if commands.length == 1:
			self.set_text(commands.getByIndex(0).getName())
		else:
			for command in commands.getValueIterator():
				var name = command.getName()
				Console.write_line('[color=#ffff66][url=%s]%s[/url][/color]' % [ name, name ])

	# Finish
	if self._currCmd != null:
		self.set_text(self._currCmd.getText() if self._currCmd and typeof(self._currCmd) == TYPE_OBJECT else self._currCmd)
		self.accept_event()
		self._currCmd = null


# @param    String  text
# @param    bool    move_caret_to_end
# @returns  void
func setText(text, move_caret_to_end = true):
	Console.Log.warn("DEPRECATED: We're moving our api from camelCase to snake_case, please update this method to `get_command`. Please refer to documentation for more info.")
	return self.set_text(text, move_caret_to_end)

# @param    String  text
# @param    bool    move_caret_to_end
# @returns  void
func set_text(text, move_caret_to_end = true):
	self.text = text
	self.grab_focus()

	if move_caret_to_end:
		self.caret_position = text.length()


# @param    String  input
# @returns  void
func execute(input):
	Console.write_line('[color=#999999]$[/color] ' + input)

	# @var  PoolStringArray
	var rawCommands = RegExLib.split(RECOMMANDS_SEPARATOR, input)

	# @var  Dictionary[]
	var parsedCommands = self._parse_commands(rawCommands)

	for parsedCommand in parsedCommands:
		# @var  Command/Command|null
		var command = Console.get_command(parsedCommand.name)

		if command:
			Console.Log.debug('Executing `' + parsedCommand.command + '`.')
			command.execute(parsedCommand.arguments)
		else:
			Console.write_line('Command `' + parsedCommand.name + '` not found.')

	Console.History.push(input)
	self.clear()


# @param    PoolStringArray  rawCommands
# @returns  Array
func _parse_commands(rawCommands):
	var resultCommands = []

	for rawCommand in rawCommands:
		if rawCommand:
			resultCommands.append(self._parse_command(rawCommand))

	return resultCommands


# @param    String  rawCommand
# @returns  Dictionary
func _parse_command(rawCommand):
	var name = null
	var arguments = PoolStringArray([])

	var beginning = 0  # int
	var openQuote  # String|null
	var isInsideQuotes = false  # boolean
	var subString  # String|null
	for i in rawCommand.length():
		# Quote
		if rawCommand[i] in QUOTES and i > 0 and not rawCommand[i - 1] in SCREENERS:
			if isInsideQuotes and rawCommand[i] == openQuote:
				openQuote = null
				isInsideQuotes = false
				subString = rawCommand.substr(beginning, i - beginning)
				beginning = i + 1
			elif !isInsideQuotes:
				openQuote = rawCommand[i]
				isInsideQuotes = true
				beginning += 1

		# Separate arguments
		elif rawCommand[i] == COMMAND_PARTS_SEPARATOR and !isInsideQuotes or i == rawCommand.length() - 1:
			if i == rawCommand.length() - 1:
				subString = rawCommand.substr(beginning, i - beginning + 1)
			else:
				subString = rawCommand.substr(beginning, i - beginning)
			beginning = i + 1

		# Save separated argument
		if subString != null and typeof(subString) == TYPE_STRING and !subString.empty():
			if !name:
				name = subString
			else:
				arguments.append(subString)
			subString = null

	return {
		'command': rawCommand,
		'name': name,
		'arguments': arguments
	}


# @returns  void
func _set_protected(value):
	Console.Log.warn('QC/Console/ConsoleLine: set_protected: Attempted to set a protected variable, ignoring.')
