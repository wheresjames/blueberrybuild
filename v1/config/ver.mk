
# Build number
ifeq ($(VER_BUILD),)
	VER_BUILD := $(shell date +'%y.%m.%d.%H%M')
endif

# File name string from build number
ifeq ($(VER_FILE),)
	VER_FILE := $(subst .,_,$(VER_BUILD))
endif

# Version number
ifeq ($(VER),)
	VER := $(VER_BUILD)
endif

