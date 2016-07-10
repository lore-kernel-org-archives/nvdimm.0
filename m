Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 6881E1A1E36
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 20:28:11 -0700 (PDT)
Subject: [PATCH v2 09/17] libnvdimm: cycle flush hints
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Jul 2016 20:25:17 -0700
Message-ID: <146812111719.32932.8437995190573895578.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146812106839.32932.2870621200867047059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, hch@lst.de, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When the NFIT provides multiple flush hint addresses per-dimm it is
expressing that the platform is capable of processing multiple flush
requests in parallel.  There is some fixed cost per flush request, let
the cost be shared in parallel on multiple cpus.

Since there may not be enough flush hint addresses for each cpu to have
one, keep a per-cpu index of the last used hint, hash it with current
pid, and assume that access pattern and scheduler randomness will keep
the flush-hint usage somewhat staggered across cpus.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region_devs.c |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 5912bd6b4234..40476399d227 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -52,6 +52,7 @@ struct nvdimm_drvdata {
 struct nd_region_data {
 	int ns_count;
 	int ns_active;
+	unsigned int flush_mask;
 	void __iomem *flush_wpq[0][0];
 };
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 46b6e2f7d5f0..4bcb3b6744aa 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -14,6 +14,7 @@
 #include <linux/highmem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/hash.h>
 #include <linux/pmem.h>
 #include <linux/sort.h>
 #include <linux/io.h>
@@ -22,6 +23,7 @@
 #include "nd.h"
 
 static DEFINE_IDA(region_ida);
+static DEFINE_PER_CPU(int, flush_idx);
 
 static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 		struct nd_region_data *ndrd)
@@ -61,7 +63,7 @@ static int nvdimm_map_flush(struct device *dev, struct nvdimm *nvdimm, int dimm,
 
 int nd_region_activate(struct nd_region *nd_region)
 {
-	int i;
+	int i, num_flush = 0;
 	struct nd_region_data *ndrd;
 	struct device *dev = &nd_region->dev;
 	size_t flush_data_size = sizeof(void *);
@@ -73,6 +75,7 @@ int nd_region_activate(struct nd_region *nd_region)
 
 		/* at least one null hint slot per-dimm for the "no-hint" case */
 		flush_data_size += sizeof(void *);
+		num_flush = min_not_zero(num_flush, nvdimm->num_flush);
 		if (!nvdimm->num_flush)
 			continue;
 		flush_data_size += nvdimm->num_flush * sizeof(void *);
@@ -84,6 +87,7 @@ int nd_region_activate(struct nd_region *nd_region)
 		return -ENOMEM;
 	dev_set_drvdata(dev, ndrd);
 
+	ndrd->flush_mask = (1 << ilog2(num_flush)) - 1;
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -872,7 +876,14 @@ EXPORT_SYMBOL_GPL(nvdimm_volatile_region_create);
 void nvdimm_flush(struct nd_region *nd_region)
 {
 	struct nd_region_data *ndrd = dev_get_drvdata(&nd_region->dev);
-	int i;
+	int i, idx;
+
+	/*
+	 * Try to encourage some diversity in flush hint addresses
+	 * across cpus assuming a limited number of flush hints.
+	 */
+	idx = this_cpu_read(flush_idx);
+	idx = this_cpu_add_return(flush_idx, hash_32(current->pid + idx, 8));
 
 	/*
 	 * The first wmb() is needed to 'sfence' all previous writes
@@ -884,7 +895,7 @@ void nvdimm_flush(struct nd_region *nd_region)
 	wmb();
 	for (i = 0; i < nd_region->ndr_mappings; i++)
 		if (ndrd->flush_wpq[i][0])
-			writeq(1, ndrd->flush_wpq[i][0]);
+			writeq(1, ndrd->flush_wpq[i][idx & ndrd->flush_mask]);
 	wmb();
 }
 EXPORT_SYMBOL_GPL(nvdimm_flush);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
