Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B319D21F3C1AE
 for <linux-nvdimm@lists.01.org>; Tue, 10 Oct 2017 07:51:52 -0700 (PDT)
Subject: [PATCH v8 00/14] MAP_DIRECT for DAX RDMA and userspace flush
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Oct 2017 07:48:55 -0700
Message-ID: <150764693502.16882.15848797003793552156.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Sean Hefty <sean.hefty@intel.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma@vger.kernel.org, Joerg Roedel <joro@8bytes.org>, Doug Ledford <dledford@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Hal Rosenstock <hal.rosenstock@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, iommu@lists.linux-foundation.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v7 [1]:
* Fix IOVA reuse race by leaving the dma scatterlist mapped until
  unregistration time. Use iommu_unmap() in ib_umem_lease_break() to
  force-invalidate the ibverbs memory registration. (David Woodhouse)

* Introduce iomap_can_allocate() as a way to check if any layouts are
  present in the mmap write-fault path to prevent block map changes, and
  start the leak break process when an allocating write-fault occurs.
  This also removes the i_mapdcount bloat of 'struct inode' from v7.
  (Dave Chinner)

* Provide generic_map_direct_{open,close,lease} to cleanup the
  filesystem wiring to implement MAP_DIRECT support (Dave Chinner)

* Abandon (defer to a potential new fcntl()) support for using
  MAP_DIRECT on non-DAX files. With this change we can validate the
  inode is MAP_DIRECT capable just once at mmap time rather than every
  fault.  (Dave Chinner)

* Arrange for lease_direct leases to also wait the
  /proc/sys/fs/lease-break-time period before calling break_fn. For
  example, allow the lease-holder time to quiesce RDMA operations before
  the iommu starts throwing io-faults.

* Switch intel-iommu to use iommu_num_sg_pages().

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012707.html

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

---

Dan Williams (14):
      mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap flags
      fs, mm: pass fd to ->mmap_validate()
      fs: MAP_DIRECT core
      xfs: prepare xfs_break_layouts() for reuse with MAP_DIRECT
      fs, xfs, iomap: introduce iomap_can_allocate()
      xfs: wire up MAP_DIRECT
      iommu, dma-mapping: introduce dma_get_iommu_domain()
      fs, mapdirect: introduce ->lease_direct()
      xfs: wire up ->lease_direct()
      device-dax: wire up ->lease_direct()
      iommu: up-level sg_num_pages() from amd-iommu
      iommu/vt-d: use iommu_num_sg_pages
      IB/core: use MAP_DIRECT to fix / enable RDMA to DAX mappings
      tools/testing/nvdimm: enable rdma unit tests


 arch/alpha/include/uapi/asm/mman.h           |    1 
 arch/mips/include/uapi/asm/mman.h            |    1 
 arch/mips/kernel/vdso.c                      |    2 
 arch/parisc/include/uapi/asm/mman.h          |    1 
 arch/tile/mm/elf.c                           |    3 
 arch/x86/mm/mpx.c                            |    3 
 arch/xtensa/include/uapi/asm/mman.h          |    1 
 drivers/base/dma-mapping.c                   |   10 +
 drivers/dax/Kconfig                          |    1 
 drivers/dax/device.c                         |    4 
 drivers/infiniband/core/umem.c               |   90 +++++-
 drivers/iommu/amd_iommu.c                    |   40 +--
 drivers/iommu/intel-iommu.c                  |   30 +-
 drivers/iommu/iommu.c                        |   27 ++
 fs/Kconfig                                   |    5 
 fs/Makefile                                  |    1 
 fs/aio.c                                     |    2 
 fs/mapdirect.c                               |  382 ++++++++++++++++++++++++++
 fs/xfs/Kconfig                               |    4 
 fs/xfs/Makefile                              |    1 
 fs/xfs/xfs_file.c                            |  103 +++++++
 fs/xfs/xfs_iomap.c                           |    3 
 fs/xfs/xfs_layout.c                          |   45 +++
 fs/xfs/xfs_layout.h                          |   13 +
 fs/xfs/xfs_pnfs.c                            |   30 --
 fs/xfs/xfs_pnfs.h                            |   10 -
 include/linux/dma-mapping.h                  |    3 
 include/linux/fs.h                           |    2 
 include/linux/iomap.h                        |   10 +
 include/linux/iommu.h                        |    2 
 include/linux/mapdirect.h                    |   57 ++++
 include/linux/mm.h                           |   17 +
 include/linux/mman.h                         |   42 +++
 include/rdma/ib_umem.h                       |    8 +
 include/uapi/asm-generic/mman-common.h       |    1 
 include/uapi/asm-generic/mman.h              |    1 
 ipc/shm.c                                    |    3 
 mm/internal.h                                |    2 
 mm/mmap.c                                    |   28 +-
 mm/nommu.c                                   |    5 
 mm/util.c                                    |    7 
 tools/include/uapi/asm-generic/mman-common.h |    1 
 tools/testing/nvdimm/Kbuild                  |   31 ++
 tools/testing/nvdimm/config_check.c          |    2 
 tools/testing/nvdimm/test/iomap.c            |   14 +
 45 files changed, 938 insertions(+), 111 deletions(-)
 create mode 100644 fs/mapdirect.c
 create mode 100644 fs/xfs/xfs_layout.c
 create mode 100644 fs/xfs/xfs_layout.h
 create mode 100644 include/linux/mapdirect.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
