Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F5342118FF2F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 17:31:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 4/4] ndctl: clean up usage of ndctl_cmd_submit
Date: Fri, 11 Jan 2019 18:30:35 -0700
Message-Id: <20190112013035.32087-5-vishal.l.verma@intel.com>
In-Reply-To: <20190112013035.32087-1-vishal.l.verma@intel.com>
References: <20190112013035.32087-1-vishal.l.verma@intel.com>
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
Cc: Ami Pathak <ami.g.pathak@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

It is possible for ndctl_cmd_submit to return a positive number,
indicating a buffer underrun. It is only truly an error if it returns a
negative number. Several places in the library, the ndctl utility, and
in test/ were simply checking for an error with "if (rc)". Fix these to
only error out for negative returns.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/dimm.c           |  6 +++---
 ndctl/lib/inject.c         |  8 ++++----
 ndctl/lib/nfit.c           |  2 +-
 ndctl/util/json-firmware.c |  2 +-
 test/daxdev-errors.c       |  8 ++++----
 test/libndctl.c            | 18 +++++++++---------
 test/smart-notify.c        |  8 ++++----
 7 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 79e2ca0..12dc74a 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -332,7 +332,7 @@ static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
 		goto out;
 
 	rc = ndctl_cmd_submit(cmd_write);
-	if (rc || ndctl_cmd_get_firmware_status(cmd_write))
+	if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_write))
 		rc = -ENXIO;
  out:
 	ndctl_cmd_unref(cmd_write);
@@ -488,14 +488,14 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_read_labels(struct ndctl_dimm *dimm)
         if (!cmd_size)
                 return NULL;
         rc = ndctl_cmd_submit(cmd_size);
-        if (rc || ndctl_cmd_get_firmware_status(cmd_size))
+        if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_size))
                 goto out_size;
 
         cmd_read = ndctl_dimm_cmd_new_cfg_read(cmd_size);
         if (!cmd_read)
                 goto out_size;
         rc = ndctl_cmd_submit(cmd_read);
-        if (rc || ndctl_cmd_get_firmware_status(cmd_read))
+        if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_read))
                 goto out_read;
 	ndctl_cmd_unref(cmd_size);
 
diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 2b0702e..c35d0f3 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -156,7 +156,7 @@ static int ndctl_namespace_inject_one_error(struct ndctl_namespace *ndns,
 			(1 << ND_ARS_ERR_INJ_OPT_NOTIFY);
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		dbg(ctx, "Error submitting command: %d\n", rc);
 		goto out;
 	}
@@ -234,7 +234,7 @@ static int ndctl_namespace_uninject_one_error(struct ndctl_namespace *ndns,
 	err_inj_clr->err_inj_clr_spa_range_length = length;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		dbg(ctx, "Error submitting command: %d\n", rc);
 		goto out;
 	}
@@ -443,7 +443,7 @@ NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
 
 		cmd = ndctl_bus_cmd_new_ars_cap(bus, ns_offset, ns_size);
 		rc = ndctl_cmd_submit(cmd);
