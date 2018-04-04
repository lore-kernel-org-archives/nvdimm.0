Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34F7F22526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:22:03 -0700 (PDT)
Subject: [ndctl PATCH 2/5] ndctl,
 scrub: report the bus scrub state in 'ndctl list'
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:12:06 -0700
Message-ID: <152287632679.29230.14997478290667449138.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for adding 'wait-scrub' and 'start-scrub' utility
helpers, indicate the current state of ARS operations in the listing for
bus objects. The field is omitted if the bus does not support ARS
operations.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   49 ++++++++++++++++++++++++++++++++++++++----------
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h       |    1 +
 util/json.c            |   10 ++++++++++
 4 files changed, 51 insertions(+), 10 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 743863b5c7e7..ff0d44ffefe6 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1114,29 +1114,58 @@ NDCTL_EXPORT int ndctl_bus_wait_probe(struct ndctl_bus *bus)
 	return rc < 0 ? -ENXIO : 0;
 }
 
-NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
+static int __ndctl_bus_get_scrub_state(struct ndctl_bus *bus,
+		unsigned int *scrub_count, bool *active)
 {
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
 	char buf[SYSFS_ATTR_SIZE];
-	unsigned int scrub_count;
 	char in_progress = '\0';
 	int rc;
 
 	rc = sysfs_read_attr(ctx, bus->scrub_path, buf);
 	if (rc < 0)
-		return UINT_MAX;
+		return -EOPNOTSUPP;
 
-	rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
+	rc = sscanf(buf, "%u%c", scrub_count, &in_progress);
 	if (rc < 0)
-		return UINT_MAX;
-	if (rc == 0) {
+		return -ENXIO;
+
+	switch (rc) {
+	case 1:
+		*active = false;
+		return 0;
+	case 2:
+		if (in_progress == '+') {
+			*active = true;
+			return 0;
+		}
+		/* fall through */
+	default:
 		/* unable to read scrub count */
-		return UINT_MAX;
+		return -ENXIO;
 	}
-	if (rc >= 1)
-		return scrub_count;
+}
+
+NDCTL_EXPORT int ndctl_bus_get_scrub_state(struct ndctl_bus *bus)
+{
+	unsigned int scrub_count = 0;
+	bool active = false;
+	int rc;
+
+	rc = __ndctl_bus_get_scrub_state(bus, &scrub_count, &active);
+	if (rc < 0)
+		return rc;
+	return active;
+}
+
+NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
+{
+	unsigned int scrub_count = 0;
+	bool active = false;
 
-	return UINT_MAX;
+	if (__ndctl_bus_get_scrub_state(bus, &scrub_count, &active))
+		return UINT_MAX;
+	return scrub_count;
 }
 
 /**
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 3209aefe6672..06cace96724f 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -352,4 +352,5 @@ global:
 	ndctl_dimm_fw_update_supported;
 	ndctl_region_get_persistence_domain;
 	ndctl_bus_get_persistence_domain;
+	ndctl_bus_get_scrub_state;
 } LIBNDCTL_14;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index cf6a77fd0992..36c04d871bd5 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -121,6 +121,7 @@ enum ndctl_persistence_domain ndctl_bus_get_persistence_domain(
 int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
+int ndctl_bus_get_scrub_state(struct ndctl_bus *bus);
 int ndctl_bus_has_error_injection(struct ndctl_bus *bus);
 
 struct ndctl_dimm;
diff --git a/util/json.c b/util/json.c
index a464f21d6d5a..5b4b4c374d44 100644
--- a/util/json.c
+++ b/util/json.c
@@ -124,6 +124,7 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus)
 {
 	struct json_object *jbus = json_object_new_object();
 	struct json_object *jobj;
+	int scrub;
 
 	if (!jbus)
 		return NULL;
@@ -138,6 +139,15 @@ struct json_object *util_bus_to_json(struct ndctl_bus *bus)
 		goto err;
 	json_object_object_add(jbus, "dev", jobj);
 
+	scrub = ndctl_bus_get_scrub_state(bus);
+	if (scrub < 0)
+		return jbus;
+
+	jobj = json_object_new_string(scrub ? "active" : "idle");
+	if (!jobj)
+		goto err;
+	json_object_object_add(jbus, "scrub_state", jobj);
+
 	return jbus;
  err:
 	json_object_put(jbus);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
