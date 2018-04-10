Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2668D2261815B
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 14:19:40 -0700 (PDT)
Subject: [PATCH v2] libnvdimm: fix NULL ptr access in nvdimm_flush when
 region is disabled
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 10 Apr 2018 14:19:39 -0700
Message-ID: <152339515127.30466.8052576975908716815.stgit@djiang5-desk3.ch.intel.com>
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

When a region is disabled, there is no driver attached. Therefore
dev->driverdata is NULL. An attempt to write to regionN/deep_flush via sysfs
would cause a NULL pointer dereference. Bail when dev->driver is NULL to
protect this scenario.

Fix: ab630891ce0eb(libnvdimm, region: sysfs trigger for nvdimm_flush())

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2: Move to deep_flush_store. (Dan)

 drivers/nvdimm/region_devs.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index a612be6f019d..65cc2a5b48b8 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -290,6 +290,11 @@ static ssize_t deep_flush_store(struct device *dev, struct device_attribute *att
 		return rc;
 	if (!flush)
 		return -EINVAL;
+
+	/* protect against disabled region */
+	if (!nd_region->dev.driver)
+		return -ENXIO;
+
 	nvdimm_flush(nd_region);
 
 	return len;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
