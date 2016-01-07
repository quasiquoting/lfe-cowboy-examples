PROJECT     = $(notdir $(CURDIR))
DEPS        = lfe cowboy lone-ranger
BUILD_DEPS  = lfe.mk
DEP_PLUGINS = lfe.mk
dep_lfe.mk  = git https://github.com/ninenines/lfe.mk master
dep_cowboy  = git https://github.com/ninenines/cowboy master
dep_lone-ranger = git https://github.com/quasiquoting/lone-ranger master
include ../resources/make/erlang.mk
include ../resources/make/dev.mk
