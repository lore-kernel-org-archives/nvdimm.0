Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0962D2034D8C8
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 11:18:11 -0700 (PDT)
From: Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/5] acpi,
 nfit: Add function to look up nvdimm device and provide SMBIOS handle
Date: Mon, 12 Mar 2018 11:24:28 -0700
Message-Id: <20180312182430.10335-4-tony.luck@intel.com>
In-Reply-To: <20180312182430.10335-1-tony.luck@intel.com>
References: <CAPcyv4iHr9nUAS0SiFeqqDkU8NXZ_x=rkD3YS010Dy-nbHJXmA@mail.gmail.com>
 <20180312182430.10335-1-tony.luck@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Borislav Petkov <bp@suse.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

EDAC driver needs to look up attributes of NVDIMMs provided in SMBIOS.

Provide a function that looks up an acpi_nfit_memory_map from a device
handle (node/socket/mc/channel/dimm) and returns the SMBIOS handle.
Also pass back the "flags" so we can see if the NVDIMM is OK.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/nfit/core.c | 27 +++++++++++++++++++++++++++
 include/acpi/nfit.h      | 18 ++++++++++++++++++
 2 files changed, 45 insertions(+)
 create mode 100644 include/acpi/nfit.h

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index bbe48ad20886..4d6eeb1793e6 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -23,6 +23,7 @@
 #include <linux/io.h>
 #include <linux/nd.h>
 #include <asm/cacheflush.h>
+#include <acpi/nfit.h>
 #include "nfit.h"
 
 /*
@@ -690,6 +691,32 @@ static bool add_memdev(struct acpi_nfit_desc *acpi_desc,
 	return true;
 }
 
+int nfit_get_smbios_id(u32 device_handle, u16 *flags)
+{
+	struct acpi_nfit_memory_map *memdev;
+	struct acpi_nfit_desc *acpi_desc;
+	struct nfit_mem *nfit_mem;
+
+	mutex_lock(&acpi_desc_lock);
+	list_for_each_entry(acpi_desc, &acpi_descs, list) {
+		mutex_lock(&acpi_desc->init_mutex);
+		list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
+			memdev = __to_nfit_memdev(nfit_mem);
+			if (memdev->device_handle == device_handle) {
+				mutex_unlock(&acpi_desc->init_mutex);
+				mutex_unlock(&acpi_desc_lock);
+				*flags = memdev->flags;
+				return memdev->physical_id;
+			}
+		}
+		mutex_unlock(&acpi_desc->init_mutex);
+	}
+	mutex_unlock(&acpi_desc_lock);
+
+	return -ENODEV;
+}
+EXPORT_SYMBOL_GPL(nfit_get_smbios_id);
+
 /*
  * An implementation may provide a truncated control region if no block windows
  * are defined.
diff --git a/include/acpi/nfit.h b/include/acpi/nfit.h
new file mode 100644
index 000000000000..86ed07c1200d
--- /dev/null
+++ b/include/acpi/nfit.h
@@ -0,0 +1,18 @@
+/*
+ * SPDX-License-Identifier: GPL-2.0
+ * Copyright (C) 2018 Intel Corporation
+ */
+
+#ifndef __ACPI_NFIT_H
+#define __ACPI_NFIT_H
+
+#if IS_ENABLED(CONFIG_ACPI_NFIT)
+int nfit_get_smbios_id(u32 device_handle, u16 *flags);
+#else
+static inline int nfit_get_smbios_id(u32 device_handle, u16 *flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif /* __ACPI_NFIT_H */
-- 
2.14.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
