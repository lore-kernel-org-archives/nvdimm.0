Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 688A5212DD37D
 for <linux-nvdimm@lists.01.org>; Fri,  9 Aug 2019 00:48:10 -0700 (PDT)
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v5 1/4] nvdimm: Consider probe return -EOPNOTSUPP as success
Date: Fri,  9 Aug 2019 13:15:17 +0530
Message-Id: <20190809074520.27115-2-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
References: <20190809074520.27115-1-aneesh.kumar@linux.ibm.com>
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
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch add -EOPNOTSUPP as return from probe callback to
indicate we were not able to initialize a namespace due to pfn superblock
feature/version mismatch. We want to consider this a probe success so that
we can create new namesapce seed and there by avoid marking the failed
namespace as the seed namespace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/bus.c  |  2 +-
 drivers/nvdimm/pmem.c | 26 ++++++++++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 798c5c4aea9c..16c35e6446a7 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -95,7 +95,7 @@ static int nvdimm_bus_probe(struct device *dev)
 	rc = nd_drv->probe(dev);
 	debug_nvdimm_unlock(dev);
 
-	if (rc == 0)
+	if (rc == 0 || rc == -EOPNOTSUPP)
 		nd_region_probe_success(nvdimm_bus, dev);
 	else
 		nd_region_disable(nvdimm_bus, dev);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4c121dd03dd9..3f498881dd28 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -490,6 +490,7 @@ static int pmem_attach_disk(struct device *dev,
 
 static int nd_pmem_probe(struct device *dev)
 {
+	int ret;
 	struct nd_namespace_common *ndns;
 
 	ndns = nvdimm_namespace_common_probe(dev);
@@ -505,12 +506,29 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return pmem_attach_disk(dev, ndns);
 
-	/* if we find a valid info-block we'll come back as that personality */
-	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
-			|| nd_dax_probe(dev, ndns) == 0)
+	ret = nd_btt_probe(dev, ndns);
+	if (ret == 0)
 		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
 
-	/* ...otherwise we're just a raw pmem device */
+	ret = nd_pfn_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+
+	ret = nd_dax_probe(dev, ndns);
+	if (ret == 0)
+		return -ENXIO;
+	else if (ret == -EOPNOTSUPP)
+		return ret;
+	/*
+	 * We have two failure conditions here, there is no
+	 * info reserver block or we found a valid info reserve block
+	 * but failed to initialize the pfn superblock.
+	 * Don't create a raw pmem disk for the second case.
+	 */
 	return pmem_attach_disk(dev, ndns);
 }
 
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
