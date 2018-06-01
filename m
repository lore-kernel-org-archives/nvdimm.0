Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 391BB210D6933
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 14:22:50 -0700 (PDT)
Subject: [PATCH] libnvdimm: debug probe times
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Jun 2018 14:12:52 -0700
Message-ID: <152788757290.17184.15378156389453066118.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Instrument nvdimm_bus_probe() to emit timestamps for the start and end
of libnvdimm device probing. This is useful for identifying sources of
libnvdimm sub-system initialization latency.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b9e0d30e317a..27902a8799b1 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -100,6 +100,9 @@ static int nvdimm_bus_probe(struct device *dev)
 	if (!try_module_get(provider))
 		return -ENXIO;
 
+	dev_dbg(&nvdimm_bus->dev, "START: %s.probe(%s)\n",
+			dev->driver->name, dev_name(dev));
+
 	nvdimm_bus_probe_start(nvdimm_bus);
 	rc = nd_drv->probe(dev);
 	if (rc == 0)
@@ -108,7 +111,7 @@ static int nvdimm_bus_probe(struct device *dev)
 		nd_region_disable(nvdimm_bus, dev);
 	nvdimm_bus_probe_end(nvdimm_bus);
 
-	dev_dbg(&nvdimm_bus->dev, "%s.probe(%s) = %d\n", dev->driver->name,
+	dev_dbg(&nvdimm_bus->dev, "END: %s.probe(%s) = %d\n", dev->driver->name,
 			dev_name(dev), rc);
 
 	if (rc != 0)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
