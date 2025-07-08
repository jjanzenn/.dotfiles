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
	$ls_def = { |@a| e:eza $@a }
} catch { }
fn ls { |@a| $ls_def $@a }
fn l { |@a| ls -F $@a }
fn la { |@a| ls -a $@a }
fn ll { |@a| ls -alF $@a }
```

Use readline bindings, including alt-backspace to delete the word behind the cursor.
```sh
  use readline-binding
  var b = {|k f| set edit:insert:binding[$k] = $f }
  $b Alt-Backspace $edit:kill-word-left~
```
