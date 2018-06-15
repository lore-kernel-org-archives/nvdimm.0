Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7144821130E61
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:38:38 -0700 (PDT)
Subject: [ndctl PATCH] ndctl,
 test: Update tests for capacity vs namespace-label locking
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Jun 2018 17:28:10 -0700
Message-ID: <152902249055.9927.9157713405568345680.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Check that namespaces can be enumerated, but are disabled if the labels
are readable while the DIMM is locked. Alternatively, if the namespace
label area is locked, validate that regions with the affected DIMM fail
to enable.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am |   10 +-
 test/dsm-fail.c  |  305 ++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 257 insertions(+), 58 deletions(-)

diff --git a/test/Makefile.am b/test/Makefile.am
index 92cf29d6065e..f6483910af45 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -69,9 +69,15 @@ libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
 dsm_fail_SOURCES =\
 	dsm-fail.c \
-	$(testcore)
+	$(testcore) \
+	../ndctl/namespace.c \
+	../ndctl/check.c \
+	../util/json.c
 
-dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+dsm_fail_LDADD = $(LIBNDCTL_LIB) \
+		$(KMOD_LIBS) \
+		$(JSON_LIBS) \
+		../libutil.a
 
 ack_shutdown_count_set_SOURCES =\
 	ack-shutdown-count-set.c \
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 90d3e074f12b..b0df9da8ffab 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -24,6 +24,7 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
+#include <builtin.h>
 #include <ndctl.h>
 #include <test.h>
 
@@ -38,20 +39,153 @@ static void reset_bus(struct ndctl_bus *bus)
 	ndctl_region_foreach(bus, region)
 		ndctl_region_disable_invalidate(region);
 
-	ndctl_dimm_foreach(bus, dimm)
-		ndctl_dimm_zero_labels(dimm);
+	ndctl_dimm_foreach(bus, dimm) {
+		struct ndctl_cmd *cmd_read = ndctl_dimm_read_labels(dimm);
+
+		ndctl_dimm_disable(dimm);
+		ndctl_dimm_init_labels(dimm, NDCTL_NS_VERSION_1_2);
+		ndctl_dimm_enable(dimm);
+	}
 
 	/* set regions back to their default state */
 	ndctl_region_foreach(bus, region)
 		ndctl_region_enable(region);
 }
 
