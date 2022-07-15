Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3CB4C96
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919316; x=1689455316;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7BF81LETZaU+r3o9lF+SOM9GnjKhTQeTvLp6cuo8V9s=;
  b=ewMn4JzYffmaZtHj/hQTm1EkfSM044KbiUVkBdRo3pjSjGPjBC0A0sSc
   AQ5+8bGEWchw+zERRvMlL7OzX2g+hEM67SwiMUEnLcacR05ZvKYPj1lEK
   klE3gs4JvtSbkxSXrxhZ0pDJb5agoDGuB4p7EHn6AEp5o5J3H2JqrsMoU
   Vt4ujGVYJILvQFGcw5qc8XrTKFlZOs5mgloyfdH+SEmZ0Uha2qEF9Fv79
   efjzON5P8OKzHrYYfJQ9uX5ms9fF3GsU2GaCqypVyuvbyZcqwunvKYhTU
   8AmTrTKXg0i3ogv8nkLH8aqpn/lKLYp5nAi0LZAjRw/KglSQrxF6Innh7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="286636496"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="286636496"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:33 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="654501206"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:32 -0700
Subject: [PATCH RFC 00/15] Introduce security commands for CXL pmem device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:08:32 -0700
Message-ID: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

This series is seeking comments on the implementation. It has not been fully
tested yet.

This series adds the support for "Persistent Memory Data-at-rest Security"
block of command set for the CXL Memory Devices. The enabling is done through
the nvdimm_security_ops as the operations are very similar to the same
operations that the persistent memory devices through NFIT provider support.
This enabling does not include the security pass-through commands nor the
Santize commands.

Under the nvdimm_security_ops, this patch series will enable get_flags(),
freeze(), change_key(), unlock(), disable(), and erase(). The disable() API
does not support disabling of the master passphrase. To maintain established
user ABI through the sysfs attribute "security", the "disable" command is
left untouched and a new "disable_master" command is introduced with a new
disable_master() API call for the nvdimm_security_ops().

This series does not include plumbing to directly handle the security commands
through cxl control util. The enabled security commands will still go through
ndctl tool with this enabling.

For calls such as unlock() and erase(), the CPU caches must be invalidated
post operation. Currently, the implementation resides in
drivers/acpi/nfit/intel.c with a comment that it should be implemented
cross arch when more than just NFIT based device needs this operation.
With the coming of CXL persistent memory devices this is now needed.
Introduce ARCH_HAS_NVDIMM_INVAL_CACHE and implement similar to
ARCH_HAS_PMEM_API where the arch can opt in with implementation.
Currently only add x86_64 implementation where wbinvd_on_all_cpus()
is called.

---

Dave Jiang (15):
      cxl/pmem: Introduce nvdimm_security_ops with ->get_flags() operation
      tools/testing/cxl: Create context for cxl mock device
      tools/testing/cxl: Add "Get Security State" opcode support
      cxl/pmem: Add "Set Passphrase" security command support
      tools/testing/cxl: Add "Set Passphrase" opcode support
      cxl/pmem: Add Disable Passphrase security command support
      tools/testing/cxl: Add "Disable" security opcode support
      cxl/pmem: Add "Freeze Security State" security command support
      tools/testing/cxl: Add "Freeze Security State" security opcode support
      x86: add an arch helper function to invalidate all cache for nvdimm
      cxl/pmem: Add "Unlock" security command support
      tools/testing/cxl: Add "Unlock" security opcode support
      cxl/pmem: Add "Passphrase Secure Erase" security command support
      tools/testing/cxl: Add "passphrase secure erase" opcode support
      nvdimm/cxl/pmem: Add support for master passphrase disable security command


 arch/x86/Kconfig             |   1 +
 arch/x86/mm/pat/set_memory.c |   8 +
 drivers/acpi/nfit/intel.c    |  28 +--
 drivers/cxl/Kconfig          |  16 ++
 drivers/cxl/Makefile         |   1 +
 drivers/cxl/cxlmem.h         |  41 +++++
 drivers/cxl/pmem.c           |  10 +-
 drivers/cxl/security.c       | 182 ++++++++++++++++++
 drivers/nvdimm/security.c    |  33 +++-
 include/linux/libnvdimm.h    |  10 +
 lib/Kconfig                  |   3 +
 tools/testing/cxl/Kbuild     |   1 +
 tools/testing/cxl/test/mem.c | 348 ++++++++++++++++++++++++++++++++++-
 13 files changed, 644 insertions(+), 38 deletions(-)
 create mode 100644 drivers/cxl/security.c

--

