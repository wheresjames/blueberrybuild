
ifeq ($(ABORT_UNSUPPORTED),)

#-------------------------------------------------------------------
# Input parameters
#-------------------------------------------------------------------

# Tool executable
$(BLD)_EXE := $(BLD_EXE)
BLD_EXE :=

# Source patterns
$(BLD)_FPT := $(BLD_FPT)
BLD_FPT :=

# File extensions to build
$(BLD)_EXT := $(BLD_EXT)
BLD_EXT :=

# Source file root
$(BLD)_DIR := $(BLD_DIR)
BLD_DIR :=

# Source sub directories
$(BLD)_SUB := $(BLD_SUB)
BLD_SUB :=

# Source directory patterns
$(BLD)_DPT := $(BLD_DPT)
BLD_DPT :=

# Exclude directories patterns
$(BLD)_DEX := $(BLD_DEX)
BLD_DEX :=

# Maximum depth to search
$(BLD)_MAX := $(BLD_MAX)
BLD_MAX :=

# Files to exclude
$(BLD)_FEX := $(BLD_FEX)
BLD_FEX :=

# Exclude files containing this sub-string
$(BLD)_FSX := $(BLD_FSX)
BLD_FSX :=

# Includes for this specific project
$(BLD)_INC := $(BLD_INC)
BLD_INC :=

# Tool set
$(BLD)_TOOL := $(BLD_TOOL)
BLD_TOOL :=

#-------------------------------------------------------------------
# Defaults
#-------------------------------------------------------------------

# Default compiler
ifeq ($($(BLD)_TOOL),)
	$(BLD)_TOOL := $($(PARSE_TO)_COMPILER)
endif

# use 'cpp' as default extension
ifeq ($($(BLD)_EXT),)
	$(BLD)_EXT := cpp
endif

# Default executable
ifeq ($($(BLD)_EXE),)
	$(BLD)_EXE := $($(BLD)_EXT)
endif

# Default file pattern
ifeq ($($(BLD)_FPT),)
	$(BLD)_FPT := *
endif

# Default to current directory
ifeq ($($(BLD)_SUB),)
	$(BLD)_SUB := .
endif

# Default build depth
ifeq ($($(BLD)_MAX),)
	$(BLD)_MAX := 1
endif

#-------------------------------------------------------------------
# Initialize tools
#-------------------------------------------------------------------
include $(MAKROOT)/tools/$($(BLD)_TOOL).mk

#-------------------------------------------------------------------
# Defines
#-------------------------------------------------------------------
$(BLD)_DEFINES := $(call $(BLD)_make_defines,$(PRJ_DEFS))
$(BLD)_DEFINES := $($(BLD)_DEFINES) $(call $(BLD)_make_defines,$(CFG_DEFS))

#-------------------------------------------------------------------
# Include directories
#-------------------------------------------------------------------
$(BLD)_INCLUDES := $($(BLD)_INCLUDES) $(call $(BLD)_make_includes,$(call NPAT,$(LIBROOT))/,$($(BLD)_INC))
$(BLD)_INCLUDES := $($(BLD)_INCLUDES) $(call $(BLD)_make_includes,$(call NPAT,$(LIBROOT))/,$(PRJ_INCS))

#-------------------------------------------------------------------
# Source file directories
#-------------------------------------------------------------------

# Wild card sub directories?
ifneq ($($(BLD)_DPT),)

	# Find directories using a wildcard
	$(BLD)_FND := $(foreach p,$($(BLD)_DPT),$(shell find $($(BLD)_DIR) -maxdepth $($(BLD)_MAX) -type d -name '$(p)'))
	$(BLD)_FRS := $(foreach d,$($(BLD)_FND),$(subst $($(BLD)_DIR),,$(subst $($(BLD)_DIR)/,,$(d))))
	
	# Directories to exclude
	ifneq ($($(BLD)_DEX),)
		$(BLD)_FRS := $(filter-out $($(BLD)_DEX),$($(BLD)_FRS))
	endif

$(BLD)_SUB := $($(BLD)_SUB) $($(BLD)_FRS)

#$(info FIND $($(BLD)_FND))
#$(info DIRS $($(BLD)_SUB))
#$(info RESS $($(BLD)_XXX))

endif

#-------------------------------------------------------------------
# Show config info
#-------------------------------------------------------------------
ifneq ($(MAKEDBG),)
$(info =----------------------- build.mk --------------------------)
$(info = Ext          : $($(BLD)_EXT) )
$(info = Tool         : $($(BLD)_TOOL) )
$(info = Invoke       : $($(BLD)_CC) )
$(info = Source       : $($(BLD)_DIR) )
$(info = Sub Dirs     : $($(BLD)_SUB) )
$(info = Defines      : $($(BLD)_DEFINES) )
$(info = Includes     : $($(BLD)_INCLUDES) )
$(info = Exc Dirs     : $($(BLD)_DEX) )
$(info = Exc Files    : $($(BLD)_FEX) )
$(info = Exc Files Sub: $($(BLD)_FSX) )
$(info =------------------------------------------------------------)
endif

# Command that handles each individual directory
$(BLD)_build_dir = $(eval $(BLD)_ONE := $(1)) $(eval include $(MAKROOT)/build-dir.mk)

# Call make file for each sub directory
$(foreach d,$($(BLD)_SUB),$(call $(BLD)_build_dir,$(d)))

endif
