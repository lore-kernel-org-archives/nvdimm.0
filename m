Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C993C1C05
	for <nvdimm@lists.linux.dev>; Thu, 24 Nov 2022 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669314876; x=1700850876;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uovkNp7KYAXOFKZpoVE/uu1pW0qGLiaOQNj5Lx1hcZw=;
  b=lHtVPZWdTehoRVY1tNg/GSLLXQb5IjA2jUzlin9fReO50o49ZF0XSc74
   oAEwywBLSNdlkGxqkMC95iL++FoysgYQSPleO5slySZ6f3oqyEutS5btz
   fTDDdyicF52S7npyV0gTwov7RJyAPoWHIb8wqSVV4KwFHBCJ8AaLwqX0G
   rPOKG8nYCM/QAXUFbNXSU6yHrR+JDTuVF98BIHhzZ239PYxmz1Dqbf0va
   mJj5+bvp5Tjuho/MsBhBoInN4xQ0NFVr0v88Z8/fWdRaKD59aftugVPeu
   VdX+5MdcNS2FbdtmclJEVQX4nvbZHhoBU+D7ESo2ntXqNIt1+sd+2eNF5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="400642017"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="400642017"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:34:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="705839121"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="705839121"
Received: from aglevin-mobl3.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.65.252])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 10:34:35 -0800
Subject: [PATCH v4 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Terry Bowman <terry.bowman@amd.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Robert Richter <rrichter@amd.com>, rrichter@amd.com, terry.bowman@amd.com,
 bhelgaas@google.com, dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 24 Nov 2022 10:34:35 -0800
Message-ID: <166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Changes since v3 [1]:
- Rework / simplify CXL to LIBNVDIMM coordination to remove a
  flush_work() locking dependency from underneath the root device lock.
- Move the root device rescan to a workqueue
- Connect RCDs directly as endpoints reachable through a CXL host bridge
  as a dport, i.e. drop the extra dport indirection from v3
- Add unit test infrastructure for an RCD configuration

[1]: http://lore.kernel.org/r/20221109104059.766720-1-rrichter@amd.com/

---

>From [PATCH v4 10/12] cxl/port: Add RCD endpoint port enumeration

Unlike a CXL memory expander in a VH topology that has at least one
intervening 'struct cxl_port' instance between itself and the CXL root
device, an RCD attaches one-level higher. For example:

               VH
          ┌──────────┐
          │ ACPI0017 │
          │  root0   │
          └─────┬────┘
                │
          ┌─────┴────┐
          │  dport0  │
    ┌─────┤ ACPI0016 ├─────┐
    │     │  port1   │     │
    │     └────┬─────┘     │
    │          │           │
 ┌──┴───┐   ┌──┴───┐   ┌───┴──┐
 │dport0│   │dport1│   │dport2│
 │ RP0  │   │ RP1  │   │ RP2  │
 └──────┘   └──┬───┘   └──────┘
               │
           ┌───┴─────┐
           │endpoint0│
           │  port2  │
           └─────────┘

...vs:

              RCH
          ┌──────────┐
          │ ACPI0017 │
          │  root0   │
          └────┬─────┘
               │
           ┌───┴────┐
           │ dport0 │
           │ACPI0016│
           └───┬────┘
               │
          ┌────┴─────┐
          │endpoint0 │
          │  port1   │
          └──────────┘

So arrange for endpoint port in the RCH/RCD case to appear directly
connected to the host-bridge in its singular role as a dport. Compare
that to the VH case where the host-bridge serves a dual role as a
'cxl_dport' for the CXL root device *and* a 'cxl_port' upstream port for
the Root Ports in the Root Complex that are modeled as 'cxl_dport'
instances in the CXL topology.

Another deviation from the VH case is that RCDs may need to look up
their component registers from the Root Complex Register Block (RCRB).
That platform firmware specified RCRB area is cached by the cxl_acpi
driver and conveyed via the host-bridge dport to the cxl_mem driver to
perform the cxl_rcrb_to_component() lookup for the endpoint port
(See 9.11.8 CXL Devices Attached to an RCH for the lookup of the
upstream port component registers).

---

Dan Williams (9):
      cxl/acpi: Simplify cxl_nvdimm_bridge probing
      cxl/region: Drop redundant pmem region release handling
      cxl/pmem: Refactor nvdimm device registration, delete the workqueue
      cxl/pmem: Remove the cxl_pmem_wq and related infrastructure
      cxl/acpi: Move rescan to the workqueue
      tools/testing/cxl: Make mock CEDT parsing more robust
      cxl/mem: Move devm_cxl_add_endpoint() from cxl_core to cxl_mem
      cxl/port: Add RCD endpoint port enumeration
      tools/testing/cxl: Add an RCH topology

Robert Richter (2):
      cxl/ACPI: Register CXL host ports by bridge device
      cxl/acpi: Extract component registers of restricted hosts from RCRB

Terry Bowman (1):
      cxl/acpi: Set ACPI's CXL _OSC to indicate CXL1.1 support


 drivers/acpi/pci_root.c       |    1 
 drivers/cxl/acpi.c            |  105 +++++++++---
 drivers/cxl/core/core.h       |    8 -
 drivers/cxl/core/pmem.c       |   94 +++++++----
 drivers/cxl/core/port.c       |  111 +++++++------
 drivers/cxl/core/region.c     |   54 ++++++
 drivers/cxl/core/regs.c       |   56 +++++++
 drivers/cxl/cxl.h             |   46 +++--
 drivers/cxl/cxlmem.h          |   15 ++
 drivers/cxl/mem.c             |   72 ++++++++
 drivers/cxl/pci.c             |   13 +-
 drivers/cxl/pmem.c            |  351 +++++------------------------------------
 tools/testing/cxl/Kbuild      |    1 
 tools/testing/cxl/test/cxl.c  |  241 ++++++++++++++++++++++------
 tools/testing/cxl/test/mem.c  |   40 ++++-
 tools/testing/cxl/test/mock.c |   19 ++
 tools/testing/cxl/test/mock.h |    3 
 17 files changed, 712 insertions(+), 518 deletions(-)

base-commit: 3b39fd6cf12ceda2a2582dcb9b9ee9f4d197b857
