Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B09821A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:21 -0800 (PST)
Subject: [ndctl PATCH 12/17] ndctl,
 debug: improve do_cmd output for ND_CMD_CALL
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:33 -0800
Message-ID: <151217073370.28402.14730045606301358395.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Call back to a per-dimm-family operation that can provide a text
description for the function number passed in ND_CMD_CALL invocations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/intel.c    |   17 +++++++++++++++++
 ndctl/lib/libndctl.c |   37 +++++++++++++++++++++++++------------
 ndctl/lib/private.h  |    2 ++
 3 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index af13c60d4f52..3e4260f9dbd1 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -283,7 +283,24 @@ intel_smart_set_threshold_field(spares)
 intel_smart_set_threshold_field(media_temperature)
 intel_smart_set_threshold_field(ctrl_temperature)
 
+static const char *intel_cmd_desc(int fn)
+{
+	static const char *descs[] = {
+		[ND_INTEL_SMART] = "smart",
+		[ND_INTEL_SMART_THRESHOLD] = "smart_thresh",
+		[ND_INTEL_SMART_SET_THRESHOLD] = "smart_set_thresh",
+	};
+	const char *desc = descs[fn];
+
+	if (fn >= (int) ARRAY_SIZE(descs))
+		return "unknown";
+	if (!desc)
+		return "unknown";
+	return desc;
+}
+
 struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
+	.cmd_desc = intel_cmd_desc,
 	.new_smart = intel_dimm_cmd_new_smart,
 	.smart_get_flags = intel_cmd_smart_get_flags,
 	.smart_get_health = intel_cmd_smart_get_health,
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index d6d8a7f0c0b3..8471dd8c4f89 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2372,26 +2372,39 @@ static int to_ioctl_cmd(int cmd, int dimm)
 	}
 }
 
+static const char *ndctl_dimm_get_cmd_subname(struct ndctl_cmd *cmd)
+{
+	struct ndctl_dimm *dimm = cmd->dimm;
+	struct ndctl_dimm_ops *ops = dimm ? dimm->ops : NULL;
+
+	if (!dimm || cmd->type != ND_CMD_CALL || !ops || !ops->cmd_desc)
+		return NULL;
+	return ops->cmd_desc(cmd->pkg->nd_command);
+}
+
 static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 {
 	int rc;
 	u32 offset;
-	const char *name;
+	const char *name, *sub_name = NULL;
+	struct ndctl_dimm *dimm = cmd->dimm;
 	struct ndctl_bus *bus = cmd_to_bus(cmd);
 	struct ndctl_cmd_iter *iter = &cmd->iter;
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
 
-	if (cmd->dimm)
-		name = ndctl_dimm_get_cmd_name(cmd->dimm, cmd->type);
-	else
+	if (dimm) {
+		name = ndctl_dimm_get_cmd_name(dimm, cmd->type);
+		sub_name = ndctl_dimm_get_cmd_subname(cmd);
+	} else
 		name = ndctl_bus_get_cmd_name(cmd->bus, cmd->type);
 
+
 	if (iter->total_xfer == 0) {
 		rc = ioctl(fd, ioctl_cmd, cmd->cmd_buf);
-		dbg(ctx, "bus: %d dimm: %#x cmd: %s status: %d fw: %d (%s)\n",
-				bus->id, cmd->dimm
-				? ndctl_dimm_get_handle(cmd->dimm) : 0,
-				name, rc, *(cmd->firmware_status), rc < 0 ?
+		dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s status: %d fw: %d (%s)\n",
+				bus->id, dimm ? ndctl_dimm_get_handle(dimm) : 0,
+				name, sub_name ? ":" : "", sub_name ? sub_name : "",
+				rc, *(cmd->firmware_status), rc < 0 ?
 				strerror(errno) : "success");
 		if (rc < 0)
 			return -errno;
@@ -2421,10 +2434,10 @@ static int do_cmd(int fd, int ioctl_cmd, struct ndctl_cmd *cmd)
 		}
 	}
 
-	dbg(ctx, "bus: %d dimm: %#x cmd: %s total: %d max_xfer: %d status: %d fw: %d (%s)\n",
-			bus->id,
-			cmd->dimm ? ndctl_dimm_get_handle(cmd->dimm) : 0,
-			name, iter->total_xfer, iter->max_xfer, rc,
+	dbg(ctx, "bus: %d dimm: %#x cmd: %s%s%s total: %d max_xfer: %d status: %d fw: %d (%s)\n",
+			bus->id, dimm ? ndctl_dimm_get_handle(dimm) : 0,
+			name, sub_name ? ":" : "", sub_name ? sub_name : "",
+			iter->total_xfer, iter->max_xfer, rc,
 			*(cmd->firmware_status),
 			rc < 0 ? strerror(errno) : "success");
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 490de96f6ce6..67260970bfb2 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -260,6 +260,7 @@ struct ndctl_cmd {
 		struct nd_cmd_ars_start ars_start[0];
 		struct nd_cmd_ars_status ars_status[0];
 		struct nd_cmd_clear_error clear_err[0];
+		struct nd_cmd_pkg pkg[0];
 		struct ndn_pkg_hpe1 hpe1[0];
 		struct ndn_pkg_msft msft[0];
 		struct nd_pkg_intel intel[0];
@@ -278,6 +279,7 @@ struct ndctl_bb {
 };
 
 struct ndctl_dimm_ops {
+	const char *(*cmd_desc)(int);
 	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_health)(struct ndctl_cmd *);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
