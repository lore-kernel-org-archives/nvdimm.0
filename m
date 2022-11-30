Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E243979C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836091; x=1701372091;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GtU8rGo8JmRG4wE+K9y+c1KjMQtSq5BPfcSAWxAmoZU=;
  b=gx3x2s3tEJcQoMpC0it9QnVsDkC9k96oqPl5j3dn8RJJbCbirnpw4LwS
   ygwH5ceuPuLitqh7kF8UZ0khjry9iZrtsj//uc2b2Hqv1qj01j8OZuv9f
   AUvTpMwFL6f1B/xNO7T5bbcfNwWLffZymQO2ITvoaZgdJsuVbfiJDEIUZ
   fG6fsAYOpRFf8vlV7asya0X8eXRp/UoEe2dcDQjrRMl0JWGrv5+8nJtCi
   XcSzCK7F3akDHksBl76csCmjB7mlL6Ir24vGPV6v/U55y8Xdty4+WqM3I
   fNM2ibXBKZ9hCYaAATiwepfcqnZYH76mVWuqoZ2IVq+lkWfbzYjI6RIiH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303092350"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303092350"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="712932688"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="712932688"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:30 -0800
Subject: [PATCH v7 00/20] Introduce security commands for CXL pmem device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:21:30 -0700
Message-ID: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
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

v7:
- cxl_test moved plat_data to drv_data by Dan.
- Rebased to latest pending patches by Dan.
- Add bypass for cpu_cache_invalidate_memregion() for cxl_test and nfit_test. (Dan)
- Remove unneeded comment in disable passphrase. (Dan)
- Fix nmem cxl id documentation. (Dan)
- Fix nmem clx provider documentation. (Dan)
- Reduce id length allocation size. (Dan)
- Move id to cxl_nvdimm. (Dan)

v6:
- Change behavior for no master set while issue secure erase per spec.
- Add spec references in comments (Jonathan)

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

Dave Jiang (20):
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
      cxl: bypass cpu_cache_invalidate_memregion() when in test config
      acpi/nfit: bypass cpu_cache_invalidate_memregion() when in test config
      cxl: add dimm_id support for __nvdimm_create()


 Documentation/ABI/testing/sysfs-bus-nvdimm |  14 +
 drivers/acpi/nfit/intel.c                  |  51 ++-
 drivers/cxl/Makefile                       |   2 +-
 drivers/cxl/core/mbox.c                    |   6 +
 drivers/cxl/core/pmem.c                    |  10 +
 drivers/cxl/cxl.h                          |   3 +
 drivers/cxl/cxlmem.h                       |  41 ++
 drivers/cxl/pmem.c                         |  43 ++-
 drivers/cxl/security.c                     | 202 ++++++++++
 drivers/nvdimm/Kconfig                     |  12 +
 drivers/nvdimm/dimm_devs.c                 |   9 +-
 drivers/nvdimm/security.c                  |  37 +-
 include/linux/libnvdimm.h                  |   2 +
 include/uapi/linux/cxl_mem.h               |   6 +
 tools/testing/cxl/Kbuild                   |   1 +
 tools/testing/cxl/test/mem.c               | 413 ++++++++++++++++++++-
 tools/testing/nvdimm/Kbuild                |   1 -
 tools/testing/nvdimm/dimm_devs.c           |  30 --
 18 files changed, 825 insertions(+), 58 deletions(-)
 create mode 100644 drivers/cxl/security.c
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

--

