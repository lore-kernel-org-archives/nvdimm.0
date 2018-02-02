Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C945821E0BA1B
 for <linux-nvdimm@lists.01.org>; Thu,  1 Feb 2018 16:32:24 -0800 (PST)
Subject: [PATCH] tools/testing/nvdimm: force nfit_test to depend on
 instrumented modules
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 01 Feb 2018 16:28:56 -0800
Message-ID: <151753133661.5914.4544112484376138963.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The libnvdimm unit tests will fail when they are run against the
production / in-tree version of libnvdimm.ko or nfit.ko due to
symbols not being mocked per nfit_test's expectation. For example,
nfit_test expects acpi_evaluate_dsm() to be replaced by
__wrap_acpi_evaluate_dsm() to test how acpi_nfit_ctl() responds to
different stimuli.

Create a test-only symbol name that nfit_test links against to cause
module load failures when the wrong module is present.

For example, with this change, attempts to use the wrong module will
report:

    nfit_test: Unknown symbol libnvdimm_test (err 0)

Reported-by: Dave Jiang <dave.jiang@intel.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/Kbuild            |    4 ++++
 tools/testing/nvdimm/acpi_nfit_test.c  |    8 ++++++++
 tools/testing/nvdimm/device_dax_test.c |    8 ++++++++
 tools/testing/nvdimm/libnvdimm_test.c  |    8 ++++++++
 tools/testing/nvdimm/pmem_test.c       |    8 ++++++++
 tools/testing/nvdimm/test/nfit.c       |    6 ++++++
 tools/testing/nvdimm/watermark.h       |   21 +++++++++++++++++++++
 7 files changed, 63 insertions(+)
 create mode 100644 tools/testing/nvdimm/acpi_nfit_test.c
 create mode 100644 tools/testing/nvdimm/device_dax_test.c
 create mode 100644 tools/testing/nvdimm/libnvdimm_test.c
 create mode 100644 tools/testing/nvdimm/pmem_test.c
 create mode 100644 tools/testing/nvdimm/watermark.h

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index db33b28c5ef3..0392153a0009 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -37,10 +37,12 @@ obj-$(CONFIG_DEV_DAX_PMEM) += dax_pmem.o
 
 nfit-y := $(ACPI_SRC)/core.o
 nfit-$(CONFIG_X86_MCE) += $(ACPI_SRC)/mce.o
+nfit-y += acpi_nfit_test.o
 nfit-y += config_check.o
 
 nd_pmem-y := $(NVDIMM_SRC)/pmem.o
 nd_pmem-y += pmem-dax.o
+nd_pmem-y += pmem_test.o
 nd_pmem-y += config_check.o
 
 nd_btt-y := $(NVDIMM_SRC)/btt.o
@@ -57,6 +59,7 @@ dax-y += config_check.o
 
 device_dax-y := $(DAX_SRC)/device.o
 device_dax-y += dax-dev.o
+device_dax-y += device_dax_test.o
 device_dax-y += config_check.o
 
 dax_pmem-y := $(DAX_SRC)/pmem.o
@@ -75,6 +78,7 @@ libnvdimm-$(CONFIG_ND_CLAIM) += $(NVDIMM_SRC)/claim.o
 libnvdimm-$(CONFIG_BTT) += $(NVDIMM_SRC)/btt_devs.o
 libnvdimm-$(CONFIG_NVDIMM_PFN) += $(NVDIMM_SRC)/pfn_devs.o
 libnvdimm-$(CONFIG_NVDIMM_DAX) += $(NVDIMM_SRC)/dax_devs.o
+libnvdimm-y += libnvdimm_test.o
 libnvdimm-y += config_check.o
 
 obj-m += test/
diff --git a/tools/testing/nvdimm/acpi_nfit_test.c b/tools/testing/nvdimm/acpi_nfit_test.c
new file mode 100644
index 000000000000..43521512e577
--- /dev/null
+++ b/tools/testing/nvdimm/acpi_nfit_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(acpi_nfit);
diff --git a/tools/testing/nvdimm/device_dax_test.c b/tools/testing/nvdimm/device_dax_test.c
new file mode 100644
index 000000000000..24b17bf42429
--- /dev/null
+++ b/tools/testing/nvdimm/device_dax_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(device_dax);
diff --git a/tools/testing/nvdimm/libnvdimm_test.c b/tools/testing/nvdimm/libnvdimm_test.c
new file mode 100644
index 000000000000..00ca30b23932
--- /dev/null
+++ b/tools/testing/nvdimm/libnvdimm_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(libnvdimm);
diff --git a/tools/testing/nvdimm/pmem_test.c b/tools/testing/nvdimm/pmem_test.c
new file mode 100644
index 000000000000..fd38f92275cf
--- /dev/null
+++ b/tools/testing/nvdimm/pmem_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(pmem);
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 2b57254342aa..77bd5d096333 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -27,6 +27,7 @@
 #include <nfit.h>
 #include <nd.h>
 #include "nfit_test.h"
+#include "../watermark.h"
 
 /*
  * Generate an NFIT table to describe the following topology:
@@ -2239,6 +2240,11 @@ static __init int nfit_test_init(void)
 {
 	int rc, i;
 
+	pmem_test();
+	libnvdimm_test();
+	acpi_nfit_test();
+	device_dax_test();
+
 	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 
 	nfit_wq = create_singlethread_workqueue("nfit");
diff --git a/tools/testing/nvdimm/watermark.h b/tools/testing/nvdimm/watermark.h
new file mode 100644
index 000000000000..ed0528757bd4
--- /dev/null
+++ b/tools/testing/nvdimm/watermark.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2018 Intel Corporation. All rights reserved.
+#ifndef _TEST_NVDIMM_WATERMARK_H_
+#define _TEST_NVDIMM_WATERMARK_H_
+int pmem_test(void);
+int libnvdimm_test(void);
+int acpi_nfit_test(void);
+int device_dax_test(void);
+
+/*
+ * dummy routine for nfit_test to validate it is linking to the properly
+ * mocked module and not the standard one from the base tree.
+ */
+#define nfit_test_watermark(x)				\
+int x##_test(void)					\
+{							\
+	pr_debug("%s for nfit_test\n", KBUILD_MODNAME);	\
+	return 0;					\
+}							\
+EXPORT_SYMBOL(x##_test)
+#endif /* _TEST_NVDIMM_WATERMARK_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
