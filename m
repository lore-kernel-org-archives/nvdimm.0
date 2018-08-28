Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 86BC121102DAE
 for <linux-nvdimm@lists.01.org>; Tue, 28 Aug 2018 15:51:51 -0700 (PDT)
Subject: [PATCH v3 1/6] ndctl: add support for display security state
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 28 Aug 2018 15:51:50 -0700
Message-ID: <153549671087.5723.14981430820112198685.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
References: <153549661384.5723.4757814248604794802.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com
Cc: dhowells@redhat.com, alison.schofield@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding libndctl API call for retrieving security state for a DIMM and also
adding support to ndctl list for displaying security state.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-list.txt |    8 ++++++++
 ndctl/lib/dimm.c                   |   16 ++++++++++++++++
 ndctl/lib/libndctl.sym             |    1 +
 ndctl/libndctl.h                   |    1 +
 util/json.c                        |    8 ++++++++
 5 files changed, 34 insertions(+)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index e24c8f40..a4a712a0 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -98,6 +98,14 @@ include::xable-region-options.txt[]
 -D::
 --dimms::
 	Include dimm info in the listing
+[verse]
+{
+  "dev":"nmem0",
+  "id":"cdab-0a-07e0-ffffffff",
+  "handle":0,
+  "phys_id":0,
+  "security_state:":"disabled"
+}
 
 -H::
 --health::
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index b3e032e0..8ed58559 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -579,3 +579,19 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 
 	return strtoul(buf, NULL, 0);
 }
+
+NDCTL_EXPORT int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm,
+		char *state)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char *path = dimm->dimm_buf;
+	int len = dimm->buf_len;
+
+	if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_dimm_get_devname(dimm));
+		return -ERANGE;
+	}
+
+	return sysfs_read_attr(ctx, path, state);
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index a6849ee1..062b41d3 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -377,4 +377,5 @@ global:
 	ndctl_dimm_is_flag_supported;
 	ndctl_region_get_max_available_extent;
 	ndctl_cmd_smart_inject_ctrl_temperature;
+	ndctl_dimm_get_security_state;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 83d6c6ca..f23bfdee 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -673,6 +673,7 @@ unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
+int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/json.c b/util/json.c
index 2d158592..d8514ab2 100644
--- a/util/json.c
+++ b/util/json.c
@@ -164,6 +164,7 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 	unsigned int handle = ndctl_dimm_get_handle(dimm);
 	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
 	struct json_object *jobj;
+	char security_state[32];
 
 	if (!jdimm)
 		return NULL;
@@ -243,6 +244,13 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 		json_object_object_add(jdimm, "flag_smart_event", jobj);
 	}
 
+	if (ndctl_dimm_get_security_state(dimm, security_state) == 0) {
+		jobj = json_object_new_string(security_state);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "security_state:", jobj);
+	}
+
 	return jdimm;
  err:
 	json_object_put(jdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
