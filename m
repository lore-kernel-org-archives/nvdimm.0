Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C0F98041E
 for <linux-nvdimm@lists.01.org>; Thu, 16 Mar 2017 15:59:13 -0700 (PDT)
Subject: [PATCH v4 4/5] acpi_nfit,
 libnvdimm: Add support for clear poison list and bad blocks
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 16 Mar 2017 15:59:13 -0700
Message-ID: <148970515290.49411.8476575932675475933.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <148970513650.49411.10791297905780906216.stgit@djiang5-desk3.ch.intel.com>
References: <148970513650.49411.10791297905780906216.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Providing mechanism to clear poison list via the ndctl ND_CMD_CLEAR_ERROR
call. We will update the poison list and also the badblocks at region level
if the region is in dax mode or in pmem mode and not active.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/acpi/nfit/core.c         |   24 ++++++++++++++
 drivers/acpi/nfit/nfit.h         |    2 +
 drivers/nvdimm/bus.c             |   64 ++++++++++++++++++++++++++++++++++----
 drivers/nvdimm/core.c            |   17 ++++++++--
 drivers/nvdimm/region.c          |   25 +++++++++++++++
 include/linux/libnvdimm.h        |    7 ++++
 tools/testing/nvdimm/test/nfit.c |   21 +++++++-----
 7 files changed, 139 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index e7b05df..706eccd 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -94,6 +94,28 @@ static struct acpi_device *to_acpi_dev(struct acpi_nfit_desc *acpi_desc)
 	return to_acpi_device(acpi_desc->dev);
 }
 
+void acpi_nfit_forget_poison(struct nvdimm_bus_descriptor *nd_desc,
+		unsigned int cmd, void *buf)
+{
+	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
+	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
+	struct nd_cmd_clear_error *clear_err = buf;
+	struct resource res;
+
+	if (!nvdimm_bus || !clear_err->cleared)
+		return;
+
+	/* clearing the poison list we keep track of */
+	__nvdimm_forget_poison(nvdimm_bus, clear_err->address,
+			clear_err->cleared);
+
+	/* now sync the badblocks lists from the poison list */
+	res.start = clear_err->address;
+	res.end = clear_err->address + clear_err->cleared - 1;
+	__nvdimm_bus_badblocks_clear(nvdimm_bus, &res);
+}
+EXPORT_SYMBOL_GPL(acpi_nfit_forget_poison);
+
 static int xlat_bus_status(void *buf, unsigned int cmd, u32 status)
 {
 	struct nd_cmd_clear_error *clear_err;
@@ -353,6 +375,8 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 	}
 
 	xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
+	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR && xlat_rc >= 0)
+		acpi_nfit_forget_poison(nd_desc, cmd, buf);
 
 	if (cmd_rc)
 		*cmd_rc = xlat_rc;
diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
index fc29c2e..7b2c5ec 100644
--- a/drivers/acpi/nfit/nfit.h
+++ b/drivers/acpi/nfit/nfit.h
@@ -243,4 +243,6 @@ void __acpi_nvdimm_notify(struct device *dev, u32 event);
 int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
 		unsigned int cmd, void *buf, unsigned int buf_len, int *cmd_rc);
 void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev);
+void acpi_nfit_forget_poison(struct nvdimm_bus_descriptor *nd_desc,
+		unsigned int cmd, void *buf);
 #endif /* __NFIT_H__ */
diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 23d4a17..a5850d4 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -27,6 +27,7 @@
 #include <linux/nd.h>
 #include "nd-core.h"
 #include "nd.h"
+#include "pfn.h"
 
 int nvdimm_major;
 static int nvdimm_bus_major;
@@ -218,11 +219,21 @@ long nvdimm_clear_poison(struct device *dev, phys_addr_t phys,
 	if (cmd_rc < 0)
 		return cmd_rc;
 
-	nvdimm_clear_from_poison_list(nvdimm_bus, phys, len);
+	nvdimm_forget_poison(nvdimm_bus, phys, len);
+
 	return clear_err.cleared;
 }
 EXPORT_SYMBOL_GPL(nvdimm_clear_poison);
 
