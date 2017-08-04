Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 138FC21E1DAFA
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 17:29:15 -0700 (PDT)
Subject: [4.9-stable PATCH] device-dax: fix sysfs duplicate warnings
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 Aug 2017 17:25:02 -0700
Message-ID: <150180630236.6719.1152880381080551797.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <15010052332208@kroah.com>
References: <15010052332208@kroah.com>
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
To: stable@vger.kernel.org
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

commit bbb3be170ac2891526ad07b18af7db226879a8e7 upstream.

Fix warnings of the form...

     WARNING: CPU: 10 PID: 4983 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
     sysfs: cannot create duplicate filename '/class/dax/dax12.0'
     Call Trace:
      dump_stack+0x63/0x86
      __warn+0xcb/0xf0
      warn_slowpath_fmt+0x5a/0x80
      ? kernfs_path_from_node+0x4f/0x60
      sysfs_warn_dup+0x62/0x80
      sysfs_do_create_link_sd.isra.2+0x97/0xb0
      sysfs_create_link+0x25/0x40
      device_add+0x266/0x630
      devm_create_dax_dev+0x2cf/0x340 [dax]
      dax_pmem_probe+0x1f5/0x26e [dax_pmem]
      nvdimm_bus_probe+0x71/0x120

...by reusing the namespace id for the device-dax instance name.

Now that we have decided that there will never by more than one
device-dax instance per libnvdimm-namespace parent device [1], we can
directly reuse the namepace ids. There are some possible follow-on
cleanups, but those are saved for a later patch to simplify the -stable
backport.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2016-December/008266.html

Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pmem...")
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c  |   24 ++++++++++++++++--------
 drivers/dax/dax.h  |    2 +-
 drivers/dax/pmem.c |   12 +++++++-----
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 586f9543de73..40be3747724d 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -546,7 +546,8 @@ static void dax_dev_release(struct device *dev)
 	struct dax_dev *dax_dev = to_dax_dev(dev);
 	struct dax_region *dax_region = dax_dev->region;
 
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	if (dax_dev->id >= 0)
+		ida_simple_remove(&dax_region->ida, dax_dev->id);
 	ida_simple_remove(&dax_minor_ida, MINOR(dev->devt));
 	dax_region_put(dax_region);
 	iput(dax_dev->inode);
@@ -581,7 +582,7 @@ static void unregister_dax_dev(void *dev)
 }
 
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
-		struct resource *res, int count)
+		int id, struct resource *res, int count)
 {
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
@@ -608,10 +609,16 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	if (i < count)
 		goto err_id;
 
-	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
-	if (dax_dev->id < 0) {
-		rc = dax_dev->id;
-		goto err_id;
+	if (id < 0) {
+		id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
+		dax_dev->id = id;
+		if (id < 0) {
+			rc = id;
+			goto err_id;
+		}
+	} else {
+		/* region provider owns @id lifetime */
+		dax_dev->id = -1;
 	}
 
 	minor = ida_simple_get(&dax_minor_ida, 0, 0, GFP_KERNEL);
@@ -650,7 +657,7 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
 	dev->parent = parent;
 	dev->groups = dax_attribute_groups;
 	dev->release = dax_dev_release;
-	dev_set_name(dev, "dax%d.%d", dax_region->id, dax_dev->id);
+	dev_set_name(dev, "dax%d.%d", dax_region->id, id);
 	rc = device_add(dev);
 	if (rc) {
 		kill_dax_dev(dax_dev);
@@ -669,7 +676,8 @@ struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
  err_inode:
 	ida_simple_remove(&dax_minor_ida, minor);
  err_minor:
-	ida_simple_remove(&dax_region->ida, dax_dev->id);
+	if (dax_dev->id >= 0)
+		ida_simple_remove(&dax_region->ida, dax_dev->id);
  err_id:
 	kfree(dax_dev);
 
diff --git a/drivers/dax/dax.h b/drivers/dax/dax.h
index ddd829ab58c0..b5ed85036b2a 100644
--- a/drivers/dax/dax.h
+++ b/drivers/dax/dax.h
@@ -21,5 +21,5 @@ struct dax_region *alloc_dax_region(struct device *parent,
 		int region_id, struct resource *res, unsigned int align,
 		void *addr, unsigned long flags);
 struct dax_dev *devm_create_dax_dev(struct dax_region *dax_region,
-		struct resource *res, int count);
+		int id, struct resource *res, int count);
 #endif /* __DAX_H__ */
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index 73c6ce93a0d9..eebb35720398 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -58,13 +58,12 @@ static void dax_pmem_percpu_kill(void *data)
 
 static int dax_pmem_probe(struct device *dev)
 {
-	int rc;
 	void *addr;
 	struct resource res;
 	struct dax_dev *dax_dev;
+	int rc, id, region_id;
 	struct nd_pfn_sb *pfn_sb;
 	struct dax_pmem *dax_pmem;
-	struct nd_region *nd_region;
 	struct nd_namespace_io *nsio;
 	struct dax_region *dax_region;
 	struct nd_namespace_common *ndns;
@@ -122,14 +121,17 @@ static int dax_pmem_probe(struct device *dev)
 	/* adjust the dax_region resource to the start of data */
 	res.start += le64_to_cpu(pfn_sb->dataoff);
 
-	nd_region = to_nd_region(dev->parent);
-	dax_region = alloc_dax_region(dev, nd_region->id, &res,
+	rc = sscanf(dev_name(&ndns->dev), "namespace%d.%d", &region_id, &id);
+	if (rc != 2)
+		return -EINVAL;
+
+	dax_region = alloc_dax_region(dev, region_id, &res,
 			le32_to_cpu(pfn_sb->align), addr, PFN_DEV|PFN_MAP);
 	if (!dax_region)
 		return -ENOMEM;
 
 	/* TODO: support for subdividing a dax region... */
-	dax_dev = devm_create_dax_dev(dax_region, &res, 1);
+	dax_dev = devm_create_dax_dev(dax_region, id, &res, 1);
 
 	/* child dax_dev instances now own the lifetime of the dax_region */
 	dax_region_put(dax_region);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
