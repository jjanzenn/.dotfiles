# Elvish Configuration

Set my path variable.
```elv
  set paths = [ {% for item in path %} {{ item }} {% endfor %} ]
```

Use readline bindings, including alt-backspace to delete the word behind the cursor.
```
  use readline-binding
  var b = {|k f| set edit:insert:binding[$k] = $f }
  $b Alt-Backspace $edit:kill-word-left~
```
