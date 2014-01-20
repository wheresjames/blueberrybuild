
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := libav
PRJ_DESC := Audio and video processing tools
PRJ_DEPS := libav
PRJ_TYPE := lib
PRJ_INCS := libav zlib
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
ifeq ($(TGT_PLATFORM),posix)
$(LIBROOT)/libav/libavutil/avconfig.h: $(BLDCHAIN)
	cd "$(LIBROOT)/libav"; ./configure --enable-cross-compile \
									   --target-os=linux --arch=x86 \
									   --cross-prefix=$(PRE)
BLDCHAIN := $(LIBROOT)/libav/libavutil/avconfig.h
else ifeq ($(TGT_PLATFORM)-$(CYGBLD),windows-1)
$(LIBROOT)/libav/libavutil/avconfig.h: $(BLDCHAIN)
	cd "$(LIBROOT)/libav"; ./configure --enable-cross-compile \
									   --target-os=mingw32 --arch=x86 \
									   --cross-prefix=$(PRE)
BLDCHAIN := $(LIBROOT)/libav/libavutil/avconfig.h
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := def
BLD_EXT := c
BLD_DIR := $(LIBROOT)/libav
BLD_SUB := libavcodec libavformat libavutil
#BLD_SUB := libavutil
BLD_DPT := 
BLD_FSX := lib _template dxva2 vaapi vda_ vdpau
BLD_FEX := libavcodec/aacpsdata libavcodec/hpeldsp libavcodec/mpegvideo_xvmc \
		   libavformat/avisynth libavformat/rtmpdh libavformat/rtmphttp \
		   libavformat/rtmpcrypt libavformat/sctp
#BLD_FEX := libavcodec/4xm libavcodec/8bps libavcodec/8svx libavcodec/a64multienc \
#		   libavcodec/aac_ac3_parser
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

