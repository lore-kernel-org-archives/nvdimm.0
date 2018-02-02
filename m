Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8164D223CCF17
 for <linux-nvdimm@lists.01.org>; Fri,  2 Feb 2018 00:32:46 -0800 (PST)
Subject: [ndctl PATCH] ndctl: update minimum namespace size
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Feb 2018 00:29:18 -0800
Message-ID: <151756015882.24501.9157437746399427723.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The kernel starting with version v4.16 supports a minimum namespace size
as low as PAGE_SIZE. Update the dpa-alloc test to account for the fact
that its 4K allocations may result in the namespace being activated with
its parent region.

Cc: Matthew Wilcox <willy@infradead.org>
Reported-by: Cheng-mean Liu <soccerl@microsoft.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/ndctl.h    |    3 ++-
 test/dpa-alloc.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index 4cf373b2a5d4..eb5a9b387b3d 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -15,6 +15,7 @@
 
 #include <ccan/array_size/array_size.h>
 #include <linux/types.h>
+#include <sys/user.h>
 
 struct nd_cmd_dimm_flags {
 	__u32 status;
@@ -210,7 +211,7 @@ enum nd_driver_flags {
 };
 
 enum {
-	ND_MIN_NAMESPACE_SIZE = 0x00400000,
+	ND_MIN_NAMESPACE_SIZE = PAGE_SIZE,
 };
 
 enum ars_masks {
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 7793650699da..8bb7dd7408a1 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -232,6 +232,11 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 
 		uuid_unparse(namespaces[i].uuid, uuid_str);
 		size = ndctl_namespace_get_size(victim);
+		rc = ndctl_namespace_disable(victim);
+		if (rc) {
+			fprintf(stderr, "failed to disable %s\n", uuid_str);
+			return rc;
+		}
 		rc = ndctl_namespace_delete(victim);
 		if (rc) {
 			fprintf(stderr, "failed to delete %s\n", uuid_str);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
