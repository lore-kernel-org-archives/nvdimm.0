Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90733A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534918; x=1702070918;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lRuQG05UP4XfJ3wVJcSrMxD4UPUTHzbZPDP3e8Hdh+8=;
  b=DeYCExv1zX6LYoFPVS84tFp0jCgye81lD3gkTH7mvXFlzClAcfpconYD
   vLV0cI9eLata4hChtPJZzrW9D1YCvx+32qzDELNFuchnTYQLTaAiDjG1Q
   lfjpyTYBPeNODxyWncADXIoCGGOuv3KLuljyafWCNzYbkCf7Kau6jPGtc
   pjdxVYJa8izQjT5g2TWz1gZgV8yc+9Cr9ZHKXj3xBdlSOdhQEHeFGt89c
   rXfrsQTccoKOLb407ZB57r4KoOxSPErmUJWaOM6CCwdzxSkc6XnhWt2IO
   gqyp9ASApPSj/OAzLDYgqvHrMQ0BWROK86z92EXdvEhXDdN2UOKQ2G6cu
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="319170303"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="319170303"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="753756104"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="753756104"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:28:33 -0800
Subject: [ndctl PATCH v2 06/18] cxl/list: Add a 'firmware_node' alias
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:28:33 -0800
Message-ID: <167053491307.582963.8109215191948535895.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for the kernel switching from ACPI0016 devices as the dport
identifier to the corresponding host-bridge as the identifier, add support
for listing the dport firmware_node as an alias, and determining when the
dev_path is the phys_path for a dport or a target.

The code paths that depend on phys_path like cxl_target_maps_memdev() and
cxl_dport_maps_memdev() already have appropriate fallbacks to dev_path.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/json.c         |   20 +++++++++++++++++---
 cxl/lib/libcxl.c   |   31 +++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |    6 ++++++
 cxl/lib/private.h  |    2 ++
 cxl/libcxl.h       |    2 ++
 5 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index 63c17519aba1..5cff532acb13 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -384,7 +384,7 @@ void util_cxl_dports_append_json(struct json_object *jport,
 
 	cxl_dport_foreach(port, dport) {
 		struct json_object *jdport;
-		const char *phys_node;
+		const char *phys_node, *fw_node;
 
 		if (!util_cxl_dport_filter_by_memdev(dport, ident, serial))
 			continue;
@@ -404,6 +404,13 @@ void util_cxl_dports_append_json(struct json_object *jport,
 				json_object_object_add(jdport, "alias", jobj);
 		}
 
+		fw_node = cxl_dport_get_firmware_node(dport);
+		if (fw_node) {
+			jobj = json_object_new_string(fw_node);
+			if (jobj)
+				json_object_object_add(jdport, "alias", jobj);
+		}
+
 		val = cxl_dport_get_id(dport);
 		jobj = util_json_object_hex(val, flags);
 		if (jobj)
@@ -711,9 +718,9 @@ void util_cxl_targets_append_json(struct json_object *jdecoder,
 		return;
 
 	cxl_target_foreach(decoder, target) {
-		struct json_object *jtarget;
-		const char *phys_node;
 		const char *devname;
+		struct json_object *jtarget;
+		const char *phys_node, *fw_node;
 
 		if (!util_cxl_target_filter_by_memdev(target, ident, serial))
 			continue;
@@ -734,6 +741,13 @@ void util_cxl_targets_append_json(struct json_object *jdecoder,
 				json_object_object_add(jtarget, "alias", jobj);
 		}
 
+		fw_node = cxl_target_get_firmware_node(target);
+		if (fw_node) {
+			jobj = json_object_new_string(fw_node);
+			if (jobj)
+				json_object_object_add(jtarget, "alias", jobj);
+		}
+
 		val = cxl_target_get_position(target);
 		jobj = json_object_new_int(val);
 		if (jobj)
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e8c5d4444dd0..a69e31bc8a6e 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -77,6 +77,7 @@ static void free_target(struct cxl_target *target, struct list_head *head)
 		list_del_from(head, &target->list);
 	free(target->dev_path);
 	free(target->phys_path);
+	free(target->fw_path);
 	free(target);
 }
 
@@ -134,6 +135,7 @@ static void free_dport(struct cxl_dport *dport, struct list_head *head)
 	free(dport->dev_buf);
 	free(dport->dev_path);
 	free(dport->phys_path);
+	free(dport->fw_path);
 	free(dport);
 }
 
@@ -1856,6 +1858,15 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 		dbg(ctx, "%s: target%ld %s phys_path: %s\n", devname, i,
 		    target->dev_path,
 		    target->phys_path ? target->phys_path : "none");
+
+		sprintf(port->dev_buf, "%s/dport%d/firmware_node", port->dev_path, did);
+		target->fw_path = realpath(port->dev_buf, NULL);
+		dbg(ctx, "%s: target%ld %s fw_path: %s\n", devname, i,
+		    target->dev_path,
+		    target->fw_path ? target->fw_path : "none");
+
+		if (!target->phys_path && target->fw_path)
+			target->phys_path = strdup(target->dev_path);
 		list_add(&decoder->targets, &target->list);
 	}
 
@@ -2288,6 +2299,13 @@ CXL_EXPORT const char *cxl_target_get_physical_node(struct cxl_target *target)
 	return devpath_to_devname(target->phys_path);
 }
 
