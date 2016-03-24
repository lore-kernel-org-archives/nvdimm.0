Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 676271A1ECF
 for <linux-nvdimm@lists.01.org>; Wed, 23 Mar 2016 18:26:45 -0700 (PDT)
Subject: [PATCH 04/13] libnvdimm, btt, convert nd_btt_probe() to devm
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 23 Mar 2016 18:25:42 -0700
Message-ID: <20160324012542.21436.95801.stgit@dwillia2-desk3.jf.intel.com>
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
the btt superblock.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/blk.c      |    2 +-
 drivers/nvdimm/btt.c      |   17 ++++++-----------
 drivers/nvdimm/btt_devs.c |   26 +++++++++++++-------------
 drivers/nvdimm/nd.h       |    6 ++++--
 drivers/nvdimm/pmem.c     |    2 +-
 5 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 24649396b638..c8215dc356cc 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -314,7 +314,7 @@ static int nd_blk_probe(struct device *dev)
 	ndns->rw_bytes = nd_blk_rw_bytes;
 	if (is_nd_btt(dev))
 		rc = nvdimm_namespace_attach_btt(ndns);
-	else if (nd_btt_probe(ndns, blk_dev) == 0) {
+	else if (nd_btt_probe(dev, ndns, blk_dev) == 0) {
 		/* we'll come back as btt-blk */
 		rc = -ENXIO;
 	} else
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 48e036621d05..a5ebbff46655 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1306,7 +1306,7 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	struct btt *btt;
 	struct device *dev = &nd_btt->dev;
 
-	btt = kzalloc(sizeof(struct btt), GFP_KERNEL);
+	btt = devm_kzalloc(dev, sizeof(struct btt), GFP_KERNEL);
 	if (!btt)
 		return NULL;
 
@@ -1321,13 +1321,13 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 	ret = discover_arenas(btt);
 	if (ret) {
 		dev_err(dev, "init: error in arena_discover: %d\n", ret);
-		goto out_free;
+		return NULL;
 	}
 
 	if (btt->init_state != INIT_READY && nd_region->ro) {
 		dev_info(dev, "%s is read-only, unable to init btt metadata\n",
 				dev_name(&nd_region->dev));
-		goto out_free;
+		return NULL;
 	} else if (btt->init_state != INIT_READY) {
 		btt->num_arenas = (rawsize / ARENA_MAX_SIZE) +
 			((rawsize % ARENA_MAX_SIZE) ? 1 : 0);
@@ -1337,29 +1337,25 @@ static struct btt *btt_init(struct nd_btt *nd_btt, unsigned long long rawsize,
 		ret = create_arenas(btt);
 		if (ret) {
 			dev_info(dev, "init: create_arenas: %d\n", ret);
-			goto out_free;
+			return NULL;
 		}
 
 		ret = btt_meta_init(btt);
 		if (ret) {
 			dev_err(dev, "init: error in meta_init: %d\n", ret);
-			goto out_free;
+			return NULL;
 		}
 	}
 
 	ret = btt_blk_init(btt);
 	if (ret) {
 		dev_err(dev, "init: error in blk_init: %d\n", ret);
-		goto out_free;
+		return NULL;
 	}
 
 	btt_debugfs_init(btt);
 
 	return btt;
-
- out_free:
-	kfree(btt);
-	return NULL;
 }
 
 /**
@@ -1377,7 +1373,6 @@ static void btt_fini(struct btt *btt)
 		btt_blk_cleanup(btt);
 		free_arenas(btt);
 		debugfs_remove_recursive(btt->debugfs_dir);
-		kfree(btt);
 	}
 }
 
diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index cb477518dd0e..1886171af80e 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -273,10 +273,11 @@ static int __nd_btt_probe(struct nd_btt *nd_btt,
 	return 0;
 }
 
-int nd_btt_probe(struct nd_namespace_common *ndns, void *drvdata)
+int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns,
+		void *drvdata)
 {
 	int rc;
-	struct device *dev;
+	struct device *btt_dev;
 	struct btt_sb *btt_sb;
 	struct nd_region *nd_region = to_nd_region(ndns->dev.parent);
 
@@ -284,21 +285,20 @@ int nd_btt_probe(struct nd_namespace_common *ndns, void *drvdata)
 		return -ENODEV;
 
 	nvdimm_bus_lock(&ndns->dev);
-	dev = __nd_btt_create(nd_region, 0, NULL, ndns);
+	btt_dev = __nd_btt_create(nd_region, 0, NULL, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
-	if (!dev)
+	if (!btt_dev)
 		return -ENOMEM;
-	dev_set_drvdata(dev, drvdata);
-	btt_sb = kzalloc(sizeof(*btt_sb), GFP_KERNEL);
-	rc = __nd_btt_probe(to_nd_btt(dev), ndns, btt_sb);
-	kfree(btt_sb);
-	dev_dbg(&ndns->dev, "%s: btt: %s\n", __func__,
-			rc == 0 ? dev_name(dev) : "<none>");
+	dev_set_drvdata(btt_dev, drvdata);
+	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
+	rc = __nd_btt_probe(to_nd_btt(btt_dev), ndns, btt_sb);
+	dev_dbg(dev, "%s: btt: %s\n", __func__,
+			rc == 0 ? dev_name(btt_dev) : "<none>");
 	if (rc < 0) {
-		struct nd_btt *nd_btt = to_nd_btt(dev);
+		struct nd_btt *nd_btt = to_nd_btt(btt_dev);
 
-		__nd_detach_ndns(dev, &nd_btt->ndns);
-		put_device(dev);
+		__nd_detach_ndns(btt_dev, &nd_btt->ndns);
+		put_device(btt_dev);
 	}
 
 	return rc;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index c831caa3d60a..0fb14890ba26 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -197,11 +197,13 @@ struct nd_gen_sb {
 
 u64 nd_sb_checksum(struct nd_gen_sb *sb);
 #if IS_ENABLED(CONFIG_BTT)
-int nd_btt_probe(struct nd_namespace_common *ndns, void *drvdata);
+int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns,
+		void *drvdata);
 bool is_nd_btt(struct device *dev);
 struct device *nd_btt_create(struct nd_region *nd_region);
 #else
-static inline int nd_btt_probe(struct nd_namespace_common *ndns, void *drvdata)
+static inline int nd_btt_probe(struct device *dev,
+		struct nd_namespace_common *ndns, void *drvdata)
 {
 	return -ENODEV;
 }
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 77d94b42c32f..1e492c66d105 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -560,7 +560,7 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return nvdimm_namespace_attach_pfn(ndns);
 
-	if (nd_btt_probe(ndns, pmem) == 0
+	if (nd_btt_probe(dev, ndns, pmem) == 0
 			|| nd_pfn_probe(dev, ndns, pmem) == 0) {
 		/*
 		 * We'll come back as either btt-pmem, or pfn-pmem, so

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
