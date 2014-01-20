
#-------------------------------------------------------------------
# Source file location
#-------------------------------------------------------------------

ifeq ($($(BLD)_ONE),.)
	$(BLD)_FUL := $($(BLD)_DIR)
	TAG :=
else
	$(BLD)_FUL := $($(BLD)_DIR)/$($(BLD)_ONE)
	TAG := $(BLD)_$(subst .,_,$($(BLD)_ONE))
endif

#-------------------------------------------------------------------
# Include directories
#-------------------------------------------------------------------
#$(BLD)$(TAG)_INCLUDES := $($(BLD)_INCLUDES) $(call $(BLD)_make_includes,,$(call NPAT,$($(BLD)_FUL)))
$(BLD)$(TAG)_INCLUDES := $($(BLD)_INCLUDES)

#-------------------------------------------------------------------
# Source files
#-------------------------------------------------------------------

# Get a list of source files
$(BLD)_SOURCES := $(foreach file,$($(BLD)_FPT),$(wildcard $($(BLD)_FUL)/$(file).$($(BLD)_EXT)))

# Filter out files containing string _FSX
ifneq ($($(BLD)_FSX),)
	$(BLD)_SOURCE_FILES := $(foreach f,$($(BLD)_SOURCES),$(subst $($(BLD)_FUL)/,,$(f)))
	$(BLD)_SOURCE_FILTR := $(call filter-out-str,$($(BLD)_FSX),$($(BLD)_SOURCE_FILES))
	$(BLD)_SOURCES := $(foreach f,$($(BLD)_SOURCE_FILTR),$($(BLD)_FUL)/$(f))
endif

# Exclude certain files
ifneq ($($(BLD)_FEX),)
	$(BLD)_EXCLUDE := $(foreach file,$($(BLD)_FEX),$($(BLD)_DIR)/$(file).$($(BLD)_EXT))
	$(BLD)_SOURCES := $(filter-out $($(BLD)_EXCLUDE),$($(BLD)_SOURCES))
endif

# Human readable list of final file list
$(BLD)_SORUCES_HR := $(foreach f,$($(BLD)_SOURCES),$(\n)    $(subst $($(BLD)_FUL)/,,$(f)))

#-------------------------------------------------------------------
# Output directory
#-------------------------------------------------------------------
ifeq ($(TAG),)
	$(BLD)_OBJROOT := $(DIR_OBJROOT)/$(BLD)
else
	$(BLD)_OBJROOT := $(DIR_OBJROOT)/$(BLD)/$($(BLD)_ONE)
endif

#-------------------------------------------------------------------
# Output Files
#-------------------------------------------------------------------
$(BLD)_OUTFILES := $(subst $($(BLD)_FUL)/,$($(BLD)_OBJROOT)/,$($(BLD)_SOURCES:.$($(BLD)_EXT)=.$($(BLD)_EXT_OUT)))
$(BLD)_OUTFILES_HR := $(foreach f,$($(BLD)_OUTFILES),$(\n)    $(subst $($(BLD)_OBJROOT)/,,$(f)))

#-------------------------------------------------------------------
# Include dependency files
#-------------------------------------------------------------------
ifneq ($(CYGBLD)$(CFG_ABSROOT),11)
-include $(wildcard $($(BLD)_OBJROOT)/*.d)
endif

#-------------------------------------------------------------------
# Show config info
#-------------------------------------------------------------------
ifneq ($(MAKEDBG),)
$(info =--------------------- build-dir.mk -------------------------)
$(info = Source   : $($(BLD)_FUL) )
$(info = Tag      : $(TAG) )
ifneq ($(MAKEDBGFILES),)
$(info = Input    : $($(BLD)_FUL) $($(BLD)_SORUCES_HR) )
$(info = Output   : $($(BLD)_OBJROOT) $($(BLD)_OUTFILES_HR) )
endif
$(info =------------------------------------------------------------)
endif

# Export variable name, thanks MadScientist ;)
$($(BLD)_OBJROOT)/%.$($(BLD)_EXT_OUT) : BLD := $(BLD)
$($(BLD)_OBJROOT)/%.$($(BLD)_EXT_OUT) : TAG := $(TAG)

# Make output directory
$($(BLD)_OBJROOT)/mkdir.log:
	-mkdir -p $(subst /mkdir.log,,$@)
	@echo "$(VER) / $(VER_BUILD)" >> $@

REQ_DIRS := $(REQ_DIRS) $($(BLD)_OBJROOT)/mkdir.log

# How to build these sources
$($(BLD)_OBJROOT)/%.$($(BLD)_EXT_OUT) : $($(BLD)_FUL)/%.$($(BLD)_EXT)
ifneq ($(MAKEDBG),)
	$(call $(BLD)_make_cmd,$@,$(call NPAT,$<),$(call NPAT,$@), $($(BLD)_DEFINES) $($(BLD)$(TAG)_INCLUDES) )
else
	@echo ": $(call NPAT,$<)"
	@$(call $(BLD)_make_cmd,$@,$(call NPAT,$<),$(call NPAT,$@), $($(BLD)_DEFINES) $($(BLD)$(TAG)_INCLUDES) )
endif

# Chain into dependencies
#BLDCHAIN := $($(BLD)_OUTFILES)

# Add to linker items?
ifeq ($(BLD_NOLINK),)
LINK_FILES := $(LINK_FILES) $($(BLD)_OUTFILES)
endif

BLD_NOLINK :=
