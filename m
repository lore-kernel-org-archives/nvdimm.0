From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: mmap dio write failure
Date: Fri, 20 Jan 2017 12:40:07 +0800
Message-ID: <20170120044007.kwevjo7nawwolagy@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Hi,

At first, I am not sure whether this is an issue.

mmap a file in a DAX mountpoint, open another file
in a non-DAX mountpoint with O_DIRECT, write the
mapped area to the other file.

This write Success on pmem ramdisk(memmap=2G!20G like)
This write Fail(Bad address) on nvdimm pmem devices.
This write Fail(Bad address) on brd based ramdisk.

If we skip the O_DIRECT flag, all tests pass.

If we write from DAX to DAX, all tests pass.
If we write from non-DAX to DAX, all tests pass.

Kernel version: Linus tree commit 44b4b46.

I have checked back to v4.6 testing on nvdimm devices,
all the same results. I do remember that this test
passed on nvdimms back to May 2016 and i have some
notes for that. However things changed a lot, test
scripts, kernel code, even the nvdimm and machine
firmweare.

Thanks,
Xiong

sh-4.2# cat tbad.sh
#!/bin/bash
[ -z "$1" ] && exit 1
DEV="$1"
MNT=/tbdmnt
cc t_mmap_dio.c
mkdir -p $MNT
wipefs -af $DEV
mkfs.xfs -fq $DEV && \
mount -o dax $DEV $MNT && \
xfs_io -f -c "w -W 0 268435456" $MNT/ts > /dev/null && \
xfs_io -f -c "w -W 0 268435456" ./td > /dev/null
if ./a.out $MNT/ts ./td 16777216 "$DEV" ; then
	echo PASS
else
	echo FAIL
fi
umount $MNT

sh-4.2# cat t_mmap_dio.c 
/*
 * This programme was originally written by
 *     Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 */
#define _GNU_SOURCE 1
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <libaio.h>
#include <errno.h>
#include <sys/time.h>

void usage(char *prog)
{
	fprintf(stderr,
		"usage: %s <src file> <dest file> <size> <msg>\n",
		prog);
	exit(1);
}

void err_exit(char *op, unsigned long len, char *s)
{
	fprintf(stderr, "%s(%s) len %lu %s\n",
		op, strerror(errno), len, s);
	exit(1);
}

int main(int argc, char **argv)
{
	int fd, fd2, ret;
	char *map;
	unsigned long len;

	if (argc < 4)
		usage(basename(argv[0]));

	len = strtoul(argv[3], NULL, 10);
	if (errno == ERANGE)
		err_exit("strtoul", 0, argv[4]);

	/* Open source file and mmap*/
	fd = open(argv[1], O_RDWR, 0644);
	if (fd < 0)
		err_exit("open s", len, argv[4]);

	map = (char *)mmap(NULL, len,
		PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (map == MAP_FAILED)
		err_exit("mmap", len, argv[4]);

	/* Open dest file with O_DIRECT */
	fd2 = open(argv[2], O_RDWR|O_DIRECT, 0644);
	if (fd2 < 0)
		err_exit("open d", len, argv[4]);

	/* First, test storing to dest file from source mapping */
	ret = write(fd2, map, len);
	if (ret != len)
		err_exit("write", len, argv[4]);

	ret = (int)lseek(fd2, 0, SEEK_SET);
	if (ret == -1)
		err_exit("lseek", len, argv[4]);

	/* Next, test reading from dest file into source mapping */
	ret = read(fd2, map, len);
	if (ret != len)
		err_exit("read", len, argv[4]);
	ret = msync(map, len, MS_SYNC);
	if (ret < 0)
		err_exit("msync", len, argv[4]);

	ret = munmap(map, len);
	if (ret < 0)
		err_exit("munmap", len, argv[4]);

	ret = close(fd);
	if (ret < 0)
		err_exit("clsoe fd", len, argv[4]);

	ret = close(fd2);
	if (ret < 0)
		err_exit("close fd2", len, argv[4]);

	exit(0);
}

sh-4.2# ndctl list -N
[
  {
    "dev":"namespace3.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem3"
  },
  {
    "dev":"namespace2.0",
    "mode":"raw",
    "size":8589934592,
    "blockdev":"pmem2"
  },
  {
    "dev":"namespace1.0",
    "mode":"memory",
    "size":2147483648,
    "blockdev":"pmem1"
  },
  {
    "dev":"namespace0.0",
    "mode":"memory",
    "size":2147483648,
    "blockdev":"pmem0"
  }
]

sh-4.2# modinfo brd
filename:       /lib/modules/4.10.0-rc4-master-44b4b46+/kernel/drivers/block/brd.ko
alias:          rd
alias:          block-major-1-*
license:        GPL
srcversion:     25AABF2EF57F6A37AFFEBA6
depends:        
intree:         Y
vermagic:       4.10.0-rc4-master-44b4b46+ SMP mod_unload modversions 
parm:           rd_nr:Maximum number of brd devices (int)
parm:           rd_size:Size of each RAM disk in kbytes. (ulong)
parm:           max_part:Num Minors to reserve between devices (int)

sh-4.2# uname -r
4.10.0-rc4-master-44b4b46+

sh-4.2# bash tbad.sh /dev/pmem0
/dev/pmem0: 4 bytes were erased at offset 0x00000000 (xfs): 58 46 53 42
PASS

sh-4.2# bash tbad.sh /dev/pmem2
/dev/pmem2: 4 bytes were erased at offset 0x00000000 (xfs): 58 46 53 42
write(Bad address) len 16777216 /dev/pmem2
FAIL

sh-4.2# bash tbad.sh /dev/ram0
/dev/ram0: 4 bytes were erased at offset 0x00000000 (xfs): 58 46 53 42
write(Bad address) len 16777216 /dev/ram0
FAIL

sh-4.2# df .
Filesystem                              1K-blocks     Used Available Use% Mounted on
/dev/mapper/rhxxxxxxxxxxxxxxxxx-01-root  52399104 43658792   8740312  84% /
sh-4.2# 
