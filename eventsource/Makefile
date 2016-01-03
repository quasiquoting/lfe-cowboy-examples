PROJECT = eventsource
DEPS = cowboy
dep_cowboy = git https://github.com/ninenines/cowboy master
include ../resources/make/erlang.mk


all::
	mkdir -p ebin && lfec -o ebin src/*.lfe

dev:
	lfe -pa $(CURDIR)/ebin -pa $(CURDIR)deps/*/ebin -s $(PROJECT)
