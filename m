Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C27F4C63
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774291; x=1695310291;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z6t59XHjrmcCr4Hpz4QstXO/w5hgMyZ4F5YLJwWfzXg=;
  b=KijJ7F1M2trAPx87VZQANVk4EhmYqZKmCG7on9+gS0EJ/g62cGwhdMbf
   0y0EWYJ8zoMZQYfKfQu8mwW0wcedHnrv93aBLYu6x3ZteFqBJAVtyxIT4
   gqr6uHJ8nTOyxDPwfnWnWA0och7Mg65vxjOfnaBJUtX60oxo12uTXthUJ
   YwlD9ecipSHAhY3Q10Rg4uX0lP4lrizeySjUb/azbW215hUvx8/aWPZcC
   LvQvtB1ss7Wz2L39IzbKV3wuLEvf9tJbhChMw65P6e+oH7/KeABFDetTy
   zPt9M6/hEQQWgur4KSGdtgr1+0laohc1M3SoMJDncGVvLzypbgp2gMNmt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="300876675"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="300876675"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="708499251"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:27 -0700
Subject: [PATCH v2 00/19] Introduce security commands for CXL pmem device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:31:26 -0700
Message-ID: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

This series adds the support for "Persistent Memory Data-at-rest Security"
block of command set for the CXL Memory Devices. The enabling is done
through the nvdimm_security_ops as the operations are very similar to the
same operations that the persistent memory devices through NFIT provider
support. This enabling does not include the security pass-through commands
nor the Santize commands.

Under the nvdimm_security_ops, this patch series will enable get_flags(),
freeze(), change_key(), unlock(), disable(), and erase(). The disable() API
does not support disabling of the master passphrase. To maintain
established user ABI through the sysfs attribute "security", the "disable"
command is left untouched and a new "disable_master" command is introduced
with a new disable_master() API call for the nvdimm_security_ops().

This series does not include plumbing to directly handle the security
commands through cxl control util. The enabled security commands will still
go through ndctl tool with this enabling.

The first commit is from Davidlohr [1]. It's submitted separately and can
be dropped. It's here for reference and 0-day testing convenience. The
series does have dependency on the patch.

[1]: https://lore.kernel.org/nvdimm/20220919110605.3696-1-dave@stgolabs.net/T/#u

v2:
- Rebased against Davidlohr's memregion flush call
- Remove SECURITY Kconfig and merge with PMEM (Davidlohr & Jonathan)
- Remove inclusion of ndctl.h from security.c (Davidlohr)
- Return errno and leave out return_code for error cases not in spec for
  mock device (Jonathan)
  - Add comment for using NVDIMM_PASSPHRASE_LEN (Jonathan)
  - Put 'struct cxl_set_pass' on the stack instead of kmalloc (Jonathan)
  - Directly return in mock_set_passphrase() when done. (Jonathan)
  - Tie user interface change commenting for passphrase disable. (Jonathan)
  - Pass passphrase directly in command and remove copy. (Jonathan)
  - Remove state check to enable first time passphrase set in mock device.
  - Fix missing ptr assignment in mock secure erase
  - Tested against cxl_test with new cxl security test.

---

Dave Jiang (18):
      cxl/pmem: Introduce nvdimm_security_ops with ->get_flags() operation
      tools/testing/cxl: Add "Get Security State" opcode support
      cxl/pmem: Add "Set Passphrase" security command support
      tools/testing/cxl: Add "Set Passphrase" opcode support
      cxl/pmem: Add Disable Passphrase security command support
      tools/testing/cxl: Add "Disable" security opcode support
      cxl/pmem: Add "Freeze Security State" security command support
      tools/testing/cxl: Add "Freeze Security State" security opcode support
      cxl/pmem: Add "Unlock" security command support
      tools/testing/cxl: Add "Unlock" security opcode support
      cxl/pmem: Add "Passphrase Secure Erase" security command support
      tools/testing/cxl: Add "passphrase secure erase" opcode support
      nvdimm/cxl/pmem: Add support for master passphrase disable security command
      cxl/pmem: add id attribute to CXL based nvdimm
      tools/testing/cxl: add mechanism to lock mem device for testing
      cxl/pmem: add provider name to cxl pmem dimm attribute group
      libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST flag
      cxl: add dimm_id support for __nvdimm_create()

Davidlohr Bueso (1):
      memregion: Add cpu_cache_invalidate_memregion() interface


 arch/x86/Kconfig                   |   1 +
 arch/x86/mm/pat/set_memory.c       |  15 ++
 drivers/acpi/nfit/intel.c          |  41 ++--
 drivers/cxl/Makefile               |   2 +-
 drivers/cxl/core/mbox.c            |   6 +
 drivers/cxl/cxlmem.h               |  44 +++++
 drivers/cxl/pci.c                  |   4 +
 drivers/cxl/pmem.c                 |  45 ++++-
 drivers/cxl/security.c             | 184 ++++++++++++++++++
 drivers/nvdimm/Kconfig             |   9 +
 drivers/nvdimm/dimm_devs.c         |   9 +-
 drivers/nvdimm/security.c          |  37 +++-
 include/linux/libnvdimm.h          |   2 +
 include/linux/memregion.h          |  35 ++++
 include/uapi/linux/cxl_mem.h       |   6 +
 lib/Kconfig                        |   3 +
 tools/testing/cxl/Kbuild           |   1 +
 tools/testing/cxl/test/cxl.c       |  70 ++++++-
 tools/testing/cxl/test/mem.c       | 294 +++++++++++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h |  16 ++
 tools/testing/nvdimm/Kbuild        |   1 -
 tools/testing/nvdimm/dimm_devs.c   |  30 ---
 22 files changed, 788 insertions(+), 67 deletions(-)
 create mode 100644 drivers/cxl/security.c
 create mode 100644 tools/testing/cxl/test/mem_pdata.h
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

--

