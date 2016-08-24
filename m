Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DB331A1E2B
 for <linux-nvdimm@lists.01.org>; Wed, 24 Aug 2016 10:17:51 -0700 (PDT)
Subject: [ndctl PATCH] test: add device-dax direct-i/o test
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Aug 2016 10:15:28 -0700
Message-ID: <147205892817.13782.16283776602958182643.stgit@dwillia2-desk3.amr.corp.intel.com>
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

A recent kernel bug report [1], highlighted the need to test page
structure mappings and direct-i/o for device dax.  Repurpose the
existing filesystem-dax test for this case.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-August/006704.html

Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am  |    1 
 test/dax-pmd.c    |  147 +++++++++++++++++++++++++++++------------------------
 test/device-dax.c |   10 ++++
 3 files changed, 92 insertions(+), 66 deletions(-)

diff --git a/test.h b/test.h
index 331d4131e2c7..2940ac0f7396 100644
--- a/test.h
+++ b/test.h
@@ -16,7 +16,7 @@ void builtin_xaction_namespace_reset(void);
 
 struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
-int test_direct_io(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
+int test_dax_directio(int dax_fd, void *dax_addr, off_t offset);
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_blk_namespaces(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/Makefile.am b/test/Makefile.am
index d13c138bb28a..f0240fe5883a 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -60,6 +60,7 @@ dax_errors_SOURCES = dax-errors.c
 device_dax_SOURCES = \
 		device-dax.c \
 		dax-dev.c \
+		dax-pmd.c \
 		core.c \
 		../ndctl/builtin-xaction-namespace.c \
 		../ndctl/util/json.c
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index ff0c70e9ea47..47f254e398b2 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -10,84 +10,35 @@
 #include <sys/ioctl.h>
 #include <stdlib.h>
 #include <linux/fs.h>
+#include <test.h>
 #include <linux/fiemap.h>
 
 #define NUM_EXTENTS 5
 #define HPAGE_SIZE (2 << 20)
 #define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
 #define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
-#define faili(i) fprintf(stderr, "%s: failed at: %d: %ld\n", __func__, __LINE__, i)
+#define faili(i) fprintf(stderr, "%s: failed at: %d: %d\n", __func__, __LINE__, i)
 #define TEST_FILE "test_dax_data"
 
-/* test_pmd assumes that fd references a pre-allocated + dax-capable file */
-static int test_pmd(int fd)
+int test_dax_directio(int dax_fd, void *dax_addr, off_t offset)
 {
-	unsigned long long m_align, p_align;
-	int fd2 = -1, rc = -ENXIO;
-	struct fiemap_extent *ext;
-	void *base, *addr, *buf;
-	struct fiemap *map;
-	unsigned long i;
-
-	if (fd < 0) {
-		fail();
-		return -ENXIO;
-	}
-
-	map = calloc(1, sizeof(struct fiemap)
-			+ sizeof(struct fiemap_extent) * NUM_EXTENTS);
-	if (!map) {
-		fail();
-		return -ENXIO;
-	}
+	int i, rc = -ENXIO;
+	void *buf;
 
 	if (posix_memalign(&buf, 4096, 4096) != 0)
-		goto err_memalign;
-
-	base = mmap(NULL, 4*HPAGE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	if (base == MAP_FAILED) {
-		fail();
-		goto err_mmap;
-	}
-	munmap(base, 4*HPAGE_SIZE);
-
-	map->fm_start = 0;
-	map->fm_length = -1;
-	map->fm_extent_count = NUM_EXTENTS;
-	rc = ioctl(fd, FS_IOC_FIEMAP, map);
-	if (rc < 0) {
-		fail();
-		goto err_extent;
-	}
-
-	for (i = 0; i < map->fm_mapped_extents; i++) {
-		ext = &map->fm_extents[i];
-		fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
-				i, ext->fe_logical, ext->fe_physical,
-				ext->fe_length, ext->fe_flags);
-		if (ext->fe_length > 2 * HPAGE_SIZE) {
-			fprintf(stderr, "found potential huge extent\n");
-			break;
-		}
-	}
-
-	if (i >= map->fm_mapped_extents) {
-		fail();
-		goto err_extent;
-	}
-
-	m_align = ALIGN(base, HPAGE_SIZE) - ((unsigned long) base);
-	p_align = ALIGN(ext->fe_physical, HPAGE_SIZE) - ext->fe_physical;
+		return -ENOMEM;
 
 	for (i = 0; i < 3; i++) {
-		rc = -ENXIO;
-		addr = mmap((char *) base + m_align, 2*HPAGE_SIZE,
-				PROT_READ|PROT_WRITE, MAP_SHARED, fd,
-				ext->fe_logical + p_align);
+		void *addr = mmap(dax_addr, 2*HPAGE_SIZE,
+				PROT_READ|PROT_WRITE, MAP_SHARED, dax_fd,
+				offset);
+		int fd2;
+
 		if (addr == MAP_FAILED) {
 			faili(i);
 			break;
 		}
+		rc = -ENXIO;
 
 		fd2 = open(TEST_FILE, O_CREAT|O_TRUNC|O_DIRECT|O_RDWR,
 				DEFFILEMODE);
@@ -97,7 +48,7 @@ static int test_pmd(int fd)
 			break;
 		}
 
-		fprintf(stderr, "%s: test: %ld\n", __func__, i);
+		fprintf(stderr, "%s: test: %d\n", __func__, i);
 		rc = 0;
 		switch (i) {
 		case 0: /* test O_DIRECT of unfaulted address */
@@ -131,8 +82,10 @@ static int test_pmd(int fd)
 			} else if (rc > 0) {
 				/* parent */
 				wait(&rc);
-				if (rc != EXIT_SUCCESS)
+				rc = WEXITSTATUS(rc);
+				if (rc != EXIT_SUCCESS) {
 					faili(i);
+				}
 			} else
 				faili(i);
 			break;
@@ -151,15 +104,77 @@ static int test_pmd(int fd)
 			break;
 	}
 
+	free(buf);
+	return rc;
+}
+
+/* test_pmd assumes that fd references a pre-allocated + dax-capable file */
+static int test_pmd(int fd)
+{
+	unsigned long long m_align, p_align;
+	struct fiemap_extent *ext;
+	struct fiemap *map;
+	int rc = -ENXIO;
+	unsigned long i;
+	void *base;
+
+	if (fd < 0) {
+		fail();
+		return -ENXIO;
+	}
+
+	map = calloc(1, sizeof(struct fiemap)
+			+ sizeof(struct fiemap_extent) * NUM_EXTENTS);
+	if (!map) {
+		fail();
+		return -ENXIO;
+	}
+
+	base = mmap(NULL, 4*HPAGE_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (base == MAP_FAILED) {
+		fail();
+		goto err_mmap;
+	}
+	munmap(base, 4*HPAGE_SIZE);
+
+	map->fm_start = 0;
+	map->fm_length = -1;
+	map->fm_extent_count = NUM_EXTENTS;
+	rc = ioctl(fd, FS_IOC_FIEMAP, map);
+	if (rc < 0) {
+		fail();
+		goto err_extent;
+	}
+
+	for (i = 0; i < map->fm_mapped_extents; i++) {
+		ext = &map->fm_extents[i];
+		fprintf(stderr, "[%ld]: l: %llx p: %llx len: %llx flags: %x\n",
+				i, ext->fe_logical, ext->fe_physical,
+				ext->fe_length, ext->fe_flags);
+		if (ext->fe_length > 2 * HPAGE_SIZE) {
+			fprintf(stderr, "found potential huge extent\n");
+			break;
+		}
+	}
+
+	if (i >= map->fm_mapped_extents) {
+		fail();
+		goto err_extent;
+	}
+
+	m_align = ALIGN(base, HPAGE_SIZE) - ((unsigned long) base);
+	p_align = ALIGN(ext->fe_physical, HPAGE_SIZE) - ext->fe_physical;
+
+	rc = test_dax_directio(fd, (char *) base + m_align, ext->fe_logical
+			+ p_align);
+
  err_extent:
  err_mmap:
-	free(buf);
- err_memalign:
 	free(map);
 	return rc;
 }
 
-int main(int argc, char *argv[])
+int __attribute__((weak)) main(int argc, char *argv[])
 {
 	int fd, rc;
 
diff --git a/test/device-dax.c b/test/device-dax.c
index fdd138884522..34ca284f2ef5 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -117,6 +117,16 @@ static int test_device_dax(int loglevel, struct ndctl_test *test,
 	p = (int *) (buf + (1UL << 20));
 	*p = 0;
 
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 9, 0))) {
+		/* prior to 4.8-final this crashes */
+		rc = test_dax_directio(fd, NULL, 0);
+		if (rc) {
+			fprintf(stderr, "%s: failed dax direct-i/o\n",
+					ndctl_namespace_get_devname(ndns));
+			return rc;
+		}
+	}
+
 	rc = reset_device_dax(ndns);
 	if (rc < 0) {
 		fprintf(stderr, "%s: failed to reset device-dax instance\n",

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
