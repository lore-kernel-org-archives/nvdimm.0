Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6822821E70D4C
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 19:15:08 -0700 (PDT)
Subject: [ndctl PATCH v2 05/10] ndctl: refactor read_labels() helper into a
 library call
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 19:11:25 -0700
Message-ID: <150405908547.22171.11115984552688133682.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
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

As a pre-requisite to making an "init labels" library call, refactor
label reading into a generic helper call.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/dimm.c           |   40 ++----------------------------
 ndctl/lib/dimm.c       |   64 ++++++++++++++++++++++++++++++------------------
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 4 files changed, 45 insertions(+), 61 deletions(-)

diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 4a39189297a6..ca7b833db182 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -358,40 +358,6 @@ static int rw_bin(FILE *f, struct ndctl_cmd *cmd, ssize_t size, int rw)
 	return 0;
 }
 
-static struct ndctl_cmd *read_labels(struct ndctl_dimm *dimm)
-{
-	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
-	struct ndctl_cmd *cmd_size, *cmd_read;
-	int rc;
-
-	rc = ndctl_bus_wait_probe(bus);
-	if (rc < 0)
-		return NULL;
-
-	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
-	if (!cmd_size)
-		return NULL;
-	rc = ndctl_cmd_submit(cmd_size);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
-		goto out_size;
-
-	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
-	if (!cmd_read)
-		goto out_size;
-	rc = ndctl_cmd_submit(cmd_read);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
-		goto out_read;
-
-	ndctl_cmd_unref(cmd_size);
-	return cmd_read;
-
- out_read:
-	ndctl_cmd_unref(cmd_read);
- out_size:
-	ndctl_cmd_unref(cmd_size);
-	return NULL;
-}
-
 static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	struct ndctl_cmd *cmd_read, *cmd_write;
@@ -403,7 +369,7 @@ static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
 		return -EBUSY;
 	}
 
-	cmd_read = read_labels(dimm);
+	cmd_read = ndctl_dimm_read_labels(dimm);
 	if (!cmd_read)
 		return -ENXIO;
 
@@ -441,7 +407,7 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 	ssize_t size;
 	int rc = 0;
 
-	cmd_read = read_labels(dimm);
+	cmd_read = ndctl_dimm_read_labels(dimm);
 	if (!cmd_read)
 		return -ENXIO;
 
@@ -794,7 +760,7 @@ static int __action_init(struct ndctl_dimm *dimm, int version, int chk_only)
 	int rc = 0, i;
 	ssize_t size;
 
-	cmd_read = read_labels(dimm);
+	cmd_read = ndctl_dimm_read_labels(dimm);
 	if (!cmd_read)
 		return -ENXIO;
 
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index e4ea81835989..d6d99df7106b 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -15,38 +15,56 @@
 #include <stdlib.h>
 #include "private.h"
 
+NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm)
+{
+        struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+        struct ndctl_cmd *cmd_size, *cmd_read;
+        int rc;
+
+        rc = ndctl_bus_wait_probe(bus);
+        if (rc < 0)
+                return NULL;
+
+        cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
+        if (!cmd_size)
+                return NULL;
+        rc = ndctl_cmd_submit(cmd_size);
+        if (rc || ndctl_cmd_get_firmware_status(cmd_size))
+                goto out_size;
+
+        cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
+        if (!cmd_read)
+                goto out_size;
+        rc = ndctl_cmd_submit(cmd_read);
+        if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+                goto out_read;
+
+        ndctl_cmd_unref(cmd_size);
+        return cmd_read;
+
+ out_read:
+        ndctl_cmd_unref(cmd_read);
+ out_size:
+        ndctl_cmd_unref(cmd_size);
+        return NULL;
+}
+
 NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
 {
-	struct ndctl_cmd *cmd_size, *cmd_read, *cmd_write;
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
+	struct ndctl_cmd *cmd_read, *cmd_write;
 	int rc;
 
-	rc = ndctl_bus_wait_probe(bus);
-	if (rc < 0)
-		return rc;
+	cmd_read = ndctl_dimm_read_labels(dimm);
+	if (!cmd_read)
+		return -ENXIO;
 
 	if (ndctl_dimm_is_active(dimm)) {
 		dbg(ctx, "%s: regions active, abort label write\n",
 			ndctl_dimm_get_devname(dimm));
-		return -EBUSY;
-	}
-
-	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
-	if (!cmd_size)
-		return -ENOTTY;
-	rc = ndctl_cmd_submit(cmd_size);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_size))
-		goto out_size;
-
-	cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
-	if (!cmd_read) {
-		rc = -ENOTTY;
-		goto out_size;
-	}
-	rc = ndctl_cmd_submit(cmd_read);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+		rc = -EBUSY;
 		goto out_read;
+	}
 
 	cmd_write = ndctl_dimm_cmd_new_cfg_write(cmd_read);
 	if (!cmd_write) {
@@ -77,8 +95,6 @@ NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
 	ndctl_cmd_unref(cmd_write);
  out_read:
 	ndctl_cmd_unref(cmd_read);
- out_size:
-	ndctl_cmd_unref(cmd_size);
 
 	return rc;
 }
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b8ac65f2917f..95c6e400124d 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -113,6 +113,7 @@ global:
 	ndctl_cmd_smart_threshold_get_temperature;
 	ndctl_cmd_smart_threshold_get_spares;
 	ndctl_dimm_zero_labels;
+	ndctl_dimm_read_labels;
 	ndctl_dimm_get_available_labels;
 	ndctl_region_get_first;
 	ndctl_region_get_next;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 855d883c3380..9be380b8a735 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -358,6 +358,7 @@ struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_size(struct ndctl_dimm *dimm);
 struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg_size);
 struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cfg_read);
 int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm);
+struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm);
 unsigned long ndctl_dimm_get_available_labels(struct ndctl_dimm *dimm);
 unsigned int ndctl_cmd_cfg_size_get_size(struct ndctl_cmd *cfg_size);
 ssize_t ndctl_cmd_cfg_read_get_data(struct ndctl_cmd *cfg_read, void *buf,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
