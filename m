Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14DBC22283527
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 15:28:03 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH] ndctl: fail NUMA filtering when unsupported
Date: Fri,  9 Mar 2018 16:34:16 -0700
Message-Id: <20180309233416.13243-1-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Verma, Vishal L" <vishal.l.verma@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

For systems that don't support NUMA, numactl gives a loud and fatal error:

  # numactl -N 0 ls
  numactl: This system does not support NUMA policy

Follow this model in ndctl for NUMA based filtering:

  # ./ndctl/ndctl list --numa-node=0
    Error: This system does not support NUMA

This is done instead of just quietly filtering out all dimms, regions and
namespaces because the NUMA node they were trying to match didn't exist in
the system.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
---
 util/filter.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/util/filter.c b/util/filter.c
index 291d7ed..fdc46a3 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -14,7 +14,10 @@
 #include <string.h>
 #include <stdlib.h>
 #include <limits.h>
+#include <unistd.h>
+#include <sys/stat.h>
 #include <util/util.h>
+#include <sys/types.h>
 #include <ndctl/ndctl.h>
 #include <util/filter.h>
 #include <ndctl/libndctl.h>
@@ -328,6 +331,13 @@ int util_filter_walk(struct ndctl_ctx *ctx, struct util_filter_ctx *fctx,
 	}
 
 	if (param->numa_node && strcmp(param->numa_node, "all") != 0) {
+		struct stat st;
+
+		if (stat("/sys/devices/system/node", &st)) {
+			error("This system does not support NUMA\n");
+			return -EINVAL;
+		}
+
 		numa_node = strtol(param->numa_node, &end, 0);
 		if (end == param->numa_node || end[0]) {
 			error("invalid numa_node: '%s'\n", param->numa_node);
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
