
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := poco
PRJ_DESC := Open source C++ class libraries and frameworks
PRJ_DEPS := poco
PRJ_TYPE := lib
PRJ_INCS := poco/Foundation/include poco/Net/include zlib \
			openssl/include poco/Crypto/include poco/NetSSL_OpenSSL/include \
			poco/WebWidgets/include poco/Util/include poco/XML/include poco/Zip/include
PRJ_LIBS :=
PRJ_DEFS := HAVE_MEMMOVE POCO_NO_AUTOMATIC_LIBS XML_STATIC POCO_STATIC \
			PCRE_STATIC OPENSSL_NO_ENGINE OPENSSL_NOWINSOCK2
PRJ_OBJR := _deps
PRJ_LINK := cmdfile

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

#ifeq ($(TGT_PROC),64b)
#	PRJ_DEFS := $(PRJ_DEFS) POCO_PTR_IS_64_BIT POCO_LONG_IS_64_BIT
#endif

ifeq ($(TGT_PLATFORM),windows)

	ifneq ($(TGT_UNICODE),)
		PRJ_DEFS := $(PRJ_DEFS) POCO_WIN32_UTF8
	endif

	ifeq ($(TGT_COMPILER),gcc)
		PRJ_DEFS := $(PRJ_DEFS) WC_NO_BEST_FIT_CHARS=0x00000400 MCW_RC=_MCW_RC \
								RC_DOWN=_RC_DOWN RC_UP=_RC_UP RC_NEAR=_RC_NEAR RC_CHOP=_RC_CHOP \
								SW_INEXACT=0x00000001 SW_UNDERFLOW=0x00000002 SW_OVERFLOW=0x00000004 \
								SW_ZERODIVIDE=0x00000008 SW_INVALID=0x00000010 SW_DENORMAL=0x00080000
	endif

else ifeq ($(TGT_PLATFORM),android)

	PRJ_DEFS := $(PRJ_DEFS) POCO_OS_FAMILY_UNIX POCO_NO_FPENVIRONMENT \
							POCO_NO_NAMEDEVENTS POCO_NO_RWLOCKS \
							POCO_NO_SHAREDMEMORY

endif

ifeq ($(TGT_TYPE),debug)
$(LIBROOT)/poco/Foundation/include/pcre_printint.src: $(BLDOUT)
	( echo "static void pcre_printint(pcre *external_re, FILE *f, BOOL print_lengths) {}" ) > $@
BLDOUT := $(LIBROOT)/poco/Foundation/include/pcre_printint.src
endif

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := foundation
BLD_DEX := 		   
BLD_FSX := _
BLD_FEX := OpcomChannel	SyslogChannel
BLD_DIR := $(LIBROOT)/poco/Foundation/src
ifneq ($(BLD_PLATFORM),windows)
	BLD_FEX := $(BLD_FEX) EventLogChannel WindowsConsoleChannel
endif
include $(BBBROOT)/v1/build.mk

BLD := subs
BLD_DIR := $(LIBROOT)/poco
BLD_SUB := Net/src Crypto/src NetSSL_OpenSSL/src Util/src XML/src
BLD_FEX := $(BLD_FEX) XML/src/xmlparse
ifneq ($(TGT_PLATFORM),windows)
	BLD_FEX := $(BLD_FEX) Util/src/WinRegistryConfiguration Util/src/WinRegistryKey Util/src/WinService
endif
include $(BBBROOT)/v1/build.mk

BLD := c
BLD_EXT := c
BLD_DIR := $(LIBROOT)/poco
BLD_SUB := Foundation/src XML/src
BLD_FEX := adler32 compress crc32 deflate gzio \
		   infback inffast inffixed inflate inftrees \
		   trees ucp zutil
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

