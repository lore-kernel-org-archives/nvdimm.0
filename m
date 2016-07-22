Return-Path: <linux-kernel-owner@vger.kernel.org>
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 0/3] ARS rescanning triggered by latent errors or userspace
Date: Fri, 22 Jul 2016 17:21:30 -0600
Message-Id: <1469229693-17980-1-git-send-email-vishal.l.verma@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Dan Williams <dan.j.williams@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Vishal Verma <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes in v3:
- Add a missing sysfs_put (Dan)
- Improve readability in an expression, making it (!x || !y) instead
  of !(x && y) (Dan)
- Only show the 'scrub' attribute if ARS is supported (Linda)
- For scrub_show(), indicate if a scrub is in progress (Dan)
- Rebase to nvdimm-for-next + 2 patches from Dan to handle resource leaks
  with nfit_test
- Remove an unnecessary mutex lock/unlock in nfit_exit in Patch 3


Changes in v2:
- Rework the ars_done flag in nfit_spa to be ars_required, and reuse it for
  rescanning (Dan)
- Rename the ars_rescan attribute to simply 'scrub', and move into the nfit
  group since only nfit buses have this capability (Dan)
- Make the scrub attribute RW, and on reads return the number of times a
  scrub has happened since driver load. This prompted some additional
  refactoring, notably the new helpers acpi_nfit_desc_alloc_register, and
  to_nvdimm_bus_dev. These are all in patch 2. (Dan)
- Remove some redundant list_empty checks in patch 3 (Dan)
- If the acpi_descs lists is not empty at driver unload time, WARN() (Dan)

This series adds on-demand ARS scanning on both, discovery of
latent media errors, and a sysfs trigger from userspace.

The rescanning part is easy to test using the nfit_test framework
- create a namespace (this will by default have bad sectors in
the middle), clear the bad sectors by writing to them, trigger
the rescan through sysfs, and the bad sectors will reappear in
/sys/block/<pmemX>/badblocks.

For the mce handling, I've tested the notifier chain callback
being called with a mock struct mce (called via another sysfs
trigger - this isn't included in the patch obviously), which
has the address field set to a known address in a SPA range,
and the status field with the MCACOD flag set.

What I haven't easily been able to test is the same callback
path with a 'real world' mce, being called as part of the
x86_mce_decoder_chain notifier. I'd therefore appreciate a
closer look at the initial filtering done in nfit_handle_mce
(patch 3/3) from Tony or anyone more familiar with mce handling.

The series is based on v4.7-rc7, and a tree is available at
https://git.kernel.org/cgit/linux/kernel/git/vishal/nvdimm.git/log/?h=ars-ondemand


Vishal Verma (3):
  pmem: clarify a debug print in pmem_clear_poison
  nfit, libnvdimm: allow an ARS scrub to be triggered on demand
  nfit: do an ARS scrub on hitting a latent media error

 drivers/acpi/nfit.c       | 221 ++++++++++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit.h       |   5 +-
 drivers/nvdimm/core.c     |   7 ++
 drivers/nvdimm/pmem.c     |   2 +-
 include/linux/libnvdimm.h |   1 +
 5 files changed, 227 insertions(+), 9 deletions(-)

-- 
2.7.4
