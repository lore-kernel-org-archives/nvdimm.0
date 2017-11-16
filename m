Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3A1321B00DC1
 for <linux-nvdimm@lists.01.org>; Thu, 16 Nov 2017 14:07:59 -0800 (PST)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.15
Date: Thu, 16 Nov 2017 22:12:06 +0000
Message-ID: <1510870318.21471.1.camel@intel.com>
Content-Language: en-US
Content-ID: <27B6A8EF285ED5469889A7E658CD8BD0@intel.com>
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
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.15

...to receive the libnvdimm and dax update for 4.15.

Save for a few late fixes, all of these commits have shipped in -next
releases since before the merge window opened, and 0day has given a
build success notification. The MAP_SYNC work included some re-
factoring of dax_insert_mapping(), to break out a common
dax_iomap_pfn() helper, that collided with other small changes in
fs/dax.c. A suggested merge resolution for that collision and a few
other minor collisions is included below after the diffstat.

The ext4 touches came from Jan, and the xfs touches have Darrick's
reviewed-by. An xfstest for the MAP_SYNC feature [1] has been through a
few round of reviews and is on track to be merged. The final policy of
how MAP_SHARED_VALIDATE and MAP_SYNC flags behave was discussed by you
and Jan here: [2].

[1]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012974.ht
ml
[2]: https://lists.01.org/pipermail/linux-nvdimm/2017-October/012894.ht
ml

---

