Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9783212E25AC
 for <linux-nvdimm@lists.01.org>; Sat, 27 Jul 2019 14:58:07 -0700 (PDT)
Subject: [ndctl PATCH v2 23/26] ndctl/namespace: Report ENOSPC when regions
 are full
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 27 Jul 2019 14:41:23 -0700
Message-ID: <156426368351.531577.5819409272263585965.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156426356088.531577.14828880045306313118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The create-namespace error message:

    failed to create namespace: Resource temporarily unavailable

...is misleading because the lack of capacity is permanent until the
user frees up space.

Trap EAGAIN and translate to ENOSPC in case the region capacity search
fails:

    failed to create namespace: No space left on device

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 75ea366574f8..f215f77a94e1 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1806,6 +1806,15 @@ static int do_xaction_namespace(const char *namespace,
 	if (ri_ctx.f_out && ri_ctx.f_out != stdout)
 		fclose(ri_ctx.f_out);
 
+	if (action == ACTION_CREATE && rc == -EAGAIN) {
+		/*
+		 * Namespace creation searched through all candidate
+		 * regions and all of them said "nope, I don't have
+		 * enough capacity", so report -ENOSPC
+		 */
+		rc = -ENOSPC;
+	}
+
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
