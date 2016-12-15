Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19EDC81EB9
 for <linux-nvdimm@lists.01.org>; Wed, 14 Dec 2016 23:21:55 -0800 (PST)
Subject: [PATCH] libnvdimm,
 dax: replace mutex_is_locked() warnings with lockdep_assert_held
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 14 Dec 2016 23:17:46 -0800
Message-ID: <148178626605.29348.10608402287406082602.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For warnings that should only ever trigger during development and
testing replace WARN statements with lockdep_assert_held. The lockdep
pattern is prevalent, and these paths are are well covered by libnvdimm
+ dax unit tests.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c               |    4 ++--
 drivers/nvdimm/claim.c          |   10 ++++------
 drivers/nvdimm/namespace_devs.c |    2 +-
 drivers/nvdimm/region_devs.c    |    2 +-
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index c7b23d52f945..cae68465f430 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -94,7 +94,7 @@ static unsigned long long dax_region_avail_size(
 	unsigned long long size;
 	struct resource *res;
 
-	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
+	lockdep_assert_held(&dax_region->lock);
 
 	size = resource_size(&dax_region->res);
 	for_each_dax_region_resource(dax_region, res) {
@@ -419,7 +419,7 @@ static unsigned long long dax_dev_size(struct dax_dev *dax_dev)
 	unsigned long long size = 0;
 	int i;
 
-	WARN_ON_ONCE(!mutex_is_locked(&dax_region->lock));
+	lockdep_assert_held(&dax_region->lock);
 
 	if (!dax_dev->alive)
 		return 0;
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index d5dc80c48b4c..b910d171824a 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -22,9 +22,8 @@ void __nd_detach_ndns(struct device *dev, struct nd_namespace_common **_ndns)
 {
 	struct nd_namespace_common *ndns = *_ndns;
 
-	dev_WARN_ONCE(dev, !mutex_is_locked(&ndns->dev.mutex)
-			|| ndns->claim != dev,
-			"%s: invalid claim\n", __func__);
+	lockdep_assert_held(&ndns->dev.mutex);
+	dev_WARN_ONCE(dev, ndns->claim != dev, "%s: invalid claim\n", __func__);
 	ndns->claim = NULL;
 	*_ndns = NULL;
 	put_device(&ndns->dev);
@@ -49,9 +48,8 @@ bool __nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
 {
 	if (attach->claim)
 		return false;
-	dev_WARN_ONCE(dev, !mutex_is_locked(&attach->dev.mutex)
-			|| *_ndns,
-			"%s: invalid claim\n", __func__);
+	lockdep_assert_held(&attach->dev.mutex);
+	dev_WARN_ONCE(dev, *_ndns, "%s: invalid claim\n", __func__);
 	attach->claim = dev;
 	*_ndns = attach;
 	get_device(&attach->dev);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index abe5c6bc756c..874471a98751 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1653,7 +1653,7 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
 		u64 hw_start, hw_end, pmem_start, pmem_end;
 		struct nd_label_ent *label_ent;
 
-		WARN_ON(!mutex_is_locked(&nd_mapping->lock));
+		lockdep_assert_held(&nd_mapping->lock);
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 			nd_label = label_ent->label;
 			if (!nd_label)
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 6af5e629140c..7cd705f3247c 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -509,7 +509,7 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
 {
 	struct nd_label_ent *label_ent, *e;
 
-	WARN_ON(!mutex_is_locked(&nd_mapping->lock));
+	lockdep_assert_held(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
 		list_del(&label_ent->list);
 		kfree(label_ent);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
