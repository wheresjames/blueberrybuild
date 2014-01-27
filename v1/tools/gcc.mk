
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
$(BLD)_make_libs = $(foreach v,$(1),-l"$(v)")
$(BLD)_make_lib_paths = $(foreach v,$(1),-L"$(v)")
$(BLD)_make_defines = $(foreach v,$(1),-D$(v))

# x86_64-w64-mingw32-g++ -s -export-all-symbols -fno-leading-underscore -static-libgcc -static-libstdc++ -static    ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/def/stdafx.obj ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/def/join.obj   ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/_rc/ver.obj   -o ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/join.exe    -L../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static   -loexlib    -lole32 -lgdi32 -lws2_32 -lavicap32 -lmsvfw32
# x86_64-w64-mingw32-g++ -s -export-all-symbols -fno-leading-underscore -static-libgcc -static-libstdc++ -static    ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/def/stdafx.obj ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/def/join.obj   ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/_0_obj/join/_rc/ver.obj   -o ../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static/join.exe    -L../../../../deftbuild/v1/../../bin3/windows-gcc-win64-x64-mingw64-static   -loexlib    -lole32 -lgdi32 -lws2_32 -lavicap32 -lmsvfw32

#-------------------------------------------------------------------
# Switches - -std=c99 -Wall
#-------------------------------------------------------------------

ifeq ($(TGT_TYPE),debug)
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -s -DDEBUG=1 -D_DEBUG
	$(BLD)_LFLAGS := $($(BLD)_LFLAGS) -g
	$(BLD)_OUTPRE := $(CFG_OUTPRE)
	$(BLD)_OUTEXT := $(CFG_OUTEXT)
else
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -s -DNDEBUG=1 -O3
	ifneq ($(PRJ_TYPE),dll)
		$(BLD)_LFLAGS := $($(BLD)_LFLAGS) -s
	endif
	$(BLD)_OUTPRE := $(CFG_OUTPRE)
	$(BLD)_OUTEXT := $(CFG_OUTEXT)
endif

ifeq ($(TGT_BITS),64b)
	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -m64
endif

ifeq ($(TGT_LINK),static)
	$(BLD)_LFLAGS := $($(BLD)_LFLAGS) -static -export-all-symbols
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
#           trade off. As compared to -O, this option increases both 
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
ifeq ($($(BLD)_EXE),c)

	$(BLD)_make_cmd = $(PRE)gcc -c -MMD -MT $(1) $($(BLD)_CFLAGS) $(4) "$(2)" -o "$(3)"
	$(BLD)_EXT_OUT := o

# c++ compiler
else ifeq ($($(BLD)_EXE),cpp)

	$(BLD)_CFLAGS := $($(BLD)_CFLAGS) -fpermissive

	$(BLD)_make_cmd = $(PRE)g++ -c -MMD -MT $(1) $($(BLD)_CFLAGS) $(4) "$(2)" -o "$(3)"
	$(BLD)_EXT_OUT := o

# Library linker
else ifeq ($($(BLD)_EXE),lib)

	$(BLD)_make_cmd = $(PRE)ar cq $(2) $(1)
	$(BLD)_make_cmd_file = $(PRE)ar cq $(2) @$(1)

else ifeq ($($(BLD)_EXE),exe)

	# Windows gui?
	$(BLD)_LFLAGS := $($(BLD)_LFLAGS) $(if $(findstring gui,$(PRJ_TYPE)),-mwindows,)

	$(BLD)_make_cmd = $(PRE)g++ $(CFG_LFLAGS) $($(BLD)_LFLAGS) $(3) $(1) -o "$(2)" $(4)
	
endif

