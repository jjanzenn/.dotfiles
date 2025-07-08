# Elvish Configuration

Set my path variable.
```sh
  set paths = [ {% for item in path %} {{ item }} {% endfor %} ]
```

Define ls shortcuts.
```sh
var ls_def = { |@a| e:ls --color $@a }
try {
	which eza > /dev/null 2> /dev/null
	set ls_def = { |@a| e:eza $@a }
} catch { }
fn ls { |@a| $ls_def $@a }
fn l { |@a| $ls_def -F $@a }
fn la { |@a| $ls_def -a $@a }
fn ll { |@a| $ls_def -alF $@a }
```

Use `lesspipe` if it is available.
```sh
try {
	which lesspipe.sh > /dev/null 2> /dev/null
	set E:LESSOPEN = "|lesspipe.sh %s"
} catch { }
```

Use readline bindings, including alt-backspace to delete the word behind the cursor.
```sh
  use readline-binding
  var b = {|k f| set edit:insert:binding[$k] = $f }
  $b Alt-Backspace $edit:kill-word-left~
```
