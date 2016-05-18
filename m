Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 8FAA71A1FCD
 for <linux-nvdimm@lists.01.org>; Wed, 18 May 2016 13:57:25 -0700 (PDT)
Subject: [PATCH v3 5/5] libnvdimm: release ida resources
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 18 May 2016 13:56:33 -0700
Message-ID: <146360499323.37439.11321597319333400688.stgit@dwillia2-desk3.amr.corp.intel.com>
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

ida instances allocate some internal memory for ->free_bitmap in
addition to the base 'struct ida'.  Use ida_destroy() to release that
memory at module_exit().

Reported-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/core.c        |    3 +++
 drivers/nvdimm/dimm_devs.c   |    5 +++++
 drivers/nvdimm/nd-core.h     |    2 ++
 drivers/nvdimm/region_devs.c |    5 +++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index 182a93fe3712..847532de087a 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -648,6 +648,9 @@ static __exit void libnvdimm_exit(void)
 	nd_region_exit();
 	nvdimm_exit();
 	nvdimm_bus_exit();
+	nd_region_devs_exit();
+	nvdimm_devs_exit();
+	ida_destroy(&nd_ida);
 }
 
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index c56f88217924..6cca03eaa345 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -546,3 +546,8 @@ int nvdimm_bus_check_dimm_count(struct nvdimm_bus *nvdimm_bus, int dimm_count)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_check_dimm_count);
+
+void __exit nvdimm_devs_exit(void)
+{
+	ida_destroy(&dimm_ida);
+}
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index cb65308c0329..4136c1a82539 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -49,6 +49,8 @@ bool is_nd_blk(struct device *dev);
 struct nvdimm_bus *walk_to_nvdimm_bus(struct device *nd_dev);
 int __init nvdimm_bus_init(void);
 void nvdimm_bus_exit(void);
+void nvdimm_devs_exit(void);
+void nd_region_devs_exit(void);
 void nd_region_probe_success(struct nvdimm_bus *nvdimm_bus, struct device *dev);
 struct nd_region;
 void nd_region_create_blk_seed(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 9e1b054e0e61..40fcfea26fbb 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -793,3 +793,8 @@ struct nd_region *nvdimm_volatile_region_create(struct nvdimm_bus *nvdimm_bus,
 			__func__);
 }
 EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
+
+void __exit nd_region_devs_exit(void)
+{
+	ida_destroy(&region_ida);
+}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
