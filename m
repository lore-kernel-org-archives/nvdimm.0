Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4210221DFA91C
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:07 -0700 (PDT)
Subject: [ndctl PATCH 1/6] ndctl: drop "builtin" prefix from source file names
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:13:57 -0700
Message-ID: <149074283709.18735.7744448841642627131.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The "builtin" designation is a hold over from the initial duplication of
git infrastructure where builtin commands are differentiated from shell
helper commands. Since ndctl only has the former the prefix is not
useful.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am                 |   16 ++++++++--------
 ndctl/bat.c                       |    0 
 ndctl/check.c                     |    0 
 ndctl/create-nfit.c               |    0 
 ndctl/dimm.c                      |    0 
 ndctl/list.c                      |    0 
 ndctl/namespace.c                 |    0 
 ndctl/region.c                    |    0 
 ndctl/test.c                      |    0 
 test/Makefile.am                  |    8 ++++----
 10 files changed, 12 insertions(+), 12 deletions(-)
 rename ndctl/{builtin-bat.c => bat.c} (100%)
 rename ndctl/{builtin-check.c => check.c} (100%)
 rename ndctl/{builtin-create-nfit.c => create-nfit.c} (100%)
 rename ndctl/{builtin-dimm.c => dimm.c} (100%)
 rename ndctl/{builtin-list.c => list.c} (100%)
 rename ndctl/{builtin-xaction-namespace.c => namespace.c} (100%)
 rename ndctl/{builtin-xable-region.c => region.c} (100%)
 rename ndctl/{builtin-test.c => test.c} (100%)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index f9158d9cce63..d346c041d74b 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -3,14 +3,14 @@ include $(top_srcdir)/Makefile.am.in
 bin_PROGRAMS = ndctl
 
 ndctl_SOURCES = ndctl.c \
-		builtin-create-nfit.c \
-		builtin-xaction-namespace.c \
-		builtin-check.c \
-		builtin-xable-region.c \
-		builtin-dimm.c \
+		create-nfit.c \
+		namespace.c \
+		check.c \
+		region.c \
+		dimm.c \
 		 ../util/log.c \
-		builtin-list.c \
-		builtin-test.c \
+		list.c \
+		test.c \
 		../util/json.c
 
 if ENABLE_SMART
@@ -20,7 +20,7 @@ endif
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
 		 ../test/pmem_namespaces.c
-ndctl_SOURCES += builtin-bat.c
+ndctl_SOURCES += bat.c
 endif
 
 ndctl_LDADD =\
diff --git a/ndctl/builtin-bat.c b/ndctl/bat.c
similarity index 100%
rename from ndctl/builtin-bat.c
rename to ndctl/bat.c
diff --git a/ndctl/builtin-check.c b/ndctl/check.c
similarity index 100%
rename from ndctl/builtin-check.c
rename to ndctl/check.c
diff --git a/ndctl/builtin-create-nfit.c b/ndctl/create-nfit.c
similarity index 100%
rename from ndctl/builtin-create-nfit.c
rename to ndctl/create-nfit.c
diff --git a/ndctl/builtin-dimm.c b/ndctl/dimm.c
similarity index 100%
rename from ndctl/builtin-dimm.c
rename to ndctl/dimm.c
diff --git a/ndctl/builtin-list.c b/ndctl/list.c
similarity index 100%
rename from ndctl/builtin-list.c
rename to ndctl/list.c
diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/namespace.c
similarity index 100%
rename from ndctl/builtin-xaction-namespace.c
rename to ndctl/namespace.c
diff --git a/ndctl/builtin-xable-region.c b/ndctl/region.c
similarity index 100%
rename from ndctl/builtin-xable-region.c
rename to ndctl/region.c
diff --git a/ndctl/builtin-test.c b/ndctl/test.c
similarity index 100%
rename from ndctl/builtin-test.c
rename to ndctl/test.c
diff --git a/test/Makefile.am b/test/Makefile.am
index 3fdd2272b4eb..969fe055b35e 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -79,8 +79,8 @@ device_dax_SOURCES = \
 		dax-dev.c \
 		dax-pmd.c \
 		$(testcore) \
-		../ndctl/builtin-xaction-namespace.c \
-		../ndctl/builtin-check.c \
+		../ndctl/namespace.c \
+		../ndctl/check.c \
 		../util/json.c
 device_dax_LDADD = \
 		$(LIBNDCTL_LIB) \
@@ -91,8 +91,8 @@ device_dax_LDADD = \
 multi_pmem_SOURCES = \
 		multi-pmem.c \
 		$(testcore) \
-		../ndctl/builtin-xaction-namespace.c \
-		../ndctl/builtin-check.c \
+		../ndctl/namespace.c \
+		../ndctl/check.c \
 		../util/json.c
 multi_pmem_LDADD = \
 		$(LIBNDCTL_LIB) \

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
