Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7FBA21A10961
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:28:59 -0800 (PST)
Subject: [ndctl PATCH 08/17] ndctl,
 test: reset all nfit_test data for each test/libndctl run
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:12 -0800
Message-ID: <151217071253.28402.991007933773283137.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151217066885.28402.7962437173336388439.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for tests that write smart threshold and injected-smart
values arrange for nfit_test to be completely reloaded for each test
run. I.e. it is no longer sufficient to just clear label data and reset
regions.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h                 |    3 ++-
 test/blk_namespaces.c  |    2 +-
 test/core.c            |   25 ++++++++++++++++++++++++-
 test/dpa-alloc.c       |    2 +-
 test/dsm-fail.c        |    2 +-
 test/libndctl.c        |    2 +-
 test/multi-pmem.c      |    2 +-
 test/parent-uuid.c     |    2 +-
 test/pmem_namespaces.c |    2 +-
 9 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/test.h b/test.h
index 1ff350a9c1ba..5f2d6293c104 100644
--- a/test.h
+++ b/test.h
@@ -29,7 +29,8 @@ void builtin_xaction_namespace_reset(void);
 struct kmod_ctx;
 struct kmod_module;
 int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
-	int log_level, struct ndctl_test *test);
+		struct ndctl_ctx *nd_ctx, int log_level,
+		struct ndctl_test *test);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 7b33bfd0528b..b587ab93fbb8 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -239,7 +239,7 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test,
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = nfit_test_init(&kmod_ctx, &mod, log_level, test);
+		rc = nfit_test_init(&kmod_ctx, &mod, NULL, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {
diff --git a/test/core.c b/test/core.c
index e0806ed24058..ca983e4913f7 100644
--- a/test/core.c
+++ b/test/core.c
@@ -20,6 +20,7 @@
 
 #include <util/log.h>
 #include <util/sysfs.h>
+#include <ndctl/libndctl.h>
 #include <ccan/array_size/array_size.h>
 
 #define KVER_STRLEN 20
@@ -116,11 +117,13 @@ int ndctl_test_get_skipped(struct ndctl_test *test)
 }
 
 int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
-		int log_level, struct ndctl_test *test)
+		struct ndctl_ctx *nd_ctx, int log_level,
+		struct ndctl_test *test)
 {
 	int rc;
 	unsigned int i;
 	const char *name;
+	struct ndctl_bus *bus;
 	struct log_ctx log_ctx;
 	const char *list[] = {
 		"nfit",
@@ -219,6 +222,26 @@ retry:
 		return rc;
 	}
 
+	if (nd_ctx) {
+		/* caller wants a full nfit_test reset */
+		ndctl_bus_foreach(nd_ctx, bus) {
+			struct ndctl_region *region;
+
+			if (strncmp(ndctl_bus_get_provider(bus),
+						"nfit_test", 9) != 0)
+				continue;
+			ndctl_region_foreach(bus, region)
+				ndctl_region_disable_invalidate(region);
+		}
+
+		rc = kmod_module_remove_module(*mod, 0);
+		if (rc < 0 && rc != -ENOENT) {
+			kmod_unref(*ctx);
+			return rc;
+		}
+		ndctl_invalidate(nd_ctx);
+	}
+
 	rc = kmod_module_probe_insert_module(*mod, KMOD_PROBE_APPLY_BLACKLIST,
 			NULL, NULL, NULL, NULL);
 	if (rc)
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 9ab10f90293a..7793650699da 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -287,7 +287,7 @@ int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 		return 77;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
+	err = nfit_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index b363decc29c8..90d3e074f12b 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -167,7 +167,7 @@ int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	int result = EXIT_FAILURE, err;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
+	err = nfit_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
 	if (err < 0) {
 		result = 77;
 		ndctl_test_skip(test);
diff --git a/test/libndctl.c b/test/libndctl.c
index b534b640cb8d..b10142ebdee4 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2567,7 +2567,7 @@ int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	daxctl_set_log_priority(daxctl_ctx, loglevel);
 	ndctl_set_private_data(ctx, test);
 
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
+	err = nfit_test_init(&kmod_ctx, &mod, ctx, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index b3054f44b5dd..668662cded25 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -260,7 +260,7 @@ int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx
 
 	ndctl_set_log_priority(ctx, loglevel);
 
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
+	err = nfit_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
 	if (err < 0) {
 		result = 77;
 		ndctl_test_skip(test);
diff --git a/test/parent-uuid.c b/test/parent-uuid.c
index 87ea4d75b5a5..3a63f7244e21 100644
--- a/test/parent-uuid.c
+++ b/test/parent-uuid.c
@@ -229,7 +229,7 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ct
 		return 77;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
+	err = nfit_test_init(&kmod_ctx, &mod, NULL, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 69e87abc592f..eac56ce25d58 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -203,7 +203,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = nfit_test_init(&kmod_ctx, &mod, log_level, test);
+		rc = nfit_test_init(&kmod_ctx, &mod, NULL, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
