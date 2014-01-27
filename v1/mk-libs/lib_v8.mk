
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := v8
PRJ_DESC := Open source JavaScript engine
PRJ_DEPS := v8
PRJ_TYPE := lib
PRJ_INCS := v8/include v8/src
PRJ_LIBS :=
PRJ_DEFS := ENABLE_DEBUGGER_SUPPORT
PRJ_OBJR := _deps
#PRJ_LINK := cmdfile

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

ifneq ($(CYGBLD),)
	# Also include malloc.h in allocation.cc
	PRJ_DEFS := $(PRJ_DEFS) _aligned_malloc=__mingw_aligned_malloc \
							_aligned_free=__mingw_aligned_free \
							_CRT_RAND_S
							#errno_t=int
endif

# Select architecture
ifeq ($(TGT_PROC)-$(TGT_BITS),x86-32b)
	PRJ_DEFS := $(PRJ_DEFS) V8_TARGET_ARCH_IA32 V8_HOST_ARCH_IA32
else ifeq ($(TGT_PROC)-$(TGT_BITS),x86-64b)
	PRJ_DEFS := $(PRJ_DEFS) V8_TARGET_ARCH_X64 V8_HOST_ARCH_X64
endif

#ifeq ($(TGT_COMPILER),gcc)
#	PRJ_DEFS := $(PRJ_DEFS) __USE_GNU
#endif

$(LIBROOT)/v8/build/gyp/gyp: $(BLDCHAIN)
	cd "$(LIBROOT)/v8"; make dependencies
BLDCHAIN := $(LIBROOT)/v8/build/gyp/gyp

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := foundation
BLD_EXT := cc
BLD_EXE := cpp
BLD_DEX :=
BLD_FSX := platform- d8-
BLD_FEX := i18n mksnapshot v8dll-main
BLD_SUB := . utils platform extensions
BLD_DIR := $(LIBROOT)/v8/src
ifeq ($(TGT_PLATFORM),windows)
BLD_FLS := $(BLD_FLS) d8-windows platform-windows
else
BLD_FLS := $(BLD_FLS) d8-posix.cc platform-posix.cc
endif
include $(BBBROOT)/v1/build.mk

BLD := foundation_platform
BLD_EXT := cc
BLD_EXE := cpp
BLD_DEX := 		   
BLD_DIR := $(LIBROOT)/v8/src
ifeq ($(TGT_PLATFORM),windows)
BLD_FPT := $(BLD_FLS) d8-windows platform-win32
else
BLD_FPT := $(BLD_FLS) d8-posix platform-posix platform-linux
endif
include $(BBBROOT)/v1/build.mk

BLD := platform
BLD_EXT := cc
BLD_EXE := cpp
BLD_FEX :=
ifeq ($(TGT_BITS),32b)
BLD_INC := v8/src/ia32
BLD_DIR := $(LIBROOT)/v8/src/ia32
else
BLD_INC := v8/src/x64
BLD_DIR := $(LIBROOT)/v8/src/x64
endif
include $(BBBROOT)/v1/build.mk

BLD := native
BLD_EXT := cc
BLD_EXE := cpp
BLD_DIR := $(LIBROOT)/v8/out/native/obj/gen
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

