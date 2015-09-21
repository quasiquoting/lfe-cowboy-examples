PROJECT := $(notdir $(CURDIR))
DEPS = cowboy
dep_cowboy = git https://github.com/ninenines/cowboy master
include ../erlang.mk


all::
	mkdir -p ebin && lfec -o ebin src/*.lfe

dev:
	lfe -pa ebin -pa deps/*/ebin -s $(PROJECT)
