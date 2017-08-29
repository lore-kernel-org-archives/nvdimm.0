Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 674BE2095B9C8
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:45 -0700 (PDT)
Subject: [ndctl PATCH 2/7] ndctl: drop the "libndctl-" prefix on library
 source files
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:01:40 -0700
Message-ID: <150403690093.8240.4123334555138751671.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The "libndctl-" prefix is redundant given the source files already live
in the ndctl/lib/ directory. There is a similar story for removing the
"ndctl-" prefix on the vendor-specific / internal-only headers.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/Makefile.am        |   10 +++++-----
 ndctl/lib/ars.c              |    2 +-
 ndctl/lib/hpe1.c             |    4 ++--
 ndctl/lib/hpe1.h             |    0 
 ndctl/lib/libndctl.c         |    2 +-
 ndctl/lib/msft.c             |    4 ++--
 ndctl/lib/msft.h             |    0 
 ndctl/lib/private.h          |    4 ++--
 ndctl/lib/smart.c            |    2 +-
 9 files changed, 14 insertions(+), 14 deletions(-)
 rename ndctl/lib/{libndctl-ars.c => ars.c} (99%)
 rename ndctl/lib/{libndctl-hpe1.c => hpe1.c} (99%)
 rename ndctl/lib/{ndctl-hpe1.h => hpe1.h} (100%)
 rename ndctl/lib/{libndctl-msft.c => msft.c} (98%)
 rename ndctl/lib/{ndctl-msft.h => msft.h} (100%)
 rename ndctl/lib/{libndctl-private.h => private.h} (99%)
 rename ndctl/lib/{libndctl-smart.c => smart.c} (99%)

diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
index 7a446be295bb..0f01b7d88007 100644
--- a/ndctl/lib/Makefile.am
+++ b/ndctl/lib/Makefile.am
@@ -12,7 +12,7 @@ lib_LTLIBRARIES = libndctl.la
 
 libndctl_la_SOURCES =\
 	libndctl.h \
-	libndctl-private.h \
+	private.h \
 	../../util/log.c \
 	../../util/log.h \
 	../../util/sysfs.c \
@@ -26,13 +26,13 @@ libndctl_la_LIBADD =\
 	$(KMOD_LIBS)
 
 if ENABLE_ARS
-libndctl_la_SOURCES += libndctl-ars.c
+libndctl_la_SOURCES += ars.c
 endif
 
 if ENABLE_SMART
-libndctl_la_SOURCES += libndctl-smart.c
-libndctl_la_SOURCES += libndctl-hpe1.c
-libndctl_la_SOURCES += libndctl-msft.c
+libndctl_la_SOURCES += smart.c
+libndctl_la_SOURCES += hpe1.c
+libndctl_la_SOURCES += msft.c
 endif
 
 EXTRA_DIST += libndctl.sym
diff --git a/ndctl/lib/libndctl-ars.c b/ndctl/lib/ars.c
similarity index 99%
rename from ndctl/lib/libndctl-ars.c
rename to ndctl/lib/ars.c
index 9b1a0cb6e1d6..735c1457a3ec 100644
--- a/ndctl/lib/libndctl-ars.c
+++ b/ndctl/lib/ars.c
@@ -12,7 +12,7 @@
  */
 #include <stdlib.h>
 #include <ndctl/libndctl.h>
-#include "libndctl-private.h"
+#include "private.h"
 
 NDCTL_EXPORT struct ndctl_cmd *ndctl_bus_cmd_new_ars_cap(struct ndctl_bus *bus,
 		unsigned long long address, unsigned long long len)
diff --git a/ndctl/lib/libndctl-hpe1.c b/ndctl/lib/hpe1.c
similarity index 99%
rename from ndctl/lib/libndctl-hpe1.c
rename to ndctl/lib/hpe1.c
index ec542527e509..45cb5cc6db73 100644
--- a/ndctl/lib/libndctl-hpe1.c
+++ b/ndctl/lib/hpe1.c
@@ -15,9 +15,9 @@
 #include <limits.h>
 #include <util/log.h>
 #include <ndctl/libndctl.h>
-#include "libndctl-private.h"
+#include "private.h"
 
-#include "ndctl-hpe1.h"
+#include "hpe1.h"
 
 #define CMD_HPE1(_c) ((_c)->hpe1)
 #define CMD_HPE1_SMART(_c) (CMD_HPE1(_c)->u.smart.data)
diff --git a/ndctl/lib/ndctl-hpe1.h b/ndctl/lib/hpe1.h
similarity index 100%
rename from ndctl/lib/ndctl-hpe1.h
rename to ndctl/lib/hpe1.h
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index c2e0efbd87b0..4c0f8a7afd57 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -37,7 +37,7 @@
 #include <util/sysfs.h>
 #include <ndctl/libndctl.h>
 #include <daxctl/libdaxctl.h>
-#include "libndctl-private.h"
+#include "private.h"
 
 static uuid_t null_uuid;
 
diff --git a/ndctl/lib/libndctl-msft.c b/ndctl/lib/msft.c
similarity index 98%
rename from ndctl/lib/libndctl-msft.c
rename to ndctl/lib/msft.c
index d46f79bb534d..8c226f5602f1 100644
--- a/ndctl/lib/libndctl-msft.c
+++ b/ndctl/lib/msft.c
@@ -16,8 +16,8 @@
 #include <limits.h>
 #include <util/log.h>
 #include <ndctl/libndctl.h>
-#include "libndctl-private.h"
-#include "ndctl-msft.h"
+#include "private.h"
+#include "msft.h"
 
 #define CMD_MSFT(_c) ((_c)->msft)
 #define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
diff --git a/ndctl/lib/ndctl-msft.h b/ndctl/lib/msft.h
similarity index 100%
rename from ndctl/lib/ndctl-msft.h
rename to ndctl/lib/msft.h
diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/private.h
similarity index 99%
rename from ndctl/lib/libndctl-private.h
rename to ndctl/lib/private.h
index 8f10fbc76aca..8bc730d4b39a 100644
--- a/ndctl/lib/libndctl-private.h
+++ b/ndctl/lib/private.h
@@ -31,8 +31,8 @@
 #include <ndctl/libndctl.h>
 #include <ccan/endian/endian.h>
 #include <ccan/short_types/short_types.h>
-#include "ndctl-hpe1.h"
-#include "ndctl-msft.h"
+#include "hpe1.h"
+#include "msft.h"
 
 #define SZ_16M 0x01000000
 
diff --git a/ndctl/lib/libndctl-smart.c b/ndctl/lib/smart.c
similarity index 99%
rename from ndctl/lib/libndctl-smart.c
rename to ndctl/lib/smart.c
index 73a49efe5d58..41bbc6f93b80 100644
--- a/ndctl/lib/libndctl-smart.c
+++ b/ndctl/lib/smart.c
@@ -14,7 +14,7 @@
 #include <limits.h>
 #include <util/log.h>
 #include <ndctl/libndctl.h>
-#include "libndctl-private.h"
+#include "private.h"
 
 /*
  * Define the wrappers around the ndctl_smart_ops:

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
