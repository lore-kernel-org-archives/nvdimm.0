Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8CF772215BD87
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 16:01:25 -0800 (PST)
Date: Mon, 5 Feb 2018 17:07:06 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [GIT PULL] libnvdimm for 4.16
Message-ID: <20180206000706.GA24568@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdim=
m-for-4.16

...to receive the libnvdimm update for 4.16.

All of these commits have shipped in -next and have received build verifica=
tion
notices from 0day.

There is one small merge conflict that Michael Ellerman also noted in his p=
ull
request.  In Michael's tree the axonram driver was removed, and in our tree=
 it
received two small updates.  The merge can be trivially resolved by just
keeping the driver removed per Michael's tree.

Regarding the vmem_altmap patches, Michal Hocko took a quick look and while=
 it
wasn't a full review he has future plans to reuse vmem_altmap in wider plac=
es
in the memory hotplug code, so he's in favor of getting it properly plumbed.

In case you wanted to inspect them or verify the merge I've also pushed the
three topic branches for this cycle to our nvdimm tree: =


  for-4.16/nfit
  for-4.16/libnvdimm
  for-4.16/dax

---

The following changes since commit a7f2766ac7c359216da4e714dc117c881e39a74a:

  Merge branches 'acpi-gpio', 'acpi-button', 'acpi-battery' and 'acpi-video=
' (2018-01-18 03:02:16 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdim=
m-for-4.16

for you to fetch changes up to ee95f4059a833839bf52972191b2d4c3d3cec552:

  Merge branch 'for-4.16/nfit' into libnvdimm-for-next (2018-02-03 00:26:26=
 -0700)

----------------------------------------------------------------
libnvdimm for 4.16

* Require struct page by default for filesystem DAX to remove a number of
  surprising failure cases.  This includes failures with direct I/O, gdb and
  fork(2).

* Add support for the new Platform Capabilities Structure added to the NFIT=
 in
  ACPI 6.2a.  This new table tells us whether the platform supports flushing
  of CPU and memory controller caches on unexpected power loss events.

* Revamp vmem_altmap and dev_pagemap handling to clean up code and better
  support future future PCI P2P uses.

* Deprecate the ND_IOCTL_SMART_THRESHOLD command whose payload has become
  out-of-sync with recent versions of the NVDIMM_FAMILY_INTEL spec, and
  instead rely on the generic ND_CMD_CALL approach used by the two other IO=
CTL
  families, NVDIMM_FAMILY_{HPE,MSFT}.

* Enhance nfit_test so we can test some of the new things added in version =
1.6
  of the DSM specification.  This includes testing firmware download and
  simulating the Last Shutdown State (LSS) status.

----------------------------------------------------------------
Christoph Hellwig (16):
      memremap: provide stubs for vmem_altmap_offset and vmem_altmap_free
      mm: don't export arch_add_memory
      mm: don't export __add_pages
      mm: pass the vmem_altmap to arch_add_memory and __add_pages
      mm: pass the vmem_altmap to vmemmap_populate
      mm: pass the vmem_altmap to arch_remove_memory and __remove_pages
      mm: pass the vmem_altmap to vmemmap_free
      mm: pass the vmem_altmap to memmap_init_zone
      mm: split altmap memory map allocation from normal case
      mm: merge vmem_altmap_alloc into altmap_alloc_block_buf
      mm: move get_dev_pagemap out of line
      mm: optimize dev_pagemap reference counting around get_dev_pagemap
      memremap: remove to_vmem_altmap
      memremap: simplify duplicate region handling in devm_memremap_pages
      memremap: change devm_memremap_pages interface to use struct dev_page=
map
      memremap: merge find_dev_pagemap into get_dev_pagemap

Colin Ian King (1):
      libnvdimm, namespace: remove redundant initialization of 'nd_mapping'

Dan Williams (8):
      nfit, libnvdimm: deprecate the generic SMART ioctl
      tools/testing/nvdimm: smart alarm/threshold control
      mm, dax: introduce pfn_t_special()
      ext4: auto disable dax instead of failing mount
      ext2: auto disable dax instead of failing mount
      dax: require 'struct page' by default for filesystem dax
      tools/testing/nvdimm: force nfit_test to depend on instrumented modul=
es
      libnvdimm, namespace: make min namespace size 4K

Dave Jiang (6):
      acpi: nfit: Add support for detect platform CPU cache flush on power =
