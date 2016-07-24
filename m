Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 485E21A1DEF
 for <linux-nvdimm@lists.01.org>; Sat, 23 Jul 2016 22:28:57 -0700 (PDT)
Subject: [PATCH v4 0/4] ARS rescanning triggered by latent errors or userspace
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Jul 2016 22:26:32 -0700
Message-ID: <146933799257.26196.10157809349693736359.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Changes since v3 [1]:

1/ Fixed races of scrub_{store|show} versus driver shutdown.  We need to
   make sure the nvdimm_bus, nvdimm_bus_descriptor, and acpi_nfit_desc data
   structures for a given instance remain valid for the duration of an
   acpi_nfit_ars_rescan() submission.  Patch1 "libnvdimm: register
   nvdimm_bus devices with an nd_bus driver", which is new for v4, enables
   use of device_lock() to pin the nvdimm_bus active for this duration.

2/ Fixed races of scrub_{store|show} versus hotplug.  This was simply
   some missing acquisitions of acpi_desc->init_mutex.

3/ Enforce that scrub_store() only initiates a scrub when writing "1",
   other values are invalid.  This lets us introduce new values down the
   road to, for example, disable scrubs after machine checks or other scrub
   policies.

4/ Require all three ARS DSMs be available before the 'scrub' attribute
   becomes visible.

5/ Fix races of mce notifier chain vs driver shutdown by holding
   acpi_desc_lock over the acpi_nfit_destruct() event.

6/ Given ARM is now re-using the NFIT driver, move the x86 specific
   machine check code to its own conditionally-compiled file.  As a
   precursor to this change the nfit source was moved to its own
   sub-directory in Patch3 "nfit: move to nfit/ sub-directory".

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-July/006407.html

---
Initial cover letter from Vishal:

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

---

Dan Williams (2):
      libnvdimm: register nvdimm_bus devices with an nd_bus driver
      nfit: move to nfit/ sub-directory

Vishal Verma (2):
      nfit, libnvdimm: allow an ARS scrub to be triggered on demand
      nfit: do an ARS scrub on hitting a latent media error


 drivers/acpi/Kconfig             |   27 -----
 drivers/acpi/Makefile            |    2 
 drivers/acpi/nfit/Kconfig        |   26 +++++
 drivers/acpi/nfit/Makefile       |    3 +
 drivers/acpi/nfit/core.c         |  187 ++++++++++++++++++++++++++++++++++++--
 drivers/acpi/nfit/mce.c          |   89 ++++++++++++++++++
 drivers/acpi/nfit/nfit.h         |   24 +++++
 drivers/nvdimm/bus.c             |  188 +++++++++++++++++++++++++++++++++++++-
 drivers/nvdimm/core.c            |  128 +-------------------------
 include/linux/libnvdimm.h        |    1 
 tools/testing/nvdimm/Kbuild      |    5 +
 tools/testing/nvdimm/test/Kbuild |    2 
 12 files changed, 512 insertions(+), 170 deletions(-)
 create mode 100644 drivers/acpi/nfit/Kconfig
 create mode 100644 drivers/acpi/nfit/Makefile
 rename drivers/acpi/{nfit.c => nfit/core.c}
 create mode 100644 drivers/acpi/nfit/mce.c
 rename drivers/acpi/{nfit.h => nfit/nfit.h}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
