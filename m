Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D7CA820A8
 for <linux-nvdimm@lists.01.org>; Sat,  4 Feb 2017 15:25:53 -0800 (PST)
Subject: [ndctl PATCH 1/2] util: add a common ALIGN macro
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Feb 2017 15:21:47 -0800
Message-ID: <148625050793.27070.3913104369267731411.stgit@dwillia2-desk3.amr.corp.intel.com>
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

There are a couple locations where we locally define ALIGN(), add a
global definition before adding another local one.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-dimm.c |    3 +--
 test/dax-pmd.c       |    3 +--
 util/size.h          |    4 ++++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 8a041cee8cab..637b10b47abf 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -17,6 +17,7 @@
 #include <limits.h>
 #include <syslog.h>
 #include <util/log.h>
+#include <util/size.h>
 #include <uuid/uuid.h>
 #include <util/json.h>
 #include <util/filter.h>
@@ -605,8 +606,6 @@ static struct namespace_label *label_base(struct nvdimm_data *ndd)
 	return (struct namespace_label *) base;
 }
 
-#define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
-#define BITS_PER_LONG (sizeof(unsigned long) * 8)
 static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
 {
 	struct namespace_index *nsindex;
diff --git a/test/dax-pmd.c b/test/dax-pmd.c
index 47f254e398b2..831b1f0a6572 100644
--- a/test/dax-pmd.c
+++ b/test/dax-pmd.c
@@ -11,11 +11,10 @@
 #include <stdlib.h>
 #include <linux/fs.h>
 #include <test.h>
+#include <util/size.h>
 #include <linux/fiemap.h>
 
 #define NUM_EXTENTS 5
-#define HPAGE_SIZE (2 << 20)
-#define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
 #define fail() fprintf(stderr, "%s: failed at: %d\n", __func__, __LINE__)
 #define faili(i) fprintf(stderr, "%s: failed at: %d: %d\n", __func__, __LINE__, i)
 #define TEST_FILE "test_dax_data"
diff --git a/util/size.h b/util/size.h
index 776363fd19e9..4af14eb7d150 100644
--- a/util/size.h
+++ b/util/size.h
@@ -14,4 +14,8 @@
 unsigned long long parse_size64(const char *str);
 unsigned long long __parse_size64(const char *str, unsigned long long *units);
 
+#define ALIGN(x, a) ((((unsigned long long) x) + (a - 1)) & ~(a - 1))
+#define BITS_PER_LONG (sizeof(unsigned long) * 8)
+#define HPAGE_SIZE (2 << 20)
+
 #endif /* _NDCTL_SIZE_H_ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
