Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 360972034860A
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 10:03:01 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: autoconf detect BUS_MCEERR_AR
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 08 Jun 2018 09:53:03 -0700
Message-ID: <152847672050.34182.16344688151291100337.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The definition of BUS_MCEERR_AR is not available by default on older
glibc releases. Auto-detect this capability and de-feature the
MADV_HWPOISON injection tests if the definition is not found.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
This depends on "test: Add device-dax MADV_HWPOISON test"
https://patchwork.kernel.org/patch/10451131/

 configure.ac      |    5 ++
 test.h            |    8 +++
 test/Makefile.am  |    8 +++
 test/dax-pmd.c    |  130 ----------------------------------------------
 test/dax-poison.c |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 170 insertions(+), 130 deletions(-)
 create mode 100644 test/dax-poison.c

diff --git a/configure.ac b/configure.ac
index 02e8679ab707..17b5a657149c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -102,6 +102,11 @@ AS_IF([test "x$enable_test" = "xyes"],
 	[AC_DEFINE([ENABLE_TEST], [1], [ndctl test support])])
 AM_CONDITIONAL([ENABLE_TEST], [test "x$enable_test" = "xyes"])
 
+AC_CHECK_DECLS([BUS_MCEERR_AR], [enable_poison=yes], [], [[#include <signal.h>]])
+AS_IF([test "x$enable_poison" = "xyes"],
+	[AC_DEFINE([ENABLE_POISON], [1], [ndctl test poison support])])
+AM_CONDITIONAL([ENABLE_POISON], [test "x$enable_poison" = "xyes"])
+
 PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
 PKG_CHECK_MODULES([UUID], [uuid])
diff --git a/test.h b/test.h
index ce873f51f7aa..e627785a5334 100644
--- a/test.h
+++ b/test.h
@@ -38,8 +38,16 @@ struct ndctl_ctx;
 int test_parent_uuid(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_multi_pmem(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t offset);
+#ifdef ENABLE_POISON
 int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
 		off_t offset, bool fsdax);
+#else
+static inline int test_dax_poison(int dax_fd, unsigned long align,
+		void *dax_addr, off_t offset, bool fsdax)
+{
+	return 0;
+}
+#endif
 int test_dpa_alloc(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_dsm_fail(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
 int test_libndctl(int loglevel, struct ndctl_test *test, struct ndctl_ctx *ctx);
diff --git a/test/Makefile.am b/test/Makefile.am
index 496a663351c1..a9b8b3eccbbf 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -97,6 +97,7 @@ dax_dev_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 dax_pmd_SOURCES = dax-pmd.c
 hugetlb_SOURCES = hugetlb.c \
 		  dax-pmd.c
+
 mmap_SOURCES = mmap.c
 dax_errors_SOURCES = dax-errors.c
 daxdev_errors_SOURCES = daxdev-errors.c \
@@ -111,6 +112,13 @@ device_dax_SOURCES = \
 		../ndctl/namespace.c \
 		../ndctl/check.c \
 		../util/json.c
+
+if ENABLE_POISON
+dax_pmd_SOURCES += dax-poison.c
+hugetlb_SOURCES += dax-poison.c
+device_dax_SOURCES += dax-poison.c
+endif
+
 device_dax_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(KMOD_LIBS) \
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 65110b7c6a4c..0b4bd98edce4 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -27,7 +27,6 @@
 #include <test.h>
 #include <util/size.h>
 #include <linux/fiemap.h>
-#include <stdbool.h>
 
 #define NUM_EXTENTS 5
 #define fail() fprintf(stderr, "%s: failed at: %d (%s)\n", \
@@ -194,135 +193,6 @@ int test_dax_directio(int dax_fd, unsigned long align, void *dax_addr, off_t off
 	return rc;
 }
 
-static sigjmp_buf sj_env;
-static int sig_mcerr_ao, sig_mcerr_ar, sig_count;
-
-static void sigbus_hdl(int sig, siginfo_t *si, void *ptr)
-{
-	switch (si->si_code) {
-	case BUS_MCEERR_AO:
-		fprintf(stderr, "%s: BUS_MCEERR_AO addr: %p len: %d\n",
-			__func__, si->si_addr, 1 << si->si_addr_lsb);
-		sig_mcerr_ao++;
-		break;
-	case BUS_MCEERR_AR:
-		fprintf(stderr, "%s: BUS_MCEERR_AR addr: %p len: %d\n",
-			__func__, si->si_addr, 1 << si->si_addr_lsb);
-		sig_mcerr_ar++;
-		break;
-	default:
-		sig_count++;
-		break;
-	}
-
-	siglongjmp(sj_env, 1);
-}
-
-int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
-		off_t offset, bool fsdax)
-{
-	unsigned char *addr = MAP_FAILED;
-	struct sigaction act;
-	unsigned x = x;
-	void *buf;
-	int rc;
-
-	/*
-	 * MADV_HWPOISON must be page aligned, and this routine assumes
-	 * align is >= 8K
-	 */
-	if (align < SZ_2M)
-		return 0;
-
-	if (posix_memalign(&buf, 4096, 4096) != 0)
-		return -ENOMEM;
-
-	memset(&act, 0, sizeof(act));
-	act.sa_sigaction = sigbus_hdl;
-	act.sa_flags = SA_SIGINFO;
-
-	if (sigaction(SIGBUS, &act, 0)) {
-		fail();
-		rc = -errno;
-		goto out;
-	}
-
-	/* dirty the block on disk to bypass the default zero page */
-	if (fsdax) {
-		rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
-		if (rc < 4096) {
-			fail();
-			rc = -ENXIO;
-			goto out;
-		}
-		fsync(dax_fd);
-	}
-
-	addr = mmap(dax_addr, 2*align, PROT_READ|PROT_WRITE,
-			MAP_SHARED_VALIDATE|MAP_POPULATE|MAP_SYNC, dax_fd, offset);
-	if (addr == MAP_FAILED) {
-		fail();
-		rc = -errno;
-		goto out;
-	}
-
-	if (sigsetjmp(sj_env, 1)) {
-		if (sig_mcerr_ar) {
-			fprintf(stderr, "madvise triggered 'action required' sigbus\n");
-			goto clear_error;
-		} else if (sig_count) {
-			fail();
-			return -ENXIO;
-		}
-	}
-
-	rc = madvise(addr + align / 2, 4096, MADV_HWPOISON);
-	if (rc) {
-		fail();
-		rc = -errno;
-		goto out;
-	}
-
-	/* clear the error */
-clear_error:
-	if (!sig_mcerr_ar) {
-		fail();
-		rc = -ENXIO;
-		goto out;
-	}
-
-	if (!fsdax) {
-		rc = 0;
-		goto out;
-	}
-
-	rc = fallocate(dax_fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
-			offset + align / 2, 4096);
-	if (rc) {
-		fail();
-		rc = -errno;
-		goto out;
-	}
-
-	rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
-	if (rc < 4096) {
-		fail();
-		rc = -ENXIO;
-		goto out;
-	}
-	fsync(dax_fd);
-
-	/* check that we can fault in the poison page */
-	x = *(volatile unsigned *) addr + align / 2;
-	rc = 0;
-
-out:
-	if (addr != MAP_FAILED)
-		munmap(addr, 2 * align);
-	free(buf);
-	return rc;
-}
-
 /* test_pmd assumes that fd references a pre-allocated + dax-capable file */
 static int test_pmd(int fd)
 {
diff --git a/test/dax-poison.c b/test/dax-poison.c
new file mode 100644
index 000000000000..7faa402e623c
--- /dev/null
+++ b/test/dax-poison.c
@@ -0,0 +1,149 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <unistd.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
+#include <fcntl.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <stdlib.h>
+#include <linux/fs.h>
+#include <test.h>
+#include <util/size.h>
+#include <stdbool.h>
+
+#define fail() fprintf(stderr, "%s: failed at: %d (%s)\n", \
+	__func__, __LINE__, strerror(errno))
+
+static sigjmp_buf sj_env;
+static int sig_mcerr_ao, sig_mcerr_ar, sig_count;
+
+static void sigbus_hdl(int sig, siginfo_t *si, void *ptr)
+{
+	switch (si->si_code) {
+	case BUS_MCEERR_AO:
+		fprintf(stderr, "%s: BUS_MCEERR_AO addr: %p len: %d\n",
+			__func__, si->si_addr, 1 << si->si_addr_lsb);
+		sig_mcerr_ao++;
+		break;
+	case BUS_MCEERR_AR:
+		fprintf(stderr, "%s: BUS_MCEERR_AR addr: %p len: %d\n",
+			__func__, si->si_addr, 1 << si->si_addr_lsb);
+		sig_mcerr_ar++;
+		break;
+	default:
+		sig_count++;
+		break;
+	}
+
+	siglongjmp(sj_env, 1);
+}
+
+int test_dax_poison(int dax_fd, unsigned long align, void *dax_addr,
+		off_t offset, bool fsdax)
+{
+	unsigned char *addr = MAP_FAILED;
+	struct sigaction act;
+	unsigned x = x;
+	void *buf;
+	int rc;
+
+	/*
+	 * MADV_HWPOISON must be page aligned, and this routine assumes
+	 * align is >= 8K
+	 */
+	if (align < SZ_2M)
+		return 0;
+
+	if (posix_memalign(&buf, 4096, 4096) != 0)
+		return -ENOMEM;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_sigaction = sigbus_hdl;
+	act.sa_flags = SA_SIGINFO;
+
+	if (sigaction(SIGBUS, &act, 0)) {
+		fail();
+		rc = -errno;
+		goto out;
+	}
+
+	/* dirty the block on disk to bypass the default zero page */
+	if (fsdax) {
+		rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
+		if (rc < 4096) {
+			fail();
+			rc = -ENXIO;
+			goto out;
+		}
+		fsync(dax_fd);
+	}
+
+	addr = mmap(dax_addr, 2*align, PROT_READ|PROT_WRITE,
+			MAP_SHARED_VALIDATE|MAP_POPULATE|MAP_SYNC, dax_fd, offset);
+	if (addr == MAP_FAILED) {
+		fail();
+		rc = -errno;
+		goto out;
+	}
+
+	if (sigsetjmp(sj_env, 1)) {
+		if (sig_mcerr_ar) {
+			fprintf(stderr, "madvise triggered 'action required' sigbus\n");
+			goto clear_error;
+		} else if (sig_count) {
+			fail();
+			return -ENXIO;
+		}
+	}
+
+	rc = madvise(addr + align / 2, 4096, MADV_HWPOISON);
+	if (rc) {
+		fail();
+		rc = -errno;
+		goto out;
+	}
+
+	/* clear the error */
+clear_error:
+	if (!sig_mcerr_ar) {
+		fail();
+		rc = -ENXIO;
+		goto out;
+	}
+
+	if (!fsdax) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = fallocate(dax_fd, FALLOC_FL_PUNCH_HOLE|FALLOC_FL_KEEP_SIZE,
+			offset + align / 2, 4096);
+	if (rc) {
+		fail();
+		rc = -errno;
+		goto out;
+	}
+
+	rc = pwrite(dax_fd, buf, 4096, offset + align / 2);
+	if (rc < 4096) {
+		fail();
+		rc = -ENXIO;
+		goto out;
+	}
+	fsync(dax_fd);
+
+	/* check that we can fault in the poison page */
+	x = *(volatile unsigned *) addr + align / 2;
+	rc = 0;
+
+out:
+	if (addr != MAP_FAILED)
+		munmap(addr, 2 * align);
+	free(buf);
+	return rc;
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
