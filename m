Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2A00210FC369
 for <linux-nvdimm@lists.01.org>; Wed, 22 Aug 2018 15:23:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/2] ndctl,
 destroy-namespace: check for an already-zeroed info block
Date: Wed, 22 Aug 2018 16:22:48 -0600
Message-Id: <20180822222249.30838-2-vishal.l.verma@intel.com>
In-Reply-To: <20180822222249.30838-1-vishal.l.verma@intel.com>
References: <20180822222249.30838-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargal <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

in zero_info_block, check if the info block is already all-zeroes, and
if so, don't write zeroes. This is in preparation for the fixes to
destroy-namespace accounting where the number of namespaces 'destroyed'
is often incorrect.

Cc: Steve Scargall <steve.scargall@intel.com>
Link: https://github.com/pmem/ndctl/issues/41
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 510553c..65e8f7c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -14,6 +14,7 @@
 #include <fcntl.h>
 #include <errno.h>
 #include <stdlib.h>
+#include <string.h>
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
@@ -786,23 +787,35 @@ static int namespace_create(struct ndctl_region *region)
 	return setup_namespace(region, ndns, &p);
 }
 
+/*
+ * Return convention:
+ * rc < 0 : Error while zeroing, propagate forward
+ * rc == 0 : Successfully cleared the info block, report as destroyed
+ * rc > 0 : skipped, do not count
+ */
 static int zero_info_block(struct ndctl_namespace *ndns)
 {
 	const char *devname = ndctl_namespace_get_devname(ndns);
-	int fd, rc = -ENXIO;
-	void *buf = NULL;
+	int fd, rc = -ENXIO, info_size = 8192;
+	void *buf = NULL, *read_buf = NULL;
 	char path[50];
 
 	ndctl_namespace_set_raw_mode(ndns, 1);
 	rc = ndctl_namespace_enable(ndns);
 	if (rc < 0) {
 		debug("%s failed to enable for zeroing, continuing\n", devname);
-		rc = 0;
+		rc = 1;
 		goto out;
 	}
 
-	if (posix_memalign(&buf, 4096, 4096) != 0)
-		return -ENXIO;
+	if (posix_memalign(&buf, 4096, info_size) != 0) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	if (posix_memalign(&read_buf, 4096, info_size) != 0) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
 	fd = open(path, O_RDWR|O_DIRECT|O_EXCL);
@@ -812,18 +825,30 @@ static int zero_info_block(struct ndctl_namespace *ndns)
 		goto out;
 	}
 
-	memset(buf, 0, 4096);
-	rc = pwrite(fd, buf, 4096, 4096);
-	if (rc < 4096) {
+	memset(buf, 0, info_size);
+	rc = pread(fd, read_buf, info_size, 0);
+	if (rc < info_size) {
+		debug("%s: failed to read info block, continuing\n",
+			devname);
+	}
+	if (memcmp(buf, read_buf, info_size) == 0) {
+		rc = 1;
+		goto out_close;
+	}
+
+	rc = pwrite(fd, buf, info_size, 0);
+	if (rc < info_size) {
 		debug("%s: failed to zero info block %s\n",
 				devname, path);
 		rc = -ENXIO;
 	} else
 		rc = 0;
+ out_close:
 	close(fd);
  out:
 	ndctl_namespace_set_raw_mode(ndns, 0);
 	ndctl_namespace_disable_invalidate(ndns);
+	free(read_buf);
 	free(buf);
 	return rc;
 }
@@ -857,7 +882,7 @@ static int namespace_destroy(struct ndctl_region *region,
 
 	if (pfn || btt || dax) {
 		rc = zero_info_block(ndns);
-		if (rc)
+		if (rc < 0)
 			return rc;
 	}
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
