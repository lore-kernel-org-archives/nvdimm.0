Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AA971A1E67
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 18:03:37 -0700 (PDT)
Subject: [ndctl PATCH 3/3] test, dsm-fail: test get_config_size DSM failures
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 13 Sep 2016 18:00:33 -0700
Message-ID: <147381483355.12944.971063849457148580.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147381481774.12944.1660067055752367684.stgit@dwillia2-desk3.amr.corp.intel.com>
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

We expect that if the dimm driver fails to enable then any
label-data-dependent regions/namespaces will also fail to enable.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am    |    3 +
 ndctl/builtin-test.c |    5 +
 test.h               |    1 
 test/Makefile.am     |   10 ++
 test/dsm-fail.c      |  216 ++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 235 insertions(+)
 create mode 100644 test/dsm-fail.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index f6cd3f1c235b..63f387b58de9 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -34,6 +34,9 @@ ndctl_LDADD =\
 
 if ENABLE_TEST
 ndctl_SOURCES += ../test/libndctl.c \
+		 ../test/dsm-fail.c \
+		 ../util/log.c \
+		 ../util/sysfs.c \
 		 ../test/dpa-alloc.c \
 		 ../test/parent-uuid.c \
 		 ../test/core.c
diff --git a/ndctl/builtin-test.c b/ndctl/builtin-test.c
index d9c5b0f28d6e..d8539a133d10 100644
--- a/ndctl/builtin-test.c
+++ b/ndctl/builtin-test.c
@@ -49,6 +49,11 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 	if (rc && rc != 77)
 		return rc;
 
+	rc = test_dsm_fail(loglevel, test, ctx);
+	fprintf(stderr, "test-dsm-fail: %s\n", result(rc));
+	if (rc && rc != 77)
+		return rc;
+
 	rc = test_dpa_alloc(loglevel, test, ctx);
 	fprintf(stderr, "test-dpa-alloc: %s\n", result(rc));
 	if (rc && rc != 77)
diff --git a/test.h b/test.h
index 2940ac0f7396..bf708f38bfbf 100644
--- a/test.h
+++ b/test.h
@@ -18,6 +18,7 @@ struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, void *dax_addr, off_t offset);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_blk_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_pmem_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/Makefile.am b/test/Makefile.am
index f0240fe5883a..5513f429869f 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -2,6 +2,7 @@ include $(top_srcdir)/Makefile.am.in
 
 TESTS =\
 	libndctl \
+	dsm-fail \
 	dpa-alloc \
 	parent-uuid \
 	create.sh \
@@ -10,6 +11,7 @@ TESTS =\
 
 check_PROGRAMS =\
 	libndctl \
+	dsm-fail \
 	dpa-alloc \
 	parent-uuid \
 	dax-errors
@@ -39,6 +41,14 @@ LIBNDCTL_LIB =\
 libndctl_SOURCES = libndctl.c core.c
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
+dsm_fail_SOURCES =\
+	dsm-fail.c \
+	core.c \
+	../util/log.c \
+	../util/sysfs.c
+
+dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
+
 blk_ns_SOURCES = blk_namespaces.c core.c
 blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
