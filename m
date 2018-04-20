Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x244.google.com (mail-io0-x244.google.com
 [IPv6:2607:f8b0:4001:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D3247228392E1
 for <linux-nvdimm@lists.01.org>; Fri, 20 Apr 2018 16:37:05 -0700 (PDT)
Received: by mail-io0-x244.google.com with SMTP id v13-v6so12333874iob.6
 for <linux-nvdimm@lists.01.org>; Fri, 20 Apr 2018 16:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <1523337147.23102.31.camel@intel.com>
In-Reply-To: <1523337147.23102.31.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Apr 2018 23:36:53 +0000
Message-ID: <CAA9_cmftqu55K4YG1i18S7ZPD9r8gT0r1CH_gsA=jzAbbO2uuQ@mail.gmail.com>
Subject: Fwd: [GIT PULL] libnvdimm for 4.17
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
To: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ adding to the linux-nvdimm archive ]

---------- Forwarded message ---------
From: Williams, Dan J <dan.j.williams@intel.com>
Date: Mon, Apr 9, 2018 at 10:15 PM
Subject: [GIT PULL] libnvdimm for 4.17
To: torvalds@linux-foundation.org <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>,
linux-acpi@vger.kernel.org <linux-acpi@vger.kernel.org>,
linux-fsdevel@vger.kernel.org <linux-fsdevel@vger.kernel.org>,
inux-nvdimm@lists.01.org <inux-nvdimm@lists.01.org>


Hi Linus, please pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-4.17

...to receive the libnvdimm update for 4.17.

This cycle was was not something I ever want to repeat as there were
several late changes that have only now just settled. Half of the
branch up to commit d2c997c0f145 "fs, dax: use page->mapping to
warn..." have been in -next for several releases. The of_pmem driver
and the address range scrub rework were late arrivals, and the dax work
was scaled back at the last moment.

The of_pmem driver missed a previous merge window due to an oversight.
A sense of obligation to rectify that miss is why it is included for
4.17. It has acks from PowerPC folks. Stephen reported a build failure
that only occurs when merging it with your latest tree, for now I have
fixed that up by disabling modular builds of of_pmem. A test merge with
your tree has received a build success report from the 0day robot over
156 configs.

An initial version of the ARS rework was submitted before the merge
window. It is self contained to libnvdimm, a net code reduction, and
passing all unit tests.

The filesystem-dax changes are based on the wait_var_event()
functionality from tip/sched/core. However, late review feedback showed
that those changes regressed truncate performance to a large degress.
The branch was rewound to drop the truncate behavior change and now
only includes preparation patches and cleanups (with full acks and
reviews). The finalization of this dax-dma-vs-trnucate work will need
to wait for 4.18.

git picked the wait_var_event() baseline for the diffstat, so I also
include the diffstat of the test merge below.

The following changes since commit 3eb2ce825ea1ad89d20f7a3b5780df850e4be274:

   Linux 4.16-rc7 (2018-03-25 12:44:30 -1000)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-4.17

for you to fetch changes up to e13e75b86ef2f88e3a47d672dd4c52a293efb95b:

   Merge branch 'for-4.17/dax' into libnvdimm-for-next (2018-04-09 10:50:17
-0700)

----------------------------------------------------------------
libnvdimm for 4.17

* A rework of the filesytem-dax implementation provides for detection of
   unmap operations (truncate / hole punch) colliding with in-progress
   device-DMA. A fix for these collisions remains a work-in-progress
   pending resolution of truncate latency and starvation regressions.

* The of_pmem driver expands the users of libnvdimm outside of x86 and
   ACPI to describe an implementation of persistent memory on PowerPC with
   Open Firmware / Device tree.

* Address Range Scrub (ARS) handling is completely rewritten to account for
   the fact that ARS may run for 100s of seconds and there is no platform
   defined way to cancel it. ARS will now no longer block namespace
   initialization.

* The NVDIMM Namespace Label implementation is updated to handle label
   areas as small as 1K, down from 128K.

* Miscellaneous cleanups and updates to unit test infrastructure.

----------------------------------------------------------------
Dan Williams (26):
       libnvdimm: remove redundant __func__ in dev_dbg
       device-dax: remove redundant __func__ in dev_dbg
       nfit: skip region registration for incomplete control regions
       acpi, nfit: rework NVDIMM leaf method detection
       dax: store pfns in the radix
       fs, dax: prepare for dax-specific address_space_operations
       block, dax: remove dead code in blkdev_writepages()
       xfs, dax: introduce xfs_dax_aops
       ext4, dax: introduce ext4_dax_aops
       nfit: fix region registration vs block-data-window ranges
       ext2, dax: introduce ext2_dax_aops
       fs, dax: use page->mapping to warn if truncate collides with a busy
page
       dax: introduce CONFIG_DAX_DRIVER
       dax, dm: allow device-mapper to operate without dax support
       nfit, address-range-scrub: fix scrub in-progress reporting
       libnvdimm: add an api to cast a 'struct nd_region' to its 'struct
device'
       nfit, address-range-scrub: introduce nfit_spa->ars_state
       libnvdimm, dimm: fix dpa reservation vs uninitialized label area
       libnvdimm, namespace: use a safe lookup for dimm device name
       libnvdimm, region: quiet region probe
       nfit, address-range-scrub: determine one platform max_ars value
       nfit, address-range-scrub: rework and simplify ARS state machine
       nfit, address-range-scrub: add module option to skip initial ars
       libnvdimm, of_pmem: workaround OF_NUMA=n build error
       Merge branch 'for-4.17/libnvdimm' into libnvdimm-for-next
       Merge branch 'for-4.17/dax' into libnvdimm-for-next

Johannes Thumshirn (4):
       acpi, nfit: remove redundant __func__ in dev_dbg
       libnvdimm: provide module_nd_driver wrapper
       libnvdimm, pmem: use module_nd_driver
       device-dax: use module_nd_driver

Oliver O'Halloran (4):
       libnvdimm: Add of_node to region and bus descriptors
       libnvdimm: Add device-tree based driver
       doc/devicetree: Persistent memory region bindings
       powerpc/powernv: Create platform devs for nvdimm buses

Ross Zwisler (3):
       nfit_test: improve structure offset handling
       nfit_test: fix buffer overrun, add sanity check
       nfit_test: prevent parsing error of nfit_test.0

Toshi Kani (2):
       libnvdimm, label: change min label storage size per UEFI 2.7
       libnvdimm, label: change nvdimm_num_label_slots per UEFI 2.7

Vishal Verma (2):
       libnvdimm, testing: Add emulation for smart injection commands
       libnvdimm, testing: update the default smart ctrl_temperature

  Documentation/admin-guide/kernel-parameters.txt    |  11 +
  .../devicetree/bindings/pmem/pmem-region.txt       |  65 ++
  MAINTAINERS                                        |   8 +
  arch/powerpc/platforms/powernv/opal.c              |   3 +
  drivers/acpi/nfit/core.c                           | 679
++++++++++-----------
  drivers/acpi/nfit/mce.c                            |   5 +-
  drivers/acpi/nfit/nfit.h                           |  22 +-
  drivers/dax/Kconfig                                |   5 +-
  drivers/dax/device.c                               |  38 +-
  drivers/dax/pmem.c                                 |  18 +-
  drivers/dax/super.c                                |  15 +-
  drivers/md/Kconfig                                 |   2 +-
  drivers/md/dm-linear.c                             |   6 +
  drivers/md/dm-log-writes.c                         |  95 +--
  drivers/md/dm-stripe.c                             |   6 +
  drivers/md/dm.c                                    |  10 +-
  drivers/nvdimm/Kconfig                             |  13 +-
  drivers/nvdimm/Makefile                            |   1 +
  drivers/nvdimm/btt_devs.c                          |  21 +-
  drivers/nvdimm/bus.c                               |  14 +-
  drivers/nvdimm/claim.c                             |   2 +-
  drivers/nvdimm/core.c                              |   6 +-
  drivers/nvdimm/dax_devs.c                          |   5 +-
  drivers/nvdimm/dimm.c                              |   8 +-
  drivers/nvdimm/dimm_devs.c                         |   7 +-
  drivers/nvdimm/label.c                             |  85 +--
  drivers/nvdimm/label.h                             |   2 +-
  drivers/nvdimm/namespace_devs.c                    |  42 +-
  drivers/nvdimm/nd.h                                |   1 -
  drivers/nvdimm/of_pmem.c                           | 119 ++++
  drivers/nvdimm/pfn_devs.c                          |  25 +-
  drivers/nvdimm/pmem.c                              |  14 +-
  drivers/nvdimm/region.c                            |   4 +-
  drivers/nvdimm/region_devs.c                       |   9 +
  drivers/s390/block/Kconfig                         |   2 +-
  fs/block_dev.c                                     |   5 -
  fs/dax.c                                           | 146 +++--
  fs/ext2/ext2.h                                     |   1 +
  fs/ext2/inode.c                                    |  46 +-
  fs/ext2/namei.c                                    |  18 +-
  fs/ext4/inode.c                                    |  42 +-
  fs/libfs.c                                         |  39 ++
  fs/xfs/xfs_aops.c                                  |  34 +-
  fs/xfs/xfs_aops.h                                  |   1 +
  fs/xfs/xfs_iops.c                                  |   5 +-
  include/linux/dax.h                                |  42 +-
  include/linux/fs.h                                 |   4 +
  include/linux/libnvdimm.h                          |   4 +
  include/linux/nd.h                                 |   6 +
  include/linux/sched/deadline.h                     |   6 -
  include/linux/sched/isolation.h                    |   1 +
  include/linux/sched/nohz.h                         |   4 -
  include/linux/tick.h                               |   4 +-
  include/linux/wait_bit.h                           |  70 +++
  kernel/sched/Makefile                              |   5 +-
  kernel/sched/autogroup.c                           |  21 +-
  kernel/sched/autogroup.h                           |  12 +-
  kernel/sched/clock.c                               |  36 +-
  kernel/sched/completion.c                          |   5 +-
  kernel/sched/core.c                                | 165 +++--
  kernel/sched/cpuacct.c                             |  33 +-
  kernel/sched/cpudeadline.c                         |  23 +-
  kernel/sched/cpudeadline.h                         |  29 +-
  kernel/sched/cpufreq.c                             |   1 -
  kernel/sched/cpufreq_schedutil.c                   | 137 ++---
  kernel/sched/cpupri.c                              |  15 +-
  kernel/sched/cpupri.h                              |  25 +-
  kernel/sched/cputime.c                             |  58 +-
  kernel/sched/deadline.c                            |  78 +--
  kernel/sched/debug.c                               |  99 ++-
  kernel/sched/fair.c                                | 299 +++++----
  kernel/sched/idle.c                                | 142 ++++-
  kernel/sched/idle_task.c                           | 110 ----
  kernel/sched/isolation.c                           |  14 +-
  kernel/sched/loadavg.c                             |  34 +-
  kernel/sched/membarrier.c                          |  27 +-
  kernel/sched/rt.c                                  |  51 +-
  kernel/sched/sched.h                               | 623
++++++++++---------
  kernel/sched/stats.c                               |  20 +-
  kernel/sched/stats.h                               |  86 ++-
  kernel/sched/stop_task.c                           |  11 +-
  kernel/sched/swait.c                               |   6 +-
  kernel/sched/topology.c                            |  46 +-
  kernel/sched/wait.c                                |  13 +-
  kernel/sched/wait_bit.c                            |  71 ++-
  kernel/time/tick-sched.c                           |  15 +-
  kernel/workqueue.c                                 |   3 +-
  tools/testing/nvdimm/test/nfit.c                   | 239 +++++---
  tools/testing/nvdimm/test/nfit_test.h              |  16 +
  89 files changed, 2513 insertions(+), 1901 deletions(-)
  create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
  create mode 100644 drivers/nvdimm/of_pmem.c
  delete mode 100644 kernel/sched/idle_task.c

---
Test merge diffstat:

  .../devicetree/bindings/pmem/pmem-region.txt       |  65 ++
  MAINTAINERS                                        |   8 +
  arch/powerpc/platforms/powernv/opal.c              |   3 +
  drivers/acpi/nfit/core.c                           | 679
++++++++++-----------
  drivers/acpi/nfit/mce.c                            |   5 +-
  drivers/acpi/nfit/nfit.h                           |  22 +-
  drivers/dax/Kconfig                                |   5 +-
  drivers/dax/device.c                               |  38 +-
  drivers/dax/pmem.c                                 |  18 +-
  drivers/dax/super.c                                |  15 +-
  drivers/md/Kconfig                                 |   2 +-
  drivers/md/dm-linear.c                             |   6 +
  drivers/md/dm-log-writes.c                         |  95 +--
  drivers/md/dm-stripe.c                             |   6 +
  drivers/md/dm.c                                    |  10 +-
  drivers/nvdimm/Kconfig                             |  13 +-
  drivers/nvdimm/Makefile                            |   1 +
  drivers/nvdimm/btt_devs.c                          |  21 +-
  drivers/nvdimm/bus.c                               |  14 +-
  drivers/nvdimm/claim.c                             |   2 +-
  drivers/nvdimm/core.c                              |   6 +-
  drivers/nvdimm/dax_devs.c                          |   5 +-
  drivers/nvdimm/dimm.c                              |   8 +-
  drivers/nvdimm/dimm_devs.c                         |   7 +-
  drivers/nvdimm/label.c                             |  85 +--
  drivers/nvdimm/label.h                             |   2 +-
  drivers/nvdimm/namespace_devs.c                    |  42 +-
  drivers/nvdimm/nd.h                                |   1 -
  drivers/nvdimm/of_pmem.c                           | 119 ++++
  drivers/nvdimm/pfn_devs.c                          |  25 +-
  drivers/nvdimm/pmem.c                              |  14 +-
  drivers/nvdimm/region.c                            |   4 +-
  drivers/nvdimm/region_devs.c                       |   9 +
  drivers/s390/block/Kconfig                         |   2 +-
  fs/block_dev.c                                     |   5 -
  fs/dax.c                                           | 146 +++--
  fs/ext2/ext2.h                                     |   1 +
  fs/ext2/inode.c                                    |  46 +-
  fs/ext2/namei.c                                    |  18 +-
  fs/ext4/inode.c                                    |  42 +-
  fs/libfs.c                                         |  39 ++
  fs/xfs/xfs_aops.c                                  |  34 +-
  fs/xfs/xfs_aops.h                                  |   1 +
  fs/xfs/xfs_iops.c                                  |   5 +-
  include/linux/dax.h                                |  42 +-
  include/linux/fs.h                                 |   4 +
  include/linux/libnvdimm.h                          |   4 +
  include/linux/nd.h                                 |   6 +
  tools/testing/nvdimm/test/nfit.c                   | 239 +++++---
  tools/testing/nvdimm/test/nfit_test.h              |  16 +
  50 files changed, 1217 insertions(+), 788 deletions(-)--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
