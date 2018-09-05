Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 526662111B770
 for <linux-nvdimm@lists.01.org>; Wed,  5 Sep 2018 08:55:46 -0700 (PDT)
Subject: [PATCH 10/11] UAPI: ndctl: Remove use of PAGE_SIZE
From: David Howells <dhowells@redhat.com>
Date: Wed, 05 Sep 2018 16:55:44 +0100
Message-ID: <153616294415.23468.9444162145650526598.stgit@warthog.procyon.org.uk>
In-Reply-To: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
References: <153616286704.23468.584491117180383924.stgit@warthog.procyon.org.uk>
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
To: linux-api@vger.kernel.org, linux-kbuild@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The macro PAGE_SIZE isn't valid outside of the kernel, so it should not
appear in UAPI headers.

Furthermore, the actual machine page size could theoretically change from
an application's point of view if it's running in a container that gets
migrated to another machine (say 4K/ppc64 to 64K/ppc64).

Fixes: f2ba5a5baecf ("libnvdimm, namespace: make min namespace size 4K")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Dan Williams <dan.j.williams@intel.com>
cc: linux-nvdimm@lists.01.org
---

 include/linux/ndctl.h      |   22 ++++++++++++++++++++++
 include/uapi/linux/ndctl.h |    4 ----
 2 files changed, 22 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/ndctl.h

diff --git a/include/linux/ndctl.h b/include/linux/ndctl.h
new file mode 100644
index 000000000000..cd5a293ce3ae
--- /dev/null
+++ b/include/linux/ndctl.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#ifndef _LINUX_NDCTL_H
+#define _LINUX_NDCTL_H
+
+#include <uapi/linux/ndctl.h>
+
+enum {
+	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
+};
+
+#endif /* _LINUX_NDCTL_H */
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 9c89159f6a0f..bcda968e6d80 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -216,10 +216,6 @@ enum nd_driver_flags {
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
-enum {
-	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
-};
-
 enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
