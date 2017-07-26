Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 162AB21D0FE0B
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 16:35:41 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v4 5/6] libnvdimm: fix potential deadlock while clearing errors
Date: Wed, 26 Jul 2017 17:35:45 -0600
Message-Id: <20170726233546.29052-6-vishal.l.verma@intel.com>
In-Reply-To: <20170726233546.29052-1-vishal.l.verma@intel.com>
References: <20170726233546.29052-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

With the ACPI NFIT 'DSM' methods, acpi can be called from IO paths.
Specifically, the DSM to clear media errors is called during writes, so
that we can provide a writes-fix-errors model.

However it is easy to imagine a scenario like:
 -> write through the nvdimm driver
   -> acpi allocation
     -> writeback, causes more IO through the nvdimm driver
       -> deadlock

Fix this by using memalloc_noio_{save,restore}, which sets the GFP_NOIO
flag for the current scope when issuing commands/IOs that are expected
to clear errors.

Cc: <linux-acpi@vger.kernel.org>
Cc: <linux-nvdimm@lists.01.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Robert Moore <robert.moore@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 937fafa..a18c291 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -11,6 +11,7 @@
  * General Public License for more details.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#include <linux/sched/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
@@ -234,6 +235,7 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	struct nd_cmd_clear_error clear_err;
 	struct nd_cmd_ars_cap ars_cap;
 	u32 clear_err_unit, mask;
+	unsigned int noio_flag;
 	int cmd_rc, rc;
 
 	if (!nvdimm_bus)
@@ -250,8 +252,10 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	memset(&ars_cap, 0, sizeof(ars_cap));
 	ars_cap.address = phys;
 	ars_cap.length = len;
+	noio_flag = memalloc_noio_save();
 	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_ARS_CAP, &ars_cap,
 			sizeof(ars_cap), &cmd_rc);
+	memalloc_noio_restore(noio_flag);
 	if (rc < 0)
 		return rc;
 	if (cmd_rc < 0)
@@ -266,8 +270,10 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	memset(&clear_err, 0, sizeof(clear_err));
 	clear_err.address = phys;
 	clear_err.length = len;
+	noio_flag = memalloc_noio_save();
 	rc = nd_desc->ndctl(nd_desc, NULL, ND_CMD_CLEAR_ERROR, &clear_err,
 			sizeof(clear_err), &cmd_rc);
+	memalloc_noio_restore(noio_flag);
 	if (rc < 0)
 		return rc;
 	if (cmd_rc < 0)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
