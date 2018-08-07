Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C31B210DF5C7
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 15:24:12 -0700 (PDT)
From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 2/2] ndctl, intel: Pre-initialize smart shutdown_count
Date: Tue,  7 Aug 2018 16:24:41 -0600
Message-Id: <20180807222441.14246-2-keith.busch@intel.com>
In-Reply-To: <20180807222441.14246-1-keith.busch@intel.com>
References: <20180807222441.14246-1-keith.busch@intel.com>
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
for Intel dimms so that non-root users can read it. This patch uses that
saved value if it is available in case the command can't be executed due
to user permissions, allowing an application to detect if an unsafe
shutdown occured during a write.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 ndctl/lib/intel.c       | 42 +++++++++++++++++++++++++++++++++++++-----
 ndctl/util/json-smart.c |  4 ----
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 0abea1e..6df5aff 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -56,6 +56,35 @@ static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
 	return cmd;
 }
 
+/*
+ * If provided, prime the shutdown count with the saved value in case the user
+ * does not have access rights to run the smart command.
+ */
+static void intel_prime_shutdown_count(struct ndctl_dimm *dimm,
+				       struct ndctl_cmd *cmd)
+{
+	char *path = NULL, shutdown_count[16] = {};
+	int fd;
+
+	if (asprintf(&path, DEF_TMPFS_DIR "/%s/usc",
+		     ndctl_dimm_get_unique_id(dimm)) < 0)
+		return;
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		goto free_path;
+
+	if (read(fd, shutdown_count, sizeof(shutdown_count)) < 0)
+		goto close;
+
+	cmd->intel->smart.flags |= ND_INTEL_SMART_SHUTDOWN_COUNT_VALID;
+	cmd->intel->smart.shutdown_count = strtoull(shutdown_count, NULL, 0);
+ close:
+	close (fd);
+ free_path:
+	free(path);
+}
+
 static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 {
 	struct ndctl_cmd *cmd;
@@ -67,7 +96,7 @@ static struct ndctl_cmd *intel_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	if (!cmd)
 		return NULL;
 	cmd->firmware_status = &cmd->intel->smart.status;
-
+	intel_prime_shutdown_count(dimm, cmd);
 	return cmd;
 }
 
@@ -95,9 +124,6 @@ static unsigned int intel_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 	unsigned int flags = 0;
 	unsigned int intel_flags;
 
-	if (intel_smart_valid(cmd) < 0)
-		return 0;
-
 	/* translate intel specific flags to libndctl api smart flags */
 	intel_flags = cmd->intel->smart.flags;
 	if (intel_flags & ND_INTEL_SMART_HEALTH_VALID)
@@ -142,13 +168,19 @@ static unsigned int intel_cmd_smart_get_health(struct ndctl_cmd *cmd)
 	return health;
 }
 
+static unsigned int intel_cmd_smart_get_shutdown_count(struct ndctl_cmd *cmd)
+{
+	if (cmd->intel->smart.flags & ND_INTEL_SMART_SHUTDOWN_COUNT_VALID)
+		return cmd->intel->smart.shutdown_count;
+	return UINT_MAX;
+}
+
 intel_smart_get_field(cmd, media_temperature)
 intel_smart_get_field(cmd, ctrl_temperature)
 intel_smart_get_field(cmd, spares)
 intel_smart_get_field(cmd, alarm_flags)
 intel_smart_get_field(cmd, life_used)
 intel_smart_get_field(cmd, shutdown_state)
-intel_smart_get_field(cmd, shutdown_count)
 intel_smart_get_field(cmd, vendor_size)
 
 static unsigned char *intel_cmd_smart_get_vendor_data(struct ndctl_cmd *cmd)
diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
index 6a1f294..5f43982 100644
--- a/ndctl/util/json-smart.c
+++ b/ndctl/util/json-smart.c
@@ -93,7 +93,6 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
 		jobj = json_object_new_string("unknown");
 		if (jobj)
 			json_object_object_add(jhealth, "health_state", jobj);
-		goto out;
 	}
 
 	flags = ndctl_cmd_smart_get_flags(cmd);
@@ -189,8 +188,5 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm *dimm)
  err:
 	json_object_put(jhealth);
 	jhealth = NULL;
- out:
-	if (cmd)
-		ndctl_cmd_unref(cmd);
 	return jhealth;
 }
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
