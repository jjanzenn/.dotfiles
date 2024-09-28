.PHONY: install update rollback

SRCDIR = ./nixos
DSTDIR = $(HOME)/quarantine

SOURCES := $(shell find -L $(SRCDIR)/ -type f)
CONFIGS := $(subst $(SRCDIR)/,$(DSTDIR)/,$(SOURCES:%.org=%))

all: update

update: install
	nix flake update $(DSTDIR)/.flake
	cp $(DSTDIR)/.flake/flake.lock $(SRCDIR)/.flake
	sudo nixos-rebuild switch --flake $(DSTDIR)/.flake

install: $(CONFIGS)
	sudo nixos-rebuild switch --flake $(DSTDIR)/.flake

$(DSTDIR)/%: $(SRCDIR)/%.org
	mkdir -p $(dir $@)
	python3 ./extract_src.py $< $@

$(DSTDIR)/%: $(SRCDIR)/%
	mkdir -p $(dir $@)
	cp $< $@
