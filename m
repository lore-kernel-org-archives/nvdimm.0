Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8FB21FB7D37
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 21:56:13 -0700 (PDT)
Subject: [PATCH 3/6] libnvdimm: add an api to cast a 'struct nd_region' to
 its 'struct device'
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 02 Apr 2018 21:46:17 -0700
Message-ID: <152273077753.38372.6434283957266644623.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

For debug, it is useful for bus providers to be able to retrieve the
'struct device' associated with an nd_region instance that it
registered. We already have to_nd_region() to perform the reverse cast
operation, in fact its duplicate declaration can be removed from the
private drivers/nvdimm/nd.h header.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h          |    1 -
 drivers/nvdimm/region_devs.c |    8 ++++++++
 include/linux/libnvdimm.h    |    1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 8d6375ee0fda..9dad5d737309 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -341,7 +341,6 @@ static inline struct device *nd_dax_create(struct nd_region *nd_region)
 }
 #endif
 
-struct nd_region *to_nd_region(struct device *dev);
 int nd_region_to_nstype(struct nd_region *nd_region);
 int nd_region_register_namespaces(struct nd_region *nd_region, int *err);
 u64 nd_region_interleave_set_cookie(struct nd_region *nd_region,
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index e6d01911e092..0af275c62bdf 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -182,6 +182,14 @@ struct nd_region *to_nd_region(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(to_nd_region);
 
+struct device *nd_region_dev(struct nd_region *nd_region)
+{
+	if (!nd_region)
+		return NULL;
+	return &nd_region->dev;
+}
+EXPORT_SYMBOL_GPL(nd_region_dev);
+
 struct nd_blk_region *to_nd_blk_region(struct device *dev)
 {
 	struct nd_region *nd_region = to_nd_region(dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index ff855ed965fb..e0684a678a1b 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -164,6 +164,7 @@ void nvdimm_bus_unregister(struct nvdimm_bus *nvdimm_bus);
 struct nvdimm_bus *to_nvdimm_bus(struct device *dev);
 struct nvdimm *to_nvdimm(struct device *dev);
 struct nd_region *to_nd_region(struct device *dev);
+struct device *nd_region_dev(struct nd_region *nd_region);
 struct nd_blk_region *to_nd_blk_region(struct device *dev);
 struct nvdimm_bus_descriptor *to_nd_desc(struct nvdimm_bus *nvdimm_bus);
 struct device *to_nvdimm_bus_dev(struct nvdimm_bus *nvdimm_bus);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
