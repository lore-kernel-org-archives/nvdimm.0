Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED9DB21A0483B
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 12:14:42 -0700 (PDT)
Subject: [resend PATCH v2 00/33] dax: introduce dax_operations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Apr 2017 12:08:49 -0700
Message-ID: <149245612770.10206.15496018295337908594.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, hch@lst.de, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

[ resend to add dm-devel, linux-block, and fs-devel, apologies for the
duplicates ]

Changes since v1 [1] and the dax-fs RFC [2]:
* rename struct dax_inode to struct dax_device (Christoph)
* rewrite arch_memcpy_to_pmem() in C with inline asm
* use QUEUE_FLAG_WC to gate dax cache management (Jeff)
* add device-mapper plumbing for the ->copy_from_iter() and ->flush()
  dax_operations
* kill struct blk_dax_ctl and bdev_direct_access (Christoph)
* cleanup the ->direct_access() calling convention to be page based
  (Christoph)
* introduce dax_get_by_host() and don't pollute struct super_block with
  dax_device details (Christoph)

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008586.html
[2]: https://lwn.net/Articles/713064/

---
A few months back, in the course of reviewing the memcpy_nocache()
proposal from Brian, Linus proposed that the pmem specific
memcpy_to_pmem() routine be moved to be implemented at the driver level
[3]:

   "Quite frankly, the whole 'memcpy_nocache()' idea or (ab-)using
    copy_user_nocache() just needs to die. It's idiotic.
    
    As you point out, it's also fundamentally buggy crap.
    
    Throw it away. There is no possible way this is ever valid or
    portable. We're not going to lie and claim that it is.
    
    If some driver ends up using 'movnt' by hand, that is up to that
    *driver*. But no way in hell should we care about this one whit in
    the sense of <linux/uaccess.h>."

This feedback also dovetails with another fs/dax.c design wart of being
hard coded to assume the backing device is pmem. We call the pmem
specific copy, clear, and flush routines even if the backing device
driver is one of the other 3 dax drivers (axonram, dccssblk, or brd).
There is no reason to spend cpu cycles flushing the cache after writing
to brd, for example, since it is using volatile memory for storage.

Moreover, the pmem driver might be fronting a volatile memory range
published by the ACPI NFIT, or the platform might have arranged to flush
cpu caches on power fail. This latter capability is a feature that has
appeared in embedded storage appliances (pre-ACPI-NFIT nvdimm
platforms).

So, this series:

1/ moves what was previously named "the pmem api" out of the global
   namespace and into drivers that need to be concerned with
   architecture specific persistent memory considerations.

2/ arranges for dax to stop abusing __copy_user_nocache() and implements
   a libnvdimm-local memcpy that uses 'movnt' on x86_64. This might be
   expanded in the future to use 'movntdqa' if the copy size is above
   some threshold, or expanded with support for other architectures [4].

3/ makes cache maintenance optional by arranging for dax to call driver
   specific copy and flush operations only if the driver publishes them.

4/ allows filesytem-dax cache management to be controlled by the block
   device write-cache queue flag. The pmem driver is updated to clear
   that flag by default when pmem is driving volatile memory.

[3]: https://lists.01.org/pipermail/linux-nvdimm/2017-January/008364.html
[4]: https://lists.01.org/pipermail/linux-nvdimm/2017-April/009478.html

These patches have been through a round of build regression fixes
notified by the 0day robot. All review welcome, but the patches that
need extra attention are the device-mapper and uio changes
(copy_from_iter_ops).

This series is based on a merge of char-misc-next (for cdev api reworks)
and libnvdimm-fixes (dax locking and __copy_user_nocache fixes).

---

