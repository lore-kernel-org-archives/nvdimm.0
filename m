Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14D541A1E92
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 09:42:21 -0700 (PDT)
Subject: [PATCH 07/14] libnvdimm, namespace: sort namespaces by dpa at init
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 07 Oct 2016 09:39:18 -0700
Message-ID: <147585835836.22349.5818834126920367671.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147585832067.22349.6376523541984122050.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Add more determinism to initial namespace device-name assignments by
sorting the namespaces by starting dpa.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/namespace_devs.c |   35 ++++++++++++++++++++++++++++++++---
 include/linux/nd.h              |    6 +++---
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 47d29632b937..f0536c2789e9 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -12,6 +12,7 @@
  */
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/sort.h>
 #include <linux/slab.h>
 #include <linux/pmem.h>
 #include <linux/list.h>
@@ -66,17 +67,17 @@ static struct device_type namespace_blk_device_type = {
 	.release = namespace_blk_release,
 };
 
-static bool is_namespace_pmem(struct device *dev)
+static bool is_namespace_pmem(const struct device *dev)
 {
 	return dev ? dev->type == &namespace_pmem_device_type : false;
 }
 
-static bool is_namespace_blk(struct device *dev)
+static bool is_namespace_blk(const struct device *dev)
 {
 	return dev ? dev->type == &namespace_blk_device_type : false;
 }
 
-static bool is_namespace_io(struct device *dev)
+static bool is_namespace_io(const struct device *dev)
 {
 	return dev ? dev->type == &namespace_io_device_type : false;
 }
@@ -1919,6 +1920,31 @@ struct device *create_namespace_blk(struct nd_region *nd_region,
 	return ERR_PTR(-ENXIO);
 }
 
+static int cmp_dpa(const void *a, const void *b)
+{
+	const struct device *dev_a = *(const struct device **) a;
+	const struct device *dev_b = *(const struct device **) b;
+	struct nd_namespace_blk *nsblk_a, *nsblk_b;
+	struct nd_namespace_pmem *nspm_a, *nspm_b;
+
+	if (is_namespace_io(dev_a))
+		return 0;
+
+	if (is_namespace_blk(dev_a)) {
+		nsblk_a = to_nd_namespace_blk(dev_a);
+		nsblk_b = to_nd_namespace_blk(dev_b);
+
+		return memcmp(&nsblk_a->res[0]->start, &nsblk_b->res[0]->start,
+				sizeof(resource_size_t));
+	}
+
+	nspm_a = to_nd_namespace_pmem(dev_a);
+	nspm_b = to_nd_namespace_pmem(dev_b);
+
+	return memcmp(&nspm_a->nsio.res.start, &nspm_b->nsio.res.start,
+			sizeof(resource_size_t));
+}
+
 static struct device **scan_labels(struct nd_region *nd_region)
 {
 	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
@@ -2034,6 +2060,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
 		}
 	}
 
+	if (count > 1)
+		sort(devs, count, sizeof(struct device *), cmp_dpa, NULL);
+
 	return devs;
 
  err:
diff --git a/include/linux/nd.h b/include/linux/nd.h
index ddcc7788305c..fa66aeed441a 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -107,19 +107,19 @@ struct nd_namespace_blk {
 	struct resource **res;
 };
 
-static inline struct nd_namespace_io *to_nd_namespace_io(struct device *dev)
+static inline struct nd_namespace_io *to_nd_namespace_io(const struct device *dev)
 {
 	return container_of(dev, struct nd_namespace_io, common.dev);
 }
 
-static inline struct nd_namespace_pmem *to_nd_namespace_pmem(struct device *dev)
+static inline struct nd_namespace_pmem *to_nd_namespace_pmem(const struct device *dev)
 {
 	struct nd_namespace_io *nsio = to_nd_namespace_io(dev);
 
 	return container_of(nsio, struct nd_namespace_pmem, nsio);
 }
 
-static inline struct nd_namespace_blk *to_nd_namespace_blk(struct device *dev)
+static inline struct nd_namespace_blk *to_nd_namespace_blk(const struct device *dev)
 {
 	return container_of(dev, struct nd_namespace_blk, common.dev);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