new file mode 100644
index 000000000000..e95a2f0a65a5
--- /dev/null
+++ b/test/dsm-fail.c
@@ -0,0 +1,216 @@
+/*
+ * Copyright (c) 2014-2016, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU Lesser General Public License,
+ * version 2.1, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT ANY
+ * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
+ * more details.
+ */
+#include <stdio.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+#include <syslog.h>
+#include <libkmod.h>
+#include <util/log.h>
+#include <util/sysfs.h>
+#include <linux/version.h>
+
+#include <ccan/array_size/array_size.h>
+#include <ndctl/libndctl.h>
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+#include <test.h>
+
+#define DIMM_PATH "/sys/devices/platform/nfit_test.0/nfit_test_dimm/test_dimm0"
+
+static void reset_bus(struct ndctl_bus *bus)
+{
+	struct ndctl_region *region;
+	struct ndctl_dimm *dimm;
+
+	/* disable all regions so that set_config_data commands are permitted */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+
+	ndctl_dimm_foreach(bus, dimm)
+		ndctl_dimm_zero_labels(dimm);
+
+	/* set regions back to their default state */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_enable(region);
+}
+
+static int do_test(struct ndctl_ctx *ctx, struct ndctl_test *test)
+{
+	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	struct ndctl_dimm *dimm, *victim = NULL;
+	char path[1024], buf[SYSFS_ATTR_SIZE];
+	struct ndctl_region *region;
+	struct log_ctx log_ctx;
+	unsigned int handle;
+	int rc;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0)))
+		return 77;
+
+	if (!bus)
+		return -ENXIO;
+
+	log_init(&log_ctx, "test/dsm-fail", "NDCTL_TEST");
+
+	ndctl_bus_wait_probe(bus);
+
+	/* disable all regions so that we can disable a dimm */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+
+	sprintf(path, "%s/handle", DIMM_PATH);
+	rc = __sysfs_read_attr(&log_ctx, path, buf);
+	if (rc) {
+		fprintf(stderr, "failed to retrieve test dimm handle\n");
+		return -ENXIO;
+	}
+
+	handle = strtoul(buf, NULL, 0);
+
+	ndctl_dimm_foreach(bus, dimm) {
+		if (ndctl_dimm_get_handle(dimm) == handle)
+			victim = dimm;
+
+		if (ndctl_dimm_disable(dimm)) {
+			fprintf(stderr, "failed to disable: %s\n",
+					ndctl_dimm_get_devname(dimm));
+			return -ENXIO;
+		}
+	}
+
+	if (!victim) {
+		fprintf(stderr, "failed to find victim dimm\n");
+		return -ENXIO;
+	}
+	fprintf(stderr, "victim: %s\n", ndctl_dimm_get_devname(victim));
+
+	sprintf(path, "%s/fail_cmd", DIMM_PATH);
+	sprintf(buf, "%#x\n", 1 << ND_CMD_GET_CONFIG_SIZE);
+	rc = __sysfs_write_attr(&log_ctx, path, buf);
+	if (rc) {
+		fprintf(stderr, "failed to set fail cmd mask\n");
+		return -ENXIO;
+	}
+
+	ndctl_dimm_foreach(bus, dimm) {
+		rc = ndctl_dimm_enable(dimm);
+		fprintf(stderr, "dimm: %s enable: %d\n",
+				ndctl_dimm_get_devname(dimm), rc);
+		if ((rc == 0) == (dimm == victim)) {
+			fprintf(stderr, "fail expected %s enable %s victim: %s\n",
+					ndctl_dimm_get_devname(dimm),
+					(dimm == victim) ? "failure" : "success",
+					ndctl_dimm_get_devname(victim));
+			rc = -ENXIO;
+			goto out;
+		}
+	}
+
+	ndctl_region_foreach(bus, region) {
+		bool has_victim = false;
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
+		if ((rc == 0) == has_victim) {
+			fprintf(stderr, "fail expected %s enable %s with %s disabled\n",
+					ndctl_region_get_devname(region),
+					has_victim ? "failure" : "success",
+					ndctl_dimm_get_devname(victim));
+			rc = -ENXIO;
+			goto out;
+		}
+	}
+
+	rc = 0;
+ out:
+	sprintf(buf, "0\n");
+	__sysfs_write_attr(&log_ctx, path, buf);
+	rc = ndctl_dimm_enable(victim);
+	if (rc) {
+		fprintf(stderr, "failed to enable victim: %s after clearing error\n",
+				ndctl_dimm_get_devname(victim));
+		rc = -ENXIO;
+	}
+	reset_bus(bus);
+
+	return rc;
+}
+
+int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
+{
+	struct kmod_module *mod;
+	struct kmod_ctx *kmod_ctx;
+	int result = EXIT_FAILURE, err;
+
+	ndctl_set_log_priority(ctx, loglevel);
+	kmod_ctx = kmod_new(NULL, NULL);
+	if (!kmod_ctx)
+		return result;
+	kmod_set_log_priority(kmod_ctx, loglevel);
+
+	err = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
+	if (err < 0)
+		goto err_module;
+
+	err = kmod_module_probe_insert_module(mod, KMOD_PROBE_APPLY_BLACKLIST,
+			NULL, NULL, NULL, NULL);
+	if (err < 0) {
+		result = 77;
+		ndctl_test_skip(test);
+		fprintf(stderr, "%s unavailable skipping tests\n",
+				"nfit_test");
+		goto err_module;
+	}
+
+	if (do_test(ctx, test) == 0)
+		result = EXIT_SUCCESS;
+
+	kmod_module_remove_module(mod, 0);
+
+ err_module:
+	kmod_unref(kmod_ctx);
+	return result;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	struct ndctl_test *test = ndctl_test_new(0);
+	struct ndctl_ctx *ctx;
+	int rc;
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = ndctl_new(&ctx);
+	if (rc)
+		return ndctl_test_result(test, rc);
+	rc = test_dsm_fail(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+	return ndctl_test_result(test, rc);
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
