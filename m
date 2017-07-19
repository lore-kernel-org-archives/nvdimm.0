Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E43121D0B67E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:37 -0700 (PDT)
Subject: [ndctl PATCH 2/6] daxctl: stop carrying 'dax_region' in the
 daxctl_region region_path
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:07 -0700
Message-ID: <150048918710.12895.9803911483651783630.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Clean up region_path to carry the region device path directly. This
aligns libdaxctl with libndctl internal path names, and is a preparation
for carrying absolute path names that are needed for multi-device-dax
per region support.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 019f31b5067c..41af6ee92300 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -27,6 +27,8 @@
 #include <daxctl/libdaxctl.h>
 #include "libdaxctl-private.h"
 
+static const char *attrs = "dax_region";
+
 /**
  * struct daxctl_ctx - library user context to find "nd" instances
  *
@@ -219,14 +221,16 @@ DAXCTL_EXPORT void daxctl_region_ref(struct daxctl_region *region)
 		region->refcount++;
 }
 
-static void *add_dax_region(void *parent, int id, const char *base)
+static struct daxctl_region *add_dax_region(void *parent, int id,
+		const char *base)
 {
 	struct daxctl_region *region, *region_dup;
-	const char *attrs = "dax_region";
 	struct daxctl_ctx *ctx = parent;
 	char buf[SYSFS_ATTR_SIZE];
 	char *path;
 
+	dbg(ctx, "%s: \'%s\'\n", __func__, base);
+
 	daxctl_region_foreach(ctx, region_dup)
 		if (region_dup->id == id)
 			return region_dup;
@@ -255,12 +259,12 @@ static void *add_dax_region(void *parent, int id, const char *base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		region->align = strtoul(buf, NULL, 0);
 
-	sprintf(path, "%s/%s", base, attrs);
-	region->region_path = strdup(path);
+	region->region_path = strdup(base);
 	if (!region->region_path)
 		goto err_read;
 
-	region->region_buf = calloc(1, strlen(path) + REGION_BUF_SIZE);
+	region->region_buf = calloc(1, strlen(path) + strlen(attrs)
+			+ REGION_BUF_SIZE);
 	if (!region->region_buf)
 		goto err_read;
 	region->buf_len = strlen(path) + REGION_BUF_SIZE;
@@ -306,6 +310,7 @@ static void *add_dax_dev(void *parent, int id, const char *daxdev_base)
 
 	if (!path)
 		return NULL;
+	dbg(ctx, "%s: base: \'%s\'\n", __func__, daxdev_base);
 
 	dev = calloc(1, sizeof(*dev));
 	if (!dev)
@@ -382,8 +387,8 @@ DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
 	int len = region->buf_len;
 	unsigned long long avail;
 
-	if (snprintf(path, len, "%s/available_size",
-				region->region_path) >= len) {
+	if (snprintf(path, len, "%s/%s/available_size",
+				region->region_path, attrs) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				daxctl_region_get_devname(region));
 		return 0;
@@ -407,7 +412,7 @@ DAXCTL_EXPORT struct daxctl_dev *daxctl_region_get_dev_seed(
 	char buf[SYSFS_ATTR_SIZE];
 	struct daxctl_dev *dev;
 
-	if (snprintf(path, len, "%s/seed", region->region_path) >= len) {
+	if (snprintf(path, len, "%s/%s/seed", region->region_path, attrs) >= len) {
 		err(ctx, "%s: buffer too small!\n",
 				daxctl_region_get_devname(region));
 		return NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
