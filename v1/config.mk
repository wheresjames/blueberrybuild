
#-------------------------------------------------------------------
# default target
#-------------------------------------------------------------------
.PHONY: default_target
default_target: all

#-------------------------------------------------------------------
# Configure base paths
#-------------------------------------------------------------------
BBBVDIR ?= v1
LIBPATH ?= lib
BINPATH ?= bin

BLDROOT ?= $(BBBROOT)/..
MAKROOT ?= $(BBBROOT)/$(BBBVDIR)
LIBROOT ?= $(BLDROOT)/$(LIBPATH)
BINROOT ?= $(BLDROOT)/$(BINPATH)

#-------------------------------------------------------------------
# Check dependencies
#-------------------------------------------------------------------

# Each directory in PRJ_DEPS must exist in LIBROOT
ifneq ($(strip $(PRJ_DEPS)),)
	EXISTS_LIBSRC := $(subst $(LIBROOT)/,,$(wildcard $(foreach dep,$(PRJ_DEPS),$(LIBROOT)/$(strip $(dep)))))
else
	EXISTS_LIBSRC := nodeps
endif

# Did we find all the dependencies
ifneq ($(strip $(EXISTS_LIBSRC)),$(strip $(PRJ_DEPS))) 
UNSUPPORTED := Missing $(filter-out $(strip $(EXISTS_LIBSRC)),$(strip $(PRJ_DEPS)))
include $(MAKROOT)/unsupported.mk
$(info = Required : $(PRJ_DEPS))
$(info = Found    : $(EXISTS_LIBSRC))
$(info -------------------------------------------------------------)
else

#-------------------------------------------------------------------
# Defines
#-------------------------------------------------------------------
include $(MAKROOT)/config/defs.mk

#-------------------------------------------------------------------
# Version information
#-------------------------------------------------------------------
include $(MAKROOT)/config/ver.mk

#-------------------------------------------------------------------
# Project name
#-------------------------------------------------------------------
ifeq ($(PRJ_NAME),)
	PRJ_NAME := unnamed_project_$(VER_FILE)
endif

#-------------------------------------------------------------------
# Parse target/build machine information
#-------------------------------------------------------------------

# Target machine
PARSE_IN := $(TGT)
PARSE_TO := TGT
include $(MAKROOT)/config/parse.mk

# build machine
ifneq ($(BLD),)
	PARSE_IN := $(BLD)
endif
PARSE_TO := BLD
include $(MAKROOT)/config/parse.mk

#-------------------------------------------------------------------
# Platform include
#-------------------------------------------------------------------
-include $(MAKROOT)/platform/$(TGT_PLATFORM).mk

#-------------------------------------------------------------------
# Check for cygwin
#-------------------------------------------------------------------
ifneq ($(findstring cygwin,$(BLD)),)
	CYGBLD := 1
endif
ifeq ($(CYGBLD),)
	ifneq ($(findstring cygdrive,$(PATH)),)
		CYGBLD := 1
	endif
endif

#-------------------------------------------------------------------
# Config details
#-------------------------------------------------------------------
$(info )
$(info =============================================================)
$(info = Building : $(PRJ_NAME) - $(PRJ_DESC) )
$(info =============================================================)
$(info = TGT      : $(TGT_DESC) )
$(info = BLD      : $(BLD_DESC) )
$(info = Version  : $(VER) )
$(info = Build #  : $(VER_BUILD) )
ifneq ($(CYGBLD),)
$(info = cygwin   : YES )
endif
$(info =------------------------------------------------------------)

#-------------------------------------------------------------------
# Directories
#-------------------------------------------------------------------
include $(MAKROOT)/config/dir.mk

endif


