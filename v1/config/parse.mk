
#-------------------------------------------------------------------
# Platform
#-------------------------------------------------------------------
$(PARSE_TO)_PLATFORM := $(strip $(foreach t,windows posix mac iphone android,$(findstring $(t),$(PARSE_IN))))
ifeq ($($(PARSE_TO)_PLATFORM),)
	ifneq ($(findstring mingw,$(PRE)),)
		$(PARSE_TO)_PLATFORM := windows
	else ifneq ($(strip $(foreach t,win64 win,$(findstring $(t),$(PARSE_IN)))),)
		$(PARSE_TO)_PLATFORM := windows
	else
		$(PARSE_TO)_PLATFORM := posix
	endif
endif

#-------------------------------------------------------------------
# Processor type
#-------------------------------------------------------------------

$(PARSE_TO)_PROC := $(strip $(foreach t,x86 x64 arm,$(findstring $(t),$(PARSE_IN))))
$(PARSE_TO)_BITS := $(strip $(foreach t,16b 32b 64b 128b,$(findstring $(t),$(PARSE_IN))))

ifeq ($($(PARSE_TO)_PROC),)
	$(PARSE_TO)_PROC := x86
else
	# Fix this historic clusterf
	ifeq ($($(PARSE_TO)_PROC),x64)
		$(PARSE_TO)_PROC := x86
		$(PARSE_TO)_BITS := 64b
	endif
endif

ifeq ($($(PARSE_TO)_BITS),)
	ifneq ($(findstring win64,$(PARSE_IN)),)
		$(PARSE_TO)_BITS := 64b
	else
		$(PARSE_TO)_BITS := 32b
	endif
endif

#-------------------------------------------------------------------
# Link type - static / shared
#-------------------------------------------------------------------
ifneq ($(findstring static,$(PARSE_IN)),)
	$(PARSE_TO)_LINK := static
else
	ifneq ($(findstring shared,$(PARSE_IN)),)
		$(PARSE_TO)_LINK := shared
	endif
endif

#-------------------------------------------------------------------
# Set a default link type if not specified
#-------------------------------------------------------------------
ifndef $(PARSE_TO)_LINK
	ifeq ($($(PARSE_TO)_PLATFORM),windows)
		$(PARSE_TO)_LINK := static
	else
		$(PARSE_TO)_LINK := shared
	endif
endif

#-------------------------------------------------------------------
# Compiler type supported at the moment
#-------------------------------------------------------------------
$(PARSE_TO)_COMPILER := $(strip $(foreach t,msvc gcc mingw intel,$(findstring $(t),$(PARSE_IN))))
ifeq ($($(PARSE_TO)_COMPILER),)
	$(PARSE_TO)_COMPILER := gcc
endif
ifeq ($($(PARSE_TO)_COMPILER),msvc)
	$(PARSE_TO)_COMPILER_TYPE := $(strip $(foreach t,msvc8 msvc9 msvc10 msvc11,$(findstring $(t),$(PARSE_IN))))
endif
ifeq ($($(PARSE_TO)_COMPILER_TYPE),)
	$(PARSE_TO)_COMPILER_TYPE := $($(PARSE_TO)_COMPILER)
endif

#-------------------------------------------------------------------
# Debug version?
#-------------------------------------------------------------------
$(PARSE_TO)_TYPE := $(strip $(foreach t,debug,$(findstring $(t),$(PARSE_IN))))

#-------------------------------------------------------------------
# Debug version?
#-------------------------------------------------------------------
$(PARSE_TO)_CHARTYPE := $(strip $(foreach t,unicode multibyte,$(findstring $(t),$(PARSE_IN))))
ifeq ($($(PARSE_TO)_CHARTYPE),)
	$(PARSE_TO)_CHARTYPE := multibyte
endif

#-------------------------------------------------------------------
# Create a description string
#-------------------------------------------------------------------
$(PARSE_TO)_DESC := $($(PARSE_TO)_COMPILER_TYPE)-$($(PARSE_TO)_PLATFORM)-$($(PARSE_TO)_PROC)-$($(PARSE_TO)_BITS)-$($(PARSE_TO)_LINK)
ifneq ($($(PARSE_TO)_CHARTYPE),multibyte)
	$(PARSE_TO)_DESC := $($(PARSE_TO)_DESC)-$($(PARSE_TO)_CHARTYPE)
endif
ifneq ($($(PARSE_TO)_TYPE),)
	$(PARSE_TO)_DESC := $($(PARSE_TO)_DESC)-$($(PARSE_TO)_TYPE)
endif


