
# ifeq ($(TGT_BITS),64b)
	# CFG_DEFS := $(CFG_DEFS)
# else
	# CFG_DEFS := $(CFG_DEFS)
# endif

ifeq ($(PRJ_TYPE),lib)
	CFG_OUTPRE := lib
	CFG_OUTEXT :=
else
	CFG_OUTPRE :=
	CFG_OUTEXT :=
endif

ifeq ($(TGT_TYPE),debug)
	CFG_OUTEXT := _d$(CFG_OUTEXT)
endif