+void __nvdimm_bus_badblocks_clear(struct nvdimm_bus *nvdimm_bus,
+		struct resource *res)
+{
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
+	device_for_each_child(&nvdimm_bus->dev, (void *)res,
+			nvdimm_region_badblocks_clear);
+}
+EXPORT_SYMBOL_GPL(__nvdimm_bus_badblocks_clear);
+
 static int nvdimm_bus_match(struct device *dev, struct device_driver *drv);
 
 static struct bus_type nvdimm_bus_type = {
@@ -769,16 +780,55 @@ void wait_nvdimm_bus_probe_idle(struct device *dev)
 	} while (true);
 }
 
-static int pmem_active(struct device *dev, void *data)
+static int nd_pmem_forget_poison_check(struct device *dev, void *data)
 {
-	if (is_nd_pmem(dev) && dev->driver)
+	struct nd_cmd_clear_error *clear_err =
+		(struct nd_cmd_clear_error *)data;
+	struct nd_btt *nd_btt = is_nd_btt(dev) ? to_nd_btt(dev) : NULL;
+	struct nd_pfn *nd_pfn = is_nd_pfn(dev) ? to_nd_pfn(dev) : NULL;
+	struct nd_dax *nd_dax = is_nd_dax(dev) ? to_nd_dax(dev) : NULL;
+	struct nd_namespace_common *ndns = NULL;
+	struct nd_namespace_io *nsio;
+	resource_size_t offset = 0, end_trunc = 0, start, end, pstart, pend;
+
+	if (nd_dax || !dev->driver)
+		return 0;
+
+	start = clear_err->address;
+	end = clear_err->address + clear_err->cleared - 1;
+
+	if (nd_btt || nd_pfn || nd_dax) {
+		if (nd_btt)
+			ndns = nd_btt->ndns;
+		else if (nd_pfn)
+			ndns = nd_pfn->ndns;
+		else if (nd_dax)
+			ndns = nd_dax->nd_pfn.ndns;
+
+		if (!ndns)
+			return 0;
+	} else
+		ndns = to_ndns(dev);
+
+	nsio = to_nd_namespace_io(&ndns->dev);
+	pstart = nsio->res.start + offset;
+	pend = nsio->res.end - end_trunc;
+
+	if ((pstart >= start) && (pend <= end))
 		return -EBUSY;
+
 	return 0;
+
+}
+
+static int nd_ns_forget_poison_check(struct device *dev, void *data)
+{
+	return device_for_each_child(dev, data, nd_pmem_forget_poison_check);
 }
 
 /* set_config requires an idle interleave set */
 static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
-		struct nvdimm *nvdimm, unsigned int cmd)
+		struct nvdimm *nvdimm, unsigned int cmd, void *data)
 {
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 
@@ -792,8 +842,8 @@ static int nd_cmd_clear_to_send(struct nvdimm_bus *nvdimm_bus,
 
 	/* require clear error to go through the pmem driver */
 	if (!nvdimm && cmd == ND_CMD_CLEAR_ERROR)
-		return device_for_each_child(&nvdimm_bus->dev, NULL,
-				pmem_active);
+		return device_for_each_child(&nvdimm_bus->dev, data,
+				nd_ns_forget_poison_check);
 
 	if (!nvdimm || cmd != ND_CMD_SET_CONFIG_DATA)
 		return 0;
@@ -927,7 +977,7 @@ static int __nd_ioctl(struct nvdimm_bus *nvdimm_bus, struct nvdimm *nvdimm,
 	}
 
 	nvdimm_bus_lock(&nvdimm_bus->dev);
-	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, cmd);
+	rc = nd_cmd_clear_to_send(nvdimm_bus, nvdimm, cmd, buf);
 	if (rc)
 		goto out_unlock;
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 9303cfe..40a3da0 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -574,14 +574,15 @@ int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length)
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_add_poison);
 
