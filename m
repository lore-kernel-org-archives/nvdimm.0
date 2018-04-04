Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9AFD12252648A
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 15:12:23 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: export ndctl.h
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 15:02:27 -0700
Message-ID: <152287934701.9679.14197084162568828006.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The ndctl project maintains a local version of the ndctl.h header file
published by the kernel. Given that the kernel header may be out of date
relative to the header used to build ndctl, provide the local version in
ndctl/ndctl.h alongside ndctl/libndctl.h so that consumers of the
library have access to the same definitions used to build the library.

Reported-by: Juston Li <juston.li@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/Makefile.am         |    2 +-
 ndctl/ndctl.h                 |    2 ++
 test/ack-shutdown-count-set.c |    3 ---
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index e3a12e7177e9..77970399bf00 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -3,7 +3,7 @@ include $(top_srcdir)/Makefile.am.in
 %.pc: %.pc.in Makefile
 	$(SED_PROCESS)
 
-pkginclude_HEADERS = ../libndctl.h
+pkginclude_HEADERS = ../libndctl.h ../ndctl.h
 lib_LTLIBRARIES = libndctl.la
 
 libndctl_la_SOURCES =\
diff --git a/ndctl/ndctl.h b/ndctl/ndctl.h
index ebd2a41cce46..c6aaa4c0981f 100644
--- a/ndctl/ndctl.h
+++ b/ndctl/ndctl.h
@@ -13,7 +13,9 @@
 #ifndef __NDCTL_H__
 #define __NDCTL_H__
 
+#ifndef ARRAY_SIZE
 #include <ccan/array_size/array_size.h>
+#endif
 #include <linux/types.h>
 #include <sys/user.h>
 #include <unistd.h>
diff --git a/test/ack-shutdown-count-set.c b/test/ack-shutdown-count-set.c
index ef38176442f1..6766c5f3b021 100644
--- a/test/ack-shutdown-count-set.c
+++ b/test/ack-shutdown-count-set.c
@@ -15,9 +15,6 @@
 
 #include <ccan/array_size/array_size.h>
 #include <ndctl/libndctl.h>
-#ifdef HAVE_NDCTL_H
-#include <linux/ndctl.h>
-#else
 #include <ndctl.h>
 #endif
 #include <test.h>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