+static int set_dimm_response(const char *dimm_path, int cmd, int error_code,
+		struct log_ctx *log_ctx)
+{
+	char path[1024], buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	if (error_code) {
+		sprintf(path, "%s/fail_cmd", dimm_path);
+		sprintf(buf, "%#x\n", 1 << cmd);
+		rc = __sysfs_write_attr(log_ctx, path, buf);
+		if (rc)
+			goto out;
+		sprintf(path, "%s/fail_cmd_code", dimm_path);
+		sprintf(buf, "%d\n", error_code);
+		rc = __sysfs_write_attr(log_ctx, path, buf);
+		if (rc)
+			goto out;
+	} else {
+		sprintf(path, "%s/fail_cmd", dimm_path);
+		sprintf(buf, "0\n");
+		rc = __sysfs_write_attr(log_ctx, path, buf);
+		if (rc)
+			goto out;
+	}
+out:
+	if (rc < 0)
+		fprintf(stderr, "%s failed, cmd: %d code: %d\n",
+				__func__, cmd, error_code);
+	return 0;
+}
+
+static int dimms_disable(struct ndctl_bus *bus)
+{
+	struct ndctl_dimm *dimm;
+
+	ndctl_dimm_foreach(bus, dimm) {
+		int rc = ndctl_dimm_disable(dimm);
+
+		if (rc) {
+			fprintf(stderr, "dimm: %s failed to disable: %d\n",
+				ndctl_dimm_get_devname(dimm), rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+
+static int test_dimms_enable(struct ndctl_bus *bus, struct ndctl_dimm *victim,
+		bool expect)
+{
+	struct ndctl_dimm *dimm;
+
+	ndctl_dimm_foreach(bus, dimm) {
+		int rc = ndctl_dimm_enable(dimm);
+
+		if (((expect != (rc == 0)) && (dimm == victim))
+				|| (rc && dimm != victim)) {
+			bool __expect = true;
+
+			if (dimm == victim)
+				__expect = expect;
+			fprintf(stderr, "fail expected %s enable %s victim: %s rc: %d\n",
+					ndctl_dimm_get_devname(dimm),
+					__expect ? "success" : "failure",
+					ndctl_dimm_get_devname(victim), rc);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
+static int test_regions_enable(struct ndctl_bus *bus,
+		struct ndctl_dimm *victim, struct ndctl_region *victim_region,
+		bool region_expect, int namespace_count)
+{
+	struct ndctl_region *region;
+
+	ndctl_region_foreach(bus, region) {
+		struct ndctl_namespace *ndns;
+		struct ndctl_dimm *dimm;
+		bool has_victim = false;
+		int rc, count = 0;
+
+		ndctl_dimm_foreach_in_region(region, dimm) {
+			if (dimm == victim) {
+				has_victim = true;
+				break;
+			}
+		}
+
+		rc = ndctl_region_enable(region);
+		fprintf(stderr, "region: %s enable: %d has_victim: %d\n",
+				ndctl_region_get_devname(region), rc, has_victim);
+		if (((region_expect != (rc == 0)) && has_victim)
+				|| (rc && !has_victim)) {
+			bool __expect = true;
+
+			if (has_victim)
+				__expect = region_expect;
+			fprintf(stderr, "%s: fail expected enable: %s with %s\n",
+					ndctl_region_get_devname(region),
+					__expect ? "success" : "failure",
+					ndctl_dimm_get_devname(victim));
+			return -ENXIO;
+		}
+		if (region != victim_region)
+			continue;
+		ndctl_namespace_foreach(region, ndns) {
+			if (ndctl_namespace_is_enabled(ndns)) {
+				fprintf(stderr, "%s: enabled, expected disabled\n",
+						ndctl_namespace_get_devname(ndns));
+				return -ENXIO;
+			}
+			fprintf(stderr, "%s: %s: size: %lld\n", __func__,
+					ndctl_namespace_get_devname(ndns),
+					ndctl_namespace_get_size(ndns));
+			count++;
+		}
+		if (count != namespace_count) {
+			fprintf(stderr, "%s: fail expected %d namespaces got %d\n",
+					ndctl_region_get_devname(region),
+					namespace_count, count);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
 static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
 	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	struct ndctl_region *region, *victim_region = NULL;
 	struct ndctl_dimm *dimm, *victim = NULL;
 	char path[1024], buf[SYSFS_ATTR_SIZE];
-	struct ndctl_region *region;
 	struct log_ctx log_ctx;
 	unsigned int handle;
 	int rc, err = 0;
@@ -64,11 +198,7 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 
 	log_init(&log_ctx, "test/dsm-fail", "NDCTL_TEST");
 
-	ndctl_bus_wait_probe(bus);
-
-	/* disable all regions so that we can disable a dimm */
-	ndctl_region_foreach(bus, region)
-		ndctl_region_disable_invalidate(region);
+	reset_bus(bus);
 
 	sprintf(path, "%s/handle", DIMM_PATH);
 	rc = __sysfs_read_attr(&log_ctx, path, buf);
@@ -79,16 +209,11 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 
 	handle = strtoul(buf, NULL, 0);
 
-	ndctl_dimm_foreach(bus, dimm) {
-		if (ndctl_dimm_get_handle(dimm) == handle)
+	ndctl_dimm_foreach(bus, dimm)
+		if (ndctl_dimm_get_handle(dimm) == handle) {
 			victim = dimm;
-
-		if (ndctl_dimm_disable(dimm)) {
-			fprintf(stderr, "failed to disable: %s\n",
-					ndctl_dimm_get_devname(dimm));
-			return -ENXIO;
+			break;
 		}
-	}
 
 	if (!victim) {
 		fprintf(stderr, "failed to find victim dimm\n");
@@ -96,67 +221,135 @@ static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	}
 	fprintf(stderr, "victim: %s\n", ndctl_dimm_get_devname(victim));
 
-	sprintf(path, "%s/fail_cmd", DIMM_PATH);
-	sprintf(buf, "%#x\n", 1 << ND_CMD_GET_CONFIG_SIZE);
-	rc = __sysfs_write_attr(&log_ctx, path, buf);
-	if (rc) {
-		fprintf(stderr, "failed to set fail cmd mask\n");
-		return -ENXIO;
-	}
+	ndctl_region_foreach(bus, region) {
+		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_PMEM)
+			continue;
+		ndctl_dimm_foreach_in_region(region, dimm) {
+			const char *argv[] = {
+				"__func__", "-v", "-r",
+				ndctl_region_get_devname(region),
+				"-s", "4M", "-m", "raw",
+			};
+			struct ndctl_namespace *ndns;
+			int count, i;
 
-	ndctl_dimm_foreach(bus, dimm) {
-		rc = ndctl_dimm_enable(dimm);
-		fprintf(stderr, "dimm: %s enable: %d\n",
-				ndctl_dimm_get_devname(dimm), rc);
-		if ((rc == 0) == (dimm == victim)) {
-			fprintf(stderr, "fail expected %s enable %s victim: %s\n",
-					ndctl_dimm_get_devname(dimm),
-					(dimm == victim) ? "failure" : "success",
-					ndctl_dimm_get_devname(victim));
-			err = -ENXIO;
-			goto out;
+			if (dimm != victim)
+				continue;
+			/*
+			 * Validate that we only have the one seed
+			 * namespace, and then create one so that we can
+			 * verify namespace enumeration while locked.
+			 */
+			count = 0;
+			ndctl_namespace_foreach(region, ndns)
+				count++;
+			if (count != 1) {
+				fprintf(stderr, "%s: found %d namespaces expected 1\n",
+						ndctl_region_get_devname(region),
+						count);
+				rc = -ENXIO;
+				goto out;
+			}
+			if (ndctl_region_get_size(region)
+					!= ndctl_region_get_available_size(region)) {
+				fprintf(stderr, "%s: expected empty region\n",
+						ndctl_region_get_devname(region));
+				rc = -ENXIO;
+				goto out;
+			}
+			for (i = 0; i < 2; i++) {
+				builtin_xaction_namespace_reset();
+				rc = cmd_create_namespace(ARRAY_SIZE(argv), argv,
+						ndctl_region_get_ctx(region));
+				if (rc) {
+					fprintf(stderr, "%s: failed to create namespace\n",
+							ndctl_region_get_devname(region));
+					rc = -ENXIO;
+					goto out;
+				}
+			}
+			victim_region = region;
 		}
+		if (victim_region)
+			break;
 	}
 
-	ndctl_region_foreach(bus, region) {
-		bool has_victim = false;
+	/* disable all regions so that we can disable a dimm */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
 
-		ndctl_dimm_foreach_in_region(region, dimm) {
-			if (dimm == victim) {
-				has_victim = true;
-				break;
-			}
-		}
+	rc = dimms_disable(bus);
+	if (rc)
+		goto out;
 
-		rc = ndctl_region_enable(region);
-		fprintf(stderr, "region: %s enable: %d has_victim: %d\n",
-				ndctl_region_get_devname(region), rc, has_victim);
-		if ((rc == 0) == has_victim) {
-			fprintf(stderr, "fail expected %s enable %s with %s disabled\n",
-					ndctl_region_get_devname(region),
-					has_victim ? "failure" : "success",
-					ndctl_dimm_get_devname(victim));
-			err = -ENXIO;
-			goto out;
-		}
-	}
+
+	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_SIZE, -EACCES,
+			&log_ctx);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = test_dimms_enable(bus, victim, true);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = test_regions_enable(bus, victim, victim_region, true, 2);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_SIZE, 0, &log_ctx);
+	if (rc)
+		goto out;
+
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = dimms_disable(bus);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+
+	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, -EACCES,
+			&log_ctx);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = test_dimms_enable(bus, victim, false);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = test_regions_enable(bus, victim, victim_region, false, 0);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = set_dimm_response(DIMM_PATH, ND_CMD_GET_CONFIG_DATA, 0, &log_ctx);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
+	rc = dimms_disable(bus);
+	if (rc)
+		goto out;
+	fprintf(stderr, "%s:%d\n", __func__, __LINE__);
 
  out:
+	err = rc;
+	sprintf(path, "%s/fail_cmd", DIMM_PATH);
 	sprintf(buf, "0\n");
 	rc = __sysfs_write_attr(&log_ctx, path, buf);
 	if (rc) {
 		fprintf(stderr, "%s: failed to clear fail_cmd mask\n",
 				ndctl_dimm_get_devname(victim));
-		err = -ENXIO;
+		rc = -ENXIO;
 	}
 	rc = ndctl_dimm_enable(victim);
 	if (rc) {
 		fprintf(stderr, "failed to enable victim: %s after clearing error\n",
 				ndctl_dimm_get_devname(victim));
-		err = -ENXIO;
+		rc = -ENXIO;
 	}
 	reset_bus(bus);
 
+	if (rc)
+		err = rc;
 	return err;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
