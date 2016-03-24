Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id BABA61A1E95
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:18:26 -0700 (PDT)
Subject: [ndctl PATCH 2/2] ndctl: don't skip bat tests if nfit_test not
 available
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:16:59 -0700
Message-ID: <20160324011658.20651.86424.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
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

The 'blk-ns' and 'pmem-ns' tests are meant to fallback to nfit_test, but
not require nfit_test.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk_namespaces.c  |   62 +++++++++++++++++++++++-------------------------
 test/pmem_namespaces.c |   55 ++++++++++++++++++++-----------------------
 2 files changed, 56 insertions(+), 61 deletions(-)

diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index b4d677b4d0d6..0ef5b65fd511 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -213,9 +213,9 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	char bdev[50];
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
-	struct kmod_module *mod;
 	struct ndctl_dimm *dimm;
-	struct kmod_ctx *kmod_ctx;
+	struct kmod_module *mod = NULL;
+	struct kmod_ctx *kmod_ctx = NULL;
 	struct ndctl_namespace *ndns[2];
 	struct ndctl_region *region, *blk_region = NULL;
 
@@ -228,38 +228,34 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 
 	ndctl_set_log_priority(ctx, log_level);
 
-	kmod_ctx = kmod_new(NULL, NULL);
-	if (!kmod_ctx)
-		goto err_kmod;
-	kmod_set_log_priority(kmod_ctx, log_level);
-
-	rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
-	if (rc < 0)
-		goto err_module;
-
-	rc = kmod_module_probe_insert_module(mod, KMOD_PROBE_APPLY_BLACKLIST,
-			NULL, NULL, NULL, NULL);
-	if (rc < 0) {
-		rc = 77;
-		ndctl_test_skip(test);
-		fprintf(stderr, "nfit_test unavailable skipping tests\n");
-		goto err_module;
-	}
-
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
-	if (!bus)
-		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
-
 	if (!bus) {
-		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
-		ndctl_test_skip(test);
-		rc = 77;
-		goto err_cleanup;
-	} else {
-		fprintf(stderr, "%s: found provider: %s\n", comm,
-				ndctl_bus_get_provider(bus));
+		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
+		kmod_ctx = kmod_new(NULL, NULL);
+		if (!kmod_ctx)
+			goto err_kmod;
+		kmod_set_log_priority(kmod_ctx, log_level);
+
+		rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
+		if (rc < 0)
+			goto err_module;
+
+		rc = kmod_module_probe_insert_module(mod,
+				KMOD_PROBE_APPLY_BLACKLIST,
+				NULL, NULL, NULL, NULL);
+		ndctl_invalidate(ctx);
+		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+		if (rc < 0 || !bus) {
+			rc = 77;
+			ndctl_test_skip(test);
+			fprintf(stderr, "nfit_test unavailable skipping tests\n");
+			goto err_module;
+		}
 	}
 
+	fprintf(stderr, "%s: found provider: %s\n", comm,
+			ndctl_bus_get_provider(bus));
+
 	/* get the system to a clean state */
         ndctl_region_foreach(bus, region)
                 ndctl_region_disable_invalidate(region);
@@ -345,10 +341,12 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test)
 	if (bus)
 		ndctl_region_foreach(bus, region)
 			ndctl_region_disable_invalidate(region);
-	kmod_module_remove_module(mod, 0);
+	if (mod)
+		kmod_module_remove_module(mod, 0);
 
  err_module:
-	kmod_unref(kmod_ctx);
+	if (kmod_ctx)
+		kmod_unref(kmod_ctx);
  err_kmod:
 	ndctl_unref(ctx);
 	return rc;
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 198f8ef0cb37..387c5e011f66 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -173,10 +173,10 @@ static const char *comm = "test-pmem-namespaces";
 int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 {
 	struct ndctl_region *region, *pmem_region = NULL;
+	struct kmod_ctx *kmod_ctx = NULL;
+	struct kmod_module *mod = NULL;
 	struct ndctl_namespace *ndns;
-	struct kmod_ctx *kmod_ctx;
 	struct ndctl_dimm *dimm;
-	struct kmod_module *mod;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
 	char bdev[50];
@@ -191,36 +191,33 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 
 	ndctl_set_log_priority(ctx, log_level);
 
-	kmod_ctx = kmod_new(NULL, NULL);
-	if (!kmod_ctx)
-		goto err_kmod;
-	kmod_set_log_priority(kmod_ctx, log_level);
-
-	rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
-	if (rc < 0)
-		goto err_module;
-
-	rc = kmod_module_probe_insert_module(mod, KMOD_PROBE_APPLY_BLACKLIST,
-			NULL, NULL, NULL, NULL);
-	if (rc < 0) {
-		rc = 77;
-		ndctl_test_skip(test);
-		fprintf(stderr, "nfit_test unavailable skipping tests\n");
-		goto err_module;
-	}
-
 	bus = ndctl_bus_get_by_provider(ctx, "ACPI.NFIT");
-	if (!bus)
+	if (!bus) {
+		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
+		kmod_ctx = kmod_new(NULL, NULL);
+		if (!kmod_ctx)
+			goto err_kmod;
+		kmod_set_log_priority(kmod_ctx, log_level);
+
+		rc = kmod_module_new_from_name(kmod_ctx, "nfit_test", &mod);
+		if (rc < 0)
+			goto err_module;
+
+		rc = kmod_module_probe_insert_module(mod,
+				KMOD_PROBE_APPLY_BLACKLIST,
+				NULL, NULL, NULL, NULL);
+		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
+		if (rc < 0 || !bus) {
+			rc = 77;
+			ndctl_test_skip(test);
+			fprintf(stderr, "nfit_test unavailable skipping tests\n");
+			goto err_module;
+		}
+	}
 
-	if (!bus) {
-		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
-		ndctl_test_skip(test);
-		rc = 77;
-		goto err;
-	} else
-		fprintf(stderr, "%s: found provider: %s\n", comm,
-				ndctl_bus_get_provider(bus));
+	fprintf(stderr, "%s: found provider: %s\n", comm,
+			ndctl_bus_get_provider(bus));
 
 	/* get the system to a clean state */
         ndctl_region_foreach(bus, region)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
