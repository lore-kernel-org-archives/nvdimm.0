Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4ADA2211D675B
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 14:54:59 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id t82so364931oie.12
 for <linux-nvdimm@lists.01.org>; Mon, 11 Mar 2019 14:54:59 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Mar 2019 14:54:47 -0700
Message-ID: <CAPcyv4hPv7b1FWUxuDvcx8+kFWh7Npgk92P+SEpSPWvT2cxheg@mail.gmail.com>
Subject: [GIT PULL] libnvdimm updates for 5.1
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.1

...to receive the general libnvdimm update for 5.1, while I track down
a response on the issue highlighted "PMEM as RAM" pull request.

The bulk of this has been in -next since before the merge window
opened, with no known collisions / issues reported. The only detail
worth noting, outside the tag message, is that the
"libnvdimm-start-pad" topic has been truncated to just cleanups and
small fixes. The full topic branch would have doubled down on hacks
around the "section alignment" limitation of the core-mm, instead
effort is now being spent to address that root issue in the memory
hotplug implementation for v5.2. I'll note, since I messed this up in
the past, the topic-branch merges have summary messages as to why the
merge was made.

---

The following changes since commit d13937116f1e82bf508a6325111b322c30c85eb9:

  Linux 5.0-rc6 (2019-02-10 14:42:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
tags/libnvdimm-for-5.1

for you to fetch changes up to 4083014e32699af04a8e6eaa4855b08dba36a47a:

  Merge branch 'for-5.1/nfit/ars' into libnvdimm-for-next (2019-03-11
12:37:55 -0700)

----------------------------------------------------------------
libnvdimm for v5.1

* Fix nfit-bus command submission regression

* Support retrieval of short-ARS results if the ARS state is "requires
  continuation", and even if the "no_init_ars" module parameter is
  specified.

* Allow busy-polling of the kernel ARS state by allowing root to reset
  the exponential back-off timer.

* Filter potentially stale ARS results by tracking query-ARS relative to
  the previous start-ARS.

* Enhance dax_device alignment checks

* Add support for the Hyper-V family of device-specific-methods (DSMs)

* Add several fixes and workarounds for Hyper-V compatibility.

* Fix support to cache the dirty-shutdown-count at init.

----------------------------------------------------------------
Dan Williams (20):
      libnvdimm/label: Clear 'updating' flag after label-set update
      nfit: Fix nfit_intel_shutdown_status() command submission
      MAINTAINERS: Update filesystem-dax and NVDIMM entries
      libnvdimm/dimm: Add a no-BLK quirk based on NVDIMM family
      acpi/nfit: Fix bus command validation
      libnvdimm/pfn: Account for PAGE_SIZE > info-block-size in nd_pfn_init()
      libnvdimm/pmem: Honor force_raw for legacy pmem regions
      acpi/nfit: Require opt-in for read-only label configurations
      nfit/ars: Attempt a short-ARS whenever the ARS state is idle at boot
      nfit/ars: Attempt short-ARS even in the no_init_ars case
      nfit/ars: Remove ars_start_flags
      nfit/ars: Introduce scrub_flags
      nfit/ars: Allow root to busy-poll the ARS state machine
      nfit/ars: Avoid stale ARS results
      dax: Check the end of the block-device capacity with dax_direct_access()
      libnvdimm/pfn: Remove dax_label_reserve
      libnvdimm/namespace: Clean up holder_class_store()
      Merge branch 'for-5.1/libnvdimm' into libnvdimm-for-next
      Merge branch 'for-5.1/libnvdimm-start-pad' into libnvdimm-for-next
      Merge branch 'for-5.1/nfit/ars' into libnvdimm-for-next

Dexuan Cui (2):
      nfit: acpi_nfit_ctl(): Check out_obj->type in the right place
      nfit: Add Hyper-V NVDIMM DSM command set to white list

Oliver O'Halloran (1):
      libnvdimm: Fix altmap reservation size calculation

Toshi Kani (1):
      acpi/nfit: Update NFIT flags error message

Vishal Verma (2):
      libnvdimm/btt: Remove unnecessary code in btt_freelist_init
      libnvdimm/btt: Fix LBA masking during 'free list' population

Wei Yang (1):
      libnvdimm, pfn: Fix over-trim in trim_pfn_device()

YueHaibing (1):
      libnvdimm/of_pmem: Fix platform_no_drv_owner.cocci warnings

 MAINTAINERS                     |  17 ++--
 drivers/acpi/nfit/core.c        | 185 +++++++++++++++++++++++++++-------------
 drivers/acpi/nfit/nfit.h        |  17 +++-
 drivers/dax/super.c             |  38 ++++++---
 drivers/nvdimm/btt.c            |  33 ++++---
 drivers/nvdimm/btt.h            |   2 +
 drivers/nvdimm/btt_devs.c       |   8 ++
 drivers/nvdimm/dimm_devs.c      |   7 ++
 drivers/nvdimm/label.c          |  26 ++++--
 drivers/nvdimm/namespace_devs.c |  18 +++-
 drivers/nvdimm/of_pmem.c        |   1 -
 drivers/nvdimm/pfn_devs.c       |  24 +++---
 drivers/nvdimm/region_devs.c    |   7 ++
 include/linux/libnvdimm.h       |   2 +
 include/uapi/linux/ndctl.h      |   1 +
 15 files changed, 273 insertions(+), 113 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
