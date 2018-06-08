Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B6BBA210F75D4
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 16:58:39 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.18
Date: Fri, 8 Jun 2018 23:58:29 +0000
Message-ID: <1528502307.25740.14.camel@intel.com>
Content-Language: en-US
Content-ID: <86896C0D4D77914E8F521A70B6A1C926@intel.com>
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
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.18

...to receive the first part of the libnvdimm / persistent memory
support update for 4.18. These patches have all been in -next for
several releases. The 'DAX DMA vs Truncate' work has had extra soak
time as it nearly missed 4.17.

This pull request adds a user for the new 'bytes-remaining' updates to
memcpy_mcsafe() that you already received through Ingo via the x86-dax-
for-linus pull. There is a minor collision with bdev_dax_supported()
reworks that you pulled from xfs, and another minor collision of the
vm_fault_t conversion you received from Andrew. A potential merge
resolution is here: https://git.kernel.org/pub/scm/linux/kernel/git/nvd
imm/nvdimm.git/log/?h=libnvdimm-for-4.18-merge

Not included in this pull, but still targeting this cycle, is support
for handling memory media errors (poison) consumed via userspace dax
mappings.

---

The following changes since commit b04e217704b7f879c6b91222b066983a44a7a09f:

  Linux 4.17-rc7 (2018-05-27 13:01:47 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.18

for you to fetch changes up to 930218affeadd1325ea17e053f0dcecf218f5a4f:

  Merge branch 'for-4.18/mcsafe' into libnvdimm-for-next (2018-06-08 15:16:44 -0700)

----------------------------------------------------------------
libnvdimm for 4.18

* DAX broke a fundamental assumption of truncate of file mapped pages.
  The truncate path assumed that it is safe to disconnect a pinned page
  from a file and let the filesystem reclaim the physical block. With DAX
  the page is equivalent to the filesystem block. Introduce
  dax_layout_busy_page() to enable filesystems to wait for pinned DAX
  pages to be released. Without this wait a filesystem could allocate
  blocks under active device-DMA to a new file.

* DAX arranges for the block layer to be bypassed and uses
  dax_direct_access() + copy_to_iter() to satisfy read(2) calls.
  However, the memcpy_mcsafe() facility is available through the pmem
  block driver. In order to safely handle media errors, via the DAX
  block-layer bypass, introduce copy_to_iter_mcsafe().

* Fix cache management policy relative to the ACPI NFIT Platform
  Capabilities Structure to properly elide cache flushes when they are not
  necessary. The table indicates whether CPU caches are power-fail
  protected. Clarify that a deep flush is always performed on
  REQ_{FUA,PREFLUSH} requests.

----------------------------------------------------------------
Dan Williams (17):
      memremap: split devm_memremap_pages() and memremap() infrastructure
      mm: introduce MEMORY_DEVICE_FS_DAX and CONFIG_DEV_PAGEMAP_OPS
      mm: fix __gup_device_huge vs unmap
      mm, fs, dax: handle layout changes to pinned dax mappings
      xfs: prepare xfs_break_layouts() to be called with XFS_MMAPLOCK_EXCL
      xfs: prepare xfs_break_layouts() for another layout type
      xfs, dax: introduce xfs_break_dax_layouts()
      uio, lib: Fix CONFIG_ARCH_HAS_UACCESS_MCSAFE compilation
      dax: Introduce a ->copy_to_iter dax operation
      dax: Report bytes remaining in dax_iomap_actor()
      pmem: Switch to copy_to_iter_mcsafe()
      x86, nfit_test: Add unit test for memcpy_mcsafe()
      libnvdimm: Debug probe times
      libnvdimm, e820: Register all pmem resources
      acpi, nfit: Remove ecc_unit_size
      Merge branch 'for-4.18/dax' into libnvdimm-for-next
      Merge branch 'for-4.18/mcsafe' into libnvdimm-for-next

Matthew Wilcox (1):
      dax: dax_insert_mapping_entry always succeeds

Robert Elliott (1):
      linvdimm, pmem: Preserve read-only setting for pmem devices

Ross Zwisler (4):
      libnvdimm, pmem: Complete REQ_FLUSH => REQ_PREFLUSH
      libnvdimm, pmem: Unconditionally deep flush on *sync
      libnvdimm, pmem: Do not flush power-fail protected CPU caches
      dax: Use dax_write_cache* helpers

 Documentation/ABI/removed/sysfs-bus-nfit |  17 +++
 Documentation/ABI/testing/sysfs-bus-nfit |  19 ---
 arch/x86/Kconfig                         |   1 +
 arch/x86/Kconfig.debug                   |   3 +
 arch/x86/include/asm/mcsafe_test.h       |  75 +++++++++++
 arch/x86/include/asm/string_64.h         |  10 +-
 arch/x86/include/asm/uaccess_64.h        |  14 +++
 arch/x86/lib/memcpy_64.S                 | 112 ++++++++---------
 arch/x86/lib/usercopy_64.c               |  21 ++++
 drivers/acpi/nfit/core.c                 |  11 --
 drivers/dax/super.c                      |  33 +++--
 drivers/md/dm-linear.c                   |  16 +++
 drivers/md/dm-log-writes.c               |  15 +++
 drivers/md/dm-stripe.c                   |  21 ++++
 drivers/md/dm.c                          |  25 ++++
 drivers/nvdimm/bus.c                     |  19 ++-
 drivers/nvdimm/claim.c                   |   3 +-
 drivers/nvdimm/e820.c                    |  41 +++---
 drivers/nvdimm/pfn_devs.c                |   2 -
 drivers/nvdimm/pmem.c                    |  52 ++++++--
 drivers/nvdimm/region_devs.c             |   3 +-
 drivers/s390/block/dcssblk.c             |   7 ++
 fs/Kconfig                               |   1 +
 fs/dax.c                                 | 136 ++++++++++++++++----
 fs/xfs/xfs_file.c                        |  72 ++++++++++-
 fs/xfs/xfs_inode.h                       |  16 +++
 fs/xfs/xfs_ioctl.c                       |   8 +-
 fs/xfs/xfs_iops.c                        |  16 ++-
 fs/xfs/xfs_pnfs.c                        |  15 +--
 fs/xfs/xfs_pnfs.h                        |   5 +-
 include/linux/dax.h                      |  12 ++
 include/linux/device-mapper.h            |   5 +-
 include/linux/memremap.h                 |  36 ++----
 include/linux/mm.h                       |  71 ++++++++---
 include/linux/string.h                   |   4 +-
 include/linux/uio.h                      |  15 +++
 kernel/Makefile                          |   3 +-
 kernel/iomem.c                           | 167 ++++++++++++++++++++++++
 kernel/memremap.c                        | 210 +++++--------------------------
 kernel/resource.c                        |   1 +
 lib/Kconfig                              |   3 +
 lib/iov_iter.c                           |  61 +++++++++
 mm/Kconfig                               |   5 +
 mm/gup.c                                 |  36 ++++--
 mm/hmm.c                                 |  13 +-
 mm/swap.c                                |   3 +-
 tools/testing/nvdimm/test/nfit.c         | 104 +++++++++++++++
 47 files changed, 1092 insertions(+), 446 deletions(-)
 create mode 100644 Documentation/ABI/removed/sysfs-bus-nfit
 create mode 100644 arch/x86/include/asm/mcsafe_test.h
 create mode 100644 kernel/iomem.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