-void nvdimm_clear_from_poison_list(struct nvdimm_bus *nvdimm_bus,
-		phys_addr_t start, unsigned int len)
+void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
+		unsigned int len)
 {
 	struct list_head *poison_list = &nvdimm_bus->poison_list;
 	u64 clr_end = start + len - 1;
 	struct nd_poison *pl, *next;
 
-	nvdimm_bus_lock(&nvdimm_bus->dev);
+	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
+
 	WARN_ON_ONCE(list_empty(poison_list));
 
 	/*
@@ -634,9 +635,17 @@ void nvdimm_clear_from_poison_list(struct nvdimm_bus *nvdimm_bus,
 			continue;
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(__nvdimm_forget_poison);
+
+void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t start, unsigned int len)
+{
+	nvdimm_bus_lock(&nvdimm_bus->dev);
+	__nvdimm_forget_poison(nvdimm_bus, start, len);
 	nvdimm_bus_unlock(&nvdimm_bus->dev);
 }
-EXPORT_SYMBOL_GPL(nvdimm_clear_from_poison_list);
+EXPORT_SYMBOL_GPL(nvdimm_forget_poison);
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 869a886..23c4307 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -131,6 +131,31 @@ static void nd_region_notify(struct device *dev, enum nvdimm_event event)
 	device_for_each_child(dev, &event, child_notify);
 }
 
+int nvdimm_region_badblocks_clear(struct device *dev, void *data)
+{
+	struct resource *res = (struct resource *)data;
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
+	if (res->start < nd_region->ndr_start || res->end > ndr_end)
+		return 0;
+
+	sector = (res->start - nd_region->ndr_start) >> 9;
+	badblocks_clear(&nd_region->bb, sector, resource_size(res) >> 9);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvdimm_region_badblocks_clear);
+
 static struct nd_device_driver nd_region_driver = {
 	.probe = nd_region_probe,
 	.remove = nd_region_remove,
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 77e7af3..1c609e8 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -120,7 +120,9 @@ static inline struct nd_blk_region_desc *to_blk_region_desc(
 }
 
 int nvdimm_bus_add_poison(struct nvdimm_bus *nvdimm_bus, u64 addr, u64 length);
-void nvdimm_clear_from_poison_list(struct nvdimm_bus *nvdimm_bus,
+void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
+		phys_addr_t start, unsigned int len);
+void __nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus,
 		phys_addr_t start, unsigned int len);
 struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 		struct nvdimm_bus_descriptor *nfit_desc);
@@ -162,4 +164,7 @@ void nd_region_release_lane(struct nd_region *nd_region, unsigned int lane);
 u64 nd_fletcher64(void *addr, size_t len, bool le);
 void nvdimm_flush(struct nd_region *nd_region);
 int nvdimm_has_flush(struct nd_region *nd_region);
+int nvdimm_region_badblocks_clear(struct device *dev, void *data);
+void __nvdimm_bus_badblocks_clear(struct nvdimm_bus *nvdimm_bus,
+		struct resource *res);
 #endif /* __LIBNVDIMM_H__ */
diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 798f176..31b28ad 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -319,7 +319,8 @@ static int nfit_test_cmd_ars_status(struct ars_state *ars_state,
 	return 0;
 }
 
-static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
+static int nfit_test_cmd_setup_clear_error(
+		struct nd_cmd_clear_error *clear_err,
 		unsigned int buf_len, int *cmd_rc)
 {
 	const u64 mask = NFIT_TEST_CLEAR_ERR_UNIT - 1;
@@ -330,14 +331,11 @@ static int nfit_test_cmd_clear_error(struct nd_cmd_clear_error *clear_err,
 		return -EINVAL;
 
 	/*
-	 * Report 'all clear' success for all commands even though a new
-	 * scrub will find errors again.  This is enough to have the
-	 * error removed from the 'badblocks' tracking in the pmem
-	 * driver.
+	 * since this is a test and there's no actual _DSM command being
+	 * issued, we need to fake the result.
 	 */
-	clear_err->status = 0;
-	clear_err->cleared = clear_err->length;
-	*cmd_rc = 0;
+	*cmd_rc = clear_err->cleared = clear_err->length;
+
 	return 0;
 }
 
@@ -465,7 +463,12 @@ static int nfit_test_ctl(struct nvdimm_bus_descriptor *nd_desc,
 					cmd_rc);
 			break;
 		case ND_CMD_CLEAR_ERROR:
-			rc = nfit_test_cmd_clear_error(buf, buf_len, cmd_rc);
+			rc = nfit_test_cmd_setup_clear_error(buf,
+					buf_len, cmd_rc);
+			if (rc < 0)
+				return rc;
+
+			acpi_nfit_forget_poison(nd_desc, cmd, buf);
 			break;
 		default:
 			return -ENOTTY;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
