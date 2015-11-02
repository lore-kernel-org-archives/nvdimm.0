Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH v3 00/15] block, dax updates for 4.4
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 01 Nov 2015 23:29:41 -0500
Message-ID: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@fb.com
Cc: Jens Axboe <axboe@kernel.dk>, Dave Hansen <dave@sr71.net>, jack@suse.cz, linux-nvdimm@lists.01.org, Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>, Dave Hansen <dave.hansen@linux.intel.com>, david@fromorbit.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, hch@lst.de, Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, kbuild test robot <fengguang.wu@intel.com>, ross.zwisler@linux.intel.com, Matthew Wilcox <willy@linux.intel.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v2: [1]

1/ Include a fix to revoke dax-mappings at device teardown time

2/ Include a blkdev_issue_flush implementation for pmem

3/ New block device ioctls to set/query dax mode, make dax opt-in

4/ Collect reviewed-by's

[1]: https://lists.01.org/pipermail/linux-nvdimm/2015-October/002538.html

---

There were several topics developed during this cycle, some are ready
and some are not.  The items needing more review and testing are the
pmem+dax updates with mm, ext4, and xfs dependencies.  Topics like the
dax locking reworks, dax get_user_pages, and write-protecting dax ptes
after fsync/msync.

Instead, this more conservative set represents the fs and mm independent
updates to dax and pmem:

1/ Enable dax mappings for raw block devices

2/ Use blk_queue_{enter|exit} and the availability of 'struct page' to
   fix lifetime issues and races with unloading the pmem driver.

3/ Enable blkdev_issue_flush to fix legacy apps that may dirty pmem via
   dax mmap I/O.  Although legacy environments should consider disabling
   dax for apps that don't expect it.

These depend on the latest 'libnvdimm-for-next' branch from nvdimm.git
and the 'for-4.4/integrity' branch from Jens' tree.  All but the last
three have been out for review previously, and I am looking to submit
them towards the back half of the merge window.

---

Dan Williams (15):
      pmem, dax: clean up clear_pmem()
      dax: increase granularity of dax_clear_blocks() operations
      block, dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()
      libnvdimm, pmem: move request_queue allocation earlier in probe
      libnvdimm, pmem: fix size trim in pmem_direct_access()
      um: kill pfn_t
      kvm: rename pfn_t to kvm_pfn_t
      mm, dax, pmem: introduce pfn_t
      block: notify queue death confirmation
      dax, pmem: introduce zone_device_revoke() and devm_memunmap_pages()
      block: introduce bdev_file_inode()
      block: enable dax for raw block devices
      block, dax: make dax mappings opt-in by default
      dax: dirty extent notification
      pmem: blkdev_issue_flush support


 arch/arm/include/asm/kvm_mmu.h        |    5 -
 arch/arm/kvm/mmu.c                    |   10 +
 arch/arm64/include/asm/kvm_mmu.h      |    3 
 arch/mips/include/asm/kvm_host.h      |    6 -
 arch/mips/kvm/emulate.c               |    2 
 arch/mips/kvm/tlb.c                   |   14 +-
 arch/powerpc/include/asm/kvm_book3s.h |    4 -
 arch/powerpc/include/asm/kvm_ppc.h    |    2 
 arch/powerpc/kvm/book3s.c             |    6 -
 arch/powerpc/kvm/book3s_32_mmu_host.c |    2 
 arch/powerpc/kvm/book3s_64_mmu_host.c |    2 
 arch/powerpc/kvm/e500.h               |    2 
 arch/powerpc/kvm/e500_mmu_host.c      |    8 +
 arch/powerpc/kvm/trace_pr.h           |    2 
 arch/powerpc/sysdev/axonram.c         |   11 +
 arch/um/include/asm/page.h            |    6 -
 arch/um/include/asm/pgtable-3level.h  |    4 -
 arch/um/include/asm/pgtable.h         |    2 
 arch/x86/include/asm/cacheflush.h     |    4 +
 arch/x86/include/asm/pmem.h           |    7 -
 arch/x86/kvm/iommu.c                  |   11 +
 arch/x86/kvm/mmu.c                    |   37 +++--
 arch/x86/kvm/mmu_audit.c              |    2 
 arch/x86/kvm/paging_tmpl.h            |    6 -
 arch/x86/kvm/vmx.c                    |    2 
 arch/x86/kvm/x86.c                    |    2 
 block/blk-core.c                      |   13 +-
 block/blk-mq.c                        |   19 ++-
 block/blk.h                           |   13 --
 block/ioctl.c                         |   42 ++++++
 drivers/block/brd.c                   |   10 +
 drivers/nvdimm/pmem.c                 |  247 ++++++++++++++++++++++++++++-----
 drivers/s390/block/dcssblk.c          |   13 +-
 fs/block_dev.c                        |  159 ++++++++++++++++++---
 fs/dax.c                              |  242 ++++++++++++++++++++++----------
 include/linux/blkdev.h                |   41 +++++
 include/linux/fs.h                    |   11 +
 include/linux/io.h                    |   17 --
 include/linux/kvm_host.h              |   37 +++--
 include/linux/kvm_types.h             |    2 
 include/linux/mm.h                    |   90 ++++++++++++
 include/linux/pfn.h                   |    9 +
 include/uapi/linux/fs.h               |    2 
 kernel/memremap.c                     |   98 +++++++++++++
 virt/kvm/kvm_main.c                   |   47 +++---
 45 files changed, 949 insertions(+), 325 deletions(-)
