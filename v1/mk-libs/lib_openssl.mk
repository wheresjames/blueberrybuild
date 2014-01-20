
default_target: all

#-------------------------------------------------------------------
# Project settings
#-------------------------------------------------------------------
PRJ_NAME := openssl
PRJ_DESC := Cryptography and SSL/TLS Toolkit
PRJ_DEPS := openssl
PRJ_TYPE := lib
PRJ_INCS := openssl openssl/include openssl/crypto \
			openssl/crypto/asn1 openssl/crypto/evp \
			openssl/crypto/modes
PRJ_LIBS :=
PRJ_DEFS := NO_WINDOWS_BRAINDEATH I386_ONLY OPENSSL_NO_ASM
PRJ_OBJR := _deps
PRJ_LINK := cmdfile

#-------------------------------------------------------------------
# Configure build
#-------------------------------------------------------------------
BBBROOT ?= ../..
include $(BBBROOT)/v1/config.mk

# Create include files
$(LIBROOT)/openssl/include/openssl/opensslconf.h: $(BLDCHAIN)
	cd "$(LIBROOT)/openssl"; perl Configure gcc no-shared no-asm zlib
BLDCHAIN := $(LIBROOT)/openssl/include/openssl/opensslconf.h

#-------------------------------------------------------------------
# File locations
#-------------------------------------------------------------------
BLD := def
BLD_EXT := c
BLD_DIR := $(LIBROOT)/openssl/crypto
BLD_SUB := .
BLD_DPT := *
BLD_DEX := cvs store threads jpake md2 rc5
BLD_FEX := lpdir_nyi lpdir_unix lpdir_vms lpdir_wince lpdir_win32 lpdir_win \
		   LPdir_nyi LPdir_unix LPdir_vms LPdir_wince LPdir_win32 LPdir_win \
		   armcap o_dir_test \
		   aes/aes_core \
		   bf/bf_cbc bf/bf_opts bf/bfspeed bf/bftest \
		   bio/bss_rtcp \
		   bn/exp bn/bntest bn/bnspeed bn/divtest bn/expspeed bn/exptest \
		   cast/castopts cast/cast_spd cast/casttest \
		   conf/cnf_save conf/test \
		   des/des des/des_opts des/destest des/ncbc_enc des/read_pwd des/speed \
		   dh/dhtest dh/p192 dh/p512 dh/p1024 \
		   dsa/dsatest dsa/dsagen \
		   ec/ectest \
		   ecdh/ecdhtest \
		   ecdsa/ecdsatest \
		   ssl/ssl_task ssltest \
		   ccgost/gostsum \
		   engine/enginetest \
		   evp/e_dsa evp/openbsd_hw evp/evp_test \
		   hmac/e_dsa hmac/hmactest \
		   idea/idea_spd idea/ideatest \
		   lhash/lh_test \
		   md4/md4 md4/md4test \
		   md5/md5 md5/md5test \
		   mdc2/mdc2test \
		   pkcs7/bio_ber pkcs7/dec pkcs7/enc pkcs7/pk7_enc pkcs7/sign pkcs7/verify \
		   rand/randtest \
		   rc2/rc2 rc2/rc2test rc2/rc2speed rc2/tab \
		   rc4/rc4 rc4/rc4test rc4/rc4speed \
		   ripemd/rmdtest ripemd/rmd160 \
		   rsa/rsa_test \
		   sha/sha sha/sha1 sha/shatest sha/sha1test sha/sha256t sha/sha512t \
		   whrlpool/wp_test \
		   x509v3/tabtest x509v3/v3conf x509v3/v3prin
ifeq ($(TGT_PLATFORM),windows)
	BLD_FEX := $(BLD_FEX) ppccap s390xcap sparcv9cap
endif
include $(BBBROOT)/v1/build.mk

#-------------------------------------------------------------------
# Execute the build
#-------------------------------------------------------------------
include $(BBBROOT)/v1/link.mk

