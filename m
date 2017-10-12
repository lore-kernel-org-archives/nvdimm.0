Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EBEF621F7D51C
 for <linux-nvdimm@lists.01.org>; Wed, 11 Oct 2017 17:50:02 -0700 (PDT)
Subject: [PATCH v9 0/6] MAP_DIRECT for DAX userspace flush
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 17:47:07 -0700
Message-ID: <150776922692.9144.16963640112710410217.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-api@vger.kernel.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v8 [1]:
* Move MAP_SHARED_VALIDATE definition next to MAP_SHARED in all arch
  headers (Jan)

* Include xfs_layout.h directly in all the files that call
  xfs_break_layouts() (Dave)

* Clarify / add more comments to the MAP_DIRECT checks at fault time
  (Dave)

* Rename iomap_can_allocate() to break_layouts_nowait() to make it plain
  the reason we are bailing out of iomap_begin.

* Defer the lease_direct mechanism and RDMA core changes to a later
  patch series.

* EXT4 support is in the works and will be rebased on Jan's MAP_SYNC
  patches.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012772.html

---

MAP_DIRECT is a mechanism that allows an application to establish a
mapping where the kernel will not change the block-map, or otherwise
dirty the block-map metadata of a file without notification. It supports
a "flush from userspace" model where persistent memory applications can
bypass the overhead of ongoing coordination of writes with the
filesystem, and it provides safety to RDMA operations involving DAX
mappings.

The kernel always has the ability to revoke access and convert the file
back to normal operation after performing a "lease break". Similar to
fcntl leases, there is no way for userspace to to cancel the lease break
process once it has started, it can only delay it via the
/proc/sys/fs/lease-break-time setting.

MAP_DIRECT enables XFS to supplant the device-dax interface for
mmap-write access to persistent memory with no ongoing coordination with
the filesystem via fsync/msync syscalls.

The MAP_DIRECT mechanism is complimentary to MAP_SYNC. Here are some
scenarios where you would choose one over the other:

* 3rd party DMA / RDMA to DAX with hardware that does not support
  on-demand paging (shared virtual memory) => MAP_DIRECT

* Support for reflinked inodes, fallocate-punch-hole, truncate, or any
  other operation that mutates the block map of an actively
  mapped file => MAP_SYNC

* Userpsace flush => MAP_SYNC or MAP_DIRECT

* Assurances that the file's block map metadata is stable, i.e. minimize
  worst case fault latency by locking out updates => MAP_DIRECT

---

Dan Williams (6):
      mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap flags
      fs, mm: pass fd to ->mmap_validate()
      fs: MAP_DIRECT core
      xfs: prepare xfs_break_layouts() for reuse with MAP_DIRECT
      fs, xfs, iomap: introduce break_layout_nowait()
      xfs: wire up MAP_DIRECT


 arch/alpha/include/uapi/asm/mman.h           |    1 
 arch/mips/include/uapi/asm/mman.h            |    1 
 arch/mips/kernel/vdso.c                      |    2 
 arch/parisc/include/uapi/asm/mman.h          |    1 
 arch/tile/mm/elf.c                           |    3 
 arch/x86/mm/mpx.c                            |    3 
 arch/xtensa/include/uapi/asm/mman.h          |    1 
 fs/Kconfig                                   |    1 
 fs/Makefile                                  |    2 
 fs/aio.c                                     |    2 
 fs/mapdirect.c                               |  237 ++++++++++++++++++++++++++
 fs/xfs/Kconfig                               |    4 
 fs/xfs/Makefile                              |    1 
 fs/xfs/xfs_file.c                            |  108 ++++++++++++
 fs/xfs/xfs_ioctl.c                           |    1 
 fs/xfs/xfs_iomap.c                           |    3 
 fs/xfs/xfs_iops.c                            |    1 
 fs/xfs/xfs_layout.c                          |   45 +++++
 fs/xfs/xfs_layout.h                          |   13 +
 fs/xfs/xfs_pnfs.c                            |   31 ---
 fs/xfs/xfs_pnfs.h                            |    8 -
 include/linux/fs.h                           |   11 +
 include/linux/mapdirect.h                    |   40 ++++
 include/linux/mm.h                           |    9 +
 include/linux/mman.h                         |   42 +++++
 include/uapi/asm-generic/mman-common.h       |    1 
 include/uapi/asm-generic/mman.h              |    1 
 ipc/shm.c                                    |    3 
 mm/internal.h                                |    2 
 mm/mmap.c                                    |   28 ++-
 mm/nommu.c                                   |    5 -
 mm/util.c                                    |    7 -
 tools/include/uapi/asm-generic/mman-common.h |    1 
 33 files changed, 557 insertions(+), 62 deletions(-)
 create mode 100644 fs/mapdirect.c
 create mode 100644 fs/xfs/xfs_layout.c
 create mode 100644 fs/xfs/xfs_layout.h
 create mode 100644 include/linux/mapdirect.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
