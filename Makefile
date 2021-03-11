# SPDX-License-Identifier: GPL-2.0
#
# Makefile for the ntfs3 filesystem support.
#

ifneq ($(KERNELRELEASE),)
# call from kernel build system

obj-$(CONFIG_NTFS3_FS) += ntfs3.o


ntfs3-y :=      attrib.o \
                attrlist.o \
                bitfunc.o \
                bitmap.o \
                dir.o \
                fsntfs.o \
                frecord.o \
                file.o \
                fslog.o \
                inode.o \
                index.o \
                lznt.o \
                namei.o \
                record.o \
                run.o \
                super.o \
                upcase.o \
                xattr.o

ntfs3-$(CONFIG_NTFS3_LZX_XPRESS) += $(addprefix lib/,\
                decompress_common.o \
                lzx_decompress.o \
                xpress_decompress.o \
                )

ccflags-$(CONFIG_NTFS3_LZX_XPRESS) += -DCONFIG_NTFS3_LZX_XPRESS
ccflags-$(CONFIG_NTFS3_FS_POSIX_ACL) += -DCONFIG_NTFS3_FS_POSIX_ACL


else


# external module build

EXTRA_FLAGS += -I$(PWD)

#
# KDIR is a path to a directory containing kernel source.
# It can be specified on the command line passed to make to enable the module to
# be built and installed for a kernel other than the one currently running.
# By default it is the path to the symbolic link created when
# the current kernel's modules were installed, but
# any valid path to the directory in which the target kernel's source is located
# can be provided on the command line.
#
KDIR    ?= /lib/modules/$(shell uname -r)/build
MDIR    ?= /lib/modules/$(shell uname -r)
PWD     := $(shell pwd)
PWD     := $(shell pwd)

export CONFIG_NTFS3_FS := m
export CONFIG_NTFS3_LZX_XPRESS := y
export CONFIG_NTFS3_FS_POSIX_ACL := y

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

help:
	$(MAKE) -C $(KDIR) M=$(PWD) help

install: ntfs3.ko
	rm -f ${MDIR}/kernel/fs/ntfs3/ntfs3.ko
	install -m644 -b -D ntfs3.ko ${MDIR}/kernel/fs/ntfs3/ntfs3.ko
	depmod -aq


uninstall:
	rm -rf ${MDIR}/kernel/fs/ntfs3
	depmod -aq

endif

.PHONY : all clean install uninstall

