.PHONY: all install

SYSTEM := $(shell uname -s)

ifeq ($(SYSTEM), Linux)
  SYSTEM = $(shell grep "^ID=" /etc/os-release | sed "s/^ID=//")
endif

# Set directories
SRCDIR = .
DSTDIR = $(HOME)/.ansible-conf

# Get the list of files that need to be generated
SOURCES := $(shell find -L $(SRCDIR)/ -type f -not -path "./.git/*")
NOGPG := $(SOURCES:%.gpg=%)
NOORG := $(NOGPG:%.org=%)
CONFIGS := $(subst $(SRCDIR)/,$(DSTDIR)/,$(NOORG))

# update by default, install first
all: install

# install configs and any additional targets
install: $(CONFIGS)
	ansible-playbook -i $(DSTDIR)/inventory.ini $(DSTDIR)/$(SYSTEM).yaml -vvv
	git add -A
	git commit -m "system changes" || true

# install encrypted org configs
$(DSTDIR)/%: $(SRCDIR)/%.org.gpg
	mkdir -p $(dir $@)
	gpg -d --batch $< 1> tmp.org
	python3 ./extract_src.py tmp.org $@
	rm tmp.org

# install org configs
$(DSTDIR)/%: $(SRCDIR)/%.org
	mkdir -p $(dir $@)
	python3 ./extract_src.py $< $@

# install generic files
$(DSTDIR)/%: $(SRCDIR)/%
	mkdir -p $(dir $@)
	cp $< $@
