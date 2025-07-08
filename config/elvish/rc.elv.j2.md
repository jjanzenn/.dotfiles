# Elvish Configuration

Set my path variable.
```sh
  set paths = [ {% for item in path %} {{ item }} {% endfor %} ]
```

Define ls shortcuts.
```sh
try { which eza > /dev/null 2> /dev/null } {
	fn ls { |@a| e:eza $@a }
	fn l { |@a| e:eza -F $@a }
	fn la { |@a| e:eza -a $@a }
	fn ll { |@a| e:eza -alF $@a }
} catch {
	fn ls { |@a| e:ls --color $@a }
	fn l { |@a| e:ls --color -F $@a }
	fn la { |@a| e:ls --color -a $@a }
	fn ll { |@a| e:ls --color -alF $@a }
}
```

Use readline bindings, including alt-backspace to delete the word behind the cursor.
```sh
  use readline-binding
  var b = {|k f| set edit:insert:binding[$k] = $f }
  $b Alt-Backspace $edit:kill-word-left~
```
