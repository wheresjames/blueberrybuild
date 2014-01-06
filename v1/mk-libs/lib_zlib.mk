
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := zlib
PRJ_DESC := Compression Library
PRJ_DEPS := zlib
PRJ_TYPE := lib
PRJ_INCS := 
PRJ_LIBS :=
PRJ_DEFS := 
PRJ_OBJR := _deps

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := def
BLD_EXT := c
BLD_DIR := $(LIBROOT)/zlib
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

