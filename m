Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3EA5A97
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774300; x=1695310300;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1O9Asc07GbfKVTDVTT9dGrqZT0vtPNNEedLqiQzIVsQ=;
  b=oAqvNUh4gU2Te10ETkTF713s443P66Xw5xHy5UDBJAxqL1X+odp0pPVI
   kgzwzoSJm6xoh97G6Lr6CseF+KU55ugqZV8O6RuU1otOgWG1RGzvKYAt1
   i51DUrrAMaUTRuCLyKu3Py/dDyWHttuRxjZY6Pzp1eEWIwjteuSPDjUmK
   eDKkk6IfzFnotRjKBNzSLCykdXfZvTpM+lj5qRJ/BTOOfehRJg2mxNYH7
   NeDRxRU5vIdCx2LweCrDFMI1TdTWTE42RftXc/ZyfoMh6X+1OMLlfO1aI
   k8XFv75iNbf6oShDbjexG3cMNM899LnlAXiEC89BGZRlxcspkDEkjXnWN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="298752848"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="298752848"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:40 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="652578939"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:39 -0700
Subject: [PATCH v2 02/19] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:31:39 -0700
Message-ID: 
 <166377429922.430546.3219384653732905207.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
References: 
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

Add nvdimm_security_ops support for CXL memory device with the introduction
of the ->get_flags() callback function. This is part of the "Persistent
Memory Data-at-rest Security" command set for CXL memory device support.
The ->get_flags() function provides the security state of the persistent
memory device defined by the CXL 2.0 spec section 8.2.9.5.6.1.

The nvdimm_security_ops for CXL is configured as an build option toggled by
kernel configuration CONFIG_CXL_PMEM_SECURITY.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
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
index 16176b9278b4..8f4be61a76b5 100644
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
index 7dc0a2fa1a6b..24bec4ca3866 100644
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
@@ -75,8 +77,8 @@ static int cxl_nvdimm_probe(struct device *dev)
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


