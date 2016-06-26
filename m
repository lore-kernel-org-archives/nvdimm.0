Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 146731A1E04
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:25:50 -0700 (PDT)
Subject: [ndctl PATCH 1/9] ndctl: deprecate pcommit
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:33 -0700
Message-ID: <146698347368.40541.11822733854183836110.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that the kernel no longer has pcommit support, remove the ndctl
test.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am   |    3 +-
 ndctl/builtin-bat.c |    5 ---
 test.h              |    1 -
 test/Makefile.am    |    5 ---
 test/pcommit.c      |   76 ---------------------------------------------------
 5 files changed, 1 insertion(+), 89 deletions(-)
 delete mode 100644 test/pcommit.c

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 56cd9292ef59..27e5182e28b5 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -52,8 +52,7 @@ endif
 
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
-		 ../test/pmem_namespaces.c \
-		 ../test/pcommit.c
+		 ../test/pmem_namespaces.c
 ndctl_SOURCES += builtin-bat.c
 endif
 
diff --git a/ndctl/builtin-bat.c b/ndctl/builtin-bat.c
index ca6fd121f3a7..a83eb0fec063 100644
--- a/ndctl/builtin-bat.c
+++ b/ndctl/builtin-bat.c
@@ -39,11 +39,6 @@ int cmd_bat(int argc, const char **argv)
 		return EXIT_FAILURE;
 	}
 
-	rc = test_pcommit(test);
-	fprintf(stderr, "test_pcommit: %s\n", rc ? "FAIL" : "PASS");
-	if (rc && rc != 77)
-		return rc;
-
 	rc = test_blk_namespaces(loglevel, test);
 	fprintf(stderr, "test_blk_namespaces: %s\n", rc ? "FAIL" : "PASS");
 	if (rc && rc != 77)
diff --git a/test.h b/test.h
index 61ca05f489fa..5425be1bc107 100644
--- a/test.h
+++ b/test.h
@@ -18,5 +18,4 @@ int test_dpa_alloc(int loglevel, struct ndctl_test *test);
 int test_libndctl(int loglevel, struct ndctl_test *test);
 int test_blk_namespaces(int loglevel, struct ndctl_test *test);
 int test_pmem_namespaces(int loglevel, struct ndctl_test *test);
-int test_pcommit(struct ndctl_test *test);
 #endif /* __TEST_H__ */
diff --git a/test/Makefile.am b/test/Makefile.am
index ad10caa439bf..ed9981583331 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -18,7 +18,6 @@ if ENABLE_DESTRUCTIVE
 TESTS +=\
 	blk-ns \
 	pmem-ns \
-	pcommit \
 	dax-dev \
 	dax.sh \
 	mmap.sh
@@ -26,7 +25,6 @@ TESTS +=\
 check_PROGRAMS +=\
 	blk-ns \
 	pmem-ns \
-	pcommit \
 	dax-dev \
 	dax-pmd \
 	mmap
@@ -39,9 +37,6 @@ LIBNDCTL_LIB =\
 libndctl_SOURCES = libndctl.c core.c
 libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
 
-pcommit_SOURCES = pcommit.c core.c
-pcommit_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
-
 blk_ns_SOURCES = blk_namespaces.c core.c
 blk_ns_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
 
diff --git a/test/pcommit.c b/test/pcommit.c
deleted file mode 100644
index ea5e82f3773d..000000000000
--- a/test/pcommit.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/*
- * test-pcommit: Make sure PCOMMIT is supported by the platform.
- *
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU Lesser General Public License,
- * version 2.1, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT ANY
- * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
- * more details.
- */
-#include <errno.h>
-#include <stdio.h>
-#include <string.h>
-#include <test.h>
-#include <stdlib.h>
-#include <linux/version.h>
-
-#define err(msg)\
-	fprintf(stderr, "%s:%d: %s (%s)\n", __func__, __LINE__, msg, strerror(errno))
-
-int test_pcommit(struct ndctl_test *test)
-{
-	const char *pcommit = "pcommit";
-	const char *flags = "flags";
-	const int buffer_size = 1024;
-
-	char buffer[buffer_size];
-	FILE *cpuinfo;
-	char *token;
-
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 0, 0)))
-		return 77;
-
-	cpuinfo = fopen("/proc/cpuinfo", "r");
-	if (!cpuinfo) {
-		err("open");
-		return -ENXIO;
-	}
-
-        while (fgets(buffer, buffer_size, cpuinfo)) {
-		token = strtok(buffer, " :");
-
-		if (token &&
-		    strncmp(token, flags, strlen(flags)) != 0)
-			continue;
-
-		while (token != NULL) {
-			token = strtok(NULL, " ");
-			if (token &&
-			    strncmp(token, pcommit, strlen(pcommit)) == 0) {
-				fclose(cpuinfo);
-				return 0;
-			}
-		}
-        }
-
-	fclose(cpuinfo);
-	ndctl_test_skip(test);
-	return 77;
-}
-
-int __attribute__((weak)) main(int argc, char *argv[])
-{
-	struct ndctl_test *test = ndctl_test_new(0);
-
-	if (!test) {
-		fprintf(stderr, "failed to initialize test\n");
-		return EXIT_FAILURE;
-	}
-
-	return test_pcommit(test);
-}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
