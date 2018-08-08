Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7AC6A210E129F
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 08:59:14 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [ndctl PATCHv2 2/2] ndctl,
 intel: Fallback to smart cached shutdown_count
Date: Wed,  8 Aug 2018 09:59:34 -0600
Message-Id: <20180808155934.15976-2-keith.busch@intel.com>
In-Reply-To: <20180808155934.15976-1-keith.busch@intel.com>
References: <20180808155934.15976-1-keith.busch@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A user space rule saves the unsafe shutdown count to a fixed location
for Intel dimms so that non-root users can read it. If the smart command
submission fails, this patch uses that saved value in a newly added
ndctl_cmd "handle_error" callback.  If the cached value is available,
the error handler will override the command status to success, and set
the valid flags for the shutdown count.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
v1 -> v2:

  Use nmem<X> instead of dimm-id

 ndctl/lib/intel.c    | 33 +++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.c |  2 ++
 ndctl/lib/private.h  |  1 +
 3 files changed, 36 insertions(+)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 0abea1e..00c65a5 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -56,6 +56,38 @@ static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
 	return cmd;
 }
 
+/*
+ * If provided, read the cached shutdown count in case the user does not have
+ * access rights to run the smart command, and pretend the command was
+ * successful with only the shutdown_count valid.
+ */
+static int intel_smart_handle_error(struct ndctl_cmd *cmd)
+{
+	struct ndctl_dimm *dimm = cmd->dimm;
+	char *path = NULL, shutdown_count[16] = {};
+	int fd, rc = cmd->status;
+
+	if (asprintf(&path, DEF_TMPFS_DIR "/%s/usc",
+		     ndctl_dimm_get_devname(dimm)) < 0)
+		return rc;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		goto free_path;
+
+	if (read(fd, shutdown_count, sizeof(shutdown_count)) < 0)
+		goto close;
+
+	cmd->intel->smart.flags = ND_INTEL_SMART_SHUTDOWN_COUNT_VALID;
+	cmd->intel->smart.shutdown_count = strtoull(shutdown_count, NULL, 0);
+	rc = cmd->status = 0;
+ close:
+	close (fd);
+ free_path:
+	free(path);
+	return rc;
+}
+
 static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
 	struct ndctl_cmd *cmd;
@@ -67,6 +99,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	if (!cmd)
 		return NULL;
 	cmd->firmware_status = &cmd->intel->smart.status;
+	cmd->handle_error = intel_smart_handle_error;
 
 	return cmd;
 }
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index e911ea2..ab47b27 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2766,6 +2766,8 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 	close(fd);
  out:
 	cmd->status = rc;
+	if (rc && cmd->handle_error)
+		rc = cmd->handle_error(cmd);
 	return rc;
 }
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 5ddc682..c6eb39e 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -255,6 +255,7 @@ struct ndctl_cmd {
 		int dir;
 	} iter;
 	struct ndctl_cmd *source;
+	int (*handle_error)(struct ndctl_cmd *cmd);
 	union {
 		struct nd_cmd_ars_cap ars_cap[0];
 		struct nd_cmd_ars_start ars_start[0];
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
