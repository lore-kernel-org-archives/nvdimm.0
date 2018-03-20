Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EBC3224BBC39
 for <linux-nvdimm@lists.01.org>; Tue, 20 Mar 2018 14:15:56 -0700 (PDT)
Subject: [PATCH] libndctl: adjusting debug output for return values of a
 command sent
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Mar 2018 14:22:25 -0700
Message-ID: <152158094585.50363.3257731526504862041.stgit@djiang5-desk3.ch.intel.com>
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

Moving the success indicator next to status output to make it easier to
read since that is correlated to status and not firmware status output.
Also changing the firmware status to hex in order to reflect the spec.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/libndctl.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index a165e697..413a7db3 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2441,11 +2441,11 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 
 	if (iter->total_xfer == 0) {
 		rc = ioctl(fd, ioctl_cmd, cmd->cmd_buf);
-		dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s status: %d fw: %d (%s)\n",
+		dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s status: %d (%s) fw: %#x\n",
 				bus->id, dimm ? ndctl_dimm_get_handle(dimm) : 0,
 				name, sub_name ? ":" : "", sub_name ? sub_name : "",
-				rc, *(cmd->firmware_status), rc < 0 ?
-				strerror(errno) : "success");
+				rc, rc < 0 ?  strerror(errno) : "success",
+				*(cmd->firmware_status));
 		if (rc < 0)
 			return -errno;
 		else
@@ -2474,12 +2474,12 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 		}
 	}
 
-	dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s total: %d max_xfer: %d status: %d fw: %d (%s)\n",
+	dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s total: %d max_xfer: %d status: %d (%s) fw: %#x\n",
 			bus->id, dimm ? ndctl_dimm_get_handle(dimm) : 0,
 			name, sub_name ? ":" : "", sub_name ? sub_name : "",
 			iter->total_xfer, iter->max_xfer, rc,
-			*(cmd->firmware_status),
-			rc < 0 ? strerror(errno) : "success");
+			rc < 0 ? strerror(errno) : "success",
+			*(cmd->firmware_status));
 
 	return rc;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
