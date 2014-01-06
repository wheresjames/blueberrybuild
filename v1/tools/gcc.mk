
#-------------------------------------------------------------------
# Compiler paths
#-------------------------------------------------------------------
ifneq ($(GCCROOT),)
	PATH := $(GCCROOT)/bin:$(PATH)
endif

#-------------------------------------------------------------------
# Compiler options macros
#-------------------------------------------------------------------
$(BLD)_make_includes = $(foreach v,$(2),-I"$(1)$(v)")
$(BLD)_make_defines = $(foreach v,$(1),-D$(v))

#-------------------------------------------------------------------
# Switches
#-------------------------------------------------------------------
ifeq ($(TGT_TYPE),debug)
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -s -DDEBUG=1 -D_DEBUG -Wall
else
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -O3 -s -DNDEBUG=1 -Wall
endif

ifeq ($(TGT_BITS),64b)
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -m64
endif

#-------------------------------------------------------------------
# GCC Compiler
#-------------------------------------------------------------------
#
# -c        Compile or assemble the source files, but do not link.
# -o [f]    Place output in file [f].
# -D [n]    Predefine [n] as a macro.
# -I [d]    Add the directory [d] to the list of directories to be 
#           searched for header files.
# -Wall     Turns on all optional warnings which are desirable for 
#           normal code.
#
# -O0       No optimizations.  Reduce compilation time and make 
#           debugging produce the expected results. This is the 
#           default. 
# -O / -O1  With -O, the compiler tries to reduce code size and 
#           execution time, without performing any optimizations 
#           that take a great deal of compilation time. 
# -O2       Optimize even more. GCC performs nearly all supported 
#           optimizations that do not involve a space-speed 
#           tradeoff. As compared to -O, this option increases both 
#           compilation time and the performance of the generated 
#           code. 
# -O3       Optimize yet more. -O3 turns on all optimizations 
#           specified by -O2 and also turns on the optimizations 
#           that do not involve a space-speed tradeoff.
#
# -MF       write the generated dependency rule to a file
# -MG       assume missing headers will be generated and don't stop 
#           with an error
# -MM       generate dependency rule for prerequisite, skipping 
#           system headers
# -MP       add phony target for each header to prevent errors when 
#           header is missing
# -MT       add a target to the generated dependency
# -MMD      Like -MD except mention only user header files, not 
#           system header files. 
#
#-------------------------------------------------------------------

# C compiler
ifeq ($($(BLD)_EXT),c)

	$(BLD)_make_cmd = $(PRE)gcc -c -MMD -MT $(1) $($(BLD)_CFLAGS) $(4) "$(2)" -o "$(3)"
	$(BLD)_EXT_OUT := o

# c++ compiler
else ifeq ($($(BLD)_EXT),cpp)

	$(BLD)_make_cmd = $(PRE)g++ -c -MMD -MT $(1) $($(BLD)_CFLAGS) $(4) "$(2)" -o "$(3)"
	$(BLD)_EXT_OUT := o

# Library linker
else ifeq ($($(BLD)_EXT),lib)

	$(BLD)_make_cmd = $(PRE)ar cq $(2) $(1)
	$(BLD)_make_cmd_file = $(PRE)ar cq $(2) @$(1)

endif

