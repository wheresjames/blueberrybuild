
#-------------------------------------------------------------------
# Creates a native OS path (this is for cygwin with absolute paths)
#-------------------------------------------------------------------
ifeq ($(CYGBLD)$(CFG_ABSROOT),11)
	NPAT = $(shell cygpath -m $(1))
else
	NPAT = $(1)
endif

#-------------------------------------------------------------------
# Output roots
#-------------------------------------------------------------------
# bin/<build>/_obj/<group>/<project>
DIR_BINROOT := $(BINROOT)/$(TGT_DESC)
ifeq ($(PRJ_OBJR),)
	DIR_OBJROOT := $(DIR_BINROOT)/_obj/$(PRJ_NAME)
else
	DIR_OBJROOT := $(DIR_BINROOT)/_obj/$(PRJ_OBJR)/$(PRJ_NAME)
endif

# Add to required directories
REQ_DIRS := $(REQ_DIRS) $(DIR_OBJROOT)

#-------------------------------------------------------------------
# Debug
#-------------------------------------------------------------------
ifneq ($(MAKEDBG),)
$(info =------------------------ dir.mk ----------------------------)
$(info = Root Dir : $(BLDROOT) )
$(info = Make Dir : $(MAKROOT) )
$(info = Lib Dir  : $(LIBROOT) )
$(info = Out Dir  : $(DIR_OBJROOT) )
ifneq ($(CYGBLD),)
$(info =--------- CYGWIN -----------)
$(info = Root Dir : $(call NPAT,$(BLDROOT) ))
$(info = Make Dir : $(call NPAT,$(MAKROOT) ))
$(info = Lib Dir  : $(call NPAT,$(LIBROOT) ))
$(info = Out Dir  : $(call NPAT,$(DIR_OBJROOT) ))
endif
$(info =------------------------------------------------------------)
endif