-		if (rc) {
+		if (rc < 0) {
 			dbg(ctx, "Error submitting ars_cap: %d\n", rc);
 			goto out;
 		}
@@ -464,7 +464,7 @@ NDCTL_EXPORT int ndctl_namespace_injection_status(struct ndctl_namespace *ndns)
 			(struct nd_cmd_ars_err_inj_stat *)&pkg->nd_payload[0];
 
 		rc = ndctl_cmd_submit(cmd);
-		if (rc) {
+		if (rc < 0) {
 			dbg(ctx, "Error submitting command: %d\n", rc);
 			goto out;
 		}
diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index 2ae3f07..b10edb1 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -133,7 +133,7 @@ int ndctl_bus_nfit_translate_spa(struct ndctl_bus *bus,
 	translate_spa->spa = address;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		ndctl_cmd_unref(cmd);
 		return rc;
 	}
diff --git a/ndctl/util/json-firmware.c b/ndctl/util/json-firmware.c
index 118424f..f7150d8 100644
--- a/ndctl/util/json-firmware.c
+++ b/ndctl/util/json-firmware.c
@@ -25,7 +25,7 @@ struct json_object *util_dimm_firmware_to_json(struct ndctl_dimm *dimm,
 		goto err;
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
+	if ((rc < 0) || ndctl_cmd_fw_xlat_firmware_status(cmd) != FW_SUCCESS) {
 		jobj = util_json_object_hex(-1, flags);
 		if (jobj)
 			json_object_object_add(jfirmware, "current_version",
diff --git a/test/daxdev-errors.c b/test/daxdev-errors.c
index 94fbebe..29de16b 100644
--- a/test/daxdev-errors.c
+++ b/test/daxdev-errors.c
@@ -75,7 +75,7 @@ static int check_ars_cap(struct ndctl_bus *bus, uint64_t start,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -115,7 +115,7 @@ static int check_ars_start(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -149,7 +149,7 @@ static int check_ars_status(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(cmd);
@@ -210,7 +210,7 @@ static int check_clear_error(struct ndctl_bus *bus, struct check_cmd *check)
 	}
 
 	rc = ndctl_cmd_submit(clear_err);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
 				__func__, ndctl_bus_get_provider(bus), rc);
 		ndctl_cmd_unref(clear_err);
diff --git a/test/libndctl.c b/test/libndctl.c
index 50365f0..59f68d8 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2057,7 +2057,7 @@ static int check_get_config_size(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2091,7 +2091,7 @@ static int check_get_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2127,7 +2127,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	memset(buf, 0, sizeof(buf));
 	ndctl_cmd_cfg_write_set_data(cmd, buf, sizeof(buf), 0);
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2135,7 +2135,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd_read);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit read1: %zd\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2152,7 +2152,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	sprintf(buf, "dimm-%#x", ndctl_dimm_get_handle(dimm));
 	ndctl_cmd_cfg_write_set_data(cmd, buf, sizeof(buf), 0);
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %zd\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2160,7 +2160,7 @@ static int check_set_config_data(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd_read);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit read2: %zd\n",
 				__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2225,7 +2225,7 @@ static int check_smart(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2326,7 +2326,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	}
 
 	rc = ndctl_cmd_submit(cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: dimm: %#x failed to submit cmd: %d\n",
 			__func__, ndctl_dimm_get_handle(dimm), rc);
 		ndctl_cmd_unref(cmd);
@@ -2375,7 +2375,7 @@ static int check_smart_threshold(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 		}
 
 		rc = ndctl_cmd_submit(cmd_set);
-		if (rc) {
+		if (rc < 0) {
 			fprintf(stderr, "%s: dimm: %#x failed to submit cmd_set: %d\n",
 					__func__, ndctl_dimm_get_handle(dimm), rc);
 			ndctl_cmd_unref(cmd_set);
diff --git a/test/smart-notify.c b/test/smart-notify.c
index 24e9a21..e28e0f4 100644
--- a/test/smart-notify.c
+++ b/test/smart-notify.c
@@ -22,7 +22,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(s_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart command failed: %d %s\n", name,
 				rc, strerror(errno));
 		goto out;
@@ -49,7 +49,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(st_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart threshold command failed: %d %s\n",
 				name, rc, strerror(errno));
 		goto out;
@@ -148,7 +148,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 
 		ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, set_alarm);
 		rc = ndctl_cmd_submit(sst_cmd);
-		if (rc) {
+		if (rc < 0) {
 			fprintf(stderr, "%s: smart set threshold command failed: %d %s\n",
 					name, rc, strerror(errno));
 			goto out;
@@ -166,7 +166,7 @@ static void do_notify(struct ndctl_dimm *dimm)
 	}
 
 	rc = ndctl_cmd_submit(sst_cmd);
-	if (rc) {
+	if (rc < 0) {
 		fprintf(stderr, "%s: smart set threshold defaults failed: %d %s\n",
 				name, rc, strerror(errno));
 		goto out;
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
