Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B0996211B81A5
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 15:07:11 -0800 (PST)
Subject: [PATCH v10 01/12] ndctl: add support for display security state
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 24 Jan 2019 16:07:10 -0700
Message-ID: <154837123008.37086.76497287122377987.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
References: <154837084784.37086.4597479371733088393.stgit@djiang5-desk3.ch.intel.com>
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

Adding libndctl API call for retrieving security state for a DIMM and also
adding support to ndctl list for displaying security state.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl/ndctl-list.txt |    8 ++++++++
 ndctl/lib/dimm.c                   |   33 +++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl.sym             |    1 +
 ndctl/libndctl.h                   |   11 +++++++++++
 util/json.c                        |   17 +++++++++++++++++
 5 files changed, 70 insertions(+)

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
index 11a7efe9..712223fc 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -598,3 +598,36 @@ NDCTL_EXPORT unsigned long ndctl_dimm_get_available_labels(
 
 	return strtoul(buf, NULL, 0);
 }
+
+NDCTL_EXPORT enum ndctl_security_state ndctl_dimm_get_security(
+		struct ndctl_dimm *dimm)
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
+		return NDCTL_SECURITY_INVALID;
+	}
+
+	rc = sysfs_read_attr(ctx, path, buf);
+	if (rc < 0)
+		return NDCTL_SECURITY_INVALID;
+
+	if (strcmp(buf, "disabled") == 0)
+		return NDCTL_SECURITY_DISABLED;
+	else if (strcmp(buf, "unlocked") == 0)
+		return NDCTL_SECURITY_UNLOCKED;
+	else if (strcmp(buf, "locked") == 0)
+		return NDCTL_SECURITY_LOCKED;
+	else if (strcmp(buf, "frozen") == 0)
+		return NDCTL_SECURITY_FROZEN;
+	else if (strcmp(buf, "overwrite") == 0)
+		return NDCTL_SECURITY_OVERWRITE;
+
+	return NDCTL_SECURITY_INVALID;
+}
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 275db92e..0888c824 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -390,4 +390,5 @@ LIBNDCTL_19 {
 global:
 	ndctl_cmd_xlat_firmware_status;
 	ndctl_cmd_submit_xlat;
+	ndctl_dimm_get_security;
 } LIBNDCTL_18;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index e55a5932..e228c64f 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -684,6 +684,17 @@ int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
 int ndctl_cmd_xlat_firmware_status(struct ndctl_cmd *cmd);
 int ndctl_cmd_submit_xlat(struct ndctl_cmd *cmd);
 
+enum ndctl_security_state {
+	NDCTL_SECURITY_INVALID = -1,
+	NDCTL_SECURITY_DISABLED = 0,
+	NDCTL_SECURITY_UNLOCKED,
+	NDCTL_SECURITY_LOCKED,
+	NDCTL_SECURITY_FROZEN,
+	NDCTL_SECURITY_OVERWRITE,
+};
+
+enum ndctl_security_state ndctl_dimm_get_security(struct ndctl_dimm *dimm);
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/util/json.c b/util/json.c
index 5c3424e2..9dc420ce 100644
--- a/util/json.c
+++ b/util/json.c
@@ -164,6 +164,7 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 	unsigned int handle = ndctl_dimm_get_handle(dimm);
 	unsigned short phys_id = ndctl_dimm_get_phys_id(dimm);
 	struct json_object *jobj;
+	enum ndctl_security_state sstate;
 
 	if (!jdimm)
 		return NULL;
@@ -243,6 +244,22 @@ struct json_object *util_dimm_to_json(struct ndctl_dimm *dimm,
 		json_object_object_add(jdimm, "flag_smart_event", jobj);
 	}
 
+	sstate = ndctl_dimm_get_security(dimm);
+	if (sstate == NDCTL_SECURITY_DISABLED)
+		jobj = json_object_new_string("disabled");
+	else if (sstate == NDCTL_SECURITY_UNLOCKED)
+		jobj = json_object_new_string("unlocked");
+	else if (sstate == NDCTL_SECURITY_LOCKED)
+		jobj = json_object_new_string("locked");
+	else if (sstate == NDCTL_SECURITY_FROZEN)
+		jobj = json_object_new_string("frozen");
+	else if (sstate == NDCTL_SECURITY_OVERWRITE)
+		jobj = json_object_new_string("overwrite");
+	else
+		jobj = NULL;
+	if (jobj)
+		json_object_object_add(jdimm, "security", jobj);
+
 	return jdimm;
  err:
 	json_object_put(jdimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
