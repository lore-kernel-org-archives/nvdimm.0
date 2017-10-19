Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CCD3221EA15D1
 for <linux-nvdimm@lists.01.org>; Thu, 19 Oct 2017 06:05:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/17 v4] dax, ext4, xfs: Synchronous page faults
Date: Thu, 19 Oct 2017 14:57:59 +0200
Message-Id: <20171019125817.11580-1-jack@suse.cz>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

here is the fourth version of my patches to implement synchronous page faults
for DAX mappings to make flushing of DAX mappings possible from userspace so
that they can be flushed on finer than page granularity and also avoid the
overhead of a syscall.

We use a new mmap flag MAP_SYNC to indicate that page faults for the mapping
should be synchronous.  The guarantee provided by this flag is: While a block
is writeably mapped into page tables of this mapping, it is guaranteed to be
visible in the file at that offset also after a crash.

How I implement this is that ->iomap_begin() indicates by a flag that inode
block mapping metadata is unstable and may need flushing (use the same test as
whether fdatasync() has metadata to write). If yes, DAX fault handler refrains
from inserting / write-enabling the page table entry and returns special flag
VM_FAULT_NEEDDSYNC together with a PFN to map to the filesystem fault handler.
The handler then calls fdatasync() (vfs_fsync_range()) for the affected range
and after that calls DAX code to update the page table entry appropriately.

I did some basic performance testing on the patches over ramdisk - timed
latency of page faults when faulting 512 pages. I did several tests: with file
preallocated / with file empty, with background file copying going on / without
it, with / without MAP_SYNC (so that we get comparison).  The results are
(numbers are in microseconds):

File preallocated, no background load no MAP_SYNC:
min=9 avg=10 max=46
8 - 15 us: 508
16 - 31 us: 3
32 - 63 us: 1

File preallocated, no background load, MAP_SYNC:
min=9 avg=10 max=47
8 - 15 us: 508
16 - 31 us: 2
32 - 63 us: 2

File empty, no background load, no MAP_SYNC:
min=21 avg=22 max=70
16 - 31 us: 506
32 - 63 us: 5
64 - 127 us: 1

File empty, no background load, MAP_SYNC:
min=40 avg=124 max=242
32 - 63 us: 1
64 - 127 us: 333
128 - 255 us: 178

File empty, background load, no MAP_SYNC:
min=21 avg=23 max=67
16 - 31 us: 507
32 - 63 us: 4
64 - 127 us: 1

File empty, background load, MAP_SYNC:
min=94 avg=112 max=181
64 - 127 us: 489
128 - 255 us: 23

So here we can see the difference between MAP_SYNC vs non MAP_SYNC is about
100-200 us when we need to wait for transaction commit in this setup. 

Anyway, here are the patches and AFAICT the series is pretty much complete.
The only missing piece are tests which Ross is working on. Comments are
welcome.

Changes since v3:
* updated some changelogs
* folded fs support for VM_SYNC flag into patches implementing the
  functionality
* removed ->mmap_validate, use ->mmap_supported_flags instead
* added some Reviewed-by tags
* added manpage patch

Changes since v2:
* avoid unnecessary flushing of faulted page (Ross) - I've realized it makes no
  sense to remeasure my benchmark results (after actually doing that and seeing
  no difference, sigh) since I use ramdisk and not real PMEM HW and so flushes
  are ignored.
* handle nojournal mode of ext4
* other smaller cleanups & fixes (Ross)
* factor larger part of finishing of synchronous fault into a helper (Christoph)
* reorder pfnp argument of dax_iomap_fault() (Christoph)
* add XFS support from Christoph
* use proper MAP_SYNC support in mmap(2)
* rebased on top of 4.14-rc4

Changes since v1:
* switched to using mmap flag MAP_SYNC
* cleaned up fault handlers to avoid passing pfn in vmf->orig_pte
* switched to not touching page tables before we are ready to insert final
  entry as it was unnecessary and not really simplifying anything
* renamed fault flag to VM_FAULT_NEEDDSYNC
* other smaller fixes found by reviewers

								Honza
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
