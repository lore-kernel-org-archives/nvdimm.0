Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80F510782
	for <nvdimm@lists.linux.dev>; Thu,  1 Dec 2022 21:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669930402; x=1701466402;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EOzVpZvcPedSKydE9UWbDa4FKQFCg546LS1qmj+8Sjo=;
  b=imYfwLZ/916YnfUk+uAj8BBe7aeHjRyS+ltNinSzNXkYnq1rHPNukKGW
   s/aiDEkbh/fS2sc6mx2G4gOdzpNoGPqtLqY3jEDczMpuZ2UB8WwsNfJ9T
   bGglQvc7whi3B5M2P/QAZuaDTPVrsqYciZy1qkOI1ylwYmp+xTwOuG0FD
   AJEDJ0u8h6umwYZkkeIlUWb7jEcZlh+ZyUuLliB+srzIN2snT2OXir1yU
   HFPfzkK/X1gpqA+Dy2XYvzKESJV3spF75DEAJKxLlkKMuc4PaFYDnRdcW
   uOVjEwN0VHeXF38nZvn4ZStDNcGLoS5K9ZOji59bOI1ja3tZuqeODxjMI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="315831215"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="315831215"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="677368111"
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="677368111"
Received: from navarrof-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.177.235])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2022 13:33:21 -0800
Subject: [PATCH v6 00/12] cxl: Add support for Restricted CXL hosts (RCD
 mode)
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>,
 Robert Richter <rrichter@amd.com>, Terry Bowman <terry.bowman@amd.com>,
 rrichter@amd.com, terry.bowman@amd.com, bhelgaas@google.com,
 dave.jiang@intel.com, nvdimm@lists.linux.dev
Date: Thu, 01 Dec 2022 13:33:21 -0800
Message-ID: <166993040066.1882361.5484659873467120859.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Changes since v4 [1] (v5 was a partial re-roll)
- Add commentary in cxl_nvd_unregister() to clarify the locking
  (Jonathan)
- Improve the comment about why there are 2 devm_add_action_or_reset()
  calls in devm_cxl_add_nvdimm() (Jonathan)
- Fix devm_cxl_add_nvdimm() error exit ordering to mirror the init order
  (Jonathan)
- Add a comment to clarify why the nvdimm bridge lookup only needs to be
  performed on one device in the region in cxl_pmem_region_alloc()
  (Jonathan)
- Add a comment to clarify the locking in cxlr_pmem_unregister()
  (Jonathan)
- cxl_nvdimm_bridge_probe() whitespace fixup (Jonathan)
- Exit add_host_bridge_uport() before devm_cxl_register_pci_bus() since
  that registration is unused in the RCH case (Robert)
- Fold RCRB retrieval into cxl_get_chbcr() (Robert)
- Drop 'enum cxl_dport_mode' and just assume it based on whether @rcrb
  is valid (Robert)
- Add kdoc for devm_cxl_add_rch_dport() (Robert)
- Move Upstream Port RCRB detection to offset0 returning < U32_MAX (Robert)
- Add an error message for failure to access Downstream Port RCRB
  (Robert)
- Improve changelog for "[PATCH v6 9/12] cxl/mem: Move
  devm_cxl_add_endpoint() from cxl_core to cxl_mem" (Robert)
- Drop unnecessary movement of @dport and @port variable declarations
  (Robert)
- Fix cxl_mem call to cxl_rcrb_to_component() to use CXL_RCRB_UPSTREAM
  (Dave)
- Fix up changelog of "[PATCH v6 12/12] cxl/acpi: Set ACPI's CXL _OSC to
  indicate CXL1.1 support" (Robert)

[1]: http://lore.kernel.org/r/166931487492.2104015.15204324083515120776.stgit@dwillia2-xfh.jf.intel.com

I note that the cxl_pmem_wq still appears to be proving difficult to
review. Open to ideas about how to move that along. Otherwise, since folks
seem to be happy with "[PATCH v6 10/12] cxl/port: Add RCD endpoint port
enumeration" that depends on that rework, I might just move ahead with
that implict ack, but do holler if anything looks amiss.

---

>From [PATCH v6 10/12] cxl/port: Add RCD endpoint port enumeration

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
      cxl/acpi: Set ACPI's CXL _OSC to indicate RCD mode support


 drivers/acpi/pci_root.c       |    1 
 drivers/cxl/acpi.c            |  102 +++++++++---
 drivers/cxl/core/core.h       |    8 -
 drivers/cxl/core/pmem.c       |  102 ++++++++----
 drivers/cxl/core/port.c       |  118 ++++++++------
 drivers/cxl/core/region.c     |   64 +++++++
 drivers/cxl/core/regs.c       |   64 +++++++
 drivers/cxl/cxl.h             |   46 +++--
 drivers/cxl/cxlmem.h          |   15 ++
 drivers/cxl/mem.c             |   72 ++++++++
 drivers/cxl/pci.c             |   13 +-
 drivers/cxl/pmem.c            |  351 +++++------------------------------------
 tools/testing/cxl/Kbuild      |    1 
 tools/testing/cxl/test/cxl.c  |  171 ++++++++++++++++++--
 tools/testing/cxl/test/mem.c  |   40 ++++-
 tools/testing/cxl/test/mock.c |   19 ++
 tools/testing/cxl/test/mock.h |    3 
 17 files changed, 711 insertions(+), 479 deletions(-)

base-commit: 3b39fd6cf12ceda2a2582dcb9b9ee9f4d197b857
