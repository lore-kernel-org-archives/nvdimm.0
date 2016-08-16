Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 9395D1A1E21
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:24:07 -0700 (PDT)
Subject: [ndctl PATCH 3/8] libdaxctl: add daxctl_region_get_seed()
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:21:44 -0700
Message-ID: <147136810416.27902.14672512795204206789.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136808681.27902.14029119240021638000.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Retrieve the device-dax seed, next device-dax instance to configure for
the dax_region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c   |   24 ++++++++++++++++++++++++
 daxctl/lib/libdaxctl.sym |    1 +
 daxctl/libdaxctl.h       |    1 +
 3 files changed, 26 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 4f6bbc0cd7a6..ecdb99640115 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -327,6 +327,30 @@ DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
 	return 0;
 }
 
+DAXCTL_EXPORT struct daxctl_dev *daxctl_region_get_dev_seed(
+		struct daxctl_region *region)
+{
+	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
+	char *path = region->region_buf;
+	int len = region->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+	struct daxctl_dev *dev;
+
+	if (snprintf(path, len, "%s/dax_region/seed", region->region_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_region_get_devname(region));
+		return NULL;
+	}
+
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return NULL;
+
+	daxctl_dev_foreach(region, dev)
+		if (strcmp(buf, daxctl_dev_get_devname(dev)) == 0)
+			return dev;
+	return NULL;
+}
+
 static void dax_devices_init(struct daxctl_region *region)
 {
 	struct daxctl_ctx *ctx = daxctl_region_get_ctx(region);
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 6fb11d8757cf..e74d75bf7847 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -35,4 +35,5 @@ LIBDAXCTL_3 {
 global:
 	daxctl_region_get_available_size;
 	daxctl_region_get_devname;
+	daxctl_region_get_dev_seed;
 } LIBNDCTL_2;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index ada20ee1e9dd..bb7aa363a605 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -44,6 +44,7 @@ struct daxctl_ctx *daxctl_region_get_ctx(struct daxctl_region *region);
 unsigned long long daxctl_region_get_available_size(
 		struct daxctl_region *region);
 const char *daxctl_region_get_devname(struct daxctl_region *region);
+struct daxctl_dev *daxctl_region_get_dev_seed(struct daxctl_region *region);
 
 struct daxctl_dev;
 struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
