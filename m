Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE7772
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 05:11:33 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="242989708"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="242989708"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="479463971"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 22:11:32 -0700
Subject: [PATCH v4 00/21] cxl_test: Enable CXL Topology and UAPI regression
 tests
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ira Weiny <ira.weiny@intel.com>, Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Nathan Chancellor <nathan@kernel.org>, kernel test robot <lkp@intel.com>,
 Dan Carpenter <dan.carpenter@oracle.com>, nvdimm@lists.linux.dev,
 ben.widawsky@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com,
 ira.weiny@intel.com, Jonathan.Cameron@huawei.com
Date: Wed, 08 Sep 2021 22:11:32 -0700
Message-ID: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Changes since v3 [1]:
- Rebase on the cxl-for-5.15 tag where some of v3 was accepted.

- Move the introduction of the uuid_to_nvdimm_cclass() helper to the
  patch that uses it to avoid a "defined but not used" warning (now
  fatal as of the -Werror upstream change).

- Fix the kernel-doc for the new CXL structure definitions in
  drivers/nvdimm/label.h. This resulted in a lead-in patch to fix up
  existing kernel-doc warnings. (Jonathan)

- Move the cxl_mem_get_partition_info() cleanups to their own patch
  (Jonathan).

- Fix the cxl_mem_get_partition_info() kernel-doc (Ben)

- Move the idr.h include fixup to its own patch (Jonathan)

- Fix the kernel-doc for struct cxl_mbox_cmd (Jonathan)

- Add a note about the ABI implications of the nvdimm-bridge device-name
  change (Jonathan)

- Squash "cxl/core: Replace devm_cxl_add_decoder() with non-devm
  version" into "cxl/core: Split decoder setup into alloc + add"

- Cleanup some pointless cxlm->dev to pci_dev and back conversions
  (Jonathan)

- Drop pci.h include from core/mbox.c (Jonathan)

- Drop duplicate cxl_doorbell_busy() and CXL_MAILBOX_TIMEOUT_MS
  definitions, only pci.c needs them. (Jonathan)

- Fix style violation in cxl_for_each_cmd() (Jonathan)

- Move cxl_mem_create() api change to "cxl/pci: Make 'struct cxl_mem'
  device type generic" (Jonathan)

- Add a helper, decoder_populate_targets(), for initializing a decoder
  target_list (Jonathan)

- Use put_unaligned() for potential unaligned write in
  cxl_pmem_set_config_data() (Jonathan)

- Add cxl_nvdimm_remove() to explicitly handle exclusive command
  shutdown rather than some gymnastics to handle the
  devm_add_action_or_reset() error code vs nvdimm_create() failure.
  (Jonathan)

- Switch to platform_device_unregister() lest we wake the dragons
  guarding platform_device_del(). (Jonathan)

- Fix CEL retrieval for the case where CEL is larger than payload_size
  in mock_get_log(). (Jonathan)

- Move CFMWS size definition out of the setup code and into the static
  table definition directly. (Jonathan)

[1]: https://lore.kernel.org/r/162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com

---

As mentioned in patch 17 in this series the response of upstream QEMU
community to CXL device emulation has been underwhelming to date. Even
if that picked up it still results in a situation where new driver
features and new test capabilities for those features are split across
multiple repositories.

The "nfit_test" approach of mocking up platform resources via an
external test module continues to yield positive results catching
regressions early and often. So this attempts to repeat that success
with a "cxl_test" module to inject custom crafted topologies and command
responses into the CXL subsystem's sysfs and ioctl UAPIs.

The first target for cxl_test to verify is the integration of CXL with
LIBNVDIMM and the new support for the CXL namespace label + region-label
format. The 6 patches in this series finish off the work that was merged
for the v5.15 merge window to introduce support for the new label
format.

The next 10 patches rework the CXL PCI driver to move more common
infrastructure into the core for the unit test environment to reuse. The
largest change here is disconnecting the mailbox command processing
infrastructure from the PCI specific transport. The unit test
environment replaces the PCI transport with a custom backend with mocked
responses to command requests.

Patch 17 introduces just enough mocked functionality for the cxl_acpi
driver to load against cxl_test resources. Patch 21 fixes the first bug
discovered by this framework, namely that HDM decoder target list maps
were not being filled out.

Finally patches 19 and 20 introduce a cxl_test representation of memory
expander devices. In this initial implementation these memory expander
targets implement just enough command support to pass the basic driver
init sequence and enable label command passthrough to LIBNVDIMM.

The topology of cxl_test includes:
- (4) platform fixed memory windows. One each of a x1-volatile,
  x4-volatile, x1-persistent, and x4-persistent.
- (4) Host bridges each with (2) root ports
- (8) CXL memory expanders, one for each root port
- Each memory expander device supports the GET_SUPPORTED_LOGS, GET_LOG,
  IDENTIFY, GET_LSA, and SET_LSA commands.

