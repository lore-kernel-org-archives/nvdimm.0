Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 52E571A1ED2
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:40 -0700 (PDT)
Subject: [PATCH 03/13] libnvdimm, pfn, convert nd_pfn_probe() to devm
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:37 -0700
Message-ID: <20160324012537.21436.22245.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Pass the device performing the probe so we can use a devm allocation for
the pfn superblock.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h       |    6 ++++--
 drivers/nvdimm/pfn_devs.c |   27 +++++++++++++--------------
 drivers/nvdimm/pmem.c     |   30 +++++++++---------------------
 3 files changed, 26 insertions(+), 37 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index b0a4ab91307b..c831caa3d60a 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -219,12 +219,14 @@ static inline struct device *nd_btt_create(struct nd_region *nd_region)
 
 struct nd_pfn *to_nd_pfn(struct device *dev);
 #if IS_ENABLED(CONFIG_NVDIMM_PFN)
-int nd_pfn_probe(struct nd_namespace_common *ndns, void *drvdata);
+int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
+		void *drvdata);
 bool is_nd_pfn(struct device *dev);
 struct device *nd_pfn_create(struct nd_region *nd_region);
 int nd_pfn_validate(struct nd_pfn *nd_pfn);
 #else
-static inline int nd_pfn_probe(struct nd_namespace_common *ndns, void *drvdata)
+static inline int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
+		void *drvdata)
 {
 	return -ENODEV;
 }
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 254d3bc13f70..63e2df3e052c 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -410,11 +410,12 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 }
 EXPORT_SYMBOL(nd_pfn_validate);
 
-int nd_pfn_probe(struct nd_namespace_common *ndns, void *drvdata)
+int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns,
+		void *drvdata)
 {
 	int rc;
-	struct device *dev;
 	struct nd_pfn *nd_pfn;
+	struct device *pfn_dev;
 	struct nd_pfn_sb *pfn_sb;
 	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
 
@@ -422,24 +423,22 @@ int nd_pfn_probe(struct nd_namespace_common *ndns, void *drvdata)
 		return -ENODEV;
 
 	nvdimm_bus_lock(&ndns->dev);
-	dev = __nd_pfn_create(nd_region, ndns);
+	pfn_dev = __nd_pfn_create(nd_region, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
-	if (!dev)
+	if (!pfn_dev)
 		return -ENOMEM;
-	dev_set_drvdata(dev, drvdata);
-	pfn_sb = kzalloc(sizeof(*pfn_sb), GFP_KERNEL);
-	nd_pfn = to_nd_pfn(dev);
+	dev_set_drvdata(pfn_dev, drvdata);
+	pfn_sb = devm_kzalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn);
-	nd_pfn->pfn_sb = NULL;
-	kfree(pfn_sb);
-	dev_dbg(&ndns->dev, "%s: pfn: %s\n", __func__,
-			rc == 0 ? dev_name(dev) : "<none>");
+	dev_dbg(dev, "%s: pfn: %s\n", __func__,
+			rc == 0 ? dev_name(pfn_dev) : "<none>");
 	if (rc < 0) {
-		__nd_detach_ndns(dev, &nd_pfn->ndns);
-		put_device(dev);
+		__nd_detach_ndns(pfn_dev, &nd_pfn->ndns);
+		put_device(pfn_dev);
 	} else
-		__nd_device_register(&nd_pfn->dev);
+		__nd_device_register(pfn_dev);
 
 	return rc;
 }
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b13b9095f620..77d94b42c32f 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -316,18 +316,19 @@ static int pmem_rw_bytes(struct nd_namespace_common *ndns,
 
 static int nd_pfn_init(struct nd_pfn *nd_pfn)
 {
-	struct nd_pfn_sb *pfn_sb = kzalloc(sizeof(*pfn_sb), GFP_KERNEL);
 	struct pmem_device *pmem = dev_get_drvdata(&nd_pfn->dev);
 	struct nd_namespace_common *ndns = nd_pfn->ndns;
 	u32 start_pad = 0, end_trunc = 0;
 	resource_size_t start, size;
 	struct nd_namespace_io *nsio;
 	struct nd_region *nd_region;
+	struct nd_pfn_sb *pfn_sb;
 	unsigned long npfns;
 	phys_addr_t offset;
 	u64 checksum;
 	int rc;
 
+	pfn_sb = devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
 	if (!pfn_sb)
 		return -ENOMEM;
 
@@ -343,7 +344,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 		dev_info(&nd_pfn->dev,
 				"%s is read-only, unable to init metadata\n",
 				dev_name(&nd_region->dev));
-		goto err;
+		return -ENXIO;
 	}
 
 	memset(pfn_sb, 0, sizeof(*pfn_sb));
@@ -388,12 +389,12 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	else if (nd_pfn->mode == PFN_MODE_RAM)
 		offset = ALIGN(start + SZ_8K, nd_pfn->align) - start;
 	else
-		goto err;
+		return -ENXIO;
 
 	if (offset + start_pad + end_trunc >= pmem->size) {
 		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
 				dev_name(&ndns->dev));
-		goto err;
+		return -ENXIO;
 	}
 
 	npfns = (pmem->size - offset - start_pad - end_trunc) / SZ_4K;
@@ -410,30 +411,16 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
 	checksum = nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
 	pfn_sb->checksum = cpu_to_le64(checksum);
 
-	rc = nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
-	if (rc)
-		goto err;
-
-	return 0;
- err:
-	nd_pfn->pfn_sb = NULL;
-	kfree(pfn_sb);
-	return -ENXIO;
+	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
 }
 
-static int nvdimm_namespace_detach_pfn(struct nd_pfn *nd_pfn)
+static void nvdimm_namespace_detach_pfn(struct nd_pfn *nd_pfn)
 {
 	struct pmem_device *pmem;
 
 	/* free pmem disk */
 	pmem = dev_get_drvdata(&nd_pfn->dev);
 	pmem_detach_disk(pmem);
-
-	/* release nd_pfn resources */
-	kfree(nd_pfn->pfn_sb);
-	nd_pfn->pfn_sb = NULL;
-
-	return 0;
 }
 
 /*
@@ -573,7 +560,8 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return nvdimm_namespace_attach_pfn(ndns);
 
-	if (nd_btt_probe(ndns, pmem) == 0 || nd_pfn_probe(ndns, pmem) == 0) {
+	if (nd_btt_probe(ndns, pmem) == 0
+			|| nd_pfn_probe(dev, ndns, pmem) == 0) {
 		/*
 		 * We'll come back as either btt-pmem, or pfn-pmem, so
 		 * drop the queue allocation for now.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
