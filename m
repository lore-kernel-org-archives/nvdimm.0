Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 20A7E1A1E3F
 for <linux-nvdimm@lists.01.org>; Thu,  2 Jun 2016 16:23:00 -0700 (PDT)
Subject: [PATCH] libnvdimm: IS_ERR() usage cleanup
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 02 Jun 2016 16:21:45 -0700
Message-ID: <146490970526.23141.5428974148893318100.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Prompted by commit 287980e49ffc "remove lots of IS_ERR_VALUE abuses", I
ran make coccicheck against drivers/nvdimm/ and found that:

	if (IS_ERR(x))
		return PTR_ERR(x);
	return 0;

...can be replaced with PTR_ERR_OR_ZERO().

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c   |    6 ++----
 drivers/nvdimm/claim.c |    5 ++---
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index f085f8bceae8..e4882e63bece 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -395,12 +395,10 @@ int nvdimm_bus_create_ndctl(struct nvdimm_bus *nvdimm_bus)
 	dev = device_create(nd_class, &nvdimm_bus->dev, devt, nvdimm_bus,
 			"ndctl%d", nvdimm_bus->id);
 
-	if (IS_ERR(dev)) {
+	if (IS_ERR(dev))
 		dev_dbg(&nvdimm_bus->dev, "failed to register ndctl%d: %ld\n",
 				nvdimm_bus->id, PTR_ERR(dev));
-		return PTR_ERR(dev);
-	}
-	return 0;
+	return PTR_ERR_OR_ZERO(dev);
 }
 
 void nvdimm_bus_destroy_ndctl(struct nvdimm_bus *nvdimm_bus)
diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 8b2e3c4fb0ad..9997ff94a132 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -266,9 +266,8 @@ int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio)
 
 	nsio->addr = devm_memremap(dev, res->start, resource_size(res),
 			ARCH_MEMREMAP_PMEM);
-	if (IS_ERR(nsio->addr))
-		return PTR_ERR(nsio->addr);
-	return 0;
+
+	return PTR_ERR_OR_ZERO(nsio->addr);
 }
 EXPORT_SYMBOL_GPL(devm_nsio_enable);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
