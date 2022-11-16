Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2D412290
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668633465; x=1700169465;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Fmu1CzrPmAYYcF8aVsck2BmYvCN9igytVBoqsAH4BhY=;
  b=SYDuBDrTjKgeSM5b77MDJrgM0LxKwrQmI2NdN6Pf2jGS7kvlKPhz3rKx
   cDIvoy89m7fqhb/0xsd1YJkJK3qvYx31MNkEKWTDoD0oNE7RtVqhnK69Z
   eB0syQR/+5Ze5IQHWtx3RhbKeN/jpdCEbUgMhWnsaDp3YCpbxsmR/oWm8
   yvWwVlalXbQI+xfOomZvHpOx6b9J2LXy1RtCs/44wgMcPxD8qeOTc7X0Q
   2QiGckmUtnM/uFEh29P4EnXsHfz0A2F+7Xx+ssR6CZ/uD7kjF5jgMO3BC
   d59NOLA+TlSonA2zedjASX39aGY/RtlaK4ZhK/6/Hzu9LI06v2f9WMfPw
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="398957179"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="398957179"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:17:44 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="814238709"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="814238709"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:17:43 -0800
Subject: [PATCH v5 00/18] Introduce security commands for CXL pmem device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net,
 benjamin.cheatham@amd.com
Date: Wed, 16 Nov 2022 14:17:43 -0700
Message-ID: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
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

The first commit is from Davidlohr [1]. It's submitted separately and can be
dropped. It's here for reference and 0-day testing convenience. The series does
have dependency on the patch.

[1]: https://lore.kernel.org/linux-cxl/166698148737.3132474.5901874516011784201.stgit@dwillia2-xfh.jf.intel.com/

v5:
- Fix unintended passphrase type overwrite for disable op. (Ben)
- Fix passphrase secure erase emulation in cxl_test. (Jonathan)

v4:
- Revert check for master passphrase check in mock secure erase. (Jonathan)
- Add user passphrase check for user password limit in mock secure erase. (Jonathan)
- Add master passphrase check for master password limit in mock secure erase.

v3:
- Change all spec reference to v3. (Jonathan)
- Remove errant commit log in patch 1. (Davidlohr)
- Change return to -EINVAL for cpu_cache_has_invalidate_memregion() error. (Davidlohr)
- Fix mock_freeze_security() to be spec compliant. (Jonathan)
- Change OP_PASSPHRASE_ERASE to OP_PASSPHRASE_SECURE_ERASE. (Jonathan)
- Fix mock_passphrase_erase to be spec compliant. (Jonathan)
- Change password retry limit handling to helper function.
- Add ABI documentation to new sysfs attribs. (Jonathan)
- Have security_lock_show() emit 0 or 1 instead of "locked or "unlocked". (Jonathan)
- Set pdev->dev.groups instead of using device_add_groups(). (Jonathan)
- Add context to NVDIMM_SECURITY_TEST on possible side effects. (Jonathan)

v2:
- Rebased against Davidlohr's memregion flush call
- Remove SECURITY Kconfig and merge with PMEM (Davidlohr & Jonathan)
- Remove inclusion of ndctl.h from security.c (Davidlohr)
- Return errno and leave out return_code for error cases not in spec for mock device (Jonathan)
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


 Documentation/ABI/testing/sysfs-bus-nvdimm |  12 +
 drivers/cxl/Makefile                       |   2 +-
 drivers/cxl/core/mbox.c                    |   6 +
 drivers/cxl/cxlmem.h                       |  44 +++
 drivers/cxl/pci.c                          |   4 +
 drivers/cxl/pmem.c                         |  44 ++-
 drivers/cxl/security.c                     | 185 ++++++++++++
 drivers/nvdimm/Kconfig                     |  12 +
 drivers/nvdimm/dimm_devs.c                 |   9 +-
 drivers/nvdimm/security.c                  |  37 ++-
 include/linux/libnvdimm.h                  |   2 +
 include/uapi/linux/cxl_mem.h               |   6 +
 tools/testing/cxl/Kbuild                   |   1 +
 tools/testing/cxl/test/cxl.c               |  58 ++++
 tools/testing/cxl/test/mem.c               | 331 +++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h         |  16 +
 tools/testing/nvdimm/Kbuild                |   1 -
 tools/testing/nvdimm/dimm_devs.c           |  30 --
 18 files changed, 758 insertions(+), 42 deletions(-)
 create mode 100644 drivers/cxl/security.c
 create mode 100644 tools/testing/cxl/test/mem_pdata.h
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

--

