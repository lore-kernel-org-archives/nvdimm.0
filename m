Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3E45220D77DB3
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 16:19:37 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v4 3/6] ndctl: move the fletcher64 routine to util/
Date: Fri,  7 Apr 2017 17:18:00 -0600
Message-Id: <20170407231803.14936-4-vishal.l.verma@intel.com>
In-Reply-To: <20170407231803.14936-1-vishal.l.verma@intel.com>
References: <20170407231803.14936-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In preparation for check-namespace, since it will also use the
fletcher64 routine, move it to util/ so that it can be shared by both
builtin-check.c and builtin-dimm.c

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Makefile.am          |  3 ++-
 ndctl/builtin-dimm.c | 18 ++----------------
 util/fletcher.c      | 23 +++++++++++++++++++++++
 util/fletcher.h      |  8 ++++++++
 4 files changed, 35 insertions(+), 17 deletions(-)
 create mode 100644 util/fletcher.c
 create mode 100644 util/fletcher.h

diff --git a/Makefile.am b/Makefile.am
index 06cd1b0..5453b2a 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -68,6 +68,7 @@ libutil_a_SOURCES = \
 	util/help.c \
 	util/strbuf.c \
 	util/wrapper.c \
-	util/filter.c
+	util/filter.c \
+	util/fletcher.c
 
 nobase_include_HEADERS = daxctl/libdaxctl.h
diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 637b10b..93f9530 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -22,6 +22,7 @@
 #include <util/json.h>
 #include <util/filter.h>
 #include <json-c/json.h>
+#include <util/fletcher.h>
 #include <ndctl/libndctl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
@@ -358,7 +359,7 @@ struct nvdimm_data {
 };
 
 /*
- * Note, best_seq(), inc_seq(), fletcher64(), sizeof_namespace_index()
+ * Note, best_seq(), inc_seq(), sizeof_namespace_index()
  * nvdimm_num_label_slots(), label_validate(), and label_write_index()
  * are copied from drivers/nvdimm/label.c in the Linux kernel with the
  * following modifications:
@@ -371,21 +372,6 @@ struct nvdimm_data {
  * 7/ dropped clear_bit_le() usage in label_write_index
  */
 
-static u64 fletcher64(void *addr, size_t len, bool le)
-{
-	u32 *buf = addr;
-	u32 lo32 = 0;
-	u64 hi32 = 0;
-	size_t i;
-
-	for (i = 0; i < len / sizeof(u32); i++) {
-		lo32 += le ? le32_to_cpu((le32) buf[i]) : buf[i];
-		hi32 += lo32;
-	}
-
-	return hi32 << 32 | lo32;
-}
-
 static unsigned inc_seq(unsigned seq)
 {
 	static const unsigned next[] = { 0, 2, 3, 1 };
diff --git a/util/fletcher.c b/util/fletcher.c
new file mode 100644
index 0000000..cee2fc3
--- /dev/null
+++ b/util/fletcher.c
@@ -0,0 +1,23 @@
+#include <stdlib.h>
+#include <stdbool.h>
+#include <util/fletcher.h>
+#include <ccan/endian/endian.h>
+#include <ccan/short_types/short_types.h>
+
+/*
+ * Note, fletcher64() is copied from drivers/nvdimm/label.c in the Linux kernel
+ */
+u64 fletcher64(void *addr, size_t len, bool le)
+{
+	u32 *buf = addr;
+	u32 lo32 = 0;
+	u64 hi32 = 0;
+	size_t i;
+
+	for (i = 0; i < len / sizeof(u32); i++) {
+		lo32 += le ? le32_to_cpu((le32) buf[i]) : buf[i];
+		hi32 += lo32;
+	}
+
+	return hi32 << 32 | lo32;
+}
diff --git a/util/fletcher.h b/util/fletcher.h
new file mode 100644
index 0000000..e3bbce3
--- /dev/null
+++ b/util/fletcher.h
@@ -0,0 +1,8 @@
+#ifndef _NDCTL_FLETCHER_H_
+#define _NDCTL_FLETCHER_H_
+
+#include <ccan/short_types/short_types.h>
+
+u64 fletcher64(void *addr, size_t len, bool le);
+
+#endif /* _NDCTL_FLETCHER_H_ */
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
