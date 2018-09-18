Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5C4B2113DA19
 for <linux-nvdimm@lists.01.org>; Mon, 17 Sep 2018 23:01:08 -0700 (PDT)
Subject: [ndctl PATCH 2/3] ndctl: Revert "ndctl,
 intel: Fallback to smart cached shutdown_count"
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Sep 2018 22:49:21 -0700
Message-ID: <153724976126.55312.1677206589965006541.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153724975102.55312.9664009456306267501.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153724975102.55312.9664009456306267501.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static device attribute data, if it needs to be cached and exported to
unprivileged userspace, should live in sysfs.

Cc: Keith Busch <keith.busch@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/intel.c    |   41 -----------------------------------------
 ndctl/lib/libndctl.c |    6 +-----
 ndctl/lib/private.h  |    3 ---
 3 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 15c5d1a60e34..0abea1e1f5ff 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -56,46 +56,6 @@ static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
 	return cmd;
 }
 
-/*
- * If provided, read the cached shutdown count in case the user does not have
- * access rights to run the smart command, and pretend the command was
- * successful with only the shutdown_count valid.
- */
-static int intel_smart_handle_error(struct ndctl_cmd *cmd)
-{
-	struct ndctl_dimm *dimm = cmd->dimm;
-	struct ndctl_bus *bus = cmd_to_bus(cmd);
-	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
-	char *path = NULL, shutdown_count[16] = {};
-	int fd, rc = cmd->status;
-
-	if (!dimm)
-		goto out;
-
-	if (asprintf(&path, DEF_TMPFS_DIR "/%s/usc",
-		     ndctl_dimm_get_devname(dimm)) < 0)
-		goto out;
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		goto free_path;
-
-	if (read(fd, shutdown_count, sizeof(shutdown_count)) < 0)
-		goto close;
-
-	cmd->intel->smart.flags = ND_INTEL_SMART_SHUTDOWN_COUNT_VALID;
-	cmd->intel->smart.shutdown_count = strtoull(shutdown_count, NULL, 0);
-	rc = cmd->status = 0;
- close:
-	close (fd);
- free_path:
-	free(path);
- out:
-	if (rc)
-		err(ctx, "failed: %s\n", strerror(errno));
-	return rc;
-}
-
 static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
 	struct ndctl_cmd *cmd;
@@ -107,7 +67,6 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	if (!cmd)
 		return NULL;
 	cmd->firmware_status = &cmd->intel->smart.status;
-	cmd->handle_error = intel_smart_handle_error;
 
 	return cmd;
 }
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 481b110d2a18..5bc97f25607c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2753,9 +2753,7 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 
 	fd = open(path, O_RDWR);
 	if (fd < 0) {
-		if (!cmd->handle_error)
-			err(ctx, "failed to open %s: %s\n", path,
-				strerror(errno));
+		err(ctx, "failed to open %s: %s\n", path, strerror(errno));
 		rc = -errno;
 		goto out;
 	}
@@ -2771,8 +2769,6 @@ NDCTL_EXPORT int ndctl_cmd_submit(struct ndctl_cmd *cmd)
 	close(fd);
  out:
 	cmd->status = rc;
-	if (rc && cmd->handle_error)
-		rc = cmd->handle_error(cmd);
 	return rc;
 }
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index b6e438aff8c7..5ddc682b7514 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -227,8 +227,6 @@ struct ndctl_namespace {
  * @firmware_status: NFIT command output status code
  * @iter: iterator for multi-xfer commands
  * @source: source cmd of an inherited iter.total_buf
- * @handle_error: function pointer to handle a cmd error and override it to
- * 		  return alternative data (from a cache for example).
  *
  * For dynamically sized commands like 'get_config', 'set_config', or
  * 'vendor', @size encompasses the entire buffer for the command input
@@ -257,7 +255,6 @@ struct ndctl_cmd {
 		int dir;
 	} iter;
 	struct ndctl_cmd *source;
-	int (*handle_error)(struct ndctl_cmd *cmd);
 	union {
 		struct nd_cmd_ars_cap ars_cap[0];
 		struct nd_cmd_ars_start ars_start[0];

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
