Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2266A81FEC
 for <linux-nvdimm@lists.01.org>; Mon,  6 Feb 2017 15:14:10 -0800 (PST)
Date: Mon, 6 Feb 2017 16:14:09 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: question about ext4 block allocation
Message-ID: <20170206231409.GA16676@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I recently hit an issue in my DAX testing where I was unable to get ext4 to
give me 2 MiB sized and aligned block allocations in a situation where I
thought I should be able to.  I'm using a PMEM ramdisk of size 16 GiB, created
using the memmap kernel command line parameter.

  # fdisk -l /dev/pmem0
  Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 4096 bytes / 4096 bytes

The very simple test program I used to reproduce this can be found at the
bottom of this mail.  Here is the quick function that I used to recreate my
filesystem each run:

  # type go_ext4
  go_ext4 is a function
  go_ext4 () 
  { 
      umount /dev/pmem0 2> /dev/null;
      mkfs.ext4 -b 4096 -E stride=512 -F /dev/pmem0;
      mount -o dax /dev/pmem0 ~/dax;
      cd ~/fsync
  }

To be able to easily see whether DAX is able to use PMDs instead of PTEs, you
can run with the mmots tree (git://git.cmpxchg.org/linux-mmots.git), tag
v4.10-rc4-mmots-2017-01-17-16-32.

Okay, so here's the interesting part.  If I create a filesystem and run the
test so it creates a file of size 32 MiB or 128 MiB, I get a PMD fault.
Here's the corresponding tracepoint output:

test-1429  [008] .... 10573.026699: dax_pmd_fault: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000 vm_end
0x40400000 pgoff 0x280 max_pgoff 0x7fff 

test-1429  [008] .... 10573.026912: dax_pmd_insert_mapping: dev 259:0 ino 0xc
shared write address 0x40280000 length 0x200000 pfn 0x108a00 DEV|MAP
radix_entry 0x114000e

test-1429  [008] .... 10573.026917: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000
vm_end 0x40400000 pgoff 0x280 max_pgoff 0x7fff NOPAGE

Great.  That's what I want.  But, if I create the filesystem and use the test
to create a file that is 64 MiB in size, the PMD fault fails because the PFN I
get from the filesystem isn't 2MiB aligned:

test-1475  [006] .... 11809.982188: dax_pmd_fault: dev 259:0 ino 0xc shared
WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000 vm_end
0x40400000 pgoff 0x280 max_pgoff 0x3fff 

test-1475  [006] .... 11809.982398: dax_pmd_insert_mapping_fallback: dev 259:0
ino 0xc shared write address 0x40280000 length 0x200000 pfn 0x108601 DEV|MAP
radix_entry 0x0

test-1475  [006] .... 11809.982399: dax_pmd_fault_done: dev 259:0 ino 0xc
shared WRITE|ALLOW_RETRY|KILLABLE|USER address 0x40280000 vm_start 0x40000000
vm_end 0x40400000 pgoff 0x280 max_pgoff 0x3fff FALLBACK

The PFN for the block allocation I get from ext4 is 0x108601, which isn't
aligned, so we fail the PG_PMD_COLOUR alignment check in
dax_iomap_pmd_fault(), and use PTEs instead.

I initially saw this in a test from Xiong:

https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg02615.html

and created the attached test to have a simpler reproducer.  With Xiong's
test, a test on a 128 MiB sized file will have all PMDs, an on a 64 MiB file
we'll use all PTEs.

This question is important because eventually we'd like to say to customers
"do X and you should get PMDs when you use DAX", but right now I'm not sure
what X is.  :)

Thanks,
- Ross

--- >8 ---
#define _GNU_SOURCE
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <linux/falloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>

#define GiB(a) ((a)*1024ULL*1024*1024)
#define MiB(a) ((a)*1024ULL*1024)
#define PAGE(a) ((a)*0x1000)

void usage(char *prog)
{
	fprintf(stderr, "usage: %s <size in MiB>\n", prog);
	exit(1);
}

void err_exit(char *op, unsigned long len)
{
	fprintf(stderr, "%s(%s) len %lu\n", op, strerror(errno), len);
	exit(1);
}

int main(int argc, char *argv[])
{
	char *data_array = (char*) GiB(1); /* request a 2MiB aligned address with mmap() */
	unsigned long len;
	int fd;

	if (argc < 2)
		usage(basename(argv[0]));

	len = strtoul(argv[1], NULL, 10);
	if (errno == ERANGE)
		err_exit("strtoul", 0);

	fd = open("/root/dax/data", O_RDWR|O_CREAT, S_IRUSR|S_IWUSR);
	if (fd < 0) {
		perror("fd");
		return 1;
	}

	ftruncate(fd, 0);
	fallocate(fd, 0, 0, MiB(len));

	data_array = mmap(data_array, PAGE(0x400), PROT_READ|PROT_WRITE,
			MAP_SHARED, fd, PAGE(0));
	data_array[PAGE(0x280)] = 142;

	fsync(fd);
	close(fd);
	return 0;
}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
