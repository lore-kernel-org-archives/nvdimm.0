Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id EBED91A1E48
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:00 -0700 (PDT)
Subject: [PATCH v2 07/17] libnvdimm: keep region data alive over namespace
 removal
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:06 -0700
Message-ID: <146812110665.32932.12943031269797555126.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

nd_region device driver data will be used in the namespace i/o path.
Re-order nd_region_remove() to ensure this data stays live across
namespace device removal

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/region.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
index 333175dac8d5..8f241772ec0b 100644
--- a/drivers/nvdimm/region.c
+++ b/drivers/nvdimm/region.c
@@ -82,6 +82,8 @@ static int nd_region_remove(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
 
+	device_for_each_child(dev, NULL, child_unregister);
+
 	/* flush attribute readers and disable */
 	nvdimm_bus_lock(dev);
 	nd_region->ns_seed = NULL;
@@ -91,7 +93,6 @@ static int nd_region_remove(struct device *dev)
 	dev_set_drvdata(dev, NULL);
 	nvdimm_bus_unlock(dev);
 
-	device_for_each_child(dev, NULL, child_unregister);
 	return 0;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
