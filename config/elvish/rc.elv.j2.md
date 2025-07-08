# Elvish Configuration

Set my path variable.
```sh
set paths = [ {% for item in path %}{{ item }} {% endfor %} ]
```

Define ls shortcuts. Use `eza` over `ls` if it is available.
```sh
var ls_def = { |@a| e:ls --color $@a }
try {
	which eza > /dev/null 2> /dev/null
	set ls_def = { |@a| e:eza $@a }
} catch { }

fn ls { |@a| $ls_def      $@a }
fn l  { |@a| $ls_def -F   $@a }
fn la { |@a| $ls_def -a   $@a }
fn ll { |@a| $ls_def -alF $@a }
```

Use `lesspipe` if it is available.
```sh
try {
	which lesspipe.sh > /dev/null 2> /dev/null
	set E:LESSOPEN = "|lesspipe.sh %s"
} catch { }
```

Configure the right prompt to show the `git` status if in a `git` repository.
```sh
fn rprompt_data {
	try {
		var stat = (git status 2> /dev/null | slurp)

		use str
		if (str:contains $stat 'use "git push" to publish your local commits') {
			put (styled "" green)
		}
		if (str:contains $stat 'Changes to be committed:') {
			put (styled "" magenta)
		}
		if (str:contains $stat 'Changes not staged for commit:') {
			put (styled "" yellow)
		}
		if (str:contains $stat 'Untracked files:') {
			put (styled "" red)
		}

		put (styled "(" blue)
		if (str:contains $stat 'On branch ') {
			put (styled (echo $stat | grep 'On branch ' | sed 's/On branch //') blue)
		} elif (str:contains $stat ' detached at ') {
			put (styled (echo $stat | grep ' detached at ' | sed 's/^.*detached at //') blue)
		}
		put (styled ")" blue)
	} catch e {
		put (styled (whoami)@(hostname) inverse)
	}
}
```

Use readline bindings, including alt-backspace to delete the word behind the cursor.
```sh
use readline-binding
var b = {|k f| set edit:insert:binding[$k] = $f }
$b Alt-Backspace $edit:kill-word-left~
```
