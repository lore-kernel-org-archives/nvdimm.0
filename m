Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D7D921AE30DB
 for <linux-nvdimm@lists.01.org>; Fri, 17 Aug 2018 09:17:22 -0700 (PDT)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: [GIT PULL]: libnvdimm updates for v4.19-rc1
Date: Fri, 17 Aug 2018 16:17:19 +0000
Message-ID: <1b332ae402bfc3806b834ee2c050dbc52b7eeb01.camel@intel.com>
Content-Language: en-US
Content-ID: <306A8C1B3736C94E867E97AA8E4140DF@intel.com>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus,

Please pull to receive libnvdimm contributions for v4.19-rc1

I did mess up the base slightly and several patches that went into v4.18-rc5 ended up in the pull request.
I hope that is not a problem. I didn't want to change the branch last minute since the branch has been pulled by
linux-next for a bit. Let me know if you want me to fix that. 

I believe these are the ones that went into v4.18 already.
Dan Williams (2):
      libnvdimm, pmem: Fix memcpy_mcsafe() return code handling in nsio_rw_bytes()
      acpi, nfit: Fix scrub idle detection
Jeff Moyer (1):
      dev-dax: check_vma: ratelimit dev_info-s
Dave Jiang (1):
      acpi/nfit: fix cmd_rc for acpi_nfit_ctl to always return a value
Vishal Verma (1):
      tools/testing/nvdimm: advertise a write cache for nfit_test


The following changes since commit 021c91791a5e7e85c567452f1be3e4c2c6cb6063:

  Linux 4.18-rc3 (2018-07-01 16:04:53 -0700)

are available in the Git repository at:

  git@gitolite.kernel.org:pub/scm/linux/kernel/git/nvdimm/nvdimm.git tags/libnvdimm-for-4.19

for you to fetch changes up to 9103365c3acdcb613327be3699e231e18b5cf945:

  libnvdimm: fix ars_status output length calculation (2018-08-10 12:52:09 -0700)

----------------------------------------------------------------
libnvdimm for 4.19

* memory_failure() gets confused by dev_pagemap backed mappings. The
  recovery code has specific enabling for several possible page states
  that needs new enabling to handle poison in dax mappings. Teach
  memory_failure() about ZONE_DEVICE pages.

* Adding support to read locked nvdimm capacity.

* Change test code to make DSM failure code injection an override.

* Add support for calculate maximum contiguous area for namespace.

* Add support for queueing a short ARS when there is on going ARS for
  nvdimm.

* Allow NULL to be passed in to ->direct_access() for kaddr and
  pfn params.

* Improve smart injection support for nvdimm emulation testing.

* Fix test code that supports for emulating controller temperature.

* Fix hang on error before devm_memremap_pages()

* Fix a bug that causes user memory corruption when data returned
  to user for ars_status.

* Maintainer updates for Ross Zwisler emails and adding Jan Kara to fsdax.

----------------------------------------------------------------
Dan Williams (19):
      libnvdimm, pmem: Fix memcpy_mcsafe() return code handling in nsio_rw_bytes()
      acpi, nfit: Fix scrub idle detection
      libnvdimm: Introduce locked DIMM capacity support
      acpi, nfit: Prefer _DSM over _LSR for namespace label reads
      tools/testing/nvdimm: Make DSM failure code injection an override
      tools/testing/nvdimm: Fix support for emulating controller temperature
      device-dax: Convert to vmf_insert_mixed and vm_fault_t
      device-dax: Enable page_mapping()
      device-dax: Set page->index
      filesystem-dax: Set page->index
      mm, madvise_inject_error: Disable MADV_SOFT_OFFLINE for ZONE_DEVICE pages
      mm, dev_pagemap: Do not clear ->mapping on final put
      mm, madvise_inject_error: Let memory_failure() optionally take a page reference
      mm, memory_failure: Collect mapping size in collect_procs()
      filesystem-dax: Introduce dax_lock_mapping_entry()
      mm, memory_failure: Teach memory_failure() about dev_pagemap pages
      x86/mm/pat: Prepare {reserve, free}_memtype() for "decoy" addresses
      x86/memory_failure: Introduce {set, clear}_mce_nospec()
      libnvdimm, pmem: Restore page attributes when clearing errors

Dave Jiang (4):
      acpi/nfit: fix cmd_rc for acpi_nfit_ctl to always return a value
      acpi/nfit: queue issuing of ars when an uc error notification comes in
      Merge branch 'for-4.19/libnvdimm' into libnvdimm-for-next
      Merge branch 'for-4.19/dax-memory-failure' into libnvdimm-for-next

Huaisheng Ye (6):
      libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
      s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
      tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
      dax/super: Do not request a pointer kaddr when not required
      md/dm-writecache: Don't request pointer dummy_addr when not required
      filesystem-dax: Do not request kaddr and pfn when not required

Jeff Moyer (1):
      dev-dax: check_vma: ratelimit dev_info-s

Keith Busch (2):
      libnvdimm: Use max contiguous area for namespace size
      libnvdimm: Export max available extent

Ross Zwisler (2):
      MAINTAINERS: update Ross Zwisler's email address
      MAINTAINERS: Add Jan Kara for filesystem DAX

Stefan Hajnoczi (1):
      device-dax: avoid hang on error before devm_memremap_pages()

Vishal Verma (3):
      tools/testing/nvdimm: advertise a write cache for nfit_test
      tools/testing/nvdimm: improve emulation of smart injection
      libnvdimm: fix ars_status output length calculation

 .mailmap                                  |   1 +
 MAINTAINERS                               |  13 +-
 arch/x86/include/asm/set_memory.h         |  42 ++++++
 arch/x86/kernel/cpu/mcheck/mce-internal.h |  15 ---
 arch/x86/kernel/cpu/mcheck/mce.c          |  38 +-----
 arch/x86/mm/pat.c                         |  16 +++
 drivers/acpi/nfit/core.c                  |  70 +++++++---
 drivers/acpi/nfit/nfit.h                  |   2 +
 drivers/dax/device.c                      |  87 ++++++++-----
 drivers/dax/pmem.c                        |  12 +-
 drivers/dax/super.c                       |   3 +-
 drivers/md/dm-writecache.c                |   3 +-
 drivers/nvdimm/bus.c                      |   4 +-
 drivers/nvdimm/claim.c                    |   1 +
 drivers/nvdimm/dimm.c                     |  24 +++-
 drivers/nvdimm/dimm_devs.c                |  31 +++++
 drivers/nvdimm/namespace_devs.c           |  29 ++++-
 drivers/nvdimm/nd-core.h                  |   8 ++
 drivers/nvdimm/nd.h                       |   1 +
 drivers/nvdimm/pmem.c                     |  33 ++++-
 drivers/nvdimm/pmem.h                     |  13 ++
 drivers/nvdimm/region_devs.c              |  40 ++++++
 drivers/s390/block/dcssblk.c              |   8 +-
 fs/dax.c                                  | 138 +++++++++++++++++---
 include/linux/dax.h                       |  13 ++
 include/linux/huge_mm.h                   |   5 +-
 include/linux/mm.h                        |   1 +
 include/linux/set_memory.h                |  14 ++
 kernel/memremap.c                         |   1 -
 mm/hmm.c                                  |   2 +
 mm/huge_memory.c                          |   4 +-
 mm/madvise.c                              |  16 ++-
 mm/memory-failure.c                       | 210 ++++++++++++++++++++++++------
 tools/testing/nvdimm/pmem-dax.c           |  12 +-
 tools/testing/nvdimm/test/nfit.c          | 129 +++++++++++-------
 35 files changed, 797 insertions(+), 242 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
