Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4871020352AA7
 for <linux-nvdimm@lists.01.org>; Fri,  1 Dec 2017 15:29:47 -0800 (PST)
Subject: [ndctl PATCH 17/17] ndctl, test: hugetlb fault
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Dec 2017 15:25:59 -0800
Message-ID: <151217075965.28402.12790882591361777536.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Compliment the fsdax and devdax huge page tests with hugetlbfs tests
since they share some of the same code paths.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/Makefile.am |    4 ++++
 test/dax-pmd.c   |   45 ++++++++++++++++++++++++++++++++++++++++++---
 test/hugetlb.c   |   29 +++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 3 deletions(-)
 create mode 100644 test/hugetlb.c

diff --git a/test/Makefile.am b/test/Makefile.am
index d4c2bd6b2640..a8e047bfd36c 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -16,6 +16,7 @@ TESTS =\
 	blk-exhaust.sh \
 	sector-mode.sh \
 	inject-error.sh \
+	hugetlb \
 	btt-errors.sh
 
 check_PROGRAMS =\
@@ -27,6 +28,7 @@ check_PROGRAMS =\
 	dax-errors \
 	smart-notify \
 	smart-listen \
+	hugetlb \
 	daxdev-errors
 
 if ENABLE_DESTRUCTIVE
@@ -82,6 +84,8 @@ dax_dev_SOURCES = dax-dev.c $(testcore)
 dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
 dax_pmd_SOURCES = dax-pmd.c
+hugetlb_SOURCES = hugetlb.c \
+		  dax-pmd.c
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
 daxdev_errors_SOURCES = daxdev-errors.c \
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 1a296aff32ea..06fe52200e4f 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <sys/stat.h>
@@ -42,12 +43,50 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 		return -ENOMEM;
 
 	for (i = 0; i < 5; i++) {
-		void *addr = mmap(dax_addr, 2*align,
-				PROT_READ|PROT_WRITE, MAP_SHARED, dax_fd,
-				offset);
+		unsigned long flags;
+		void *addr;
 		int fd2;
 
+		if (dax_fd >= 0)
+			flags = MAP_SHARED;
+		else {
+			/* hugetlbfs instead of device-dax */
+			const char *base = "/sys/kernel/mm/hugepages";
+			FILE *f_nrhuge;
+			char path[256];
+
+			flags = MAP_SHARED | MAP_ANONYMOUS;
+			if (align >= SZ_2M) {
+				char setting[] = { "2\n" };
+
+				sprintf(path, "%s/hugepages-%ldkB/nr_hugepages",
+						base, align / 1024);
+				f_nrhuge = fopen(path, "r+");
+				if (!f_nrhuge) {
+					rc = -errno;
+					faili(i);
+					return rc;
+				}
+				if (fwrite(setting, sizeof(setting), 1, f_nrhuge) != 1) {
+					rc = -errno;
+					faili(i);
+					fclose(f_nrhuge);
+					return rc;
+				}
+				fclose(f_nrhuge);
+
+				/* FIXME: support non-x86 page sizes */
+				if (align > SZ_2M)
+					flags |= MAP_HUGETLB | MAP_HUGE_1GB;
+				else
+					flags |= MAP_HUGETLB | MAP_HUGE_2MB;
+			}
+		}
+		addr = mmap(dax_addr, 2*align,
+				PROT_READ|PROT_WRITE, flags, dax_fd, offset);
+
 		if (addr == MAP_FAILED) {
+			rc = -errno;
 			faili(i);
 			break;
 		}
diff --git a/test/hugetlb.c b/test/hugetlb.c
new file mode 100644
index 000000000000..a08a93ad40f3
--- /dev/null
+++ b/test/hugetlb.c
@@ -0,0 +1,29 @@
+#include <stdio.h>
+#include <errno.h>
+
+#include <ccan/array_size/array_size.h>
+#include <util/size.h>
+#include <test.h>
+
+static int test_hugetlb(void)
+{
+	int rc, i;
+	unsigned long aligns[] = { SZ_4K, SZ_2M, SZ_1G };
+
+	for (i = 0; i < (int) ARRAY_SIZE(aligns); i++) {
+		fprintf(stderr, "%s: page_size: %#lx\n", __func__, aligns[i]);
+		rc = test_dax_directio(-1, aligns[i], NULL, 0);
+		if (rc == -ENOMEM || rc == -EACCES)
+			return 77;
+		else if (rc == -ENOENT && aligns[i] == SZ_1G)
+			continue; /* system not configured for 1G pages */
+		else if (rc)
+			return rc;
+	}
+	return 0;
+}
+
+int __attribute__((weak)) main(int argc, char *argv[])
+{
+	return test_hugetlb();
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
