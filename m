Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 04D4381A51
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jan 2017 17:46:23 -0800 (PST)
Subject: [ndctl PATCH 2/7] ndctl,
 daxctl: move json helpers to be available across both utilities
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 06 Jan 2017 17:42:17 -0800
Message-ID: <148375333719.38836.10332148585060953751.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148375332631.38836.5735184615585844571.stgit@dwillia2-desk3.amr.corp.intel.com>
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


---
 ndctl/Makefile.am |    2 +-
 test/Makefile.am  |    4 ++--
 util/json.c       |    0 
 util/json.h       |    0 
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename ndctl/util/json.c => util/json.c (100%)
 rename ndctl/util/json.h => util/json.h (100%)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index f03647ae9d99..c563e9411cc3 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -10,7 +10,7 @@ ndctl_SOURCES = ndctl.c \
 		 ../util/log.c \
 		builtin-list.c \
 		builtin-test.c \
-		util/json.c
+		../util/json.c
 
 if ENABLE_SMART
 ndctl_SOURCES += util/json-smart.c
diff --git a/test/Makefile.am b/test/Makefile.am
index 46a1acf98f0d..9e3ae1dab411 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -75,7 +75,7 @@ device_dax_SOURCES = \
 		dax-pmd.c \
 		core.c \
 		../ndctl/builtin-xaction-namespace.c \
-		../ndctl/util/json.c
+		../util/json.c
 device_dax_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
@@ -85,7 +85,7 @@ multi_pmem_SOURCES = \
 		multi-pmem.c \
 		core.c \
 		../ndctl/builtin-xaction-namespace.c \
-		../ndctl/util/json.c
+		../util/json.c
 multi_pmem_LDADD = \
 		$(LIBNDCTL_LIB) \
 		$(JSON_LIBS) \
diff --git a/ndctl/util/json.c b/util/json.c
similarity index 100%
rename from ndctl/util/json.c
rename to util/json.c
diff --git a/ndctl/util/json.h b/util/json.h
similarity index 100%
rename from ndctl/util/json.h
rename to util/json.h

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
