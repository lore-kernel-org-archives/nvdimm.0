Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A63FB82081
 for <linux-nvdimm@lists.01.org>; Sat, 10 Dec 2016 22:39:16 -0800 (PST)
Subject: [ndctl PATCH 6/6] daxctl: add daxctl_dev_set_size()
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 10 Dec 2016 22:35:07 -0800
Message-ID: <148143810744.11895.7950405837595504945.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <148143807638.11895.3823811556889353622.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Starting with v4.10 the kernel allows resizing device-dax instances.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c   |   26 ++++++++++++++++++++++++++
 daxctl/lib/libdaxctl.sym |    2 ++
 daxctl/libdaxctl.h       |    2 ++
 test/libndctl.c          |   33 +++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 019f31b5067c..7db569bf30d6 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -518,6 +518,11 @@ DAXCTL_EXPORT struct daxctl_region *daxctl_dev_get_region(struct daxctl_dev *dev
 	return dev->region;
 }
 
+DAXCTL_EXPORT struct daxctl_ctx *daxctl_dev_get_ctx(struct daxctl_dev *dev)
+{
+	return daxctl_region_get_ctx(dev->region);
+}
+
 DAXCTL_EXPORT int daxctl_dev_get_id(struct daxctl_dev *dev)
 {
 	return dev->id;
@@ -542,3 +547,24 @@ DAXCTL_EXPORT unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev)
 {
 	return dev->size;
 }
+
+DAXCTL_EXPORT int daxctl_dev_set_size(struct daxctl_dev *dev,
+		unsigned long long size)
+{
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char *path = dev->dev_buf;
+	int len = dev->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+
+	if (snprintf(path, len, "%s/size", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+
+	sprintf(buf, "%#llx\n", size);
+	if (sysfs_write_attr(ctx, path, buf) != 0)
+		return -ENXIO;
+	dev->size = size;
+	return 0;
+}
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 1b1104dbe74c..6712634b50ca 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -44,4 +44,6 @@ global:
 	daxctl_region_get_align;
 	daxctl_region_get_first;
 	daxctl_region_get_next;
+	daxctl_dev_set_size;
+	daxctl_dev_get_ctx;
 } LIBDAXCTL_3;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 071cb1b17e6e..b10610252cd0 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -54,11 +54,13 @@ struct daxctl_dev;
 struct daxctl_dev *daxctl_dev_get_first(struct daxctl_region *region);
 struct daxctl_dev *daxctl_dev_get_next(struct daxctl_dev *dev);
 struct daxctl_region *daxctl_dev_get_region(struct daxctl_dev *dev);
+struct daxctl_ctx *daxctl_dev_get_ctx(struct daxctl_dev *dev);
 int daxctl_dev_get_id(struct daxctl_dev *dev);
 const char *daxctl_dev_get_devname(struct daxctl_dev *dev);
 int daxctl_dev_get_major(struct daxctl_dev *dev);
 int daxctl_dev_get_minor(struct daxctl_dev *dev);
 unsigned long long daxctl_dev_get_size(struct daxctl_dev *dev);
+int daxctl_dev_set_size(struct daxctl_dev *dev, unsigned long long size);
 
 #define daxctl_dev_foreach(region, dev) \
         for (dev = daxctl_dev_get_first(region); \
diff --git a/test/libndctl.c b/test/libndctl.c
index c6e199dbb078..f133f7e6ab24 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -705,6 +705,39 @@ static int validate_dax(struct ndctl_dax *dax)
 		goto out;
 	}
 
+	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 10, 0))) {
+		unsigned long long size;
+		struct daxctl_dev *active = NULL;
+
+		daxctl_dev_foreach(dax_region, dax_dev)
+			if (dax_dev != seed) {
+				active = dax_dev;
+				break;
+			}
+
+		if (!active) {
+			fprintf(stderr, "%s: failed to find active dax_dev\n",
+					devname);
+			return -ENXIO;
+		}
+
+		if (daxctl_dev_get_size(dax_dev)
+				!= daxctl_region_get_size(dax_region)) {
+			fprintf(stderr, "%s: expected size: %#llx got %#llx\n",
+					devname, daxctl_region_get_size(dax_region),
+					daxctl_dev_get_size(dax_dev));
+			return -ENXIO;
+		}
+
+		size = daxctl_region_get_align(dax_region);
+		rc = daxctl_dev_set_size(dax_dev, size);
+		if (rc || daxctl_dev_get_size(dax_dev) != size) {
+			fprintf(stderr, "%s: failed set size rc: %d size: %#llx\n",
+					devname, rc, size);
+			return -ENXIO;
+		}
+	}
+
 	sprintf(devpath, "/dev/%s", daxctl_dev_get_devname(dax_dev));
 	fd = open(devpath, O_RDWR);
 	if (fd < 0) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
