Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C4AE221148ECD
 for <linux-nvdimm@lists.01.org>; Thu, 20 Sep 2018 15:30:18 -0700 (PDT)
Subject: [PATCH v4 5/5] nvdimm: Schedule device registration on node local
 to the device
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Thu, 20 Sep 2018 15:29:57 -0700
Message-ID: <20180920222951.19464.39241.stgit@localhost.localdomain>
In-Reply-To: <20180920215824.19464.8884.stgit@localhost.localdomain>
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
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
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, dave.hansen@intel.com, jglisse@redhat.com, akpm@linux-foundation.org, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

This patch is meant to force the device registration for nvdimm devices to
be closer to the actual device. This is achieved by using either the NUMA
node ID of the region, or of the parent. By doing this we can have
everything above the region based on the region, and everything below the
region based on the nvdimm bus.

One additional change I made is that we hold onto a reference to the parent
while we are going through registration. By doing this we can guarantee we
can complete the registration before we have the parent device removed.

By guaranteeing NUMA locality I see an improvement of as high as 25% for
per-node init of a system with 12TB of persistent memory.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/nvdimm/bus.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 8aae6dcc839f..ca935296d55e 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -487,7 +487,9 @@ static void nd_async_device_register(void *d, async_cookie_t cookie)
 		dev_err(dev, "%s: failed\n", __func__);
 		put_device(dev);
 	}
+
 	put_device(dev);
+	put_device(dev->parent);
 }
 
 static void nd_async_device_unregister(void *d, async_cookie_t cookie)
@@ -504,12 +506,25 @@ static void nd_async_device_unregister(void *d, async_cookie_t cookie)
 
 void __nd_device_register(struct device *dev)
 {
+	int node;
+
 	if (!dev)
 		return;
+
 	dev->bus = &nvdimm_bus_type;
+	get_device(dev->parent);
 	get_device(dev);
-	async_schedule_domain(nd_async_device_register, dev,
-			&nd_async_domain);
+
+	/*
+	 * For a region we can break away from the parent node,
+	 * otherwise for all other devices we just inherit the node from
+	 * the parent.
+	 */
+	node = is_nd_region(dev) ? to_nd_region(dev)->numa_node :
+				   dev_to_node(dev->parent);
+
+	async_schedule_on_domain(nd_async_device_register, dev, node,
+				 &nd_async_domain);
 }
 
 void nd_device_register(struct device *dev)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
