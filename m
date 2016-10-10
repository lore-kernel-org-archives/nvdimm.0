Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3781A1A1E48
 for <linux-nvdimm@lists.01.org>; Sun,  9 Oct 2016 17:35:52 -0700 (PDT)
From: Haozhong Zhang <haozhong.zhang@intel.com>
Subject: [RFC KERNEL PATCH 2/2] xen,
 nvdimm: report pfn devices in PFN_MODE_XEN to Xen hypervisor
Date: Mon, 10 Oct 2016 08:35:23 +0800
Message-Id: <20161010003523.4423-3-haozhong.zhang@intel.com>
In-Reply-To: <20161010003523.4423-1-haozhong.zhang@intel.com>
References: <20161010003523.4423-1-haozhong.zhang@intel.com>
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
To: linux-nvdimm@lists.01.org, xen-devel@lists.xenproject.org
Cc: Juergen Gross <jgross@suse.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, Stefano Stabellini <stefano@aporeto.com>, David Vrabel <david.vrabel@citrix.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

Xen hypervisor does not include NVDIMM driver and relies on the driver
in Dom0 Linux to probe pfn devices in PFN_MODE_XEN. Whenever such a pfn
device is probed, Dom0 Linux reports pages of the entire device, its
reserved area and data area to Xen hypervisor.

Signed-off-by: Haozhong Zhang <haozhong.zhang@intel.com>
---
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <stefano@aporeto.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
 drivers/nvdimm/pmem.c            | 25 +++++++++++++++++++
 drivers/xen/Makefile             |  2 +-
 drivers/xen/pmem.c               | 53 ++++++++++++++++++++++++++++++++++++++++
 include/xen/interface/platform.h | 13 ++++++++++
 include/xen/pmem.h               | 32 ++++++++++++++++++++++++
 5 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 drivers/xen/pmem.c
 create mode 100644 include/xen/pmem.h

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d2c9ead..eab1ee4 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -33,6 +33,11 @@
 #include "pfn.h"
 #include "nd.h"
 
+#ifdef CONFIG_XEN
+#include <xen/xen.h>
+#include <xen/pmem.h>
+#endif
+
 static struct device *to_dev(struct pmem_device *pmem)
 {
 	/*
@@ -364,6 +369,26 @@ static int pmem_attach_disk(struct device *dev,
 
 	revalidate_disk(disk);
 
+#ifdef CONFIG_XEN
+	if (xen_initial_domain() && is_nd_pfn_xen(dev)) {
+		uint64_t rsv_off, rsv_size, data_off, data_size;
+		int err;
+
+		rsv_off = le64_to_cpu(pfn_sb->start_pad) +
+			  PFN_PHYS(altmap->reserve);
+		rsv_size = PFN_PHYS(altmap->free);
+		data_off = le32_to_cpu(pfn_sb->start_pad) + pmem->data_offset;
+		data_size = pmem->size - pmem->pfn_pad - pmem->data_offset;
+
+		err = xen_pmem_add(pmem->phys_addr, pmem->size,
+				   rsv_off, rsv_size, data_off, data_size);
+		if (err) {
+			dev_err(dev, "failed to register to Xen\n");
+			return err;
+		}
+	}
+#endif
+
 	return 0;
 }
 
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 8feab810..7f95156 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 obj-$(CONFIG_X86)			+= fallback.o
-obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o time.o
+obj-y	+= grant-table.o features.o balloon.o manage.o preempt.o time.o pmem.o
 obj-y	+= events/
 obj-y	+= xenbus/
 
diff --git a/drivers/xen/pmem.c b/drivers/xen/pmem.c
new file mode 100644
index 0000000..bb027a5
--- /dev/null
+++ b/drivers/xen/pmem.c
@@ -0,0 +1,53 @@
+/******************************************************************************
+ * pmem.c
+ * pmem file for domain 0 kernel
+ *
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Haozhong Zhang <haozhong.zhang@intel.com>
+ */
+
+#include <linux/types.h>
+#include <xen/interface/platform.h>
+#include <asm/xen/hypercall.h>
+
+int xen_pmem_add(uint64_t spa, size_t size,
+		 uint64_t rsv_off, size_t rsv_size,
+		 uint64_t data_off, size_t data_size)
+{
+	int rc;
+	struct xen_platform_op op;
+
+	if ((spa | size | rsv_off | rsv_size | data_off | data_size) &
+	    (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	op.cmd = XENPF_pmem_add;
+	op.u.pmem_add.spfn = PHYS_PFN(spa);
+	op.u.pmem_add.epfn = PHYS_PFN(spa) + PHYS_PFN(size);
+	op.u.pmem_add.rsv_spfn = PHYS_PFN(spa + rsv_off);
+	op.u.pmem_add.rsv_epfn = PHYS_PFN(spa + rsv_off + rsv_size);
+	op.u.pmem_add.data_spfn = PHYS_PFN(spa + data_off);
+	op.u.pmem_add.data_epfn = PHYS_PFN(spa + data_off + data_size);
+
+	rc = HYPERVISOR_platform_op(&op);
+	if (rc)
+		pr_err("Xen pmem add failed on 0x%llx ~ 0x%llx, error: %d\n",
+		       spa, spa + size, rc);
+
+	return rc;
+}
+EXPORT_SYMBOL(xen_pmem_add);
diff --git a/include/xen/interface/platform.h b/include/xen/interface/platform.h
index 732efb0..6c51f0c 100644
--- a/include/xen/interface/platform.h
+++ b/include/xen/interface/platform.h
@@ -500,6 +500,18 @@ struct xenpf_symdata {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xenpf_symdata);
 
+#define XENPF_pmem_add     64
+struct xenpf_pmem_add {
+	/* IN variables */
+	uint64_t spfn;	    /* start PFN of the whole pmem region */
+	uint64_t epfn;	    /* end PFN of the whole pmem region */
+	uint64_t rsv_spfn;  /* start PFN of the reserved area */
+	uint64_t rsv_epfn;  /* end PFN of the reserved area */
+	uint64_t data_spfn; /* start PFN of the data area */
+	uint64_t data_epfn; /* end PFN of the data area */
+};
+DEFINE_GUEST_HANDLE_STRUCT(xenpf_pmem_add);
+
 struct xen_platform_op {
 	uint32_t cmd;
 	uint32_t interface_version; /* XENPF_INTERFACE_VERSION */
@@ -523,6 +535,7 @@ struct xen_platform_op {
 		struct xenpf_mem_hotadd        mem_add;
 		struct xenpf_core_parking      core_parking;
 		struct xenpf_symdata           symdata;
+		struct xenpf_pmem_add          pmem_add;
 		uint8_t                        pad[128];
 	} u;
 };
diff --git a/include/xen/pmem.h b/include/xen/pmem.h
new file mode 100644
index 0000000..896422a
--- /dev/null
+++ b/include/xen/pmem.h
@@ -0,0 +1,32 @@
+/******************************************************************************
+ * pmem.h
+ * pmem file for domain 0 kernel
+ *
+ * Copyright (c) 2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; If not, see <http://www.gnu.org/licenses/>.
+ *
+ * Author: Haozhong Zhang <haozhong.zhang@intel.com>
+ */
+
+#ifndef __XEN_PMEM_H__
+#define __XEN_PMEM_H__
+
+#include <linux/types.h>
+
+int xen_pmem_add(uint64_t spa, size_t size,
+		 uint64_t rsv_off, size_t rsv_size,
+		 uint64_t data_off, size_t data_size);
+
+#endif /* __XEN_PMEM_H__ */
-- 
2.10.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