#ifneq ($(SYSROOT),)
#	CFG_SYOPTS := $(CFG_SYOPTS) --sysroot=$(SYSROOT)
#endif
#
#ifneq ($(SYSHEADERS),)
#	CFG_SYOPTS := $(CFG_SYOPTS) --headers=$(SYSHEADERS)
#endif
#
#CFG_PP := $(PRE)g++ -c $(CFG_SYOPTS)
#CFG_CC := $(PRE)gcc -c $(CFG_SYOPTS)
#CFG_LD := $(PRE)g++
#CFG_AR := $(PRE)ar -cr
#CFG_DT := $(PRE)dlltool
#CFG_DP := $(PRE)makedepend
#CFG_AS := $(PRE)as
#CFG_RC := $(PRE)windres
#
##CFG_LD_FLAGS := $(CFG_LD_FLAGS) -export-all-symbols
#CFG_PP_FLAGS := $(CFG_PP_FLAGS) -MMD -Wall -fno-strict-aliasing -D__int64="long long"
#
#ifneq ($(TGT_PLATFORM),windows)
#	CFG_CC_FLAGS := $(CFG_PP_FLAGS) -fPIC -DPIC
#	CFG_PP_FLAGS := $(CFG_PP_FLAGS) -fPIC -DPIC
##	CFG_PP_FLAGS := $(CFG_PP_FLAGS) -fPIE -DPIE
##	CFG_LD_FLAGS := $(CFG_LD_FLAGS) -pie
#endif
#
#
## GUI type?
#ifneq ($(PRJ_GUIT),)
#	ifeq ($(TGT_PLATFORM),windows)
#		CFG_LD_FLAGS := $(CFG_LD_FLAGS) -mwindows
#	endif
#endif
#
#ifeq ($(TGT_PLATFORM),windows)
#	ifeq ($(TGT_PROC),x64)
#		CFG_PP_FLAGS := $(CFG_PP_FLAGS) -fno-leading-underscore
#	endif
#endif
#
## static build
#ifeq ($(TGT_LINK),static)
#	CFG_CC_FLAGS := $(CFG_PP_FLAGS) -static
#	CFG_PP_FLAGS := $(CFG_PP_FLAGS) -static
#	CFG_LD_FLAGS := $(CFG_LD_FLAGS) -static -static-libgcc -static-libstdc++
#ifneq ($(TGT_PLATFORM),windows)
#		CFG_LD_LASTO := $(CFG_LD_LASTO) -lpthread -lrt
#endif
#	
## shared build
#else
#	ifneq ($(TGT_PLATFORM),windows)
#		CFG_CC_FLAGS := $(CFG_PP_FLAGS) -shared
#		CFG_PP_FLAGS := $(CFG_PP_FLAGS) -shared
##		CFG_LD_FLAGS := $(CFG_LD_FLAGS)
#		CFG_LD_LASTO := $(CFG_LD_LASTO) -lpthread -lrt
#	else
#		CFG_LD_FLAGS := $(CFG_LD_FLAGS) -shared -shared-libgcc
#	endif
#endif
#
## debug build
#ifneq ($(DBG),)
#	CFG_CC_FLAGS := $(CFG_PP_FLAGS) -g -DDEBUG -D_DEBUG
#	CFG_PP_FLAGS := $(CFG_PP_FLAGS) -g -DDEBUG -D_DEBUG
#	CFG_LD_FLAGS := $(CFG_LD_FLAGS) -g
#endif
#
## Shared library
#ifeq ($(PRJ_TYPE),dll)
#	ifeq ($(TGT_PLATFORM),windows)
#		CFG_TGT_EXT := .dll
#		CFG_LD_FLAGS := $(CFG_LD_FLAGS) -Wl,-enable-auto-import
#	else
#		CFG_TGT_EXT := .so
#		CFG_PP_FLAGS := $(CFG_PP_FLAGS)
#		ifeq ($(TGT_LINK),static)
#			CFG_LD_FLAGS := $(CFG_LD_FLAGS) -module
#		else
#			CFG_LD_FLAGS := $(CFG_LD_FLAGS) -shared -module
#			#CFG_LD_FLAGS := $(CFG_LD_FLAGS) -shared -module -rdynamic -Wl,-E -Wl,--export-dynamic
#		endif
#	endif
#else
#	ifeq ($(PRJ_TYPE),lib)
#		ifeq ($(TGT_PLATFORM),windows)
#			CFG_TGT_EXT := .lib
#			CFG_LD_FLAGS := $(CFG_LD_FLAGS) -Wl,-enable-auto-import
#		else
#			CFG_TGT_PRE := lib
#			CFG_TGT_EXT := .a
#		endif
#	else
#		ifeq ($(TGT_PLATFORM),windows)
#			CFG_TGT_EXT := .exe
#			CFG_LD_FLAGS := $(CFG_LD_FLAGS) -Wl,-enable-auto-import
#		else
#			CFG_TGT_EXT :=
#			CFG_LD_FLAGS := $(CFG_LD_FLAGS)
#		endif
#	endif
#endif
#
