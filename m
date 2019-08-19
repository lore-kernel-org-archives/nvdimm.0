Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E13D720216B81
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 06:36:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7JDXa2t003912
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 09:35:07 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2ufuyw27tb-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 09:35:06 -0400
Received: from localhost
 by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Mon, 19 Aug 2019 14:35:06 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v6 2/7] libnvdimm/pmem: Advance namespace seed for specific
 probe errors
Date: Mon, 19 Aug 2019 19:04:46 +0530
In-Reply-To: <20190819133451.19737-1-aneesh.kumar@linux.ibm.com>
References: <20190819133451.19737-1-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <20190819133451.19737-3-aneesh.kumar@linux.ibm.com>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

In order to support marking namespaces with unsupported feature/versions
disabled, nvdimm core should advance the namespace seed on these
probe failures. Otherwise, these failed namespaces will be considered a
seed namespace and will be wrongly used while creating new namespaces.

Add -EOPNOTSUPP as return from pmem probe callback to indicate a namespace
initialization failures due to pfn superblock feature/version mismatch.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
---
 drivers/nvdimm/bus.c  |  3 ++-
 drivers/nvdimm/pmem.c | 29 +++++++++++++++++++++++++----
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index 9b64e68a20b8..69f784bf9744 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -95,7 +95,8 @@ static int nvdimm_bus_probe(struct device *dev)
 	rc = nd_drv->probe(dev);
 	debug_nvdimm_unlock(dev);
 
-	if (rc == 0 && dev->parent && is_nd_region(dev->parent))
+	if ((rc == 0 || rc == -EOPNOTSUPP) &&
+	    dev->parent && is_nd_region(dev->parent))
 		nd_region_advance_seeds(to_nd_region(dev->parent), dev);
 	nvdimm_bus_probe_end(nvdimm_bus);
 
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4c121dd03dd9..f9f76f6ba07b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -490,6 +490,7 @@ static int pmem_attach_disk(struct device *dev,
 
 static int nd_pmem_probe(struct device *dev)
 {
+	int ret;
 	struct nd_namespace_common *ndns;
 
 	ndns = nvdimm_namespace_common_probe(dev);
@@ -505,12 +506,32 @@ static int nd_pmem_probe(struct device *dev)
 	if (is_nd_pfn(dev))
 		return pmem_attach_disk(dev, ndns);
 
-	/* if we find a valid info-block we'll come back as that personality */
-	if (nd_btt_probe(dev, ndns) == 0 || nd_pfn_probe(dev, ndns) == 0
-			|| nd_dax_probe(dev, ndns) == 0)
+	ret = nd_btt_probe(dev, ndns);
+	if (ret == 0)
 		return -ENXIO;
 
-	/* ...otherwise we're just a raw pmem device */
+	/*
+	 * We have two failure conditions here, there is no
+	 * info reserver block or we found a valid info reserve block
+	 * but failed to initialize the pfn superblock.
+	 *
+	 * For the first case consider namespace as a raw pmem namespace
+	 * and attach a disk.
+	 *
+	 * For the latter, consider this a success and advance the namespace
+	 * seed.
+	 */
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
 	return pmem_attach_disk(dev, ndns);
 }
 
-- 
2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
