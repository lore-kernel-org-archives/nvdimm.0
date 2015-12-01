Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
Subject: [PATCH] nvdimm: improve diagnosibility of namespaces
Date: Wed,  2 Dec 2015 00:48:12 +0300
Message-Id: <1449006492-1474-1-git-send-email-krivenok.dmitry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

In order to bind namespace to the driver user must first
set all mandatory attributes in the following order:
- uuid
- size
- sector_size (for blk namespace only)

If the order is wrong, then user either won't be able to set
the attribute or bind the namespace.

This simple patch improves diagnosibility of common operations
with namespaces by printing some details about the error
instead of failing silently.

Below are examples of error messages (assuming dyndbg is
enabled for nvdimms):

[/]# echo 4194304 > /sys/bus/nd/devices/region5/namespace5.0/size
[  288.372612] nd namespace5.0: __size_store: uuid not set
[  288.374839] nd namespace5.0: size_store: 400000 fail (-6)
sh: write error: No such device or address
[/]#

[/]# echo namespace5.0 > /sys/bus/nd/drivers/nd_blk/bind
[  554.671648] nd_blk namespace5.0: nvdimm_namespace_common_probe: sector size not set
[  554.674688]  ndbus1: nd_blk.probe(namespace5.0) = -19
sh: write error: No such device
[/]#

Signed-off-by: Dmitry V. Krivenok <krivenok.dmitry@gmail.com>
---
 drivers/nvdimm/namespace_devs.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 0955b2c..f981177 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -791,6 +791,15 @@ static void nd_namespace_pmem_set_size(struct nd_region *nd_region,
 	res->end = nd_region->ndr_start + size - 1;
 }
 
+static bool uuid_not_set(const u8 *uuid, struct device *dev, const char *where)
+{
+	if (!uuid) {
+		dev_dbg(dev, "%s: uuid not set\n", where);
+		return true;
+	}
+	return false;
+}
+
 static ssize_t __size_store(struct device *dev, unsigned long long val)
 {
 	resource_size_t allocated = 0, available = 0;
@@ -820,8 +829,12 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 	 * We need a uuid for the allocation-label and dimm(s) on which
 	 * to store the label.
 	 */
-	if (!uuid || nd_region->ndr_mappings == 0)
+	if (uuid_not_set(uuid, dev, __func__))
 		return -ENXIO;
+	if (nd_region->ndr_mappings == 0) {
+		dev_dbg(dev, "%s: not associated with dimm(s)\n", __func__);
+		return -ENXIO;
+	}
 
 	div_u64_rem(val, SZ_4K * nd_region->ndr_mappings, &remainder);
 	if (remainder) {
@@ -1343,14 +1356,19 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 		struct nd_namespace_pmem *nspm;
 
 		nspm = to_nd_namespace_pmem(&ndns->dev);
-		if (!nspm->uuid) {
-			dev_dbg(&ndns->dev, "%s: uuid not set\n", __func__);
+		if (uuid_not_set(nspm->uuid, &ndns->dev, __func__))
 			return ERR_PTR(-ENODEV);
-		}
 	} else if (is_namespace_blk(&ndns->dev)) {
 		struct nd_namespace_blk *nsblk;
 
 		nsblk = to_nd_namespace_blk(&ndns->dev);
+		if (uuid_not_set(nsblk->uuid, &ndns->dev, __func__))
+			return ERR_PTR(-ENODEV);
+		if (!nsblk->lbasize) {
+			dev_dbg(&ndns->dev, "%s: sector size not set\n",
+				__func__);
+			return ERR_PTR(-ENODEV);
+		}
 		if (!nd_namespace_blk_validate(nsblk))
 			return ERR_PTR(-ENODEV);
 	}
-- 
2.6.2

