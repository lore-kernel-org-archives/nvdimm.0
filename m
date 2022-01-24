Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C302C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984130; x=1674520130;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qbLNMAnty4gJkoAKex52oh503HoWQvUo2O0EEWaISls=;
  b=ItRCKuPMeMk3LIvrqyZNUhV6I9ImTb72VR1EYnim9MRv3yCprIP7qE3V
   yV8Apau2z2zpvQYpw7om5b/YwI640/rMqjo0biy/FYrqIsx9nqNQZp8i5
   YGIiHYhQx2RC7xO6SCDGZXGIcnO/CqjZz1iH+zcgq3hzF5WvdZL6K/ZO7
   eaDk8xzG4vyHhKsxt37Hp7Do75aorOhiXq8a8MZrdCWePwr0oPEPTS70t
   lyIfoKY3YipfNpYuRJxqSclMm6LhPBfN+cmKHLlfQv5L4GyPuQ49dyCyW
   mRlp7JwHyZayj4p1Q+itoKVf1mXsIo3fRGMjrcu+h/yIrOgKJr/oCQWnI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="246151534"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="246151534"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:28:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="580171932"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:28:49 -0800
Subject: [PATCH v3 02/40] cxl/pci: Implement Interface Ready Timeout
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Ben Widawsky <ben.widawsky@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, linux-pci@vger.kernel.org,
 nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:28:49 -0800
Message-ID: <164298412919.3018233.12491722885382120190.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
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
 drivers/cxl/pci.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8dc91fd3396a..ed8de9eac970 100644
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
+module_param(mbox_ready_timeout, ushort, 0600);
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

