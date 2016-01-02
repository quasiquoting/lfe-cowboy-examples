PROJECT := $(notdir $(CURDIR))
DEPS = cowboy jsx
dep_cowboy = git https://github.com/ninenines/cowboy master
dep_jsx = git https://github.com/talentdeficit/jsx master
include ../resources/make/erlang.mk


all::
	mkdir -p ebin && lfec -o ebin src/*.lfe

dev:
	lfe -pa $(CURDIR)/ebin -pa $(CURDIR)deps/*/ebin -s $(PROJECT)
