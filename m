Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BB079C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836097; x=1701372097;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tGnlgtci5PtfoAhjOYeV+ngxrRFs4DqSP0BfS/eKXtI=;
  b=D5+XTGygbEKHtF2Ss8+sGbYs6pqCBtC3wZUO760FZ6yObD1vJN93oFI2
   cVD6eNCCJKDsvRdJUEGbWPesN9YytTqUyMF2yH4CVFgUF0o3EJWaaWZ5c
   K6eCDtyor1a0oc9UNFT4k5AkWiHk1XDaoxaEfFnUJKRVgKRLwrAt0yl9/
   KNrlcOGxa0IwL3zvkFMalsj6soqagtXo3idd7c3BIlEqV3+INUaIBHjX7
   9/NoNNvknzXw6ACc79e0HSxONBPwErD2P/Sj1/kBUu+1cGPIm2A6d+l8k
   E3ZLhpYUBWcfjPDCbPGO8bigiXHpA2S9JCjs6tpldy9poNTf5F1BV5vPX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303092369"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303092369"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="712932714"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="712932714"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:36 -0800
Subject: [PATCH v7 01/20] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:21:36 -0700
Message-ID: 
 <166983609611.2734609.13231854299523325319.stgit@djiang5-desk3.ch.intel.com>
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

Add nvdimm_security_ops support for CXL memory device with the introduction
of the ->get_flags() callback function. This is part of the "Persistent
Memory Data-at-rest Security" command set for CXL memory device support.
The ->get_flags() function provides the security state of the persistent
memory device defined by the CXL 3.0 spec section 8.2.9.8.6.1.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863346914.80269.2104235260504076729.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/Makefile         |    2 +-
 drivers/cxl/core/mbox.c      |    1 +
 drivers/cxl/cxlmem.h         |    8 ++++++
 drivers/cxl/pmem.c           |    6 +++--
 drivers/cxl/security.c       |   56 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/cxl_mem.h |    1 +
 tools/testing/cxl/Kbuild     |    1 +
 7 files changed, 72 insertions(+), 3 deletions(-)
 create mode 100644 drivers/cxl/security.c

diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index a78270794150..db321f48ba52 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -9,5 +9,5 @@ obj-$(CONFIG_CXL_PORT) += cxl_port.o
 cxl_mem-y := mem.o
 cxl_pci-y := pci.o
 cxl_acpi-y := acpi.o
