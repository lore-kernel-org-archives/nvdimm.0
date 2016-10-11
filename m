Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7E8361A1E6F
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 23:46:34 -0700 (PDT)
Subject: [ndctl PATCH] test,
 multi-pmem: validate the creation and detection of multi-pmem
 configurations
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 10 Oct 2016 23:43:31 -0700
Message-ID: <147616821167.36594.17815699455636516434.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Create multiple pmem namespaces in a region and check that the same
namespaces return in the same order after a region disable/enable event.
Also, check that the highest BLK capacity is limited to the
dimm-physical-address space after the highest PMEM allocation.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am    |    1 
 ndctl/builtin-test.c |    3 +
 test.h               |    1 
 test/Makefile.am     |   12 ++
 test/multi-pmem.c    |  272 ++++++++++++++++++++++++++++++++++++++++++++++++++
 util/size.h          |    2 
 6 files changed, 291 insertions(+)
 create mode 100644 test/multi-pmem.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 63f387b58de9..29237b76713a 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -39,5 +39,6 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../util/sysfs.c \
 		 ../test/dpa-alloc.c \
 		 ../test/parent-uuid.c \
+		 ../test/multi-pmem.c \
 		 ../test/core.c
 endif
diff --git a/ndctl/builtin-test.c b/ndctl/builtin-test.c
index d8539a133d10..caa666b68e69 100644
--- a/ndctl/builtin-test.c
+++ b/ndctl/builtin-test.c
@@ -62,5 +62,8 @@ int cmd_test(int argc, const char **argv, struct ndctl_ctx *ctx)
 	rc = test_parent_uuid(loglevel, test, ctx);
 	fprintf(stderr, "test-parent-uuid: %s\n", result(rc));
 
+	rc = test_multi_pmem(loglevel, test, ctx);
+	fprintf(stderr, "test-multi-pmem: %s\n", result(rc));
+
 	return ndctl_test_result(test, rc);
 }
diff --git a/test.h b/test.h
index bf708f38bfbf..6010f76dcf1d 100644
--- a/test.h
+++ b/test.h
@@ -16,6 +16,7 @@ void builtin_xaction_namespace_reset(void);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, void *dax_addr, off_t offset);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/Makefile.am b/test/Makefile.am
index 5513f429869f..46a1acf98f0d 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -5,6 +5,7 @@ TESTS =\
 	dsm-fail \
 	dpa-alloc \
 	parent-uuid \
+	multi-pmem \
 	create.sh \
 	clear.sh \
 	dax-errors.sh
@@ -14,6 +15,7 @@ check_PROGRAMS =\
 	dsm-fail \
 	dpa-alloc \
 	parent-uuid \
+	multi-pmem \
 	dax-errors
 
 if ENABLE_DESTRUCTIVE
@@ -78,3 +80,13 @@ device_dax_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
 		../libutil.a
