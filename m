Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1252210C0CE6
 for <linux-nvdimm@lists.01.org>; Fri, 27 Jul 2018 15:02:04 -0700 (PDT)
Subject: [PATCH v2 1/6] ndctl: add support for display security state
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 27 Jul 2018 15:02:04 -0700
Message-ID: <153272892404.12034.8204619027211673490.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <153272888859.12034.12514972515977309760.stgit@djiang5-desk3.ch.intel.com>
References: <153272888859.12034.12514972515977309760.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
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
index 13ebdcdd..57eac1fe 100644
--- a/Documentation/ndctl/ndctl-list.txt
+++ b/Documentation/ndctl/ndctl-list.txt
@@ -97,6 +97,14 @@ include::xable-region-options.txt[]
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
index 8932ef66..8040d7de 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -371,4 +371,5 @@ global:
 LIBNDCTL_17 {
 global:
 	ndctl_dimm_smart_inject_supported;
+	ndctl_dimm_get_security_state;
 } LIBNDCTL_16;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 8a96c846..d48513ce 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -659,6 +659,7 @@ unsigned long long ndctl_cmd_fw_fquery_get_fw_rev(struct ndctl_cmd *cmd);
 enum ND_FW_STATUS ndctl_cmd_fw_xlat_firmware_status(struct ndctl_cmd *cmd);
 struct ndctl_cmd *ndctl_dimm_cmd_new_ack_shutdown_count(struct ndctl_dimm *dimm);
 int ndctl_dimm_fw_update_supported(struct ndctl_dimm *dimm);
+int ndctl_dimm_get_security_state(struct ndctl_dimm *dimm, char *state);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/util/json.c b/util/json.c
index 13324588..90f05528 100644
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
