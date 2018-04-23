Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1E372265A17A
 for <linux-nvdimm@lists.01.org>; Mon, 23 Apr 2018 10:00:03 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: fix ABI breakage due to rename of
 fw_info_get_updated_version
Date: Mon, 23 Apr 2018 10:59:55 -0600
Message-Id: <20180423165955.10262-1-vishal.l.verma@intel.com>
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

Commit 47ad9f830f42 ("ndctl: add option to list firmware information for a DIMM")
renamed ndctl_cmd_fw_info_get_updated_version to ...get_next_version,
which causes an ABI breakage, since the former has appeared in a
released ndctl. Fix by renaming it back to the original.

Fixes: commit 47ad9f830f42 ("ndctl: add option to list firmware information for a DIMM")
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/firmware.c       | 2 +-
 ndctl/lib/intel.c          | 4 ++--
 ndctl/lib/libndctl.sym     | 2 +-
 ndctl/lib/private.h        | 2 +-
 ndctl/libndctl.h           | 2 +-
 ndctl/util/json-firmware.c | 2 +-
 6 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/ndctl/lib/firmware.c b/ndctl/lib/firmware.c
index 277b539..a5dd006 100644
--- a/ndctl/lib/firmware.c
+++ b/ndctl/lib/firmware.c
@@ -93,7 +93,7 @@ firmware_cmd_op(fw_info_get_max_send_len, unsigned int, 0)
 firmware_cmd_op(fw_info_get_query_interval, unsigned int, 0)
 firmware_cmd_op(fw_info_get_max_query_time, unsigned int, 0)
 firmware_cmd_op(fw_info_get_run_version, unsigned long long, 0)
-firmware_cmd_op(fw_info_get_next_version, unsigned long long, 0)
+firmware_cmd_op(fw_info_get_updated_version, unsigned long long, 0)
 firmware_cmd_op(fw_start_get_context, unsigned int, 0)
 firmware_cmd_op(fw_fquery_get_fw_rev, unsigned long long, 0)
 
diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index ba210e1..49a4360 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -434,7 +434,7 @@ intel_fw_info_get_field32(cmd, query_interval)
 intel_fw_info_get_field32(cmd, max_query_time);
 intel_fw_info_get_field64(cmd, run_version);
 
-static unsigned long long intel_cmd_fw_info_get_next_version(
+static unsigned long long intel_cmd_fw_info_get_updated_version(
 		struct ndctl_cmd *cmd)
 {
 	if (intel_fw_get_info_valid(cmd) < 0)
@@ -720,7 +720,7 @@ struct ndctl_dimm_ops * const intel_dimm_ops = &(struct ndctl_dimm_ops) {
 	.fw_info_get_query_interval = intel_cmd_fw_info_get_query_interval,
 	.fw_info_get_max_query_time = intel_cmd_fw_info_get_max_query_time,
 	.fw_info_get_run_version = intel_cmd_fw_info_get_run_version,
-	.fw_info_get_next_version = intel_cmd_fw_info_get_next_version,
+	.fw_info_get_updated_version = intel_cmd_fw_info_get_updated_version,
 	.new_fw_start_update = intel_dimm_cmd_new_fw_start,
 	.fw_start_get_context = intel_cmd_fw_start_get_context,
 	.new_fw_send = intel_dimm_cmd_new_fw_send,
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index df17c3e..65e735f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -339,6 +339,7 @@ global:
 	ndctl_cmd_fw_info_get_query_interval;
 	ndctl_cmd_fw_info_get_max_query_time;
 	ndctl_cmd_fw_info_get_run_version;
+	ndctl_cmd_fw_info_get_updated_version;
 	ndctl_cmd_fw_start_get_context;
 	ndctl_cmd_fw_fquery_get_fw_rev;
 	ndctl_cmd_fw_xlat_firmware_status;
@@ -346,7 +347,6 @@ global:
 
 LIBNDCTL_15 {
 global:
-	ndctl_cmd_fw_info_get_next_version;
 	ndctl_dimm_cmd_new_ack_shutdown_count;
 	ndctl_region_get_numa_node;
 	ndctl_dimm_fw_update_supported;
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 1cad06b..73bbeed 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -314,7 +314,7 @@ struct ndctl_dimm_ops {
 	unsigned int (*fw_info_get_query_interval)(struct ndctl_cmd *);
 	unsigned int (*fw_info_get_max_query_time)(struct ndctl_cmd *);
 	unsigned long long (*fw_info_get_run_version)(struct ndctl_cmd *);
-	unsigned long long (*fw_info_get_next_version)(struct ndctl_cmd *);
+	unsigned long long (*fw_info_get_updated_version)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_fw_start_update)(struct ndctl_dimm *);
 	unsigned int (*fw_start_get_context)(struct ndctl_cmd *);
 	struct ndctl_cmd *(*new_fw_send)(struct ndctl_cmd *,
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 10b423f..498ae19 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -640,7 +640,7 @@ unsigned int ndctl_cmd_fw_info_get_max_send_len(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_info_get_query_interval(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_info_get_max_query_time(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_info_get_run_version(struct ndctl_cmd *cmd);
-unsigned long long ndctl_cmd_fw_info_get_next_version(struct ndctl_cmd *cmd);
+unsigned long long ndctl_cmd_fw_info_get_updated_version(struct ndctl_cmd *cmd);
 unsigned int ndctl_cmd_fw_start_get_context(struct ndctl_cmd *cmd);
 unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
index e595e2f..118424f 100644
--- a/ndctl/util/json-firmware.c
+++ b/ndctl/util/json-firmware.c
@@ -46,7 +46,7 @@ struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
 	if (jobj)
 		json_object_object_add(jfirmware, "current_version", jobj);
 
-	next = ndctl_cmd_fw_info_get_next_version(cmd);
+	next = ndctl_cmd_fw_info_get_updated_version(cmd);
 	if (next == ULLONG_MAX) {
 		jobj = util_json_object_hex(-1, flags);
 		if (jobj)
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
