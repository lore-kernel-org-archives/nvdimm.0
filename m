Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D115A21D0A25C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:00 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [RFC PATCH 0/13 v2] dax, ext4: Synchronous page faults
Date: Thu, 17 Aug 2017 18:08:02 +0200
Message-Id: <20170817160815.30466-1-jack@suse.cz>
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
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

here is second version of my patches to implement synchronous page faults for
DAX mappings to make flushing of DAX mappings possible from userspace so that
they can be flushed on finer than page granularity and also avoid the overhead
of a syscall.

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

>From my (fairly limited) knowledge of XFS it seems XFS should be able to do the
same and it should be even possible for filesystem to implement safe remapping
of a file offset to a different block (i.e. break reflink, do defrag, or
similar stuff) like:

1) Block page faults
2) fdatasync() remapped range (there can be outstanding data modifications
   not yet flushed)
3) unmap_mapping_range()
4) Now remap blocks
5) Unblock page faults

Basically we do the same on events like punch hole so there is not much new
there.

Note that the implementation of MAP_SYNC flag is pretty crude for now just to
enable testing since Dan is working in the same area to implement another mmap
flag. Once the decision on how to implement new mmap flag is settled, I can
clean up that patch.

I did some basic performance testing on the patches over ramdisk - timed
latency of page faults when faulting 512 pages. I did several tests: with file
preallocated / with file empty, with background file copying going on / without
it, with / without MAP_SYNC (so that we get comparison).  The results are
(numbers are in microseconds):

File preallocated, no background load no MAP_SYNC:
min=5 avg=6 max=42
4 - 7 us: 398
8 - 15 us: 110
16 - 31 us: 2
32 - 63 us: 2

File preallocated, no background load, MAP_SYNC:
min=10 avg=10 max=43
8 - 15 us: 509
16 - 31 us: 2
32 - 63 us: 1

File empty, no background load, no MAP_SYNC:
min=21 avg=23 max=76
16 - 31 us: 503
32 - 63 us: 8
64 - 127 us: 1

File empty, no background load, MAP_SYNC:
min=91 avg=108 max=234
64 - 127 us: 467
128 - 255 us: 45

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

Anyway, here are the patches, comments are welcome.

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
