
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

ifeq ($(ABORT_UNSUPPORTED),)

# What to build
BUILDDIRS := $(LIBROOT)/bbjs

.PHONY $(BUILDDIRS) :
	$(MAKE) $(MAKECMDGOALS) -C $@ 

.PHONY all: $(BUILDDIRS)
.PHONY rebuild: $(BUILDDIRS)
.PHONY clean: $(BUILDDIRS)

endif