Dan Williams (33):
      device-dax: rename 'dax_dev' to 'dev_dax'
      dax: refactor dax-fs into a generic provider of 'struct dax_device' instances
      dax: add a facility to lookup a dax device by 'host' device name
      dax: introduce dax_operations
      pmem: add dax_operations support
      axon_ram: add dax_operations support
      brd: add dax_operations support
      dcssblk: add dax_operations support
      block: kill bdev_dax_capable()
      dax: introduce dax_direct_access()
      dm: add dax_device and dax_operations support
      dm: teach dm-targets to use a dax_device + dax_operations
      ext2, ext4, xfs: retrieve dax_device for iomap operations
      Revert "block: use DAX for partition table reads"
      filesystem-dax: convert to dax_direct_access()
      block, dax: convert bdev_dax_supported() to dax_direct_access()
      block: remove block_device_operations ->direct_access()
      x86, dax, pmem: remove indirection around memcpy_from_pmem()
      dax, pmem: introduce 'copy_from_iter' dax operation
      dm: add ->copy_from_iter() dax operation support
      filesystem-dax: convert to dax_copy_from_iter()
      dax, pmem: introduce an optional 'flush' dax_operation
      dm: add ->flush() dax operation support
      filesystem-dax: convert to dax_flush()
      x86, dax: replace clear_pmem() with open coded memset + dax_ops->flush
      x86, dax, libnvdimm: move wb_cache_pmem() to libnvdimm
      x86, libnvdimm, pmem: move arch_invalidate_pmem() to libnvdimm
      x86, libnvdimm, dax: stop abusing __copy_user_nocache
      uio, libnvdimm, pmem: implement cache bypass for all copy_from_iter() operations
      libnvdimm, pmem: fix persistence warning
      libnvdimm, nfit: enable support for volatile ranges
      filesystem-dax: gate calls to dax_flush() on QUEUE_FLAG_WC
      libnvdimm, pmem: disable dax flushing when pmem is fronting a volatile region


 MAINTAINERS                      |    2 
 arch/powerpc/platforms/Kconfig   |    1 
 arch/powerpc/sysdev/axonram.c    |   45 +++-
 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/pmem.h      |  141 ------------
 arch/x86/include/asm/string_64.h |    1 
 block/Kconfig                    |    1 
 block/partition-generic.c        |   17 -
 drivers/Makefile                 |    2 
 drivers/acpi/nfit/core.c         |   15 +
 drivers/block/Kconfig            |    1 
 drivers/block/brd.c              |   52 +++-
 drivers/dax/Kconfig              |   10 +
 drivers/dax/Makefile             |    5 
 drivers/dax/dax.h                |   15 -
 drivers/dax/device-dax.h         |   25 ++
 drivers/dax/device.c             |  415 +++++++++++------------------------
 drivers/dax/pmem.c               |   10 -
 drivers/dax/super.c              |  445 ++++++++++++++++++++++++++++++++++++++
 drivers/md/Kconfig               |    1 
 drivers/md/dm-core.h             |    1 
 drivers/md/dm-linear.c           |   53 ++++-
 drivers/md/dm-snap.c             |    6 -
 drivers/md/dm-stripe.c           |   65 ++++--
 drivers/md/dm-target.c           |    6 -
 drivers/md/dm.c                  |  112 ++++++++--
 drivers/nvdimm/Kconfig           |    6 +
 drivers/nvdimm/Makefile          |    1 
 drivers/nvdimm/bus.c             |   10 -
 drivers/nvdimm/claim.c           |    9 -
 drivers/nvdimm/core.c            |    2 
 drivers/nvdimm/dax_devs.c        |    2 
 drivers/nvdimm/dimm_devs.c       |    2 
 drivers/nvdimm/namespace_devs.c  |    9 -
 drivers/nvdimm/nd-core.h         |    9 +
 drivers/nvdimm/pfn_devs.c        |    4 
 drivers/nvdimm/pmem.c            |   82 +++++--
 drivers/nvdimm/pmem.h            |   26 ++
 drivers/nvdimm/region_devs.c     |   39 ++-
 drivers/nvdimm/x86.c             |  155 +++++++++++++
 drivers/s390/block/Kconfig       |    1 
 drivers/s390/block/dcssblk.c     |   44 +++-
 fs/block_dev.c                   |  117 +++-------
 fs/dax.c                         |  302 ++++++++++++++------------
 fs/ext2/inode.c                  |    9 +
 fs/ext4/inode.c                  |    9 +
 fs/iomap.c                       |    3 
 fs/xfs/xfs_iomap.c               |   10 +
 include/linux/blkdev.h           |   19 --
 include/linux/dax.h              |   43 +++-
 include/linux/device-mapper.h    |   14 +
 include/linux/iomap.h            |    1 
 include/linux/libnvdimm.h        |   10 +
 include/linux/pmem.h             |  165 --------------
 include/linux/string.h           |    8 +
 include/linux/uio.h              |    4 
 lib/Kconfig                      |    6 -
 lib/iov_iter.c                   |   25 ++
 tools/testing/nvdimm/Kbuild      |   11 +
 tools/testing/nvdimm/pmem-dax.c  |   21 +-
 60 files changed, 1584 insertions(+), 1042 deletions(-)
 delete mode 100644 arch/x86/include/asm/pmem.h
 create mode 100644 drivers/dax/device-dax.h
 rename drivers/dax/{dax.c => device.c} (60%)
 create mode 100644 drivers/dax/super.c
 create mode 100644 drivers/nvdimm/x86.c
 delete mode 100644 include/linux/pmem.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