-cxl_pmem-y := pmem.o
+cxl_pmem-y := pmem.o security.o
 cxl_port-y := port.o
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 0c90f13870a4..6907ee1f43e0 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -65,6 +65,7 @@ static struct cxl_mem_command cxl_mem_commands[CXL_MEM_COMMAND_ID_MAX] = {
 	CXL_CMD(GET_SCAN_MEDIA_CAPS, 0x10, 0x4, 0),
 	CXL_CMD(SCAN_MEDIA, 0x11, 0, 0),
 	CXL_CMD(GET_SCAN_MEDIA, 0, CXL_VARIABLE_PAYLOAD, 0),
+	CXL_CMD(GET_SECURITY_STATE, 0, 0x4, 0),
 };
 
 /*
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 88e3a8e54b6a..25d1d8fa7d1e 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -273,6 +273,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
 	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
+	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -372,6 +373,13 @@ struct cxl_mem_command {
 #define CXL_CMD_FLAG_FORCE_ENABLE BIT(0)
 };
 
+#define CXL_PMEM_SEC_STATE_USER_PASS_SET	0x01
+#define CXL_PMEM_SEC_STATE_MASTER_PASS_SET	0x02
+#define CXL_PMEM_SEC_STATE_LOCKED		0x04
+#define CXL_PMEM_SEC_STATE_FROZEN		0x08
+#define CXL_PMEM_SEC_STATE_USER_PLIMIT		0x10
+#define CXL_PMEM_SEC_STATE_MASTER_PLIMIT	0x20
+
 int cxl_mbox_send_cmd(struct cxl_dev_state *cxlds, u16 opcode, void *in,
 		      size_t in_size, void *out, size_t out_size);
 int cxl_dev_state_identify(struct cxl_dev_state *cxlds);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 4c627d67281a..efffc731c2ec 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -11,6 +11,8 @@
 #include "cxlmem.h"
 #include "cxl.h"
 
+extern const struct nvdimm_security_ops *cxl_security_ops;
+
 /*
  * Ordered workqueue for cxl nvdimm device arrival and departure
  * to coordinate bus rescans when a bridge arrives and trigger remove
@@ -78,8 +80,8 @@ static int cxl_nvdimm_probe(struct device *dev)
 	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
 	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
 	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
-	nvdimm = nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
-			       cmd_mask, 0, NULL);
+	nvdimm = __nvdimm_create(cxl_nvb->nvdimm_bus, cxl_nvd, NULL, flags,
+				 cmd_mask, 0, NULL, NULL, cxl_security_ops, NULL);
 	if (!nvdimm) {
 		rc = -ENOMEM;
 		goto out;
diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
new file mode 100644
index 000000000000..806173084216
--- /dev/null
+++ b/drivers/cxl/security.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/libnvdimm.h>
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <linux/async.h>
+#include <linux/slab.h>
+#include "cxlmem.h"
+#include "cxl.h"
+
+static unsigned long cxl_pmem_get_security_flags(struct nvdimm *nvdimm,
+						 enum nvdimm_passphrase_type ptype)
+{
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	unsigned long security_flags = 0;
+	u32 sec_out;
+	int rc;
+
+	rc = cxl_mbox_send_cmd(cxlds, CXL_MBOX_OP_GET_SECURITY_STATE, NULL, 0,
+			       &sec_out, sizeof(sec_out));
+	if (rc < 0)
+		return 0;
+
+	if (ptype == NVDIMM_MASTER) {
+		if (sec_out & CXL_PMEM_SEC_STATE_MASTER_PASS_SET)
+			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);
+		else
+			set_bit(NVDIMM_SECURITY_DISABLED, &security_flags);
+		if (sec_out & CXL_PMEM_SEC_STATE_MASTER_PLIMIT)
+			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
+		return security_flags;
+	}
+
+	if (sec_out & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+		if (sec_out & CXL_PMEM_SEC_STATE_FROZEN ||
+		    sec_out & CXL_PMEM_SEC_STATE_USER_PLIMIT)
+			set_bit(NVDIMM_SECURITY_FROZEN, &security_flags);
+
+		if (sec_out & CXL_PMEM_SEC_STATE_LOCKED)
+			set_bit(NVDIMM_SECURITY_LOCKED, &security_flags);
+		else
+			set_bit(NVDIMM_SECURITY_UNLOCKED, &security_flags);
+	} else {
+		set_bit(NVDIMM_SECURITY_DISABLED, &security_flags);
+	}
+
+	return security_flags;
+}
+
+static const struct nvdimm_security_ops __cxl_security_ops = {
+	.get_flags = cxl_pmem_get_security_flags,
+};
+
+const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/include/uapi/linux/cxl_mem.h b/include/uapi/linux/cxl_mem.h
index c71021a2a9ed..cdc6049683ce 100644
--- a/include/uapi/linux/cxl_mem.h
+++ b/include/uapi/linux/cxl_mem.h
@@ -41,6 +41,7 @@
 	___C(GET_SCAN_MEDIA_CAPS, "Get Scan Media Capabilities"),         \
 	___C(SCAN_MEDIA, "Scan Media"),                                   \
 	___C(GET_SCAN_MEDIA, "Get Scan Media Results"),                   \
+	___C(GET_SECURITY_STATE, "Get Security State"),			  \
 	___C(MAX, "invalid / last command")
 
 #define ___C(a, b) CXL_MEM_COMMAND_ID_##a
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 500be85729cc..e4048a05b6ab 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -26,6 +26,7 @@ cxl_acpi-y += config_check.o
 obj-m += cxl_pmem.o
 
 cxl_pmem-y := $(CXL_SRC)/pmem.o
+cxl_pmem-y += $(CXL_SRC)/security.o
 cxl_pmem-y += config_check.o
 
 obj-m += cxl_port.o


