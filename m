Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 832372034D83F
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 12:43:21 -0800 (PST)
Subject: [ndctl PATCH] ndctl, test: improve dax gup test coverage
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Nov 2017 12:39:09 -0800
Message-ID: <151034634989.27121.6767031057018403016.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Add tests for read-only to read-write conversions of dax mappings and
for the gup slow path where the initial fault is a write fault. The
gup-slow-path write fault path has been broken for the pud case since it
was introduced upstream.

Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/dax-pmd.c |   39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 6276913a0fda..1a296aff32ea 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -27,8 +27,10 @@
 #include <linux/fiemap.h>
 
 #define NUM_EXTENTS 5
-#define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
-#define faili(i) fprintf(stderr, "%s: failed at: %d: %d\n", __func__, __LINE__, i)
+#define fail() fprintf(stderr, "%s: failed at: %d (%s)\n", \
+	__func__, __LINE__, strerror(errno))
+#define faili(i) fprintf(stderr, "%s: failed at: %d: %d (%s)\n", \
+	__func__, __LINE__, i, strerror(errno))
 #define TEST_FILE "test_dax_data"
 
 int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset)
@@ -39,7 +41,7 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 	if (posix_memalign(&buf, 4096, 4096) != 0)
 		return -ENOMEM;
 
-	for (i = 0; i < 3; i++) {
+	for (i = 0; i < 5; i++) {
 		void *addr = mmap(dax_addr, 2*align,
 				PROT_READ|PROT_WRITE, MAP_SHARED, dax_fd,
 				offset);
@@ -62,11 +64,20 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 		fprintf(stderr, "%s: test: %d\n", __func__, i);
 		rc = 0;
 		switch (i) {
-		case 0: /* test O_DIRECT of unfaulted address */
+		case 0: /* test O_DIRECT read of unfaulted address */
 			if (write(fd2, addr, 4096) != 4096) {
 				faili(i);
 				rc = -ENXIO;
 			}
+
+			/*
+			 * test O_DIRECT write of pre-faulted read-only
+			 * address
+			 */
+			if (pread(fd2, addr, 4096, 0) != 4096) {
+				faili(i);
+				rc = -ENXIO;
+			}
 			break;
 		case 1: /* test O_DIRECT of pre-faulted address */
 			sprintf(addr, "odirect data");
@@ -100,6 +111,26 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 			} else
 				faili(i);
 			break;
+		case 3: /* convert ro mapping to rw */
+			rc = *(volatile int *) addr;
+			*(volatile int *) addr = rc;
+			rc = 0;
+			break;
+		case 4: /* test O_DIRECT write of unfaulted address */
+			sprintf(buf, "O_DIRECT write of unfaulted address\n");
+			if (pwrite(fd2, buf, 4096, 0) < 4096) {
+				faili(i);
+				rc = -ENXIO;
+				break;
+			}
+
+			if (pread(fd2, addr, 4096, 0) < 4096) {
+				faili(i);
+				rc = -ENXIO;
+				break;
+			}
+			rc = 0;
+			break;
 		default:
 			faili(i);
 			rc = -ENXIO;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
