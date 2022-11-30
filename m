Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923FB79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836189; x=1701372189;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iOBOCcyRhRfDAngsYxwIKQzOMhbnOtJKQN9hHGwZIOM=;
  b=FytwYjAHpNnBjaqMnVVDNueeqteI9oNq5pWJ2YFIRaVTu8HKbHcYMVPQ
   gH+eZksDGZC6XHVAcHU2bUF++Aq9VhBcV09M9w6hHevR7gygk2TRL8XI7
   UiVGdPV2da4LPIv35IpW3ODJg66mPDuxf3QgB1xgemFi38E0gZkLh8JcN
   7zsBLM8MlF2t9Dl0pd2soJDW54AGrhHLMBsy32PC2ZO8InM9sUunLHXzi
   mlw9oQ+22RUMmsAxur231hWjZ6Wvv53+GC7QGu1PrUWEkc7vfhVL8IW/3
   Q9lQCvjhmunPjkzOBQyya/+f2GypKn72wWZCezY5RxlojcmfSGpRnl2uL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="313118709"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="313118709"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:09 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="889415427"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="889415427"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:23:07 -0800
Subject: [PATCH v7 17/20] libnvdimm: Introduce CONFIG_NVDIMM_SECURITY_TEST
 flag
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:23:07 -0700
Message-ID: 
 <166983618758.2734609.18031639517065867138.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
References: 
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

nfit_test overrode the security_show() sysfs attribute function in nvdimm
dimm_devs in order to allow testing of security unlock. With the
introduction of CXL security commands, the trick to override
security_show() becomes significantly more complicated. By introdcing a
security flag CONFIG_NVDIMM_SECURITY_TEST, libnvdimm can just toggle the
check via a compile option. In addition the original override can can be
removed from tools/testing/nvdimm/.

The flag will also be used to bypass cpu_cache_invalidate_memregion() when
set in a different commit. This allows testing on QEMU with nfit_test or
cxl_test since cpu_cache_has_invalidate_memregion() checks whether
X86_FEATURE_HYPERVISOR cpu feature flag is set on x86.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863356449.80269.10160948733785901265.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/Kconfig           |   12 ++++++++++++
 drivers/nvdimm/dimm_devs.c       |    9 ++++++++-
 drivers/nvdimm/security.c        |    4 ++++
 tools/testing/nvdimm/Kbuild      |    1 -
 tools/testing/nvdimm/dimm_devs.c |   30 ------------------------------
 5 files changed, 24 insertions(+), 32 deletions(-)
 delete mode 100644 tools/testing/nvdimm/dimm_devs.c

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 5a29046e3319..79d93126453d 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -114,4 +114,16 @@ config NVDIMM_TEST_BUILD
 	  core devm_memremap_pages() implementation and other
 	  infrastructure.
 
+config NVDIMM_SECURITY_TEST
+	bool "Enable NVDIMM security unit tests"
+	depends on NVDIMM_KEYS
+	help
+	  The NVDIMM and CXL subsystems support unit testing of their device
+	  security state machines. The NVDIMM_SECURITY_TEST option disables CPU
+	  cache maintenance operations around events like secure erase and
+	  overwrite.  Also, when enabled, the NVDIMM subsystem core helps the unit
+	  test implement a mock state machine.
+
+	  Select N if unsure.
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
index 92af4c3ca0d3..6814339b3dab 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -177,6 +177,10 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
 			|| !nvdimm->sec.flags)
 		return -EIO;
 
+	/* cxl_test needs this to pre-populate the security state */
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


