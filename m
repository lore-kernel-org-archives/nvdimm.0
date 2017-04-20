Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D40892194EB63
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 14:04:57 -0700 (PDT)
Subject: [ndctl PATCH 1/5] test: teach nfit_test_init to only expect
 device-dax on v4.7+
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 20 Apr 2017 13:59:04 -0700
Message-ID: <149272194448.23427.1991038457299500600.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149272193912.23427.11500536718990091103.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h                 |    2 +-
 test/blk_namespaces.c  |    2 +-
 test/core.c            |   11 ++++++++++-
 test/dpa-alloc.c       |    2 +-
 test/dsm-fail.c        |    2 +-
 test/multi-pmem.c      |    2 +-
 test/parent-uuid.c     |    2 +-
 test/pmem_namespaces.c |    2 +-
 8 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/test.h b/test.h
index 5d17398c02f4..8abe13dd410c 100644
--- a/test.h
+++ b/test.h
@@ -17,7 +17,7 @@ void builtin_xaction_namespace_reset(void);
 struct kmod_ctx;
 struct kmod_module;
 int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
-	int log_level);
+	int log_level, struct ndctl_test *test);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 1f112744e605..178f73cacb16 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -244,7 +244,7 @@ int test_blk_namespaces(int log_level, struct ndctl_test *test,
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = nfit_test_init(&kmod_ctx, &mod, log_level);
+		rc = nfit_test_init(&kmod_ctx, &mod, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {
diff --git a/test/core.c b/test/core.c
index a2f2c76b1d29..1f6dd5966404 100644
--- a/test/core.c
+++ b/test/core.c
@@ -104,7 +104,7 @@ int ndctl_test_get_skipped(struct ndctl_test *test)
 }
 
 int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
-		int log_level)
+		int log_level, struct ndctl_test *test)
 {
 	int rc;
 	unsigned int i;
@@ -142,6 +142,15 @@ int nfit_test_init(struct kmod_ctx **ctx, struct kmod_module **mod,
 		int state;
 
 		name = list[i];
+
+		/*
+		 * Don't check for device-dax modules on kernels older
+		 * than 4.7.
+		 */
+		if (strstr(name, "dax")
+				&& !ndctl_test_attempt(test,
+					KERNEL_VERSION(4, 7, 0)))
+			continue;
 retry:
 		rc = kmod_module_new_from_name(*ctx, name, mod);
 		if (rc) {
diff --git a/test/dpa-alloc.c b/test/dpa-alloc.c
index 53656cab1004..9c80fa3fc8c9 100644
--- a/test/dpa-alloc.c
+++ b/test/dpa-alloc.c
@@ -299,7 +299,7 @@ int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 		return 77;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");
diff --git a/test/dsm-fail.c b/test/dsm-fail.c
index 0f82e7e3c4ad..22ec94451146 100644
--- a/test/dsm-fail.c
+++ b/test/dsm-fail.c
@@ -171,7 +171,7 @@ int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx)
 	int result = EXIT_FAILURE, err;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
 	if (err < 0) {
 		result = 77;
 		ndctl_test_skip(test);
diff --git a/test/multi-pmem.c b/test/multi-pmem.c
index a8c286cc49c7..abd5f3657eed 100644
--- a/test/multi-pmem.c
+++ b/test/multi-pmem.c
@@ -253,7 +253,7 @@ int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx
 
 	ndctl_set_log_priority(ctx, loglevel);
 
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
 	if (err < 0) {
 		result = 77;
 		ndctl_test_skip(test);
diff --git a/test/parent-uuid.c b/test/parent-uuid.c
index fbe1c5b0c8ee..87ea4d75b5a5 100644
--- a/test/parent-uuid.c
+++ b/test/parent-uuid.c
@@ -229,7 +229,7 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ct
 		return 77;
 
 	ndctl_set_log_priority(ctx, loglevel);
-	err = nfit_test_init(&kmod_ctx, &mod, loglevel);
+	err = nfit_test_init(&kmod_ctx, &mod, loglevel, test);
 	if (err < 0) {
 		ndctl_test_skip(test);
 		fprintf(stderr, "nfit_test unavailable skipping tests\n");
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 2d3ad736b0bb..94a5986955b3 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -208,7 +208,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 
 	if (!bus) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
-		rc = nfit_test_init(&kmod_ctx, &mod, log_level);
+		rc = nfit_test_init(&kmod_ctx, &mod, log_level, test);
 		ndctl_invalidate(ctx);
 		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
 		if (rc < 0 || !bus) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
