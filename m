Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 714372114842B
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:53:09 -0700 (PDT)
Subject: [PATCH 2/2] nvdimm: Set device node in nd_device_register
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Tue, 25 Sep 2018 13:53:07 -0700
Message-ID: <20180925205307.6182.26453.stgit@localhost.localdomain>
In-Reply-To: <20180925204801.6182.73167.stgit@localhost.localdomain>
References: <20180925204801.6182.73167.stgit@localhost.localdomain>
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
To: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: zwisler@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

This change makes it so that we don't repeatedly overwrite the device node
for nvdimm regions. The earliest we can set the node is immediately after
calling device init, so I have moved the code there so we can avoid
rewriting the node with each uevent.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/bus.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9148015ed803..96f4d0e1706a 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -54,12 +54,6 @@ static int to_nd_device_type(struct device *dev)
 
 static int nvdimm_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	/*
-	 * Ensure that region devices always have their numa node set as
-	 * early as possible.
-	 */
-	if (is_nd_region(dev))
-		set_dev_node(dev, to_nd_region(dev)->numa_node);
 	return add_uevent_var(env, "MODALIAS=" ND_DEVICE_MODALIAS_FMT,
 			to_nd_device_type(dev));
 }
@@ -519,6 +513,16 @@ void __nd_device_register(struct device *dev)
 void nd_device_register(struct device *dev)
 {
 	device_initialize(dev);
+
+	/*
+	 * Ensure that region devices always have their NUMA node set as
+	 * early as possible. This way we are able to make certain that any
+	 * memory associated with the creation and the creation itself of
+	 * the region is associated with the correct node.
+	 */
+	if (is_nd_region(dev))
+		set_dev_node(dev, to_nd_region(dev)->numa_node);
+
 	__nd_device_register(dev);
 }
 EXPORT_SYMBOL(nd_device_register);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
