
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := v8
PRJ_DESC := Open source JavaScript engine
PRJ_DEPS := v8
PRJ_TYPE := lib
PRJ_INCS := v8/include v8/src
PRJ_LIBS :=
PRJ_DEFS := ENABLE_DEBUGGER_SUPPORT
PRJ_OBJR := _deps
#PRJ_LINK := cmdfile

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk


#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := foundation
BLD_EXT := cc
BLD_EXE := cpp
BLD_DEX := 		   
BLD_FSX := platform-
BLD_FEX := d8 d8-posix d8-readline i18n v8dll-main
BLD_DIR := $(LIBROOT)/v8/src
ifeq ($(TGT_PLATFORM),windows)
BLD_FEX := $(BLD_FEX) d8-posix
else
BLD_FEX := $(BLD_FEX) d8-windows
endif
include $(BBBROOT)/v1/build.mk

BLD := platform
BLD_EXT := cc
BLD_EXE := cpp
BLD_FEX :=
ifeq ($(TGT_BITS),32b)
BLD_INC := v8/src/ia32
BLD_DIR := $(LIBROOT)/v8/src/ia32
else
BLD_INC := v8/src/x64
BLD_DIR := $(LIBROOT)/v8/src/x64
endif
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

