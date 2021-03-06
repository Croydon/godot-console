<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# Console

**Extends:** [CanvasLayer](../CanvasLayer)

## Description

## Property Descriptions

### History

```gdscript
var History: History
```

### Log

```gdscript
var Log: Logger
```

### is\_console\_shown

```gdscript
var is_console_shown: bool
```

### consume\_input

```gdscript
var consume_input: bool
```

### action\_console\_toggle

```gdscript
var action_console_toggle: String
```

### action\_history\_up

```gdscript
var action_history_up: String
```

### action\_history\_down

```gdscript
var action_history_down: String
```

### Text

```gdscript
var Text
```

### Line

```gdscript
var Line
```

## Method Descriptions

### get\_command\_service

```gdscript
func get_command_service(): Command/CommandService
```

### ~~getCommand~~ <small>(deprecated)</small>

```gdscript
func getCommand(name: String): Command/Command|null
```

### get\_command

```gdscript
func get_command(name: String): Command/Command|null
```

### ~~findCommands~~ <small>(deprecated)</small>

```gdscript
func findCommands(name: String): Command/CommandCollection
```

### find\_commands

```gdscript
func find_commands(name: String): Command/CommandCollection
```

### ~~addCommand~~ <small>(deprecated)</small>

```gdscript
func addCommand(name: String, target: Reference, target_name: String|null): Command/CommandBuilder
```

### add\_command

```gdscript
func add_command(name: String, target: Reference, target_name: String|null): Command/CommandBuilder
```

### ~~removeCommand~~ <small>(deprecated)</small>

```gdscript
func removeCommand(name: String): int
```

### remove\_command

```gdscript
func remove_command(name: String): int
```

### write

```gdscript
func write(message: String): void
```

### ~~writeLine~~ <small>(deprecated)</small>

```gdscript
func writeLine(message: String): void
```

### write\_line

```gdscript
func write_line(message: String): void
```

### clear

```gdscript
func clear(): void
```

### toggleConsole

```gdscript
func toggleConsole(): Console
```

### toggle\_console

```gdscript
func toggle_console(): Console
```

