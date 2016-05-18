Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 9DB4A1A1FC9
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 13:57:03 -0700 (PDT)
Subject: [PATCH v3 1/5] libnvdimm: stop requiring a driver ->remove() method
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 13:56:11 -0700
Message-ID: <146360497107.37439.10316060945952347673.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146360496572.37439.6497663679891935585.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The dax_pmem driver was implementing an empty ->remove() method to
satisfy the nvdimm bus driver that unconditionally calls ->remove().
Teach the core bus driver to check if ->remove() is NULL to remove that
requirement.

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 97589e3cb852..7cbc3d58d176 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -124,9 +124,10 @@ static int nvdimm_bus_remove(struct device *dev)
 	struct nd_device_driver *nd_drv = to_nd_device_driver(dev->driver);
 	struct module *provider = to_bus_provider(dev);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
-	int rc;
+	int rc = 0;
 
-	rc = nd_drv->remove(dev);
+	if (nd_drv->remove)
+		rc = nd_drv->remove(dev);
 	nd_region_disable(nvdimm_bus, dev);
 
 	dev_dbg(&nvdimm_bus->dev, "%s.remove(%s) = %d\n", dev->driver->name,
@@ -296,8 +297,8 @@ int __nd_driver_register(struct nd_device_driver *nd_drv, struct module *owner,
 		return -EINVAL;
 	}
 
-	if (!nd_drv->probe || !nd_drv->remove) {
-		pr_debug("->probe() and ->remove() must be specified\n");
+	if (!nd_drv->probe) {
+		pr_debug("%s ->probe() must be specified\n", mod_name);
 		return -EINVAL;
 	}
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
