PROJECT     = $(notdir $(CURDIR))
DEPS        = lfe cowboy jsx
BUILD_DEPS  = lfe.mk
DEP_PLUGINS = lfe.mk
dep_lfe.mk  = git https://github.com/ninenines/lfe.mk master
dep_cowboy  = git https://github.com/ninenines/cowboy master
dep_jsx     = git https://github.com/talentdeficit/jsx master
include ../resources/make/erlang.mk
