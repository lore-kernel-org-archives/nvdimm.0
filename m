Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com
 [IPv6:2607:f8b0:4864:20::643])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C82FF2112292A
 for <linux-nvdimm@lists.01.org>; Sun,  9 Sep 2018 23:24:10 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f6-v6so9254615plo.1
 for <linux-nvdimm@lists.01.org>; Sun, 09 Sep 2018 23:24:10 -0700 (PDT)
From: Ocean He <oceanhehy@gmail.com>
Subject: [PATCH 3/3] libnvdimm,
 region_devs: reset related seeds when fail to create namespace
Date: Mon, 10 Sep 2018 02:21:48 -0400
Message-Id: <1536560508-24564-4-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
References: <1536560508-24564-1-git-send-email-oceanhehy@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, zwisler@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com
Cc: Ocean He <hehy1@lenovo.com>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

From: Ocean He <hehy1@lenovo.com>

During runtime, namespace creation may fail if blocked by
commit 15d36fecd0bdc7510b70 ("mm: disallow mappings that conflict for
devm_memremap_pages()"). To ensure pfn_seed/dax_seed and namespace_seed
are ready for next namespace creation, here to do detach and reset.

Signed-off-by: Ocean He <hehy1@lenovo.com>
---
 drivers/nvdimm/region_devs.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index fa37afc..4c46fb6 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -703,7 +703,27 @@ void nd_mapping_free_labels(struct nd_mapping *nd_mapping)
 		kfree(label_ent);
 	}
 }
+/*
+ * To ensure pfn_seed/dax_seed and namespace_seed are ready for
+ * next namespace creation, here to do detach and reset.
+ */
+void nd_region_detach_and_reset(struct device *dev,
+		struct nd_region *nd_region)
+{
+	/* Only nd_pmem has been verified, fix me for other dev type. */
+	if (!is_nd_pmem(&nd_region->dev))
+		return;
 
+	if (is_nd_pfn(dev) || is_nd_dax(dev)) {
+		struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
+		struct nd_namespace_common *ndns = to_ndns(nd_region->ns_seed);
+
+		if (nd_pfn->ndns == ndns && ndns->claim == dev) {
+			nd_detach_and_reset(dev, &nd_pfn->ndns);
+			nd_region_reset_ns_seed(nd_region);
+			}
+	}
+}
 /*
  * Upon successful probe/remove, take/release a reference on the
  * associated interleave set (if present), and plant new btt + namespace
@@ -774,6 +794,20 @@ static void nd_region_notify_driver_action(struct nvdimm_bus *nvdimm_bus,
 			nd_region_create_ns_seed(nd_region);
 		nvdimm_bus_unlock(dev);
 	}
+	if (is_nd_pfn(dev) && !probe) {
+		nd_region = to_nd_region(dev->parent);
+		nvdimm_bus_lock(dev);
+		if (nd_region->pfn_seed == dev)
+			nd_region_detach_and_reset(dev, nd_region);
+		nvdimm_bus_unlock(dev);
+	}
+	if (is_nd_dax(dev) && !probe) {
+		nd_region = to_nd_region(dev->parent);
+		nvdimm_bus_lock(dev);
+		if (nd_region->dax_seed == dev)
+			nd_region_detach_and_reset(dev, nd_region);
+		nvdimm_bus_unlock(dev);
+	}
 }
 
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev)
-- 
1.8.3.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
