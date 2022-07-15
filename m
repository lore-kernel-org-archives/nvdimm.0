Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18C15382
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919319; x=1689455319;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9rZTNHLSztiH0nN2cBKzyjZJ5yqEsukWe+x5YDaSmq0=;
  b=gb75SWyW81Rgha0n+K73l3SQJbh/AxeRAhj1FNU90Qas8CzClhFHNrr2
   bBsTznbW52C3F6Dgy2L5jeJUx4hbdDElKn2f9J7C8L8sJ6Hg34/ydgj9A
   GZF7AyyL570PaCOmUGNptnKIiwVX6Sp4DoALPg9ugbDQ1G/gNJ0ekYgLL
   r1XbUhkMSf750r8dfbVwkTkDo2E9GQ3O8jpwdT4pw391+h4J9YVZKePdy
   SWTWYxGmRBevdOG7So8KYk9hs9n1jCW3DN2NC17ZyIe4cyAh9DrPD30wJ
   xew8IjQKyvXdk3SVW9/9XLHpCHrYBLI63M90jeJBGpV1aNGnOTmcMMIbC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="372214980"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="372214980"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="596605664"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:38 -0700
Subject: [PATCH RFC 01/15] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:08:38 -0700
Message-ID: 
 <165791931828.2491387.3280104860123759941.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
References: 
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

Add nvdimm_security_ops support for CXL memory device with the introduction
of the ->get_flags() callback function. This is part of the "Persistent
Memory Data-at-rest Security" command set for CXL memory device support.
The ->get_flags() function provides the security state of the persistent
memory device defined by the CXL 2.0 spec section 8.2.9.5.6.1.

The nvdimm_security_ops for CXL is configured as an build option toggled by
kernel configuration CONFIG_CXL_PMEM_SECURITY.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/Kconfig      |   16 +++++++++++++
 drivers/cxl/Makefile     |    1 +
 drivers/cxl/cxlmem.h     |    9 +++++++
 drivers/cxl/pmem.c       |   10 ++++++--
 drivers/cxl/security.c   |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/cxl/Kbuild |    1 +
 6 files changed, 92 insertions(+), 2 deletions(-)
 create mode 100644 drivers/cxl/security.c

diff --git a/drivers/cxl/Kconfig b/drivers/cxl/Kconfig
index f64e3984689f..43527a697f60 100644
--- a/drivers/cxl/Kconfig
+++ b/drivers/cxl/Kconfig
@@ -102,4 +102,20 @@ config CXL_SUSPEND
 	def_bool y
 	depends on SUSPEND && CXL_MEM
 
+config CXL_PMEM_SECURITY
+	tristate "CXL PMEM SECURITY: Persistent Memory Security Support"
+	depends on CXL_PMEM
+	default CXL_BUS
+	help
+	  CXL memory device "Persistent Memory Data-at-rest Security" command set
+	  support. Support opcode 0x4500..0x4505. The commands supported are "Get
+	  Security State", "Set Passphrase", "Disable Passphrase", "Unlock",
+	  "Freeze Security State", and "Passphrase Secure Erase". Security operation
+	  is done through nvdimm security_ops.
+
+	  See Chapter 8.2.9.5.6 in the CXL 2.0 specification for a detailed description
+	  of the Persistent Memory Security.
+
+	  If unsure say 'm'.
+
 endif
diff --git a/drivers/cxl/Makefile b/drivers/cxl/Makefile
index a78270794150..c19cf28f7512 100644
--- a/drivers/cxl/Makefile
+++ b/drivers/cxl/Makefile
@@ -11,3 +11,4 @@ cxl_pci-y := pci.o
 cxl_acpi-y := acpi.o
 cxl_pmem-y := pmem.o
 cxl_port-y := port.o
+cxl_pmem-$(CONFIG_CXL_PMEM_SECURITY) += security.o
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 7df0b053373a..35de2889aac3 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -250,6 +250,7 @@ enum cxl_opcode {
 	CXL_MBOX_OP_GET_SCAN_MEDIA_CAPS	= 0x4303,
 	CXL_MBOX_OP_SCAN_MEDIA		= 0x4304,
 	CXL_MBOX_OP_GET_SCAN_MEDIA	= 0x4305,
+	CXL_MBOX_OP_GET_SECURITY_STATE	= 0x4500,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
@@ -342,6 +343,13 @@ struct cxl_mem_command {
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
@@ -370,4 +378,5 @@ struct cxl_hdm {
 	unsigned int interleave_mask;
 	struct cxl_port *port;
 };
+
 #endif /* __CXL_MEM_H__ */
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 0aaa70b4e0f7..6dbf067dcf10 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -10,6 +10,12 @@
 #include "cxlmem.h"
 #include "cxl.h"
 
+#if IS_ENABLED(CONFIG_CXL_PMEM_SECURITY)
+extern const struct nvdimm_security_ops *cxl_security_ops;
+#else
+static const struct nvdimm_security_ops *cxl_security_ops = NULL;
+#endif
+
 /*
  * Ordered workqueue for cxl nvdimm device arrival and departure
  * to coordinate bus rescans when a bridge arrives and trigger remove
@@ -58,8 +64,8 @@ static int cxl_nvdimm_probe(struct device *dev)
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
index 000000000000..5b830ae621db
--- /dev/null
+++ b/drivers/cxl/security.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2022 Intel Corporation. All rights reserved. */
+#include <linux/libnvdimm.h>
+#include <asm/unaligned.h>
+#include <linux/module.h>
+#include <linux/ndctl.h>
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
+	unsigned long security_flags;
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
diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
index 33543231d453..7db7a35a1c2a 100644
--- a/tools/testing/cxl/Kbuild
+++ b/tools/testing/cxl/Kbuild
@@ -27,6 +27,7 @@ obj-m += cxl_pmem.o
 
 cxl_pmem-y := $(CXL_SRC)/pmem.o
 cxl_pmem-y += config_check.o
+cxl_pmem-$(CONFIG_CXL_PMEM_SECURITY) += $(CXL_SRC)/security.o
 
 obj-m += cxl_port.o
 


