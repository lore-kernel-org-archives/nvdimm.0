Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECEE32034D8FF
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 12:43:36 -0800 (PST)
Subject: [PATCH v2 2/4] ndctl: add "all" dimm-id option for update-firmware
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 22 Feb 2018 13:49:37 -0700
Message-ID: <151933257703.36856.16473005119268194390.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
References: <151933257135.36856.6462188364046414070.stgit@djiang5-desk3.ch.intel.com>
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

Modifying the code so that when "all" option is passed in, we will process
all the DIMMs on the platform.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/update.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index fc26acf..4fb572d 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -471,16 +471,22 @@ static int get_ndctl_dimm(struct update_context *uctx, void *ctx)
 {
 	struct ndctl_dimm *dimm;
 	struct ndctl_bus *bus;
+	int rc = -ENODEV;
 
 	ndctl_bus_foreach(ctx, bus)
 		ndctl_dimm_foreach(bus, dimm) {
 			if (!util_dimm_filter(dimm, uctx->dimm_id))
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
@@ -579,12 +585,6 @@ int cmd_update_firmware(int argc, const char **argv, void *ctx)
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
