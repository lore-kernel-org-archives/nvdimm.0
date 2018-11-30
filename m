Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14DF92119307C
 for <linux-nvdimm@lists.01.org>; Fri, 30 Nov 2018 13:33:31 -0800 (PST)
Subject: [PATCH v5 01/12] ndctl: add support for display security state
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 30 Nov 2018 14:33:30 -0700
Message-ID: <154361361077.6129.2692055853938395877.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
References: <154361315118.6129.3346352930852675435.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding libndctl API call for retrieving security state for a DIMM and also
adding support to ndctl list for displaying security state.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-list.txt |    8 ++++++++
 ndctl/lib/dimm.c                   |   37 ++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym             |    5 +++++
 ndctl/libndctl.h                   |   13 +++++++++++++
 util/json.c                        |   31 ++++++++++++++++++++++++++++++
 5 files changed, 94 insertions(+)

diff --git a/Documentation/ndctl/ndctl-list.txt b/Documentation/ndctl/ndctl-list.txt
index e24c8f40..bdd69add 100644
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
+  "security:":"disabled"
+}
 
 -H::
 --health::
diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 5e41734d..cd2895c9 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -583,3 +583,40 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 
 	return strtoul(buf, NULL, 0);
 }
+
+NDCTL_EXPORT int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
+		enum nd_security_state *state)
+{
+	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
+	char *path = dimm->dimm_buf;
+	int len = dimm->buf_len;
+	char buf[64];
+	int rc;
+
+	if (snprintf(path, len, "%s/security", dimm->dimm_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				ndctl_dimm_get_devname(dimm));
+		return -ERANGE;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0)
+		return rc;
+
+	if (strcmp(buf, "unsupported") == 0)
+		*state = ND_SECURITY_UNSUPPORTED;
+	else if (strcmp(buf, "disabled") == 0)
+		*state = ND_SECURITY_DISABLED;
+	else if (strcmp(buf, "unlocked") == 0)
+		*state = ND_SECURITY_UNLOCKED;
+	else if (strcmp(buf, "locked") == 0)
+		*state = ND_SECURITY_LOCKED;
+	else if (strcmp(buf, "frozen") == 0)
+		*state = ND_SECURITY_FROZEN;
+	else if (strcmp(buf, "overwrite") == 0)
+		*state = ND_SECURITY_OVERWRITE;
+	else
+		*state = ND_SECURITY_INVALID;
+
+	return 0;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 6c4c8b4d..1bd63fa1 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -385,3 +385,8 @@ global:
 	ndctl_namespace_get_next_badblock;
 	ndctl_dimm_get_dirty_shutdown;
 } LIBNDCTL_17;
+
+LIBNDCTL_19 {
+global:
+	ndctl_dimm_get_security;
+} LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 62cef9e8..a9f9167a 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -681,6 +681,19 @@ enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 
+enum nd_security_state {
+	ND_SECURITY_INVALID = -1,
+	ND_SECURITY_UNSUPPORTED = 0,
+	ND_SECURITY_DISABLED,
+	ND_SECURITY_UNLOCKED,
+	ND_SECURITY_LOCKED,
+	ND_SECURITY_FROZEN,
+	ND_SECURITY_OVERWRITE,
+};
+
+int ndctl_dimm_get_security(struct ndctl_dimm *dimm,
+		enum nd_security_state *sstate);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/util/json.c b/util/json.c
index 5c3424e2..e3b9e72e 100644
--- a/util/json.c
+++ b/util/json.c
@@ -164,6 +164,7 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 	unsigned int handle = ndctl_dimm_get_handle(dimm);
 	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
 	struct json_object *jobj;
+	enum nd_security_state sstate;
 
 	if (!jdimm)
 		return NULL;
@@ -243,6 +244,36 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 		json_object_object_add(jdimm, "flag_smart_event", jobj);
 	}
 
+	if (ndctl_dimm_get_security(dimm, &sstate) == 0) {
+		switch (sstate) {
+		case ND_SECURITY_UNSUPPORTED:
+			jobj = json_object_new_string("unsupported");
+			break;
+		case ND_SECURITY_DISABLED:
+			jobj = json_object_new_string("disabled");
+			break;
+		case ND_SECURITY_UNLOCKED:
+			jobj = json_object_new_string("unlocked");
+			break;
+		case ND_SECURITY_LOCKED:
+			jobj = json_object_new_string("locked");
+			break;
+		case ND_SECURITY_FROZEN:
+			jobj = json_object_new_string("frozen");
+			break;
+		case ND_SECURITY_OVERWRITE:
+			jobj = json_object_new_string("overwrite");
+			break;
+		case ND_SECURITY_INVALID:
+		default:
+			jobj = json_object_new_string("invalid");
+			break;
+		}
+		if (!jobj)
+			goto err;
+		json_object_object_add(jdimm, "security", jobj);
+	}
+
 	return jdimm;
  err:
 	json_object_put(jdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
