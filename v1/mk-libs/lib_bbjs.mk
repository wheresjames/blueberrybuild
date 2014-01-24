
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := bbjs
PRJ_DESC := Javascript VM
PRJ_DEPS := bbjs

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

.PHONY all :
	$(MAKE) -C $(LIBROOT)/bbjs