+CXL_EXPORT const char *cxl_target_get_firmware_node(struct cxl_target *target)
+{
+	if (!target->fw_path)
+		return NULL;
+	return devpath_to_devname(target->fw_path);
+}
+
 CXL_EXPORT struct cxl_target *
 cxl_decoder_get_target_by_memdev(struct cxl_decoder *decoder,
 				 struct cxl_memdev *memdev)
@@ -2569,6 +2587,12 @@ static void *add_cxl_dport(void *parent, int id, const char *cxldport_base)
 	sprintf(dport->dev_buf, "%s/physical_node", cxldport_base);
 	dport->phys_path = realpath(dport->dev_buf, NULL);
 
+	sprintf(dport->dev_buf, "%s/firmware_node", cxldport_base);
+	dport->fw_path = realpath(dport->dev_buf, NULL);
+
+	if (!dport->phys_path && dport->fw_path)
+		dport->phys_path = strdup(dport->dev_path);
+
 	cxl_dport_foreach(port, dport_dup)
 		if (dport_dup->id == dport->id) {
 			free_dport(dport, NULL);
@@ -2629,6 +2653,13 @@ CXL_EXPORT const char *cxl_dport_get_physical_node(struct cxl_dport *dport)
 	return devpath_to_devname(dport->phys_path);
 }
 
+CXL_EXPORT const char *cxl_dport_get_firmware_node(struct cxl_dport *dport)
+{
+	if (!dport->fw_path)
+		return NULL;
+	return devpath_to_devname(dport->fw_path);
+}
+
 CXL_EXPORT int cxl_dport_get_id(struct cxl_dport *dport)
 {
 	return dport->id;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 8bb91e05638b..490ed1fda5d3 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -217,3 +217,9 @@ global:
 	cxl_decoder_get_max_available_extent;
 	cxl_decoder_get_region;
 } LIBCXL_2;
+
+LIBCXL_4 {
+global:
+	cxl_target_get_firmware_node;
+	cxl_dport_get_firmware_node;
+} LIBCXL_3;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 437eadeb670a..e378339ec353 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -45,6 +45,7 @@ struct cxl_dport {
 	size_t buf_len;
 	char *dev_path;
 	char *phys_path;
+	char *fw_path;
 	struct cxl_port *port;
 	struct list_node list;
 };
@@ -93,6 +94,7 @@ struct cxl_target {
 	struct cxl_decoder *decoder;
 	char *dev_path;
 	char *phys_path;
+	char *fw_path;
 	int id, position;
 };
 
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9fe4e99263dd..1e0076908901 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -116,6 +116,7 @@ struct cxl_dport *cxl_dport_get_first(struct cxl_port *port);
 struct cxl_dport *cxl_dport_get_next(struct cxl_dport *dport);
 const char *cxl_dport_get_devname(struct cxl_dport *dport);
 const char *cxl_dport_get_physical_node(struct cxl_dport *dport);
+const char *cxl_dport_get_firmware_node(struct cxl_dport *dport);
 struct cxl_port *cxl_dport_get_port(struct cxl_dport *dport);
 int cxl_dport_get_id(struct cxl_dport *dport);
 bool cxl_dport_maps_memdev(struct cxl_dport *dport, struct cxl_memdev *memdev);
@@ -225,6 +226,7 @@ const char *cxl_target_get_devname(struct cxl_target *target);
 bool cxl_target_maps_memdev(struct cxl_target *target,
 			    struct cxl_memdev *memdev);
 const char *cxl_target_get_physical_node(struct cxl_target *target);
+const char *cxl_target_get_firmware_node(struct cxl_target *target);
 
 #define cxl_target_foreach(decoder, target)                                    \
 	for (target = cxl_target_get_first(decoder); target != NULL;           \

