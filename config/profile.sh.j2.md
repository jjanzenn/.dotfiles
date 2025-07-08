# Shell Profile Definitions

Configure the path. Disable loading the global configuration on Darwin as it
breaks the path variable.
```sh
{% if ansible_facts['os_family'] == 'Darwin' %}
setopt no_global_rcs
{% endif %}
export PATH="{% for item in path %}{{ item }}:{% endfor %}:$PATH"
```

Set my path for man pages on Darwin.
```sh
{% if ansible_facts['os_family'] == 'Darwin' %}
export MANPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/share/man:/usr/share/man:$MANPATH"
{% endif %}
```

Use Kakoune by default when editing.
```sh
export EDITOR="kak"
```

Install `pipx` packages to `~/.local/pipx`.
```sh
export PIPX_HOME="$HOME/.local/pipx"
```

If I am on Darwin, set the `GPG_TTY` variable.
```sh
{% if ansible_facts['os_family'] == 'Darwin' %}
export GPG_TTY=$(tty)
{% endif %}
```