The following changes since commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f:

  Linux 4.14-rc4 (2017-10-08 20:53:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.15

for you to fetch changes up to 4247f24c23589bcc3bc3490515ef8c9497e9ae55:

  Merge branch 'for-4.15/dax' into libnvdimm-for-next (2017-11-15 16:56:11 -0800)

----------------------------------------------------------------
libnvdimm for 4.15

* Introduce MAP_SYNC and MAP_SHARED_VALIDATE, a mechanism to enable
 'userspace flush' of persistent memory updates via filesystem-dax
  mappings. It arranges for any filesystem metadata updates that may be
  required to satisfy a write fault to also be flushed ("on disk") before
  the kernel returns to userspace from the fault handler. Effectively
  every write-fault that dirties metadata completes an fsync() before
  returning from the fault handler. The new MAP_SHARED_VALIDATE mapping
  type guarantees that the MAP_SYNC flag is validated as supported by the
  filesystem's ->mmap() file operation.

* Add support for the standard ACPI 6.2 label access methods that
  replace the NVDIMM_FAMILY_INTEL (vendor specific) label methods. This
  enables interoperability with environments that only implement the
  standardized methods.

* Add support for the ACPI 6.2 NVDIMM media error injection methods.

* Add support for the NVDIMM_FAMILY_INTEL v1.6 DIMM commands for latch
  last shutdown status, firmware update, SMART error injection, and
  SMART alarm threshold control.

* Cleanup physical address information disclosures to be root-only.

* Fix revalidation of the DIMM "locked label area" status to support
  dynamic unlock of the label area.

* Expand unit test infrastructure to mock the ACPI 6.2 Translate SPA
  (system-physical-address) command and error injection commands.

Acknowledgements that came after the commits were pushed to -next:

957ac8c421ad dax: fix PMD faults on zero-length files
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

a39e596baa07 xfs: support for synchronous DAX faults
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

7b565c9f965b xfs: Implement xfs_filemap_pfn_mkwrite() using __xfs_filemap_fault()
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

----------------------------------------------------------------
Arvind Yadav (1):
      dax: pr_err() strings should end with newlines

Christoph Hellwig (1):
      xfs: support for synchronous DAX faults

Colin Ian King (1):
      libnvdimm, namespace: make a couple of functions static

Dan Williams (18):
      libnvdimm, dimm: clear 'locked' status on successful DIMM enable
      libnvdimm, region : make 'resource' attribute only readable by root
      libnvdimm, namespace: make 'resource' attribute only readable by root
      libnvdimm, pfn: make 'resource' attribute only readable by root
      libnvdimm, namespace: fix label initialization to use valid seq numbers
      acpi, nfit: add support for the _LSI, _LSR, and _LSW label methods
      libnvdimm: introduce 'flags' attribute for DIMM 'lock' and 'alias' status
      acpi, nfit: hide unknown commands from nmemX/commands
      acpi, nfit: add support for NVDIMM_FAMILY_INTEL v1.6 DSMs
      mm: introduce MAP_SHARED_VALIDATE, a mechanism to safely define new mmap flags
      acpi, nfit: validate commands against the device type
      tools/testing/nvdimm: unit test clear-error commands
      fs, dax: unify IOMAP_F_DIRTY read vs write handling policy in the dax core
      dax: quiet bdev_dax_supported()
      brd: remove dax support
      dax: stop requiring a live device for dax_flush()
      acpi, nfit: add 'Enable Latch System Shutdown Status' command support
      Merge branch 'for-4.15/dax' into libnvdimm-for-next

Dave Jiang (2):
      libnvdimm: move poison list functions to a new 'badrange' file
      nfit_test: add error injection DSMs

Jan Kara (17):
      mm: Handle 0 flags in _calc_vm_trans() macro
      mm: Remove VM_FAULT_HWPOISON_LARGE_MASK
      dax: Simplify arguments of dax_insert_mapping()
      dax: Factor out getting of pfn out of iomap
      dax: Create local variable for VMA in dax_iomap_pte_fault()
      dax: Create local variable for vmf->flags & FAULT_FLAG_WRITE test
      dax: Inline dax_insert_mapping() into the callsite
      dax: Inline dax_pmd_insert_mapping() into the callsite
      dax: Fix comment describing dax_iomap_fault()
      dax: Allow dax_iomap_fault() to return pfn
      dax: Allow tuning whether dax_insert_mapping_entry() dirties entry
      mm: Define MAP_SYNC and VM_SYNC flags
      dax, iomap: Add support for synchronous faults
      dax: Implement dax_finish_sync_fault()
      ext4: Simplify error handling in ext4_dax_huge_fault()
      ext4: Support for synchronous DAX faults
      xfs: Implement xfs_filemap_pfn_mkwrite() using __xfs_filemap_fault()

Jeff Moyer (1):
      dax: fix PMD faults on zero-length files

Mikulas Patocka (1):
      dax: fix general protection fault in dax_alloc_inode

Ross Zwisler (2):
      MAINTAINERS: Add entry for device DAX
      dev/dax: fix uninitialized variable build warning

Vishal Verma (3):
      libnvdimm, badrange: remove a WARN for list_empty
      nfit_test: when clearing poison, also remove badrange entries
      tools/testing/nvdimm: stricter bounds checking for error injection commands

Yasunori Goto (3):
      nfit_test Make private definitions to command emulation
      acpi nfit: Enable to show what feature is supported via ND_CMD_CALL for nfit_test
      acpi nfit: nfit_test supports translate SPA

 MAINTAINERS                                  |   8 +-
 arch/alpha/include/uapi/asm/mman.h           |   1 +
 arch/mips/include/uapi/asm/mman.h            |   1 +
 arch/parisc/include/uapi/asm/mman.h          |   1 +
 arch/xtensa/include/uapi/asm/mman.h          |   1 +
 drivers/acpi/nfit/core.c                     | 274 ++++++++++++++++++++++-
 drivers/acpi/nfit/mce.c                      |   2 +-
 drivers/acpi/nfit/nfit.h                     |  37 +++-
 drivers/block/Kconfig                        |  12 -
 drivers/block/brd.c                          |  65 ------
 drivers/dax/device.c                         |   3 +-
 drivers/dax/super.c                          |  14 +-
 drivers/nvdimm/Makefile                      |   1 +
 drivers/nvdimm/badrange.c                    | 293 ++++++++++++++++++++++++
 drivers/nvdimm/bus.c                         |  24 +-
 drivers/nvdimm/core.c                        | 260 +---------------------
 drivers/nvdimm/dimm.c                        |   3 +
 drivers/nvdimm/dimm_devs.c                   |  19 ++
 drivers/nvdimm/label.c                       |   2 +-
 drivers/nvdimm/namespace_devs.c              |   6 +-
 drivers/nvdimm/nd-core.h                     |   3 +-
 drivers/nvdimm/nd.h                          |   7 +-
 drivers/nvdimm/pfn_devs.c                    |   8 +
 drivers/nvdimm/region_devs.c                 |   8 +-
 fs/dax.c                                     | 319 ++++++++++++++++++---------
 fs/ext2/file.c                               |   2 +-
 fs/ext4/file.c                               |  26 ++-
 fs/ext4/inode.c                              |  15 ++
 fs/jbd2/journal.c                            |  17 ++
 fs/proc/task_mmu.c                           |   1 +
 fs/xfs/xfs_file.c                            |  44 ++--
 fs/xfs/xfs_iomap.c                           |   5 +
 fs/xfs/xfs_trace.h                           |   2 -
 include/linux/dax.h                          |   4 +-
 include/linux/fs.h                           |   1 +
 include/linux/iomap.h                        |   5 +
 include/linux/jbd2.h                         |   1 +
 include/linux/libnvdimm.h                    |  21 +-
 include/linux/mm.h                           |   9 +-
 include/linux/mman.h                         |  48 +++-
 include/trace/events/fs_dax.h                |   3 +-
 include/uapi/asm-generic/mman-common.h       |   1 +
 include/uapi/asm-generic/mman.h              |   1 +
 mm/mmap.c                                    |  15 ++
 tools/include/uapi/asm-generic/mman-common.h |   1 +
 tools/testing/nvdimm/Kbuild                  |   1 +
 tools/testing/nvdimm/test/nfit.c             | 319 ++++++++++++++++++++++++---
 tools/testing/nvdimm/test/nfit_test.h        |  52 +++++
 48 files changed, 1406 insertions(+), 560 deletions(-)
 create mode 100644 drivers/nvdimm/badrange.c

---

commit 82f3359eb04e3a3b5d23655eee58d31a1b17c902
Merge: 18c83d2c0390 4247f24c2358
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Nov 16 13:20:35 2017 -0800

    Merge branch 'libnvdimm-for-next' into test

diff --cc drivers/block/brd.c
index 588360d79fca,b2391bbd7e5a..8028a3a7e7fd
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@@ -20,12 -20,6 +20,7 @@@
  #include <linux/radix-tree.h>
  #include <linux/fs.h>
  #include <linux/slab.h>
 +#include <linux/backing-dev.h>
- #ifdef CONFIG_BLK_DEV_RAM_DAX
- #include <linux/pfn_t.h>
- #include <linux/dax.h>
- #include <linux/uio.h>
- #endif
  
  #include <linux/uaccess.h>
  
@@@ -449,23 -401,9 +401,10 @@@ static struct brd_device *brd_alloc(in
  	disk->flags		= GENHD_FL_EXT_DEVT;
  	sprintf(disk->disk_name, "ram%d", i);
  	set_capacity(disk, rd_size * 2);
 +	disk->queue->backing_dev_info->capabilities |= BDI_CAP_SYNCHRONOUS_IO;
  
- #ifdef CONFIG_BLK_DEV_RAM_DAX
- 	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
- 	brd->dax_dev = alloc_dax(brd, disk->disk_name, &brd_dax_ops);
- 	if (!brd->dax_dev)
- 		goto out_free_inode;
- #endif
- 
- 
  	return brd;
  
- #ifdef CONFIG_BLK_DEV_RAM_DAX
- out_free_inode:
- 	kill_dax(brd->dax_dev);
- 	put_dax(brd->dax_dev);
- #endif
  out_free_queue:
  	blk_cleanup_queue(brd->brd_queue);
  out_free_dev:
diff --cc fs/dax.c
index 3652b26a0048,f757cd0e2d07..95981591977a
--- a/fs/dax.c
+++ b/fs/dax.c
@@@ -825,38 -820,42 +825,42 @@@ out
  }
  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
  
- static int dax_insert_mapping(struct address_space *mapping,
- 		struct block_device *bdev, struct dax_device *dax_dev,
- 		sector_t sector, size_t size, void *entry,
- 		struct vm_area_struct *vma, struct vm_fault *vmf)
+ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
  {
- 	unsigned long vaddr = vmf->address;
- 	void *ret, *kaddr;
 -	return iomap->blkno + (((pos & PAGE_MASK) - iomap->offset) >> 9);
++	return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
+ }
+ 
+ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
+ 			 pfn_t *pfnp)
+ {
+ 	const sector_t sector = dax_iomap_sector(iomap, pos);
  	pgoff_t pgoff;
+ 	void *kaddr;
  	int id, rc;
- 	pfn_t pfn;
+ 	long length;
  
- 	rc = bdev_dax_pgoff(bdev, sector, size, &pgoff);
+ 	rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
  	if (rc)
  		return rc;
- 
  	id = dax_read_lock();
- 	rc = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size), &kaddr, &pfn);
- 	if (rc < 0) {
- 		dax_read_unlock(id);
- 		return rc;
+ 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
+ 				   &kaddr, pfnp);
+ 	if (length < 0) {
+ 		rc = length;
+ 		goto out;
  	}
