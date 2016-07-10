Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 071EC1A1E21
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:22 -0700 (PDT)
Subject: [PATCH v2 11/17] libnvdimm,
 pmem: flush posted-write queues on shutdown
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:27 -0700
Message-ID: <146812112775.32932.16750910979264437016.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Commit writes to media on system shutdown or pmem driver unload.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/bus.c  |   16 ++++++++++++++++
 drivers/nvdimm/pmem.c |    8 ++++++++
 include/linux/nd.h    |    1 +
 3 files changed, 25 insertions(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index e4882e63bece..1cc7880320fe 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -136,6 +136,21 @@ static int nvdimm_bus_remove(struct device *dev)
 	return rc;
 }
 
+static void nvdimm_bus_shutdown(struct device *dev)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
+	struct nd_device_driver *nd_drv = NULL;
+
+	if (dev->driver)
+		nd_drv = to_nd_device_driver(dev->driver);
+
+	if (nd_drv && nd_drv->shutdown) {
+		nd_drv->shutdown(dev);
+		dev_dbg(&nvdimm_bus->dev, "%s.shutdown(%s)\n",
+				dev->driver->name, dev_name(dev));
+	}
+}
+
 void nd_device_notify(struct device *dev, enum nvdimm_event event)
 {
 	device_lock(dev);
@@ -214,6 +229,7 @@ static struct bus_type nvdimm_bus_type = {
 	.match = nvdimm_bus_match,
 	.probe = nvdimm_bus_probe,
 	.remove = nvdimm_bus_remove,
+	.shutdown = nvdimm_bus_shutdown,
 };
 
 static ASYNC_DOMAIN_EXCLUSIVE(nd_async_domain);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 18cd95719da0..3f3fdb9586b9 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -351,9 +351,16 @@ static int nd_pmem_remove(struct device *dev)
 {
 	if (is_nd_btt(dev))
 		nvdimm_namespace_detach_btt(to_nd_btt(dev));
+	nvdimm_flush(to_nd_region(dev->parent));
+
 	return 0;
 }
 
+static void nd_pmem_shutdown(struct device *dev)
+{
+	nvdimm_flush(to_nd_region(dev->parent));
+}
+
 static void nd_pmem_notify(struct device *dev, enum nvdimm_event event)
 {
 	struct pmem_device *pmem = dev_get_drvdata(dev);
@@ -393,6 +400,7 @@ static struct nd_device_driver nd_pmem_driver = {
 	.probe = nd_pmem_probe,
 	.remove = nd_pmem_remove,
 	.notify = nd_pmem_notify,
+	.shutdown = nd_pmem_shutdown,
 	.drv = {
 		.name = "nd_pmem",
 	},
diff --git a/include/linux/nd.h b/include/linux/nd.h
index aee2761d294c..1ecd64643512 100644
--- a/include/linux/nd.h
+++ b/include/linux/nd.h
@@ -26,6 +26,7 @@ struct nd_device_driver {
 	unsigned long type;
 	int (*probe)(struct device *dev);
 	int (*remove)(struct device *dev);
+	void (*shutdown)(struct device *dev);
 	void (*notify)(struct device *dev, enum nvdimm_event event);
 };
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
