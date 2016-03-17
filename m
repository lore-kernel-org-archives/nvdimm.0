Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 8E7161A1DEA
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:36 -0700 (PDT)
Subject: [ndctl PATCH 4/5] ndctl: convert 'ndctl bat' to use struct ndctl_test
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:50 -0700
Message-ID: <20160317005450.3025.88521.stgit@dwillia2-desk3.jf.intel.com>
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

This gives the bat test the ability to skip tests based on kernel
version and report test results in the same format as 'ndctl test'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am            |   12 ++++++------
 builtin-bat.c          |   27 +++++++++++++++++++++------
 test.h                 |    6 +++---
 test/blk_namespaces.c  |   18 ++++++++++++++++--
 test/pcommit.c         |   19 ++++++++++++++++---
 test/pmem_namespaces.c |   18 ++++++++++++++++--
 6 files changed, 78 insertions(+), 22 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 84582771e97d..eaf544a96284 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -97,13 +97,13 @@ ndctl_SOURCES = ndctl.c \
 		util/size.c \
 		util/strbuf.c \
 		util/wrapper.c \
-		util/filter.c
+		util/filter.c \
+		test/core.c
 
 if ENABLE_TEST
 ndctl_SOURCES += test/libndctl.c \
 		 test/dpa-alloc.c \
-		 test/parent-uuid.c \
-		 test/core.c
+		 test/parent-uuid.c
 endif
 
 if ENABLE_DESTRUCTIVE
@@ -158,13 +158,13 @@ endif
 test_libndctl_SOURCES = test/libndctl.c test/core.c
 test_libndctl_LDADD = lib/libndctl.la $(UUID_LIBS) $(KMOD_LIBS)
 
-test_pcommit_SOURCES = test/pcommit.c
+test_pcommit_SOURCES = test/pcommit.c test/core.c
 test_pcommit_LDADD = lib/libndctl.la $(KMOD_LIBS)
 
-test_blk_ns_SOURCES = test/blk_namespaces.c
+test_blk_ns_SOURCES = test/blk_namespaces.c test/core.c
 test_blk_ns_LDADD = lib/libndctl.la $(KMOD_LIBS)
 
-test_pmem_ns_SOURCES = test/pmem_namespaces.c
+test_pmem_ns_SOURCES = test/pmem_namespaces.c test/core.c
 test_pmem_ns_LDADD = lib/libndctl.la $(KMOD_LIBS)
 
 test_dpa_alloc_SOURCES = test/dpa-alloc.c test/core.c
diff --git a/builtin-bat.c b/builtin-bat.c
index 14ef08b756b1..ca6fd121f3a7 100644
--- a/builtin-bat.c
+++ b/builtin-bat.c
@@ -1,11 +1,14 @@
 #include <stdio.h>
 #include <syslog.h>
 #include <test.h>
+#include <limits.h>
 #include <util/parse-options.h>
 
 int cmd_bat(int argc, const char **argv)
 {
 	int loglevel = LOG_DEBUG, i, rc;
+	struct ndctl_test *test;
+	bool force = false;
 	const char * const u[] = {
 		"ndctl bat [<options>]",
 		NULL
@@ -13,6 +16,8 @@ int cmd_bat(int argc, const char **argv)
 	const struct option options[] = {
 	OPT_INTEGER('l', "loglevel", &loglevel,
 		"set the log level (default LOG_DEBUG)"),
+	OPT_BOOLEAN('f', "force", &force,
+		"force run all tests regardless of required kernel"),
 	OPT_END(),
 	};
 
@@ -24,17 +29,27 @@ int cmd_bat(int argc, const char **argv)
 	if (argc)
 		usage_with_options(u, options);
 
-	rc = test_pcommit();
+	if (force)
+		test = ndctl_test_new(UINT_MAX);
+	else
+		test = ndctl_test_new(0);
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = test_pcommit(test);
 	fprintf(stderr, "test_pcommit: %s\n", rc ? "FAIL" : "PASS");
-	if (rc)
+	if (rc && rc != 77)
 		return rc;
 
-	rc = test_blk_namespaces(loglevel);
+	rc = test_blk_namespaces(loglevel, test);
 	fprintf(stderr, "test_blk_namespaces: %s\n", rc ? "FAIL" : "PASS");
-	if (rc)
+	if (rc && rc != 77)
 		return rc;
 
-	rc = test_pmem_namespaces(loglevel);
+	rc = test_pmem_namespaces(loglevel, test);
 	fprintf(stderr, "test_pmem_namespaces: %s\n", rc ? "FAIL" : "PASS");
-	return rc;
+	return ndctl_test_result(test, rc);
 }
diff --git a/test.h b/test.h
index d58dc8874dda..61ca05f489fa 100644
--- a/test.h
+++ b/test.h
@@ -16,7 +16,7 @@ int test_parent_uuid(int loglevel, struct ndctl_test *test);
 int test_direct_io(int loglevel, struct ndctl_test *test);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test);
 int test_libndctl(int loglevel, struct ndctl_test *test);
