Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id A467F1A1DF6
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:41 -0700 (PDT)
Subject: [ndctl PATCH 5/5] ndctl: fall back to nfit_test for test/{blk|pmem}-ns
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:55 -0700
Message-ID: <20160317005455.3025.68568.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
References: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
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

Prevent these tests from bitrotting going forward by arranging for them
to be run against nfit_test resources in the case that an ACPI.NFIT
provider is not found.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk_namespaces.c  |   56 ++++++++++++++++++++++++++++++++----------
 test/pmem_namespaces.c |   64 ++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 92 insertions(+), 28 deletions(-)

diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index db30a1fe567c..b4d677b4d0d6 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -27,6 +27,7 @@
 #include <uuid/uuid.h>
 #include <linux/version.h>
 #include <test.h>
+#include <libkmod.h>
 
 /* The purpose of this test is to verify that we can successfully do I/O to
  * multiple nd_blk namespaces that have discontiguous segments.  It first
@@ -44,8 +45,6 @@
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
 
-static const char *provider = "ACPI.NFIT";
-
 static struct ndctl_namespace *create_blk_namespace(int region_fraction,
 		struct ndctl_region *region)
 {
@@ -214,9 +213,11 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	char bdev[50];
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
-	struct ndctl_namespace *ndns[2], *_n;
-	struct ndctl_region *region, *blk_region = NULL;
+	struct kmod_module *mod;
 	struct ndctl_dimm *dimm;
+	struct kmod_ctx *kmod_ctx;
+	struct ndctl_namespace *ndns[2];
+	struct ndctl_region *region, *blk_region = NULL;
 
 	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
 		return 77;
@@ -227,12 +228,33 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 
 	ndctl_set_log_priority(ctx, log_level);
 
-	bus = ndctl_bus_get_by_provider(ctx, provider);
+	kmod_ctx = kmod_new(NULL, NULL);
+	if (!kmod_ctx)
+		goto err_kmod;
+	kmod_set_log_priority(kmod_ctx, log_level);
+
+	rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
+	if (rc < 0)
+		goto err_module;
+
+	rc = kmod_module_probe_insert_module(mod, KMOD_PROBE_APPLY_BLACKLIST,
+			NULL, NULL, NULL, NULL);
+	if (rc < 0) {
+		rc = 77;
+		ndctl_test_skip(test);
+		fprintf(stderr, "nfit_test unavailable skipping tests\n");
+		goto err_module;
+	}
+
+	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
+	if (!bus)
+		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+
 	if (!bus) {
 		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
 		ndctl_test_skip(test);
 		rc = 77;
-		goto err_nobus;
+		goto err_cleanup;
 	} else {
 		fprintf(stderr, "%s: found provider: %s\n", comm,
 				ndctl_bus_get_provider(bus));
@@ -314,15 +336,21 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	rc = 0;
 
  err_cleanup:
-	if (blk_region) {
-		ndctl_namespace_foreach_safe(blk_region, ndns[0], _n)
-			if (ndctl_namespace_get_size(ndns[0]) != 0)
-				disable_blk_namespace(ndns[0]);
-	}
-
- err_nobus:
+	/* unload nfit_test */
+	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	if (bus)
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.1");
+	if (bus)
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	kmod_module_remove_module(mod, 0);
+
+ err_module:
+	kmod_unref(kmod_ctx);
+ err_kmod:
 	ndctl_unref(ctx);
-
 	return rc;
 }
 
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index f7dfce618c1a..198f8ef0cb37 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -25,14 +25,13 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <libkmod.h>
 #include <linux/version.h>
 #include <test.h>
 
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
 
-static const char *provider = "ACPI.NFIT";
-
 static struct ndctl_namespace *create_pmem_namespace(struct ndctl_region *region)
 {
 	struct ndctl_namespace *seed_ns = NULL;
@@ -175,7 +174,9 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 {
 	struct ndctl_region *region, *pmem_region = NULL;
 	struct ndctl_namespace *ndns;
+	struct kmod_ctx *kmod_ctx;
 	struct ndctl_dimm *dimm;
+	struct kmod_module *mod;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 	char bdev[50];
@@ -190,7 +191,28 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 
 	ndctl_set_log_priority(ctx, log_level);
 
-	bus = ndctl_bus_get_by_provider(ctx, provider);
+	kmod_ctx = kmod_new(NULL, NULL);
+	if (!kmod_ctx)
+		goto err_kmod;
+	kmod_set_log_priority(kmod_ctx, log_level);
+
+	rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
+	if (rc < 0)
+		goto err_module;
+
+	rc = kmod_module_probe_insert_module(mod, KMOD_PROBE_APPLY_BLACKLIST,
+			NULL, NULL, NULL, NULL);
+	if (rc < 0) {
+		rc = 77;
+		ndctl_test_skip(test);
+		fprintf(stderr, "nfit_test unavailable skipping tests\n");
+		goto err_module;
+	}
+
+	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
+	if (!bus)
+		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+
 	if (!bus) {
 		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
 		ndctl_test_skip(test);
@@ -202,16 +224,16 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 
 	/* get the system to a clean state */
         ndctl_region_foreach(bus, region)
-                ndctl_region_disable_invalidate(region);
-
-        ndctl_dimm_foreach(bus, dimm) {
-                rc = ndctl_dimm_zero_labels(dimm);
-                if (rc < 0) {
-                        fprintf(stderr, "failed to zero %s\n",
-                                        ndctl_dimm_get_devname(dimm));
-                        return rc;
-                }
-        }
+		ndctl_region_disable_invalidate(region);
+
+	ndctl_dimm_foreach(bus, dimm) {
+		rc = ndctl_dimm_zero_labels(dimm);
+		if (rc < 0) {
+			fprintf(stderr, "failed to zero %s\n",
+					ndctl_dimm_get_devname(dimm));
+			goto err;
+		}
+	}
 
 	/* create our config */
 	ndctl_region_foreach(bus, region)
@@ -237,9 +259,23 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 	rc = ns_do_io(bdev);
 
 	disable_pmem_namespace(ndns);
+
  err:
+	/* unload nfit_test */
+	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+	if (bus)
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	bus = ndctl_bus_get_by_provider(ctx, "nfit_test.1");
+	if (bus)
+		ndctl_region_foreach(bus, region)
+			ndctl_region_disable_invalidate(region);
+	kmod_module_remove_module(mod, 0);
+
+ err_module:
+	kmod_unref(kmod_ctx);
+ err_kmod:
 	ndctl_unref(ctx);
-
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
