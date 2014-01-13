#!/bin/bash

#-------------------------------------------------------------------
#
# Parameters
#
# $1 = Command      - show, checkout, update, archive, restore,
#                     diff, makepatch, applypatch, build
#
# $2 = Project list - Comma separated project list
#
# $3 = Tag			- Unique tag for archives, diffs, or patches
#
# $4 = *            - [restore] - URL Source prefix (http://example.com/)
#
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------

. ./config.sh

#-------------------------------------------------------------------
# Read in parameters
#-------------------------------------------------------------------

# Shortcuts
CMD=$1
if [ ${CMD} == "-" ]; then 
	CMD=show 
fi
if [ ${CMD} == "co" ]; then
	CMD=checkout 
fi
if [ ${CMD} == "cop" ]; then
	CMD=checkoutpatch
fi
if [ ${CMD} == "up" ]; then 
	CMD=update 
fi
if [ ${CMD} == "arc" ]; then
	CMD=archive
fi
if [ ${CMD} == "res" ]; then
	CMD=restore
fi
if [ ${CMD} == "dif" ]; then
	CMD=diff
fi
if [ ${CMD} == "mp" ]; then
	CMD=makepatch
fi
if [ ${CMD} == "ap" ]; then
	CMD=applypatch
fi
if [ ${CMD} == "bld" ]; then
	CMD=build
fi

# Get directory roots
cd ${DIR_LPRJ}
for i in $(ls -d */); do DIRLIST="${DIRLIST} ${i%*/}"; done		

echo "---"
echo " Command  : ${CMD}"
if [ $2 ]; then
	echo " Projects : $2"
fi
if [ $3 ]; then
	echo " Tag      : $3"
fi
echo "---"

# Ensure lib directory
if [ ! -d ${DIR_LIB} ]; then
	mkdir -p ${DIR_LIB}
fi

# Extra parameter(s)
EXTPARAM=$3
EXTPARAM2=$4

# Unique field
if [ ! -z ${EXTPARAM} ] && [ ${EXTPARAM} != "-" ]; then
	UNIQUENAME=${EXTPARAM}
else
	UNIQUENAME=`date +%G%m%d-%H%M%S`
fi

#-------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------

if [ ${CMD} == "archive" ]; then
	ARCHPATH="${DIR_ARC}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "restore" ]; then
	ARCHPATH="${DIR_ARC}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
	DOWNLOADLINK="${EXTPARAM2}"
fi

if [ ${CMD} == "diff" ]; then
	ARCHPATH="${DIR_DIF}/${UNIQUENAME}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "makepatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
	if [ ! -d ${ARCHPATH} ]; then
		mkdir -p ${ARCHPATH}
	fi
fi

if [ ${CMD} == "applypatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
fi

if [ ${CMD} == "checkoutpatch" ]; then
	if [ -z ${EXTPARAM} ]; then
		EXTPARAM=default
	fi
	ARCHPATH="${DIR_LPAT}/${EXTPARAM}"
fi

#-------------------------------------------------------------------
# Process each group/project
#-------------------------------------------------------------------
for DR in ${DIRLIST[@]} 
do

	if [ $2 ] && [ $2 != "-" ]; then
		IFS=","; FILELIST=($2); unset IFS
	else	
		FILELIST=
		for i in $( find ${DIR_LPRJ}/${DR} -maxdepth 1 -type f -name '*'.${EXT_REPO} ); do FILELIST="${FILELIST} ${i##*/}"; done
	fi

	for CF in ${FILELIST[@]} 
	do

		CF=${CF%.*}
		FNAME=${CF%:*}
		FVERS=${CF#*:}
		FULL="${DIR_LPRJ}/${DR}/${FNAME}.${EXT_REPO}"

		if [ -f ${FULL} ]; then

			# bug???
			if [ ${FNAME} == ${FVERS} ]; then
				FVERS=
			fi

			while read LINE
			do
				if [ -n "${LINE}" ]; then
				
					STR=${LINE}
					PROJ=${STR%% *}
					
					STR=${STR#* }
					REPO=${STR%% *}
					STR=${STR#* }
					REVN=${STR%% *}
					STR=${STR#* }
					LINK=${STR%% *}
					STR=${STR#* }
					FOPTS=${STR%% *}
					STR=${STR#* }
			
					if [ -n "${FVERS}" ]; then	
						REVN=${FVERS}			
					fi

					if [ -z "${REVN}" ]; then
						REVN="-"
					fi

					if [ -n "${PROJ}" ] && [ -n ${REPO} ] && [ "${PROJ}" != "#" ]; then

						# Where is the library?	
						LIBPATH="${DIR_LIB}/${PROJ}"
						
						# Start in library root
						cd ${DIR_LIB}
						
						# Show affected projects
						if [ ${CMD} == "show" ]; then
							echo ${PROJ} : ${REPO} : ${REVN} : ${LINK} : ${OPTS}
						fi

						# build
						if [ ${CMD} == "build" ]; then
							. ${DIR_LBIN}/build.sh
						fi
						
						# Checkout
						if [ ${CMD} == "checkout" ]; then
							. ${DIR_LBIN}/checkout.sh
						fi
						
						# Checkout and patch
						if [ ${CMD} == "checkoutpatch" ]; then
							. ${DIR_LBIN}/checkout.sh
							. ${DIR_LBIN}/applypatch.sh
						fi

						# Update
						if [ ${CMD} == "update" ]; then
							. ${DIR_LBIN}/update.sh
						fi
		
						# Archive
						if [ ${CMD} == "archive" ]; then
							. ${DIR_LBIN}/archive.sh
						fi
		
						# Restore from archive
						if [ ${CMD} == "restore" ]; then
							. ${DIR_LBIN}/restore.sh
						fi
		
						# diff
						if [ ${CMD} == "diff" ]; then
							. ${DIR_LBIN}/diff.sh
						fi
		
						# makepatch
						if [ ${CMD} == "makepatch" ]; then
							. ${DIR_LBIN}/makepatch.sh
						fi
		
						# makepatch
						if [ ${CMD} == "applypatch" ]; then
							. ${DIR_LBIN}/applypatch.sh
						fi
		
					fi
				
				fi
				
			done < ${FULL}		
		fi
	done
done

# The end
echo

