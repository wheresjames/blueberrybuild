
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := libav
PRJ_DESC := Audio and video processing tools
PRJ_DEPS := libav
PRJ_TYPE := lib
PRJ_INCS := libav
PRJ_LIBS :=
PRJ_DEFS :=
PRJ_OBJR := _deps
#PRJ_LINK := cmdfile

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

# Create include files
$(LIBROOT)/libav/libavutil/avconfig.h: $(BLDOUT)
	cd "$(LIBROOT)/libav"; ./configure --enable-cross-compile \
									   --target-os=mingw32 --arch=x86 \
									   --cross-prefix=$(PRE)
BLDOUT := $(LIBROOT)/libav/libavutil/avconfig.h

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := def
BLD_EXT := c
BLD_DIR := $(LIBROOT)/libav
BLD_SUB := libavcodec
BLD_DPT := 
BLD_DEX := 
BLD_FEX := 
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

