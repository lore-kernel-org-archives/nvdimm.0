Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C582C80
	for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 23:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643673129; x=1675209129;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+/coqwKlOdxaXYlX5oEp45IALwH8yjaQ+IYj+p4ZQB8=;
  b=CKOfyt8npCsBw358x5e3c0OStePftE7MrKj8etRJtczNKzvNUtgiiORX
   ulq+GPmQRVRlwk5xcIHyuLe+L5Cpn1zMDOREzGWpA3GHwjMapRHzfFz5F
   rSAVfOED26cguehHLWmQTCZ12K9L0WK5ODe1OMr1+9RNYtlaALh6TuWSz
   ojWZX2/VkL/FH2BrScm5NiJYMbexK9YppRozCZzbzN99UdBWy8PZbMVx6
   Xxejz0zR39aP7AKuqtoMO3w8icJBUVlFs4GG4MVxHLjamy3nrDxKSYJfr
   PHpIhG+Fg6IiqkLzbRH52JvUKBL//X6dkeNbo0p3lPUOuERPgWxbu/tRW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247348266"
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="247348266"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:51:45 -0800
X-IronPort-AV: E=Sophos;i="5.88,332,1635231600"; 
   d="scan'208";a="537554609"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:51:45 -0800
Subject: [PATCH v4 02/40] cxl/pci: Implement Interface Ready Timeout
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Mon, 31 Jan 2022 15:51:45 -0800
Message-ID: <164367306565.208548.1932299464604450843.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ben Widawsky <ben.widawsky@intel.com>

The original driver implementation used the doorbell timeout for the
Mailbox Interface Ready bit to piggy back off of, since the latter does
not have a defined timeout. This functionality, introduced in commit
8adaf747c9f0 ("cxl/mem: Find device capabilities"), needs improvement as
the recent "Add Mailbox Ready Time" ECN timeout indicates that the
mailbox ready time can be significantly longer that 2 seconds.

While the specification limits the maximum timeout to 256s, the cxl_pci
driver gives up on the mailbox after 60s. This value corresponds with
important timeout values already present in the kernel. A module
parameter is provided as an emergency override and represents the
default Linux policy for all devices.

Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[djbw: add modparam, drop check_device_status()]
Co-developed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes since v3:
- Let non-admins send timeout bug reports (Ben)

 drivers/cxl/pci.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8dc91fd3396a..cc0cdd7e9de3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -1,7 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2020 Intel Corporation. All rights reserved. */
 #include <linux/io-64-nonatomic-lo-hi.h>
+#include <linux/moduleparam.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/sizes.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -35,6 +37,20 @@
 /* CXL 2.0 - 8.2.8.4 */
 #define CXL_MAILBOX_TIMEOUT_MS (2 * HZ)
 
+/*
+ * CXL 2.0 ECN "Add Mailbox Ready Time" defines a capability field to
+ * dictate how long to wait for the mailbox to become ready. The new
+ * field allows the device to tell software the amount of time to wait
+ * before mailbox ready. This field per the spec theoretically allows
+ * for up to 255 seconds. 255 seconds is unreasonably long, its longer
+ * than the maximum SATA port link recovery wait. Default to 60 seconds
+ * until someone builds a CXL device that needs more time in practice.
+ */
+static unsigned short mbox_ready_timeout = 60;
+module_param(mbox_ready_timeout, ushort, 0644);
+MODULE_PARM_DESC(mbox_ready_timeout,
+		 "seconds to wait for mailbox ready status");
+
 static int cxl_pci_mbox_wait_for_doorbell(struct cxl_dev_state *cxlds)
 {
 	const unsigned long start = jiffies;
@@ -281,6 +297,25 @@ static int cxl_pci_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *c
 static int cxl_pci_setup_mailbox(struct cxl_dev_state *cxlds)
 {
 	const int cap = readl(cxlds->regs.mbox + CXLDEV_MBOX_CAPS_OFFSET);
+	unsigned long timeout;
+	u64 md_status;
+
+	timeout = jiffies + mbox_ready_timeout * HZ;
+	do {
+		md_status = readq(cxlds->regs.memdev + CXLMDEV_STATUS_OFFSET);
+		if (md_status & CXLMDEV_MBOX_IF_READY)
+			break;
+		if (msleep_interruptible(100))
+			break;
+	} while (!time_after(jiffies, timeout));
+
+	if (!(md_status & CXLMDEV_MBOX_IF_READY)) {
+		dev_err(cxlds->dev,
+			"timeout awaiting mailbox ready, device state:%s%s\n",
+			md_status & CXLMDEV_DEV_FATAL ? " fatal" : "",
+			md_status & CXLMDEV_FW_HALT ? " firmware-halt" : "");
+		return -EIO;
+	}
 
 	cxlds->mbox_send = cxl_pci_mbox_send;
 	cxlds->payload_size =

