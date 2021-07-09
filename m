Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E673970
	for <nvdimm@lists.linux.dev>; Fri,  9 Jul 2021 19:53:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10040"; a="270879433"
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="270879433"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:53:03 -0700
X-IronPort-AV: E=Sophos;i="5.84,227,1620716400"; 
   d="scan'208";a="647171021"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2021 12:53:02 -0700
Subject: [ndctl PATCH 4/6] build: Explicitly include version.h
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
Date: Fri, 09 Jul 2021 12:53:02 -0700
Message-ID: <162586038235.1431180.11031769782992113308.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162586035908.1431180.14991721381432827647.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for switching to meson explicitly include version.h rather
than depend on -DGIT_VERSION.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/cxl.c       |    1 +
 cxl/list.c      |    1 +
 daxctl/daxctl.c |    1 +
 daxctl/list.c   |    1 +
 ndctl/list.c    |    1 +
 ndctl/monitor.c |    1 +
 ndctl/ndctl.c   |    1 +
 7 files changed, 7 insertions(+)

diff --git a/cxl/cxl.c b/cxl/cxl.c
index 4b1661d8d4c1..4aa2038d6435 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <version.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <cxl/libcxl.h>
diff --git a/cxl/list.c b/cxl/list.c
index d7b836bd2b46..7923f64d1884 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <version.h>
 #include <util/json.h>
 #include <json-c/json.h>
 #include <cxl/libcxl.h>
diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
index 928814c8b35f..3668e760ea23 100644
--- a/daxctl/daxctl.c
+++ b/daxctl/daxctl.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <version.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <daxctl/libdaxctl.h>
diff --git a/daxctl/list.c b/daxctl/list.c
index aeff1967116b..2b2bc19d23cb 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <version.h>
 #include <util/json.h>
 #include <json-c/json.h>
 #include <daxctl/libdaxctl.h>
diff --git a/ndctl/list.c b/ndctl/list.c
index 869edde4fc65..3baf8e13c2ea 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <limits.h>
+#include <version.h>
 
 #include <util/json.h>
 #include <json-c/json.h>
diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index fde5b1209565..870dec2ef679 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -13,6 +13,7 @@
 #include <ndctl/ndctl.h>
 #include <ndctl/libndctl.h>
 #include <sys/epoll.h>
+#include <version.h>
 #define BUF_SIZE 2048
 
 /* reuse the core log helpers for the monitor logger */
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 31d2c5e35939..4c8bf3434245 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -8,6 +8,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <version.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <ndctl/builtin.h>

