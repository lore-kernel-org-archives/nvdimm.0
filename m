Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A891A211DCDB8
 for <linux-nvdimm@lists.01.org>; Mon, 18 Mar 2019 18:06:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH] tools/testing/nvdimm: add watermarks for dax_pmem* modules
Date: Mon, 18 Mar 2019 19:06:29 -0600
Message-Id: <20190319010629.26339-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Add nfit_test 'watermarks' for the dax_pmem, dax_pmem_core, and
dax_pmem_compat modules. This causes the nfit_test module to fail
loading in case any of these modules are also not overridden with the
ldconfig wrapped modules. Without this, nfit_test would sometimes fail
creation of device-dax namespaces on the nfit_test_bus with an unhelpful
error log such as:

    dax_pmem dax5.0: could not reserve metadata
    dax_pmem: probe of dax5.0 failed with error -16

Which was caused due to the unwrapped version of
devm_request_mem_region() being called.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 tools/testing/nvdimm/Kbuild                 | 3 +++
 tools/testing/nvdimm/dax_pmem_compat_test.c | 8 ++++++++
 tools/testing/nvdimm/dax_pmem_core_test.c   | 8 ++++++++
 tools/testing/nvdimm/dax_pmem_test.c        | 8 ++++++++
 tools/testing/nvdimm/test/nfit.c            | 3 +++
 tools/testing/nvdimm/watermark.h            | 3 +++
 6 files changed, 33 insertions(+)
 create mode 100644 tools/testing/nvdimm/dax_pmem_compat_test.c
 create mode 100644 tools/testing/nvdimm/dax_pmem_core_test.c
 create mode 100644 tools/testing/nvdimm/dax_pmem_test.c

diff --git a/tools/testing/nvdimm/Kbuild b/tools/testing/nvdimm/Kbuild
index e1286d2cdfbf..c4a9196d794c 100644
--- a/tools/testing/nvdimm/Kbuild
+++ b/tools/testing/nvdimm/Kbuild
@@ -68,8 +68,11 @@ device_dax-y += device_dax_test.o
 device_dax-y += config_check.o
 
 dax_pmem-y := $(DAX_SRC)/pmem/pmem.o
+dax_pmem-y += dax_pmem_test.o
 dax_pmem_core-y := $(DAX_SRC)/pmem/core.o
+dax_pmem_core-y += dax_pmem_core_test.o
 dax_pmem_compat-y := $(DAX_SRC)/pmem/compat.o
+dax_pmem_compat-y += dax_pmem_compat_test.o
 dax_pmem-y += config_check.o
 
 libnvdimm-y := $(NVDIMM_SRC)/core.o
diff --git a/tools/testing/nvdimm/dax_pmem_compat_test.c b/tools/testing/nvdimm/dax_pmem_compat_test.c
new file mode 100644
index 000000000000..7cd1877f3765
--- /dev/null
+++ b/tools/testing/nvdimm/dax_pmem_compat_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2019 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(dax_pmem_compat);
diff --git a/tools/testing/nvdimm/dax_pmem_core_test.c b/tools/testing/nvdimm/dax_pmem_core_test.c
new file mode 100644
index 000000000000..a4249cdbeec1
--- /dev/null
+++ b/tools/testing/nvdimm/dax_pmem_core_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2019 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(dax_pmem_core);
diff --git a/tools/testing/nvdimm/dax_pmem_test.c b/tools/testing/nvdimm/dax_pmem_test.c
new file mode 100644
index 000000000000..fd4c94a5aa02
--- /dev/null
+++ b/tools/testing/nvdimm/dax_pmem_test.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright(c) 2019 Intel Corporation. All rights reserved.
+
+#include <linux/module.h>
+#include <linux/printk.h>
+#include "watermark.h"
+
+nfit_test_watermark(dax_pmem);
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index b579f962451d..9e7a6ea2ac91 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -3162,6 +3162,9 @@ static __init int nfit_test_init(void)
 	acpi_nfit_test();
 	device_dax_test();
 	mcsafe_test();
+	dax_pmem_test();
+	dax_pmem_core_test();
+	dax_pmem_compat_test();
 
 	nfit_test_setup(nfit_test_lookup, nfit_test_evaluate_dsm);
 
diff --git a/tools/testing/nvdimm/watermark.h b/tools/testing/nvdimm/watermark.h
index ed0528757bd4..43fc4f3e7927 100644
--- a/tools/testing/nvdimm/watermark.h
+++ b/tools/testing/nvdimm/watermark.h
@@ -6,6 +6,9 @@ int pmem_test(void);
 int libnvdimm_test(void);
 int acpi_nfit_test(void);
 int device_dax_test(void);
+int dax_pmem_test(void);
+int dax_pmem_core_test(void);
+int dax_pmem_compat_test(void);
 
 /*
  * dummy routine for nfit_test to validate it is linking to the properly
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
