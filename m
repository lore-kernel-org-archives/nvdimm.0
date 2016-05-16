Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id DDF521A1F7A
 for <linux-nvdimm@lists.01.org>; Mon, 16 May 2016 11:31:51 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix destruction of "dax" mode namespaces
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 16 May 2016 11:31:01 -0700
Message-ID: <146342346104.22015.12393621481904572200.stgit@dwillia2-desk3.amr.corp.intel.com>
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

At destruct time disassociate the namespace from its dax device
configuration to enable the info block to be cleared.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 286628b16532..8ce7c3e55216 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -603,7 +603,8 @@ static int namespace_destroy(struct ndctl_region *region,
 					devname, bdev, strerror(errno));
 			return -errno;
 		}
-	}
+	} else if (dax_active)
+		ndctl_namespace_disable_invalidate(ndns);
 
 	if (pfn || btt || dax) {
 		rc = zero_info_block(ndns);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
