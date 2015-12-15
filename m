Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 2/9] libnvdimm, pfn: clean up pfn create parameters
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Dec 2015 18:14:39 -0800
Message-ID: <20151215021439.37090.42307.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
References: <20151215021428.37090.30720.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-nvdimm@lists.01.org
Cc: willy@linux.intel.com, ross.zwisler@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In all cases __nd_pfn_create is called with default parameters which are
then overridden by values in the info block.  Clean up pfn creation by
dropping the parameters and setting default values internal to
__nd_pfn_create.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 96c122918ee1..613ffcca6ecb 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -179,7 +179,6 @@ static const struct attribute_group *nd_pfn_attribute_groups[] = {
 };
 
 static struct device *__nd_pfn_create(struct nd_region *nd_region,
-		u8 *uuid, enum nd_pfn_mode mode,
 		struct nd_namespace_common *ndns)
 {
 	struct nd_pfn *nd_pfn;
@@ -199,10 +198,7 @@ static struct device *__nd_pfn_create(struct nd_region *nd_region,
 		return NULL;
 	}
 
-	nd_pfn->mode = mode;
-	if (uuid)
-		uuid = kmemdup(uuid, 16, GFP_KERNEL);
-	nd_pfn->uuid = uuid;
+	nd_pfn->mode = PFN_MODE_NONE;
 	dev = &nd_pfn->dev;
 	dev_set_name(dev, "pfn%d.%d", nd_region->id, nd_pfn->id);
 	dev->parent = &nd_region->dev;
@@ -220,8 +216,7 @@ static struct device *__nd_pfn_create(struct nd_region *nd_region,
 
 struct device *nd_pfn_create(struct nd_region *nd_region)
 {
-	struct device *dev = __nd_pfn_create(nd_region, NULL, PFN_MODE_NONE,
-			NULL);
+	struct device *dev = __nd_pfn_create(nd_region, NULL);
 
 	if (dev)
 		__nd_device_register(dev);
@@ -304,7 +299,7 @@ int nd_pfn_probe(struct nd_namespace_common *ndns, void *drvdata)
 		return -ENODEV;
 
 	nvdimm_bus_lock(&ndns->dev);
-	dev = __nd_pfn_create(nd_region, NULL, PFN_MODE_NONE, ndns);
+	dev = __nd_pfn_create(nd_region, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dev)
 		return -ENOMEM;

