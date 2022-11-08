Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4BD8BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928427; x=1699464427;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1PHqOGQOY2sv016natJyEHDkLTypN5RMjhg7WJb5OCo=;
  b=XvEFIpZbBwDWB0VHFsFsOg//kOY38Vl2jEEslZ/eVnfgJ76OAG/0gJIY
   EhgIiGfzVWJMN4Ez7e4Rl7UW8fnrq5fJmlDtx2cI1KNfkEUHnLClaglvQ
   Xgj0/sUDNklFyH8nQ7wPVfD0G4NqLckwkhGog9lu/sj7XGhIsINlTHuXK
   XZIrYUGm1iWtVQwIoGHuWcejrGJEsHt7v3+C9Pb6y4aIdi1+AWTycmm9Y
   UdzY9olTJgabrc5k5ds/HuZH3mjQqetTS0tvpFLrJcXRKIV9hxaAz9Q0h
   bvgpLJbbc2beIMj0UiG/SzRlK9tOdYrJ+IJdKKVT/FVgP02D9Z+wq/dY+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="312548531"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="312548531"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:27:01 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="705378721"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="705378721"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:27:00 -0800
Subject: [PATCH v3 17/18] libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST
 flag
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:27:00 -0700
Message-ID: 
 <166792842000.3767969.18296572896453551207.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

nfit_test overrode the security_show() sysfs attribute function in nvdimm
dimm_devs in order to allow testing of security unlock. With the
introduction of CXL security commands, the trick to override
security_show() becomes significantly more complicated. By introdcing a
security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
check via a compile option. In addition the original override can can be
removed from tools/testing/nvdimm/.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/nvdimm/Kconfig           |   13 +++++++++++++
 drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
 drivers/nvdimm/security.c        |    4 ++++
 tools/testing/nvdimm/Kbuild      |    1 -
 tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
 5 files changed, 25 insertions(+), 32 deletions(-)
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..0a13c53c926f 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -114,4 +114,17 @@ config NVDIMM_TEST_BUILD
 	  core devm_memremap_pages() implementation and other
 	  infrastructure.
 
+config NVDIMM_SECURITY_TEST
+	bool "Nvdimm security test code toggle"
+	depends on NVDIMM_KEYS
+	help
+	  Debug flag for security testing when using nfit_test or cxl_test
+	  modules in tools/testing/.
+
+	  Select Y if using nfit_test or cxl_test for security testing.
+	  Accidentally selecting this option when not using cxl_test
+	  introduces 1 mailbox request to the CXL device to get security
+	  status for DIMM unlock operation or sysfs attribute "security"
+	  read.
+
 endif
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c7c980577491..1fc081dcf631 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -349,11 +349,18 @@ static ssize_t available_slots_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(available_slots);
 
-__weak ssize_t security_show(struct device *dev,
+ssize_t security_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 
+	/*
+	 * For the test version we need to poll the "hardware" in order
+	 * to get the updated status for unlock testing.
+	 */
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
+		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
+
 	if (test_bit(NVDIMM_SECURITY_OVERWRITE, &nvdimm->sec.flags))
 		return sprintf(buf, "overwrite\n");
 	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 92af4c3ca0d3..12a3926f4289 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| !nvdimm->sec.flags)
 		return -EIO;
 
+	/* While nfit_test does not need this, cxl_test does */
+	if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST))
+		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
+
 	/* No need to go further if security is disabled */
 	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
 		return 0;
diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index 5eb5c23b062f..8153251ea389 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -79,7 +79,6 @@ libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
 libnvdimm-$(CONFIG_NVDIMM_KEYS) += $(NVDIMM_SRC)/security.o
-libnvdimm-y += dimm_devs.o
 libnvdimm-y += libnvdimm_test.o
 libnvdimm-y += config_check.o
 
diff --git a/tools/testing/nvdimm/dimm_devs.c b/tools/testing/nvdimm/dimm_devs.c
deleted file mode 100644
index 57bd27dedf1f..000000000000
--- a/tools/testing/nvdimm/dimm_devs.c
+++ /dev/null
@@ -1,30 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/* Copyright Intel Corp. 2018 */
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/nd.h>
-#include "pmem.h"
-#include "pfn.h"
-#include "nd.h"
-#include "nd-core.h"
-
-ssize_t security_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-
-	/*
-	 * For the test version we need to poll the "hardware" in order
-	 * to get the updated status for unlock testing.
-	 */
-	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
-
-	if (test_bit(NVDIMM_SECURITY_DISABLED, &nvdimm->sec.flags))
-		return sprintf(buf, "disabled\n");
-	if (test_bit(NVDIMM_SECURITY_UNLOCKED, &nvdimm->sec.flags))
-		return sprintf(buf, "unlocked\n");
-	if (test_bit(NVDIMM_SECURITY_LOCKED, &nvdimm->sec.flags))
-		return sprintf(buf, "locked\n");
-	return -ENOTTY;
-}