+ 	rc = -EINVAL;
+ 	if (PFN_PHYS(length) < size)
+ 		goto out;
+ 	if (pfn_t_to_pfn(*pfnp) & (PHYS_PFN(size)-1))
+ 		goto out;
+ 	/* For larger pages we need devmap */
+ 	if (length > 1 && !pfn_t_devmap(*pfnp))
+ 		goto out;
+ 	rc = 0;
+ out:
  	dax_read_unlock(id);
- 
- 	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
- 	if (IS_ERR(ret))
- 		return PTR_ERR(ret);
- 
- 	trace_dax_insert_mapping(mapping->host, vmf, ret);
- 	if (vmf->flags & FAULT_FLAG_WRITE)
- 		return vm_insert_mixed_mkwrite(vma, vaddr, pfn);
- 	else
- 		return vm_insert_mixed(vma, vaddr, pfn);
+ 	return rc;
  }
  
  /*
diff --cc fs/ext4/inode.c
index 8d2b582fb141,ee4d907a4251..0992d76f7ab1
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -3384,6 -3393,20 +3384,19 @@@ static int ext4_releasepage(struct pag
  		return try_to_free_buffers(page);
  }
  
 -#ifdef CONFIG_FS_DAX
+ static bool ext4_inode_datasync_dirty(struct inode *inode)
+ {
+ 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
+ 
+ 	if (journal)
+ 		return !jbd2_transaction_committed(journal,
+ 					EXT4_I(inode)->i_datasync_tid);
+ 	/* Any metadata buffers to write? */
+ 	if (!list_empty(&inode->i_mapping->private_list))
+ 		return true;
+ 	return inode->i_state & I_DIRTY_DATASYNC;
+ }
+ 
  static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
  			    unsigned flags, struct iomap *iomap)
  {
diff --cc include/linux/iomap.h
index ca10767ab73d,73e3b7085dbe..d187cf7c4757
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@@ -22,8 -21,12 +22,13 @@@ struct vm_fault
  /*
   * Flags for all iomap mappings:
   */
 -#define IOMAP_F_NEW	0x01	/* blocks have been newly allocated */
 +#define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 +#define IOMAP_F_BOUNDARY	0x02	/* mapping ends at metadata boundary */
+ /*
+  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
+  * written data and requires fdatasync to commit them to persistent storage.
+  */
 -#define IOMAP_F_DIRTY	0x02
++#define IOMAP_F_DIRTY		0x04
  
  /*
   * Flags that only need to be reported for IOMAP_REPORT requests:
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
