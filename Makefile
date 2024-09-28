.PHONY: install update rollback nixos-update nixos-install

SYSTEM = $(shell uname -n)
SRCDIR = ./$(SYSTEM)
DSTDIR = $(HOME)

SOURCES := $(shell find -L $(SRCDIR)/ -type f)
CONFIGS := $(subst $(SRCDIR)/,$(DSTDIR)/,$(SOURCES:%.org=%))

UPDATE_TARGET :=
INSTALL_TARGET :=

ifeq ($(SYSTEM), nixos)
	UPDATE_TARGET += nixos-update
	INSTALL_TARGET += nixos-install
endif

all: update

update: install $(UPDATE_TARGET)

install: $(CONFIGS) $(INSTALL_TARGET)

$(DSTDIR)/%: $(SRCDIR)/%.org
	mkdir -p $(dir $@)
	python3 ./extract_src.py $< $@

$(DSTDIR)/%: $(SRCDIR)/%
	mkdir -p $(dir $@)
	cp $< $@

nixos-update: install
	nix flake update $(DSTDIR)/.flake
	cp $(DSTDIR)/.flake/flake.lock $(SRCDIR)/.flake
	sudo nixos-rebuild switch --flake $(DSTDIR)/.flake

nixos-install: $(CONFIGS)
	sudo nixos-rebuild switch --flake $(DSTDIR)/.flake