+
+multi_pmem_SOURCES = \
+		multi-pmem.c \
+		core.c \
+		../ndctl/builtin-xaction-namespace.c \
+		../ndctl/util/json.c
+multi_pmem_LDADD = \
+		$(LIBNDCTL_LIB) \
+		$(JSON_LIBS) \
+		../libutil.a
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
new file mode 100644
index 000000000000..a7aedd9b5025
--- /dev/null
+++ b/test/multi-pmem.c
@@ -0,0 +1,272 @@
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <libkmod.h>
+#include <uuid/uuid.h>
+#include <sys/types.h>
+#include <util/size.h>
+#include <linux/falloc.h>
+#include <linux/version.h>
+#include <ndctl/libndctl.h>
+#include <ccan/array_size/array_size.h>
+
+#ifdef HAVE_NDCTL_H
+#include <linux/ndctl.h>
+#else
+#include <ndctl.h>
+#endif
+
+#include <ndctl/builtin.h>
+#include <test.h>
+
+#define NUM_NAMESPACES 4
+#define SZ_NAMESPACE SZ_16M
+
+static int setup_namespace(struct ndctl_region *region)
+{
+	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
+	const char *argv[] = {
+		"__func__", "-v", "-m", "raw", "-s", "16M", "-r", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_region_get_devname(region);
+	builtin_xaction_namespace_reset();
+	return cmd_create_namespace(argc, argv, ctx);
+}
+
+static void destroy_namespace(struct ndctl_namespace *ndns)
+{
+	struct ndctl_ctx *ctx = ndctl_namespace_get_ctx(ndns);
+	const char *argv[] = {
+		"__func__", "-v", "-f", "",
+	};
+	int argc = ARRAY_SIZE(argv);
+
+	argv[argc - 1] = ndctl_namespace_get_devname(ndns);
+	builtin_xaction_namespace_reset();
+	cmd_destroy_namespace(argc, argv, ctx);
+}
+
+static int do_multi_pmem(struct ndctl_ctx *ctx, struct ndctl_test *test)
+{
+	int i;
+	char devname[100];
+	struct ndctl_bus *bus;
+	uuid_t uuid[NUM_NAMESPACES];
+	struct ndctl_namespace *ndns;
+	struct ndctl_dimm *dimm_target, *dimm;
+	struct ndctl_region *region, *target = NULL;
+	struct ndctl_namespace *namespaces[NUM_NAMESPACES];
+	unsigned long long blk_avail, blk_avail_orig, expect;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
+		ndctl_test_skip(test);
+		return 77;
+	}
+
+	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	if (!bus)
+		return -ENXIO;
+
+	/* disable all regions so that set_config_data commands are permitted */
+	ndctl_region_foreach(bus, region)
+		ndctl_region_disable_invalidate(region);
+
+	ndctl_dimm_foreach(bus, dimm) {
+		int rc = ndctl_dimm_zero_labels(dimm);
+
+		if (rc < 0) {
+			fprintf(stderr, "failed to zero %s\n",
+					ndctl_dimm_get_devname(dimm));
+			return rc;
+		}
+	}
+
+	/*
+	 * Set regions back to their default state and find our target
+	 * region.
+	 */
+	ndctl_region_foreach(bus, region) {
+		ndctl_region_enable(region);
+		if (ndctl_region_get_available_size(region)
+				== SZ_NAMESPACE * NUM_NAMESPACES)
+			target = region;
+	}
+
+	if (!target) {
+		fprintf(stderr, "multi-pmem: failed to find target region\n");
+		return -ENXIO;
+	}
+	region = target;
+
+	for (i = 0; i < (int) ARRAY_SIZE(uuid); i++) {
+		if (setup_namespace(region) != 0) {
+			fprintf(stderr, "multi-pmem: failed to setup namespace: %d\n", i);
+			return -ENXIO;
+		}
+		sprintf(devname, "namespace%d.%d",
+				ndctl_region_get_id(region), i);
+		ndctl_namespace_foreach(region, ndns)
+			if (strcmp(ndctl_namespace_get_devname(ndns), devname) == 0
+					&& ndctl_namespace_is_enabled(ndns))
+				break;
+		if (!ndns) {
+			fprintf(stderr, "multi-pmem: failed to find namespace: %s\n",
+					devname);
+			return -ENXIO;
+		}
+		ndctl_namespace_get_uuid(ndns, uuid[i]);
+	}
+
+	/* bounce the region and verify everything came back as expected */
+	ndctl_region_disable_invalidate(region);
+	ndctl_region_enable(region);
+
+	for (i = 0; i < (int) ARRAY_SIZE(uuid); i++) {
+		char uuid_str1[40], uuid_str2[40];
+		uuid_t uuid_check;
+
+		ndctl_namespace_foreach(region, ndns)
+		sprintf(devname, "namespace%d.%d",
+				ndctl_region_get_id(region), i);
+		ndctl_namespace_foreach(region, ndns)
+			if (strcmp(ndctl_namespace_get_devname(ndns), devname) == 0
+					&& ndctl_namespace_is_enabled(ndns))
+				break;
+		if (!ndns) {
+			fprintf(stderr, "multi-pmem: failed to restore namespace: %s\n",
+					devname);
+			return -ENXIO;
+		}
+
+		ndctl_namespace_get_uuid(ndns, uuid_check);
+		uuid_unparse(uuid_check, uuid_str2);
+		uuid_unparse(uuid[i], uuid_str1);
+		if (uuid_compare(uuid_check, uuid[i]) != 0) {
+			fprintf(stderr, "multi-pmem: expected uuid[%d]: %s, got %s\n",
+					i, uuid_str1, uuid_str2);
+			return -ENXIO;
+		}
+		namespaces[i] = ndns;
+	}
+
+	/*
+	 * Check that aliased blk capacity does not increase until the
+	 * highest dpa pmem-namespace is deleted.
+	 */
+	dimm_target = ndctl_region_get_first_dimm(region);
+	if (!dimm_target) {
+		fprintf(stderr, "multi-pmem: failed to retrieve dimm from %s\n",
+				ndctl_region_get_devname(region));
+		return -ENXIO;
+	}
+
+	dimm = NULL;
+	ndctl_region_foreach(bus, region) {
+		if (ndctl_region_get_type(region) != ND_DEVICE_REGION_BLK)
+			continue;
+		ndctl_dimm_foreach_in_region(region, dimm)
+			if (dimm == dimm_target)
+				break;
+		if (dimm)
+			break;
+	}
+
+	blk_avail_orig = ndctl_region_get_available_size(region);
+	for (i = 1; i < NUM_NAMESPACES - 1; i++) {
+		ndns = namespaces[i];
+		sprintf(devname, "%s", ndctl_namespace_get_devname(ndns));
+		destroy_namespace(ndns);
+		blk_avail = ndctl_region_get_available_size(region);
+		if (blk_avail != blk_avail_orig) {
+			fprintf(stderr, "multi-pmem: destroy %s %llx avail, expect %llx\n",
+					devname, blk_avail, blk_avail_orig);
+			return -ENXIO;
+		}
+	}
+
+	ndns = namespaces[NUM_NAMESPACES - 1];
+	sprintf(devname, "%s", ndctl_namespace_get_devname(ndns));
+	destroy_namespace(ndns);
+	blk_avail = ndctl_region_get_available_size(region);
+	expect = (SZ_NAMESPACE / ndctl_region_get_interleave_ways(target))
+		* (NUM_NAMESPACES - 1) + blk_avail_orig;
+	if (blk_avail != expect) {
+		fprintf(stderr, "multi-pmem: destroy %s %llx avail, expect %llx\n",
+				devname, blk_avail, expect);
+		return -ENXIO;
+	}
+
+	ndctl_bus_foreach(ctx, bus) {
+		if (strncmp(ndctl_bus_get_provider(bus), "nfit_test", 9) != 0)
+			continue;
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	}
+
+	return 0;
+}
+
+int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
+{
+	struct kmod_module *mod;
+	struct kmod_ctx *kmod_ctx;
+	int err, result = EXIT_FAILURE;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
+		return 77;
+
+	ndctl_set_log_priority(ctx, loglevel);
+
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
+	result = do_multi_pmem(ctx, test);
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
+	rc = test_multi_pmem(LOG_DEBUG, test, ctx);
+	ndctl_unref(ctx);
+	return ndctl_test_result(test, rc);
+}
diff --git a/util/size.h b/util/size.h
index 9befecb28b14..50917a5cea34 100644
--- a/util/size.h
+++ b/util/size.h
@@ -5,6 +5,8 @@
 #define SZ_1M     0x00100000
 #define SZ_2M     0x00200000
 #define SZ_4M     0x00400000
+#define SZ_16M    0x01000000
+#define SZ_64M    0x04000000
 #define SZ_1G     0x40000000
 #define SZ_1T 0x10000000000ULL
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