Going forward the expectation is that where possible new UAPI visible
subsystem functionality comes with cxl_test emulation of the same.

The build process for cxl_test is:

    make M=tools/testing/cxl
    make M=tools/testing/cxl modules_install

The implementation methodology of the test module is the same as
nfit_test where the bulk of the emulation comes from replacing symbols
that cxl_acpi and the cxl_core import with mocked implementation of
those symbols. See the "--wrap=" lines in tools/testing/cxl/Kbuild. Some
symbols need to be replaced, but are local to the modules like
match_add_root_ports(). In those cases the local symbol is marked __weak
(via __mock) with a strong implementation coming from
tools/testing/cxl/. The goal being to be minimally invasive to
production code paths.

---

Dan Williams (21):
      libnvdimm/labels: Add uuid helpers
      libnvdimm/label: Add a helper for nlabel validation
      libnvdimm/labels: Introduce the concept of multi-range namespace labels
      libnvdimm/labels: Fix kernel-doc for label.h
      libnvdimm/label: Define CXL region labels
      libnvdimm/labels: Introduce CXL labels
      cxl/pci: Make 'struct cxl_mem' device type generic
      cxl/pci: Clean up cxl_mem_get_partition_info()
      cxl/mbox: Introduce the mbox_send operation
      cxl/pci: Drop idr.h
      cxl/mbox: Move mailbox and other non-PCI specific infrastructure to the core
      cxl/pci: Use module_pci_driver
      cxl/mbox: Convert 'enabled_cmds' to DECLARE_BITMAP
      cxl/mbox: Add exclusive kernel command support
      cxl/pmem: Translate NVDIMM label commands to CXL label commands
      cxl/pmem: Add support for multiple nvdimm-bridge objects
      tools/testing/cxl: Introduce a mocked-up CXL port hierarchy
      cxl/bus: Populate the target list at decoder create
      cxl/mbox: Move command definitions to common location
      tools/testing/cxl: Introduce a mock memory device + driver
      cxl/core: Split decoder setup into alloc + add


 Documentation/driver-api/cxl/memory-devices.rst |    3 
 drivers/cxl/acpi.c                              |  133 ++-
 drivers/cxl/core/Makefile                       |    1 
 drivers/cxl/core/bus.c                          |  114 +-
 drivers/cxl/core/core.h                         |   11 
 drivers/cxl/core/mbox.c                         |  787 +++++++++++++++++
 drivers/cxl/core/memdev.c                       |  117 ++-
 drivers/cxl/core/pmem.c                         |   39 +
 drivers/cxl/cxl.h                               |   49 +
 drivers/cxl/cxlmem.h                            |  202 ++++
 drivers/cxl/pci.c                               | 1059 +----------------------
 drivers/cxl/pmem.c                              |  172 +++-
 drivers/nvdimm/btt.c                            |   11 
 drivers/nvdimm/btt_devs.c                       |   14 
 drivers/nvdimm/core.c                           |   40 -
 drivers/nvdimm/label.c                          |  139 ++-
 drivers/nvdimm/label.h                          |   94 ++
 drivers/nvdimm/namespace_devs.c                 |   95 +-
 drivers/nvdimm/nd-core.h                        |    5 
 drivers/nvdimm/nd.h                             |  185 +++-
 drivers/nvdimm/pfn_devs.c                       |    2 
 include/linux/nd.h                              |    4 
 tools/testing/cxl/Kbuild                        |   38 +
 tools/testing/cxl/config_check.c                |   13 
 tools/testing/cxl/mock_acpi.c                   |  109 ++
 tools/testing/cxl/mock_pmem.c                   |   24 +
 tools/testing/cxl/test/Kbuild                   |   10 
 tools/testing/cxl/test/cxl.c                    |  576 +++++++++++++
 tools/testing/cxl/test/mem.c                    |  256 ++++++
 tools/testing/cxl/test/mock.c                   |  171 ++++
 tools/testing/cxl/test/mock.h                   |   27 +
 31 files changed, 3134 insertions(+), 1366 deletions(-)
 create mode 100644 drivers/cxl/core/mbox.c
 create mode 100644 tools/testing/cxl/Kbuild
 create mode 100644 tools/testing/cxl/config_check.c
 create mode 100644 tools/testing/cxl/mock_acpi.c
 create mode 100644 tools/testing/cxl/mock_pmem.c
 create mode 100644 tools/testing/cxl/test/Kbuild
 create mode 100644 tools/testing/cxl/test/cxl.c
 create mode 100644 tools/testing/cxl/test/mem.c
 create mode 100644 tools/testing/cxl/test/mock.c
 create mode 100644 tools/testing/cxl/test/mock.h

base-commit: 2b922a9d064f8e86b53b04f5819917b7a04142ed
