Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1BAFD21BADAB9
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/5] ndctl,
 inject: fix a resource leak in ndctl_namespace_get_clear_unit
Date: Fri, 10 Aug 2018 16:56:20 -0600
Message-Id: <20180810225624.32383-2-vishal.l.verma@intel.com>
In-Reply-To: <20180810225624.32383-1-vishal.l.verma@intel.com>
References: <20180810225624.32383-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Static analysis reports that we leak ndctl_cmd in the above function.
Fix by adding a proper cleanup path.

Fixes: 7271760ce96c ("libndctl, inject: inject fewer bytes per block by default")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/inject.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index f9da02d..268c5cd 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -102,18 +102,20 @@ static int ndctl_namespace_get_clear_unit(struct ndctl_namespace *ndns)
 		&ns_size);
 	cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		dbg(ctx, "Error submitting ars_cap: %d\n", rc);
-		return rc;
+		goto out;
 	}
 	clear_unit = ndctl_cmd_ars_cap_get_clear_unit(cmd);
 	if (clear_unit == 0) {
 		dbg(ctx, "Got an invalid clear_err_unit from ars_cap\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto out;
 	}
-
+	rc = clear_unit;
+out:
 	ndctl_cmd_unref(cmd);
-	return clear_unit;
+	return rc;
 }
 
 static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
