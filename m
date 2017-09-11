Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E0BC21E87964
 for <linux-nvdimm@lists.01.org>; Mon, 11 Sep 2017 10:14:47 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: [GIT PULL] libnvdimm for 4.14
Date: Mon, 11 Sep 2017 17:17:41 +0000
Message-ID: <1505150259.20229.2.camel@intel.com>
Content-Language: en-US
Content-ID: <C27A9237A90A5E48ADA2FDD8AD728BB7@intel.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.14

...to receive:

A rework of media error handling in the BTT driver and other updates.
It has appeared in a few -next releases and collected some late-
breaking build-error and warning fixups as a result. There are no known
merge conflicts, and the touches to fs/ have reviewed-by tags.

---

The following changes since commit 14ccee78fc82f5512908f4424f541549a5705b89:

  Linux 4.13-rc6 (2017-08-20 14:13:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-for-4.14

for you to fetch changes up to 04c3c982fcc0151ed3574d7ae4f1e62278054d72:

  libnvdimm, btt: fix format string warnings (2017-09-09 11:31:39 -0700)

----------------------------------------------------------------
libnvdimm for 4.14

* Media error handling support in the Block Translation Table (BTT)
  driver is reworked to address sleeping-while-atomic locking and
  memory-allocation-context conflicts.

* The dax_device lookup overhead for xfs and ext4 is moved out of the
  iomap hot-path to a mount-time lookup.

* A new 'ecc_unit_size' sysfs attribute is added to advertise the
  read-modify-write boundary property of a persistent memory range.

* Preparatory fix-ups for arm and powerpc pmem support are included
  along with other miscellaneous fixes.

----------------------------------------------------------------
Christophe Jaillet (1):
      libnvdimm, btt: check memory allocation failure

Colin Ian King (1):
      ext4: fix null pointer dereference on sbi

Dan Williams (13):
      nfit, libnvdimm, region: export 'position' in mapping info
      nfit: cleanup long de-reference chains in acpi_nfit_init_interleave_set
      libnvdimm: rename nd_sector_size_{show,store} to nd_size_select_{show,store}
      libnvdimm, pfn, dax: limit namespace alignments to the supported set
      libnvdimm, label: fix index block size calculation
      dax: introduce a fs_dax_get_by_bdev() helper
      xfs: perform dax_device lookup at mount
      ext2: perform dax_device lookup at mount
      ext4: perform dax_device lookup at mount
      libnvdimm, nfit: export an 'ecc_unit_size' sysfs attribute
      libnvdimm: fix integer overflow static analysis warning
      Merge branch 'for-4.14/fs' into libnvdimm-for-next
      dax: fix FS_DAX=n BLOCK=y compilation

Meng Xu (1):
      libnvdimm, nfit: move the check on nd_reserved2 to the endpoint

Oliver O'Halloran (2):
      libnvdimm: Stop using HPAGE_SIZE
      libnvdimm, pfn, dax: show supported dax/pfn region alignments in sysfs

Randy Dunlap (1):
      libnvdimm, btt: fix format string warnings

Robin Murphy (1):
      libnvdimm, nd_blk: remove mmio_flush_range()

Vishal Verma (7):
      libnvdimm, btt: fix a missed NVDIMM_IO_ATOMIC case in the write path
      libnvdimm, btt: refactor map entry operations with macros
      libnvdimm, btt: ensure that flags were also unchanged during a map_read
      libnvdimm, btt: cache sector_size in arena_info
      libnvdimm: fix potential deadlock while clearing errors
      libnvdimm, btt: rework error clearing
      libnvdimm, btt: clean up warning and error messages

 arch/x86/Kconfig                  |   1 -
 arch/x86/include/asm/cacheflush.h |   2 -
 drivers/acpi/nfit/Kconfig         |   2 +-
 drivers/acpi/nfit/core.c          |  50 ++++++++--
 drivers/dax/super.c               |  12 +++
 drivers/nvdimm/btt.c              | 197 ++++++++++++++++++++++++++++++--------
 drivers/nvdimm/btt.h              |  11 +++
 drivers/nvdimm/btt_devs.c         |   4 +-
 drivers/nvdimm/bus.c              |  27 +++---
 drivers/nvdimm/claim.c            |   9 +-
 drivers/nvdimm/core.c             |  10 +-
 drivers/nvdimm/label.c            |  30 +++---
 drivers/nvdimm/namespace_devs.c   |   6 +-
 drivers/nvdimm/nd.h               |  16 +++-
 drivers/nvdimm/pfn_devs.c         |  53 ++++++----
 drivers/nvdimm/pmem.h             |  14 ---
 drivers/nvdimm/region_devs.c      |   6 +-
 fs/ext2/ext2.h                    |   1 +
 fs/ext2/inode.c                   |  11 +--
 fs/ext2/super.c                   |   4 +
 fs/ext4/ext4.h                    |   1 +
 fs/ext4/inode.c                   |  11 +--
 fs/ext4/super.c                   |   4 +
 fs/xfs/xfs_aops.c                 |  13 +++
 fs/xfs/xfs_aops.h                 |   1 +
 fs/xfs/xfs_buf.c                  |   4 +-
 fs/xfs/xfs_buf.h                  |   3 +-
 fs/xfs/xfs_iomap.c                |  10 +-
 fs/xfs/xfs_super.c                |  25 ++++-
 include/linux/dax.h               |   6 ++
 include/linux/libnvdimm.h         |  16 ++++
 lib/Kconfig                       |   3 -
 tools/testing/nvdimm/test/nfit.c  |   4 +-
 33 files changed, 397 insertions(+), 170 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
