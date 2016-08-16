Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 9CA191A1DF2
 for <linux-nvdimm@lists.01.org>; Tue, 16 Aug 2016 10:12:30 -0700 (PDT)
Subject: [PATCH 1/4] dax: check resource alignment at dax region/device create
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Aug 2016 10:09:33 -0700
Message-ID: <147136737319.26813.14434475165026289637.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147136736786.26813.5042217541564666020.stgit@dwillia2-desk3.amr.corp.intel.com>
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

All the extents of a dax-device must match the alignment of the region.
Otherwise, we are unable to guarantee fault semantics of a given page
size.  The region must be self-consistent itself as well.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/dax.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/dax.c b/drivers/dax/dax.c
index 0a7899d5c65c..03bb54f7f58f 100644
--- a/drivers/dax/dax.c
+++ b/drivers/dax/dax.c
@@ -206,8 +206,11 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 {
 	struct dax_region *dax_region;
 
-	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
+	if (!IS_ALIGNED(res->start, align)
+			|| !IS_ALIGNED(resource_size(res), align))
+		return NULL;
 
+	dax_region = kzalloc(sizeof(*dax_region), GFP_KERNEL);
 	if (!dax_region)
 		return NULL;
 
@@ -560,15 +563,29 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 {
 	struct device *parent = dax_region->dev;
 	struct dax_dev *dax_dev;
+	int rc = 0, minor, i;
 	struct device *dev;
 	struct cdev *cdev;
-	int rc, minor;
 	dev_t dev_t;
 
 	dax_dev = kzalloc(sizeof(*dax_dev) + sizeof(*res) * count, GFP_KERNEL);
 	if (!dax_dev)
 		return -ENOMEM;
 
+	for (i = 0; i < count; i++) {
+		if (!IS_ALIGNED(res[i].start, dax_region->align)
+				|| !IS_ALIGNED(resource_size(&res[i]),
+					dax_region->align)) {
+			rc = -EINVAL;
+			break;
+		}
+		dax_dev->res[i].start = res[i].start;
+		dax_dev->res[i].end = res[i].end;
+	}
+
+	if (i < count)
+		goto err_id;
+
 	dax_dev->id = ida_simple_get(&dax_region->ida, 0, 0, GFP_KERNEL);
 	if (dax_dev->id < 0) {
 		rc = dax_dev->id;
@@ -601,7 +618,6 @@ int devm_create_dax_dev(struct dax_region *dax_region, struct resource *res,
 		goto err_cdev;
 
 	/* from here on we're committed to teardown via dax_dev_release() */
-	memcpy(dax_dev->res, res, sizeof(*res) * count);
 	dax_dev->num_resources = count;
 	dax_dev->alive = true;
 	dax_dev->region = dax_region;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
