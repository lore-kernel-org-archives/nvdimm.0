Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FD4821A0480E
 for <linux-nvdimm@lists.01.org>; Sun, 30 Apr 2017 05:44:54 -0700 (PDT)
Subject: [PATCH] libnvdimm: rework region badblocks clearing
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 30 Apr 2017 05:39:01 -0700
Message-ID: <149355594185.9917.1577772489949690281.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Toshi noticed that the new support for a region-level badblocks missed
the case where errors are cleared due to BTT I/O.

An initial attempt to fix this ran into a "sleeping while atomic"
warning due to taking the nvdimm_bus_lock() in the BTT I/O path to
satisfy the locking requirements of __nvdimm_bus_badblocks_clear().
However, that lock is not needed since we are not acting any data that
is subject to change due to a change of state of the bus / region. The
badblocks instance has its own internal lock to handle mutations of the
error list.

So, to make it clear that we are just acting on region devices and don't
need the lock rename __nvdimm_bus_badblocks_clear() to
nvdimm_clear_badblocks_regions(). Eliminate the lock and consolidate all
routines in drivers/nvdimm/bus.c. Also, make some cleanups to remove
unnecessary casts, make the calling convention of
nvdimm_clear_badblocks_regions() clearer by replacing struct resource
with the minimal struct clear_badblocks_context, and use the DEVICE_ATTR
macro.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c         |   76 ++++++++++++++++++++++++++++++------------
 drivers/nvdimm/region.c      |   25 --------------
 drivers/nvdimm/region_devs.c |   15 +++-----
 include/linux/libnvdimm.h    |    3 --
 4 files changed, 59 insertions(+), 60 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 43ddfd487c85..e9361bffe5ee 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -172,6 +172,57 @@ void nvdimm_region_notify(struct nd_region *nd_region, enum nvdimm_event event)
 }
 EXPORT_SYMBOL_GPL(nvdimm_region_notify);
 
+struct clear_badblocks_context {
+	resource_size_t phys, cleared;
+};
+
+static int nvdimm_clear_badblocks_region(struct device *dev, void *data)
+{
+	struct clear_badblocks_context *ctx = data;
+	struct nd_region *nd_region;
+	resource_size_t ndr_end;
+	sector_t sector;
+
+	/* make sure device is a region */
+	if (!is_nd_pmem(dev))
+		return 0;
+
+	nd_region = to_nd_region(dev);
+	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
+
+	/* make sure we are in the region */
+	if (ctx->phys < nd_region->ndr_start
+			|| (ctx->phys + ctx->cleared) > ndr_end)
+		return 0;
+
+	sector = (ctx->phys - nd_region->ndr_start) / 512;
+	badblocks_clear(&nd_region->bb, sector, ctx->cleared / 512);
+
+	return 0;
+}
+
+static void nvdimm_clear_badblocks_regions(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t phys, u64 cleared)
+{
+	struct clear_badblocks_context ctx = {
+		.phys = phys,
+		.cleared = cleared,
+	};
+
+	device_for_each_child(&nvdimm_bus->dev, &ctx,
+			nvdimm_clear_badblocks_region);
+}
+
+static void nvdimm_account_cleared_poison(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t phys, u64 cleared)
+{
+	if (cleared > 0)
+		nvdimm_forget_poison(nvdimm_bus, phys, cleared);
+
+	if (cleared > 0 && cleared / 512)
+		nvdimm_clear_badblocks_regions(nvdimm_bus, phys, cleared);
+}
+
 long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 		unsigned int len)
 {
@@ -219,22 +270,12 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	if (cmd_rc < 0)
 		return cmd_rc;
 
-	if (clear_err.cleared > 0)
-		nvdimm_forget_poison(nvdimm_bus, phys, clear_err.cleared);
+	nvdimm_account_cleared_poison(nvdimm_bus, phys, clear_err.cleared);
 
 	return clear_err.cleared;
 }
 EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
 
