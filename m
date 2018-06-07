Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F69D2119486B
 for <linux-nvdimm@lists.01.org>; Wed,  6 Jun 2018 21:28:34 -0700 (PDT)
Subject: [ndctl PATCH] test: Add device-dax MADV_HWPOISON test
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 06 Jun 2018 21:18:37 -0700
Message-ID: <152834511700.12835.4831071398400754767.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Reuse test_dax_poison() for triggering memory_failure() on device-dax
huge/gigantic page mappings.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test.h            |    4 ++++
 test/dax-pmd.c    |   34 +++++++++++++++++++++++++---------
 test/device-dax.c |   28 +++++++++++++++++++---------
 3 files changed, 48 insertions(+), 18 deletions(-)

diff --git a/test.h b/test.h
index 5f2d6293c104..ce873f51f7aa 100644
--- a/test.h
+++ b/test.h
@@ -12,6 +12,8 @@
  */
 #ifndef __TEST_H__
 #define __TEST_H__
+#include <stdbool.h>
+
 struct ndctl_test;
 struct ndctl_ctx;
 struct ndctl_test *ndctl_test_new(unsigned int kver);
@@ -36,6 +38,8 @@ struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset);
+int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
+		off_t offset, bool fsdax);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index abff4f9fd199..65110b7c6a4c 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -27,6 +27,7 @@
 #include <test.h>
 #include <util/size.h>
 #include <linux/fiemap.h>
+#include <stdbool.h>
 
 #define NUM_EXTENTS 5
 #define fail() fprintf(stderr, "%s: failed at: %d (%s)\n", \
@@ -217,8 +218,8 @@ static void sigbus_hdl(int sig, siginfo_t *si, void *ptr)
 	siglongjmp(sj_env, 1);
 }
 
-static int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
-		off_t offset)
+int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
+		off_t offset, bool fsdax)
 {
 	unsigned char *addr = MAP_FAILED;
 	struct sigaction act;
@@ -226,6 +227,13 @@ static int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
 	void *buf;
 	int rc;
 
+	/*
+	 * MADV_HWPOISON must be page aligned, and this routine assumes
+	 * align is >= 8K
+	 */
+	if (align < SZ_2M)
+		return 0;
+
 	if (posix_memalign(&buf, 4096, 4096) != 0)
 		return -ENOMEM;
 
@@ -240,13 +248,15 @@ static int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
 	}
 
 	/* dirty the block on disk to bypass the default zero page */
-	rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
-	if (rc < 4096) {
-		fail();
-		rc = -ENXIO;
-		goto out;
+	if (fsdax) {
+		rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
+		if (rc < 4096) {
+			fail();
+			rc = -ENXIO;
+			goto out;
+		}
+		fsync(dax_fd);
 	}
-	fsync(dax_fd);
 
 	addr = mmap(dax_addr, 2*align, PROT_READ|PROT_WRITE,
 			MAP_SHARED_VALIDATE|MAP_POPULATE|MAP_SYNC, dax_fd, offset);
@@ -281,6 +291,11 @@ clear_error:
 		goto out;
 	}
 
+	if (!fsdax) {
+		rc = 0;
+		goto out;
+	}
+
 	rc = fallocate(dax_fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
 			offset + align / 2, 4096);
 	if (rc) {
@@ -312,6 +327,7 @@ out:
 static int test_pmd(int fd)
 {
 	unsigned long long m_align, p_align, pmd_off;
+	static const bool fsdax = true;
 	struct fiemap_extent *ext;
 	void *base, *pmd_addr;
 	struct fiemap *map;
@@ -371,7 +387,7 @@ static int test_pmd(int fd)
 	if (rc)
 		goto err_directio;
 
-	rc = test_dax_poison(fd, HPAGE_SIZE, pmd_addr, pmd_off);
+	rc = test_dax_poison(fd, HPAGE_SIZE, pmd_addr, pmd_off, fsdax);
 
  err_directio:
  err_extent:
diff --git a/test/device-dax.c b/test/device-dax.c
index 0a42a327c96d..712c247adfb2 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -151,15 +151,6 @@ static int __test_device_dax(unsigned long align, int loglevel,
 	struct daxctl_region *dax_region;
 	char *buf, path[100], data[VERIFY_BUF_SIZE];
 
-	memset (&act, 0, sizeof(act));
-	act.sa_sigaction = sigbus;
-	act.sa_flags = SA_SIGINFO;
-
-	if (sigaction(SIGBUS, &act, 0)) {
-		perror("sigaction");
-		return 1;
-	}
-
 	ndctl_set_log_priority(ctx, loglevel);
 
 	ndns = ndctl_get_test_dev(ctx);
@@ -276,6 +267,7 @@ static int __test_device_dax(unsigned long align, int loglevel,
 	 * otherwise not supported.
 	 */
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
+		static const bool devdax = false;
 		int fd2;
 
 		rc = test_dax_directio(fd, align, NULL, 0);
@@ -285,6 +277,15 @@ static int __test_device_dax(unsigned long align, int loglevel,
 			goto out;
 		}
 
+		fprintf(stderr, "%s: test dax poison\n",
+				ndctl_namespace_get_devname(ndns));
+		rc = test_dax_poison(fd, align, NULL, 0, devdax);
+		if (rc) {
+			fprintf(stderr, "%s: failed dax poison\n",
+					ndctl_namespace_get_devname(ndns));
+			goto out;
+		}
+
 		fd2 = open("/proc/self/smaps", O_RDONLY);
 		if (fd2 < 0) {
 			fprintf(stderr, "%s: failed smaps open\n",
@@ -312,6 +313,15 @@ static int __test_device_dax(unsigned long align, int loglevel,
 		goto out;
 	}
 
+	memset(&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus;
+	act.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGBUS, &act, 0)) {
+		perror("sigaction");
+		rc = EXIT_FAILURE;
+		goto out;
+	}
+
 	/* test fault after device-dax instance disabled */
 	if (sigsetjmp(sj_env, 1)) {
 		/* got sigbus, success */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
