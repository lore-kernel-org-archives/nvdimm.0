Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 340242117B57B
 for <linux-nvdimm@lists.01.org>; Mon, 22 Oct 2018 13:18:44 -0700 (PDT)
Subject: [PATCH 5/9] dax/kmem: add more nd dax kmem infrastructure
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Mon, 22 Oct 2018 13:13:26 -0700
References: <20181022201317.8558C1D8@viggo.jf.intel.com>
In-Reply-To: <20181022201317.8558C1D8@viggo.jf.intel.com>
Message-Id: <20181022201326.5E3F2752@viggo.jf.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-mm@kvack.org, zwisler@kernel.org, fengguang.wu@intel.com, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>


Each DAX mode has a set of wrappers and helpers.  Add them
for the kmem mode.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Huang Ying <ying.huang@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>

---

 b/drivers/nvdimm/bus.c      |    2 ++
 b/drivers/nvdimm/dax_devs.c |   35 +++++++++++++++++++++++++++++++++++
 b/drivers/nvdimm/nd.h       |    6 ++++++
 3 files changed, 43 insertions(+)

diff -puN drivers/nvdimm/bus.c~dax-kmem-try-again-2018-4-bus-dev-type-kmem drivers/nvdimm/bus.c
--- a/drivers/nvdimm/bus.c~dax-kmem-try-again-2018-4-bus-dev-type-kmem	2018-10-22 13:12:23.024930389 -0700
+++ b/drivers/nvdimm/bus.c	2018-10-22 13:12:23.031930389 -0700
@@ -46,6 +46,8 @@ static int to_nd_device_type(struct devi
 		return ND_DEVICE_REGION_BLK;
 	else if (is_nd_dax(dev))
 		return ND_DEVICE_DAX_PMEM;
+	else if (is_nd_dax_kmem(dev))
+		return ND_DEVICE_DAX_KMEM;
 	else if (is_nd_region(dev->parent))
 		return nd_region_to_nstype(to_nd_region(dev->parent));
 
diff -puN drivers/nvdimm/dax_devs.c~dax-kmem-try-again-2018-4-bus-dev-type-kmem drivers/nvdimm/dax_devs.c
--- a/drivers/nvdimm/dax_devs.c~dax-kmem-try-again-2018-4-bus-dev-type-kmem	2018-10-22 13:12:23.026930389 -0700
+++ b/drivers/nvdimm/dax_devs.c	2018-10-22 13:12:23.031930389 -0700
@@ -51,6 +51,41 @@ struct nd_dax *to_nd_dax(struct device *
 }
 EXPORT_SYMBOL(to_nd_dax);
 
+/* nd_dax_kmem */
+static void nd_dax_kmem_release(struct device *dev)
+{
+	struct nd_region *nd_region = to_nd_region(dev->parent);
+	struct nd_dax_kmem *nd_dax_kmem = to_nd_dax_kmem(dev);
+	struct nd_pfn *nd_pfn = &nd_dax_kmem->nd_pfn;
+
+	dev_dbg(dev, "trace\n");
+	nd_detach_ndns(dev, &nd_pfn->ndns);
+	ida_simple_remove(&nd_region->dax_ida, nd_pfn->id);
+	kfree(nd_pfn->uuid);
+	kfree(nd_dax_kmem);
+}
+
+static struct device_type nd_dax_kmem_device_type = {
+	.name = "nd_dax_kmem",
+	.release = nd_dax_kmem_release,
+};
+
+bool is_nd_dax_kmem(struct device *dev)
+{
+	return dev ? dev->type == &nd_dax_kmem_device_type : false;
+}
+EXPORT_SYMBOL(is_nd_dax_kmem);
+
+struct nd_dax_kmem *to_nd_dax_kmem(struct device *dev)
+{
+	struct nd_dax_kmem *nd_dax_kmem = container_of(dev, struct nd_dax_kmem, nd_pfn.dev);
+
+	WARN_ON(!is_nd_dax_kmem(dev));
+	return nd_dax_kmem;
+}
+EXPORT_SYMBOL(to_nd_dax_kmem);
+/* end nd_dax_kmem */
+
 static const struct attribute_group *nd_dax_attribute_groups[] = {
 	&nd_pfn_attribute_group,
 	&nd_device_attribute_group,
diff -puN drivers/nvdimm/nd.h~dax-kmem-try-again-2018-4-bus-dev-type-kmem drivers/nvdimm/nd.h
--- a/drivers/nvdimm/nd.h~dax-kmem-try-again-2018-4-bus-dev-type-kmem	2018-10-22 13:12:23.027930389 -0700
+++ b/drivers/nvdimm/nd.h	2018-10-22 13:12:23.031930389 -0700
@@ -215,6 +215,10 @@ struct nd_dax {
 	struct nd_pfn nd_pfn;
 };
 
+struct nd_dax_kmem {
+	struct nd_pfn nd_pfn;
+};
+
 enum nd_async_mode {
 	ND_SYNC,
 	ND_ASYNC,
@@ -318,9 +322,11 @@ static inline int nd_pfn_validate(struct
 #endif
 
 struct nd_dax *to_nd_dax(struct device *dev);
+struct nd_dax_kmem *to_nd_dax_kmem(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_DAX)
 int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(struct device *dev);
+bool is_nd_dax_kmem(struct device *dev);
 struct device *nd_dax_create(struct nd_region *nd_region);
 #else
 static inline int nd_dax_probe(struct device *dev,
_
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
