Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 0/8] nfit, libnvdimm: async address range scrub
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Feb 2016 18:16:58 -0800
Message-ID: <20160224021655.22776.87952.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Given the capacities of next generation persistent memory devices a
scrub operation to find all poison may take 10s of seconds.  We want
this scrub work to be done asynchronously with the rest of system
initialization, so we move it out of line from the NFIT probing, i.e.
acpi_nfit_add().

However, we may want to synchronously wait for that scrubbing to
complete before we probe any pmem devices.  Consider the case where
consuming poison triggers a machine check and a reboot.  That event will
trigger platform firmware to initiate a scrub.  The kernel should
complete any firmware initiated scrubs as those likely indicate the
presence of known poison.

When errors are not present, platform firmware did not initiate
scrubbing, we still scrub, but asynchronously.  This trades off a risk
of hitting new unknown poison ranges with making the data available
faster after loading the driver.

This async scrub capability is also useful in the future when we
integrate Tony Luck's mcsafe_copy() (or whatever it is
eventually called).  After a machine check recovery event we can scrub
the pmem namespace to see if there are any other latent errors and
otherwise update the 'badblocks' list with the new entries.

This passes the libndctl unit test suite, with some minor updates to
account for the fact that when "modprobe nfit_test" returns not all
regions are registered.

---

Dan Williams (8):
      libnvdimm, nfit: centralize command status translation
      libnvdimm: protect nvdimm_{bus|namespace}_add_poison() with nvdimm_bus_lock()
      libnvdimm: async notification support
      nfit, tools/testing/nvdimm: unify common init for acpi_nfit_desc
      nfit, libnvdimm: async region scrub workqueue
      nfit: scrub and register regions in a workqueue
      nfit: disable userspace initiated ars during scrub
      tools/testing/nvdimm: expand ars unit testing


 drivers/acpi/nfit.c              |  761 +++++++++++++++++++++++++++-----------
 drivers/acpi/nfit.h              |   24 +
 drivers/nvdimm/bus.c             |   46 ++
 drivers/nvdimm/core.c            |  110 ++++-
 drivers/nvdimm/dimm_devs.c       |    6 
 drivers/nvdimm/nd.h              |    2 
 drivers/nvdimm/pmem.c            |   15 +
 drivers/nvdimm/region.c          |   12 +
 include/linux/libnvdimm.h        |    5 
 include/linux/nd.h               |    7 
 tools/testing/nvdimm/test/nfit.c |  133 +++++--
 11 files changed, 809 insertions(+), 312 deletions(-)
