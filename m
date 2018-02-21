Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B790321CF1CFE
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:00:04 -0800 (PST)
Subject: [PATCH 2/2] ndctl: add "all" dimm-id option for update-firmware
From: Dave Jiang <dave.jiang@intel.com>
Date: Wed, 21 Feb 2018 15:06:04 -0700
Message-ID: <151925076435.65338.5271742129529173494.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
References: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding all option to allow ndctl to update all DIMMs at once.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/update.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index fc26acf..1b771ff 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -77,6 +77,7 @@ struct update_context {
 	struct ndctl_dimm *dimm;
 	struct fw_info dimm_fw;
 	struct ndctl_cmd *start;
+	bool all;
 };
 
 /*
@@ -471,16 +472,23 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
 {
 	struct ndctl_dimm *dimm;
 	struct ndctl_bus *bus;
+	int rc = -ENODEV;
 
 	ndctl_bus_foreach(ctx, bus)
 		ndctl_dimm_foreach(bus, dimm) {
-			if (!util_dimm_filter(dimm, uctx->dimm_id))
+			if (!uctx->all &&
+				!util_dimm_filter(dimm, uctx->dimm_id))
 				continue;
 			uctx->dimm = dimm;
-			return 0;
+			rc = update_firmware(uctx);
+			if (rc < 0) {
+				error("Update firmware for dimm %s failed\n",
+						ndctl_dimm_get_devname(dimm));
+				continue;
+			}
 		}
 
-	return -ENODEV;
+	return rc;
 }
 
 static int verify_fw_file(struct update_context *uctx)
@@ -573,18 +581,17 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
 		return rc;
 	}
 
+	if (strcmp(uctx.dimm_id, "all") == 0)
+		uctx.all = true;
+	else
+		uctx.all = false;
+
 	rc = get_ndctl_dimm(&uctx, ctx);
 	if (rc < 0) {
 		error("DIMM %s not found", uctx.dimm_id);
 		return rc;
 	}
 
-	rc = update_firmware(&uctx);
-	if (rc < 0) {
-		error("Update firmware failed");
-		return rc;
-	}
-
 	if (uctx.start)
 		ndctl_cmd_unref(uctx.start);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
