Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6A4E21F0DA74
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 20:47:22 -0800 (PST)
Subject: [ndctl PATCH] ndctl: fallback to sysconf for PAGE_SIZE
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 09 Feb 2018 20:44:03 -0800
Message-ID: <151823784326.20330.6389521335698598896.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On ARM and PowerPC PAGE_SIZE is not defined. Fall back to sysconf().

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/ndctl.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index eb5a9b387b3d..ebd2a41cce46 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -16,6 +16,7 @@
 #include <ccan/array_size/array_size.h>
 #include <linux/types.h>
 #include <sys/user.h>
+#include <unistd.h>
 
 struct nd_cmd_dimm_flags {
 	__u32 status;
@@ -210,9 +211,13 @@ enum nd_driver_flags {
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
+#ifdef PAGE_SIZE
 enum {
 	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
 };
+#else
+#define ND_MIN_NAMESPACE_SIZE ((unsigned) sysconf(_SC_PAGESIZE))
+#endif
 
 enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
