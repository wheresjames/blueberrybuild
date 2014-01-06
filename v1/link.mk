
ifeq ($(ABORT_UNSUPPORTED),)

#-------------------------------------------------------------------
# Add output files and directories into the dependency chain
#-------------------------------------------------------------------
$(REQ_DIRS) : $(BLDOUT)
$(LINK_FILES) : $(REQ_DIRS)
BLDOUT := $(LINK_FILES)

# Create native file system list
LINK_FILES_NPAT := $(foreach f,$(LINK_FILES),$(call NPAT,$(f)))

#-------------------------------------------------------------------
# Configure linker
#-------------------------------------------------------------------
BLD := LINKER
$(BLD)_EXT := $(PRJ_TYPE)
include $(MAKROOT)/tools/$(TGT_COMPILER).mk

LNK_FILELOG := $(DIR_OBJROOT)/$(PRJ_NAME)_log.txt
LNK_FILELST := $(DIR_OBJROOT)/$(PRJ_NAME)_objs.txt
LNK_OUTFILE := $(DIR_BINROOT)/$(PRJ_NAME).$(CFG_OUTEXT)
LNK_FILES_HR := $(foreach f,$(LINK_FILES_NPAT),$(\n)    $(f))

# Do we use a file to work around the windows command line limit?
ifeq ($(BLD_PLATFORM)-$(findstring cmdfile,$(PRJ_LINK)),windows-cmdfile)

LNK_CMDFILE := 1

#-------------------------------------------------------------------
# Create log file and remove object list file
#-------------------------------------------------------------------
$(LNK_FILELOG): $(BLDOUT)
	-rm $(LNK_FILELST)
	@echo "$(VER) / $(VER_BUILD)" > $(LNK_FILELOG)
BLDOUT := $(LNK_FILELOG)

#-------------------------------------------------------------------
# Create object list file
#-------------------------------------------------------------------
$(LNK_FILELST): $(BLDOUT)
	$(foreach v,$(LINK_FILES_NPAT),$(shell echo $(v)$(\n) >> $(LNK_FILELST)))
BLDOUT := $(LNK_FILELST)

#-------------------------------------------------------------------
# Output file
#-------------------------------------------------------------------
$(LNK_OUTFILE): $(BLDOUT)
ifneq ($(MAKEDBG),)
	$(call $(BLD)_make_cmd_file,$(call NPAT,$(LNK_FILELST)),$(call NPAT,$@))
else
	@echo $(call NPAT,$<)
	@$(call $(BLD)_make_cmd_file,$(call NPAT,$(LNK_FILELST)),$(call NPAT,$@))
endif

else

#-------------------------------------------------------------------
# Output file
#-------------------------------------------------------------------
$(LNK_OUTFILE): $(BLDOUT)
ifneq ($(MAKEDBG),)
	$(call $(BLD)_make_cmd,$(LINK_FILES_NPAT),$(call NPAT,$@))
else
	@echo $@
	@$(call $(BLD)_make_cmd,$(LINK_FILES_NPAT),$(call NPAT,$@))
endif

endif

BLDOUT := $(LNK_OUTFILE)

# Show config info
ifneq ($(MAKEDBG),)
$(info =------------------------ link.mk ---------------------------)
ifneq ($(LNK_CMDFILE),)
$(info = Log      : $(LNK_FILELOG) )
$(info = Obj List : $(LNK_FILELST) )
endif
$(info = Output   : $(LNK_OUTFILE) )
ifneq ($(MAKEDBGFILES),)
$(info = Input    : $(LNK_FILES_HR) )
endif
$(info =------------------------------------------------------------)
endif

all: $(BLDOUT)
	@echo 
	@echo = $(PRJ_NAME) - Build complete	
	@echo =------------------------------------------------------------
	@echo 

clean: 
	rm -Rf $(DIR_OBJROOT)
	
endif
