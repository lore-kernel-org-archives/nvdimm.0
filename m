Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD51E211944C4
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 13:54:40 -0800 (PST)
Subject: [ndctl PATCH] ndctl, build: Define HAVE_UUID
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 13:42:12 -0800
Message-ID: <154344133285.1069420.11463868512402749463.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Attempts to build ndctl in an epel-6 environment fail with the following
messages:

    In file included from util/filter.c:24:
    ./daxctl/libdaxctl.h:22: error: redefinition of typedef 'uuid_t'
    ./ndctl/libndctl.h:26: note: previous declaration of 'uuid_t' was here

Newer compilers discard the error since it sees the types are
compatible, but the definition should be coming from uuid.h when built
with libuuid. Arrange for an AC_DEFINE for the HAVE_UUID symbol when
libuuid is detected by PKG_CHECK_MODULES.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 configure.ac       |    3 ++-
 daxctl/libdaxctl.h |    2 +-
 ndctl/libndctl.h   |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index bb6b03324ea8..de5b84cec670 100644
--- a/configure.ac
+++ b/configure.ac
@@ -112,7 +112,8 @@ AM_CONDITIONAL([ENABLE_POISON],
 
 PKG_CHECK_MODULES([KMOD], [libkmod])
 PKG_CHECK_MODULES([UDEV], [libudev])
-PKG_CHECK_MODULES([UUID], [uuid])
+PKG_CHECK_MODULES([UUID], [uuid],
+	[AC_DEFINE([HAVE_UUID], [1], [Define to 1 if using libuuid])])
 PKG_CHECK_MODULES([JSON], [json-c])
 
 AC_ARG_WITH([bash],
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 21bc376ce629..1d13ea291f6f 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -16,7 +16,7 @@
 #include <stdarg.h>
 #include <unistd.h>
 
-#ifdef HAVE_LIBUUID
+#ifdef HAVE_UUID
 #include <uuid/uuid.h>
 #else
 typedef unsigned char uuid_t[16];
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 62cef9e82da3..c81cc032ebae 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -20,7 +20,7 @@
 #include <errno.h>
 #include <limits.h>
 
-#ifdef HAVE_LIBUUID
+#ifdef HAVE_UUID
 #include <uuid/uuid.h>
 #else
 typedef unsigned char uuid_t[16];

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