-void __nvdimm_bus_badblocks_clear(struct nvdimm_bus *nvdimm_bus,
-		struct resource *res)
-{
-	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
-	device_for_each_child(&nvdimm_bus->dev, (void *)res,
-			nvdimm_region_badblocks_clear);
-}
-EXPORT_SYMBOL_GPL(__nvdimm_bus_badblocks_clear);
-
 static int nvdimm_bus_match(struct device *dev, struct device_driver *drv);
 
 static struct bus_type nvdimm_bus_type = {
@@ -989,18 +1030,9 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 
 	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && cmd_rc >= 0) {
 		struct nd_cmd_clear_error *clear_err = buf;
-		struct resource res;
-
-		if (clear_err->cleared) {
-			/* clearing the poison list we keep track of */
-			nvdimm_forget_poison(nvdimm_bus, clear_err->address,
-					clear_err->cleared);
 
-			/* now sync the badblocks lists */
-			res.start = clear_err->address;
-			res.end = clear_err->address + clear_err->cleared - 1;
-			__nvdimm_bus_badblocks_clear(nvdimm_bus, &res);
-		}
+		nvdimm_account_cleared_poison(nvdimm_bus, clear_err->address,
+				clear_err->cleared);
 	}
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 23c4307d254c..869a886c292e 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -131,31 +131,6 @@ static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 	device_for_each_child(dev, &event, child_notify);
 }
 
-int nvdimm_region_badblocks_clear(struct device *dev, void *data)
-{
-	struct resource *res = (struct resource *)data;
-	struct nd_region *nd_region;
-	resource_size_t ndr_end;
-	sector_t sector;
-
-	/* make sure device is a region */
-	if (!is_nd_pmem(dev))
-		return 0;
-
-	nd_region = to_nd_region(dev);
-	ndr_end = nd_region->ndr_start + nd_region->ndr_size - 1;
-
-	/* make sure we are in the region */
-	if (res->start < nd_region->ndr_start || res->end > ndr_end)
-		return 0;
-
-	sector = (res->start - nd_region->ndr_start) >> 9;
-	badblocks_clear(&nd_region->bb, sector, resource_size(res) >> 9);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nvdimm_region_badblocks_clear);
-
 static struct nd_device_driver nd_region_driver = {
 	.probe = nd_region_probe,
 	.remove = nd_region_remove,
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 53d1ba4e6d99..07756b2e1cd5 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -477,20 +477,15 @@ static ssize_t read_only_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(read_only);
 
-static ssize_t nd_badblocks_show(struct device *dev,
+static ssize_t region_badblocks_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	return badblocks_show(&nd_region->bb, buf, 0);
 }
-static struct device_attribute dev_attr_nd_badblocks = {
-	.attr = {
-		.name = "badblocks",
-		.mode = S_IRUGO
-	},
-	.show = nd_badblocks_show,
-};
+
+static DEVICE_ATTR(badblocks, 0444, region_badblocks_show, NULL);
 
 static ssize_t resource_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -514,7 +509,7 @@ static struct attribute *nd_region_attributes[] = {
 	&dev_attr_available_size.attr,
 	&dev_attr_namespace_seed.attr,
 	&dev_attr_init_namespaces.attr,
-	&dev_attr_nd_badblocks.attr,
+	&dev_attr_badblocks.attr,
 	&dev_attr_resource.attr,
 	NULL,
 };
@@ -532,7 +527,7 @@ static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
 	if (!is_nd_pmem(dev) && a == &dev_attr_dax_seed.attr)
 		return 0;
 
-	if (!is_nd_pmem(dev) && a == &dev_attr_nd_badblocks.attr)
+	if (!is_nd_pmem(dev) && a == &dev_attr_badblocks.attr)
 		return 0;
 
 	if (!is_nd_pmem(dev) && a == &dev_attr_resource.attr)
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 98b207611b06..f07b1b14159a 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -162,7 +162,4 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
-int nvdimm_region_badblocks_clear(struct device *dev, void *data);
-void __nvdimm_bus_badblocks_clear(struct nvdimm_bus *nvdimm_bus,
-		struct resource *res);
 #endif /* __LIBNVDIMM_H__ */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
