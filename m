Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id D267C1A1E24
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:17 -0700 (PDT)
Subject: [ndctl PATCH 5/8] test: refactor / export ndctl_get_test_dev()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:54 -0700
Message-ID: <147136811433.27902.16225655275740887590.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Provide a common C api for tests to locate an "memmap=ss!nn" defined
namespace for destructive tests.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h         |    3 ++-
 test/dax-dev.c |   42 +++++++++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/test.h b/test.h
index 1ac03aa09762..120798f2dd75 100644
--- a/test.h
+++ b/test.h
@@ -1,7 +1,7 @@
 #ifndef __TEST_H__
 #define __TEST_H__
 struct ndctl_test;
-struct ndctl_test;
+struct ndctl_ctx;
 struct ndctl_test *ndctl_test_new(unsigned int kver);
 int ndctl_test_result(struct ndctl_test *test, int rc);
 int ndctl_test_get_skipped(struct ndctl_test *test);
@@ -11,6 +11,7 @@ int __ndctl_test_attempt(struct ndctl_test *test, unsigned int kver,
 #define ndctl_test_attempt(t, v) __ndctl_test_attempt(t, v, __func__, __LINE__)
 void __ndctl_test_skip(struct ndctl_test *test, const char *caller, int line);
 #define ndctl_test_skip(t) __ndctl_test_skip(t, __func__, __LINE__)
+struct ndctl_namespace *ndctl_get_test_dev(struct ndctl_ctx *ctx);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/dax-dev.c b/test/dax-dev.c
index 519df324fdc8..0183b7af2052 100755
--- a/test/dax-dev.c
+++ b/test/dax-dev.c
@@ -25,12 +25,11 @@
 #include <linux/version.h>
 #include <ndctl/libndctl.h>
 
-static int emit_e820_device(int loglevel, struct ndctl_test *test)
+struct ndctl_namespace *ndctl_get_test_dev(struct ndctl_ctx *ctx)
 {
-	int err, fd;
 	char path[256];
 	const char *bdev;
-	struct ndctl_ctx *ctx;
+	int fd, rc = -ENXIO;
 	struct ndctl_bus *bus;
 	struct ndctl_dax *dax;
 	struct ndctl_pfn *pfn;
@@ -38,15 +37,6 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	struct ndctl_namespace *ndns;
 	enum ndctl_namespace_mode mode;
 
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
-		return 77;
-
-	err = ndctl_new(&ctx);
-	if (err < 0)
-		return err;
-
-	ndctl_set_log_priority(ctx, loglevel);
-	err = -ENXIO;
 	bus = ndctl_bus_get_by_provider(ctx, "e820");
 	if (!bus)
 		goto out;
@@ -85,16 +75,38 @@ static int emit_e820_device(int loglevel, struct ndctl_test *test)
 	fd = open(path, O_RDWR | O_EXCL);
 	if (fd < 0)
 		goto out;
-	err = 0;
+	close(fd);
+	rc = 0;
 
  out:
-	if (err) {
+	return rc ? NULL : ndns;
+}
+
+static int emit_e820_device(int loglevel, struct ndctl_test *test)
+{
+	int err;
+	struct ndctl_ctx *ctx;
+	struct ndctl_namespace *ndns;
+
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
+		return 77;
+
+	err = ndctl_new(&ctx);
+	if (err < 0)
+		return err;
+
+	ndctl_set_log_priority(ctx, loglevel);
+
+	ndns = ndctl_get_test_dev(ctx);
+	if (!ndns) {
 		fprintf(stderr, "%s: failed to find usable victim device\n",
 				__func__);
 		ndctl_test_skip(test);
 		err = 77;
-	} else
+	} else {
 		fprintf(stdout, "%s\n", ndctl_namespace_get_devname(ndns));
+		err = 0;
+	}
 	ndctl_unref(ctx);
 	return err;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