-int test_blk_namespaces(int loglevel);
-int test_pmem_namespaces(int loglevel);
-int test_pcommit(void);
+int test_blk_namespaces(int loglevel, struct ndctl_test *test);
+int test_pmem_namespaces(int loglevel, struct ndctl_test *test);
+int test_pcommit(struct ndctl_test *test);
 #endif /* __TEST_H__ */
diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index f3e7a5592e2a..db30a1fe567c 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <linux/version.h>
 #include <test.h>
 
 /* The purpose of this test is to verify that we can successfully do I/O to
@@ -207,7 +208,7 @@ static int ns_do_io(const char *bdev)
 
 static const char *comm = "test-blk-namespaces";
 
-int test_blk_namespaces(int log_level)
+int test_blk_namespaces(int log_level, struct ndctl_test *test)
 {
 	int rc;
 	char bdev[50];
@@ -217,6 +218,9 @@ int test_blk_namespaces(int log_level)
 	struct ndctl_region *region, *blk_region = NULL;
 	struct ndctl_dimm *dimm;
 
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
+		return 77;
+
 	rc = ndctl_new(&ctx);
 	if (rc < 0)
 		return rc;
@@ -226,6 +230,7 @@ int test_blk_namespaces(int log_level)
 	bus = ndctl_bus_get_by_provider(ctx, provider);
 	if (!bus) {
 		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
+		ndctl_test_skip(test);
 		rc = 77;
 		goto err_nobus;
 	} else {
@@ -323,6 +328,15 @@ int test_blk_namespaces(int log_level)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
+	struct ndctl_test *test = ndctl_test_new(0);
+	int rc;
+
 	comm = argv[0];
-	return test_blk_namespaces(LOG_DEBUG);
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = test_blk_namespaces(LOG_DEBUG, test);
+	return ndctl_test_result(test, rc);
 }
diff --git a/test/pcommit.c b/test/pcommit.c
index 3ef09a5074a4..ea5e82f3773d 100644
--- a/test/pcommit.c
+++ b/test/pcommit.c
@@ -16,11 +16,13 @@
 #include <stdio.h>
 #include <string.h>
 #include <test.h>
+#include <stdlib.h>
+#include <linux/version.h>
 
 #define err(msg)\
 	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
 
-int test_pcommit(void)
+int test_pcommit(struct ndctl_test *test)
 {
 	const char *pcommit = "pcommit";
 	const char *flags = "flags";
@@ -30,10 +32,13 @@ int test_pcommit(void)
 	FILE *cpuinfo;
 	char *token;
 
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 0, 0)))
+		return 77;
+
 	cpuinfo = fopen("/proc/cpuinfo", "r");
 	if (!cpuinfo) {
 		err("open");
-		return EBADF;
+		return -ENXIO;
 	}
 
         while (fgets(buffer, buffer_size, cpuinfo)) {
@@ -54,10 +59,18 @@ int test_pcommit(void)
         }
 
 	fclose(cpuinfo);
+	ndctl_test_skip(test);
 	return 77;
 }
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
-	return test_pcommit();
+	struct ndctl_test *test = ndctl_test_new(0);
+
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	return test_pcommit(test);
 }
diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
index 24f307df0c81..f7dfce618c1a 100644
--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -25,6 +25,7 @@
 #include <sys/types.h>
 #include <unistd.h>
 #include <uuid/uuid.h>
+#include <linux/version.h>
 #include <test.h>
 
 #define err(msg)\
@@ -170,7 +171,7 @@ static int ns_do_io(const char *bdev)
 
 static const char *comm = "test-pmem-namespaces";
 
-int test_pmem_namespaces(int log_level)
+int test_pmem_namespaces(int log_level, struct ndctl_test *test)
 {
 	struct ndctl_region *region, *pmem_region = NULL;
 	struct ndctl_namespace *ndns;
@@ -180,6 +181,9 @@ int test_pmem_namespaces(int log_level)
 	char bdev[50];
 	int rc;
 
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 2, 0)))
+		return 77;
+
 	rc = ndctl_new(&ctx);
 	if (rc < 0)
 		return rc;
@@ -189,6 +193,7 @@ int test_pmem_namespaces(int log_level)
 	bus = ndctl_bus_get_by_provider(ctx, provider);
 	if (!bus) {
 		fprintf(stderr, "%s: failed to find NFIT-provider\n", comm);
+		ndctl_test_skip(test);
 		rc = 77;
 		goto err;
 	} else
@@ -240,6 +245,15 @@ int test_pmem_namespaces(int log_level)
 
 int __attribute__((weak)) main(int argc, char *argv[])
 {
+	struct ndctl_test *test = ndctl_test_new(0);
+	int rc;
+
 	comm = argv[0];
-	return test_pmem_namespaces(LOG_DEBUG);
+	if (!test) {
+		fprintf(stderr, "failed to initialize test\n");
+		return EXIT_FAILURE;
+	}
+
+	rc = test_pmem_namespaces(LOG_DEBUG, test);
+	return ndctl_test_result(test, rc);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