loss
      acpi: nfit: add persistent memory control flag for nd_region
      libnvdimm: expose platform persistence attribute for nd_region
      nfit-test: Add platform cap support from ACPI 6.2a to test
      libnvdimm/nfit_test: add firmware download emulation
      libnvdimm/nfit_test: adding support for unit testing enable LSS status

Jan H. Sch=F6nherr (2):
      mm: Fix memory size alignment in devm_memremap_pages_release()
      mm: Fix devm_memremap_pages() collision handling

Jeff Moyer (1):
      libnvdimm, btt: fix uninitialized err_lock

Logan Gunthorpe (1):
      memremap: drop private struct page_map

Luis de Bethencourt (1):
      device-dax: Fix trailing semicolon

Ross Zwisler (2):
      Merge branch 'for-4.16/dax' into libnvdimm-for-next
      Merge branch 'for-4.16/nfit' into libnvdimm-for-next

Toshi Kani (1):
      acpi, nfit: fix register dimm error handling

 arch/arm64/mm/mmu.c                    |   9 +-
 arch/ia64/mm/discontig.c               |   6 +-
 arch/ia64/mm/init.c                    |  18 +-
 arch/powerpc/mm/init_64.c              |  17 +-
 arch/powerpc/mm/mem.c                  |  11 +-
 arch/powerpc/platforms/Kconfig         |   1 +
 arch/powerpc/sysdev/axonram.c          |   2 +-
 arch/s390/mm/init.c                    |   7 +-
 arch/s390/mm/vmem.c                    |   6 +-
 arch/sh/mm/init.c                      |  10 +-
 arch/sparc/mm/init_64.c                |   5 +-
 arch/x86/mm/init_32.c                  |   9 +-
 arch/x86/mm/init_64.c                  |  94 ++++---
 drivers/acpi/nfit/core.c               |  26 ++
 drivers/acpi/nfit/nfit.h               |   1 +
 drivers/dax/device.c                   |   2 +-
 drivers/dax/pmem.c                     |  20 +-
 drivers/dax/super.c                    |  10 +
 drivers/nvdimm/btt.c                   |   2 +-
 drivers/nvdimm/bus.c                   |   3 -
 drivers/nvdimm/namespace_devs.c        |   2 +-
 drivers/nvdimm/nd.h                    |   9 +-
 drivers/nvdimm/pfn_devs.c              |  27 +-
 drivers/nvdimm/pmem.c                  |  41 +--
 drivers/nvdimm/pmem.h                  |   1 +
 drivers/nvdimm/region_devs.c           |  13 +
 drivers/s390/block/Kconfig             |   1 +
 drivers/s390/block/dcssblk.c           |   3 +-
 fs/Kconfig                             |   7 +
 fs/ext2/super.c                        |   7 +-
 fs/ext4/super.c                        |   9 +-
 include/linux/libnvdimm.h              |  11 +
 include/linux/memory_hotplug.h         |  29 +-
 include/linux/memremap.h               |  77 ++---
 include/linux/mm.h                     |  22 +-
 include/linux/pfn_t.h                  |  13 +
 include/uapi/linux/ndctl.h             |  56 +---
 kernel/memremap.c                      | 174 +++++-------
 mm/gup.c                               |   7 +-
 mm/hmm.c                               |  13 +-
 mm/memory.c                            |  16 +-
 mm/memory_hotplug.c                    |  39 ++-
 mm/page_alloc.c                        |   6 +-
 mm/sparse-vmemmap.c                    |  67 ++---
 mm/sparse.c                            |  43 +--
 tools/testing/nvdimm/Kbuild            |   4 +
 tools/testing/nvdimm/acpi_nfit_test.c  |   8 +
 tools/testing/nvdimm/device_dax_test.c |   8 +
 tools/testing/nvdimm/libnvdimm_test.c  |   8 +
 tools/testing/nvdimm/pmem_test.c       |   8 +
 tools/testing/nvdimm/test/iomap.c      |   7 +-
 tools/testing/nvdimm/test/nfit.c       | 498 +++++++++++++++++++++++++++++=
----
 tools/testing/nvdimm/test/nfit_test.h  | 134 +++++++++
 tools/testing/nvdimm/watermark.h       |  21 ++
 54 files changed, 1122 insertions(+), 526 deletions(-)
 create mode 100644 tools/testing/nvdimm/acpi_nfit_test.c
 create mode 100644 tools/testing/nvdimm/device_dax_test.c
 create mode 100644 tools/testing/nvdimm/libnvdimm_test.c
 create mode 100644 tools/testing/nvdimm/pmem_test.c
 create mode 100644 tools/testing/nvdimm/watermark.h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
