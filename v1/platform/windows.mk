
WINVER := 0x0502

CFG_DEFS := $(CFG_DEFS) WINVER=$(WINVER) _WIN32_WINNT=$(WINVER)
# CFG_DEFS := $(CFG_DEFS) _WINNT=$(WINVER) WINNT=$(WINVER)
# CFG_DEFS := $(CFG_DEFS) NTDDI_VERSION=NTDDI_WINXP
	
ifeq ($(TGT_BITS),64b)
	CFG_DEFS := $(CFG_DEFS) WIN64 _WIN64
else
	CFG_DEFS := $(CFG_DEFS) WIN32 _WIN32
endif

ifeq ($(PRJ_TYPE),lib)
	CFG_OUTPRE := 
	CFG_OUTEXT := .lib
else
	CFG_OUTPRE := 
	CFG_OUTEXT := .exe
endif

ifeq ($(TGT_TYPE),debug)
	CFG_OUTEXT := _d$(CFG_OUTEXT)
endif

ifneq ($(findstring gui,$(PRJ_TYPE)),)
	ifeq ($(BUILD),vs)
		CFG_LFLAGS := $(CFG_LFLAGS) /SUBSYSTEM:WINDOWS /ENTRY:mainCRTStartup
	else
		CFG_LFLAGS := $(CFG_LFLAGS) -mwindows
	endif
endif


