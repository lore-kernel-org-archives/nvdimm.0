Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 43E611A1E48
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:54:07 -0700 (PDT)
Subject: [PATCH 06/13] libnvdimm: cycle flush hints per-cpu
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:53:04 -0700
Message-ID: <146507358471.8347.2701817405271061869.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

When the NFIT provides multiple flush hint addresses per-dimm it is
expressing that the platform is capable of processing multiple flush
requests in parallel.  There is some fixed cost per flush request, let
the cost be shared in parallel on multiple cpus.

Since there may not be enough flush hint addresses for each cpu to have
one keep a per-cpu index of the last used hint, and assume that access
pattern randomness will keep the flush-hint usage somewhat staggered.

Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/dimm_devs.c   |    2 ++
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region_devs.c |    8 ++++++--
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index e58e8ba155aa..c7061932ad40 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -35,10 +35,12 @@ struct nvdimm_drvdata *nvdimm_alloc_drvdata(struct device *dev)
 
 int nvdimm_populate_flush_hints(struct device *dev)
 {
+	struct nvdimm *nvdimm = to_nvdimm(dev);
 	struct nvdimm_drvdata *ndd = dev_get_drvdata(dev);
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
 	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
 
+	ndd->flush_mask = (1 << ilog2(nvdimm->flush_hints)) - 1;
 	if (nd_desc->populate_flush_hints)
 		return nd_desc->populate_flush_hints(dev, ndd->flush_wpq);
 	return 0;
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 4bba7c50961d..3ce169d49e64 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -47,6 +47,7 @@ struct nvdimm_drvdata {
 	int ns_current, ns_next;
 	struct resource dpa;
 	struct kref kref;
+	unsigned int flush_mask;
 	void __iomem *flush_wpq[0];
 };
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 5b6f85d00bb5..76ff68d432fb 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -22,6 +22,7 @@
 #include "nd.h"
 
 static DEFINE_IDA(region_ida);
+static DEFINE_PER_CPU(int, flush_idx);
 
 static void nd_region_release(struct device *dev)
 {
@@ -814,6 +815,7 @@ void nvdimm_flush(struct nd_region *nd_region)
 	 */
 	wmb();
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		int idx;
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd_unlocked(nd_mapping);
 
@@ -822,8 +824,10 @@ void nvdimm_flush(struct nd_region *nd_region)
 		 * arrange for all associated regions to be disabled
 		 * before the dimm is disabled.
 		 */
-		if (ndd->flush_wpq[0])
-			writeq(1, ndd->flush_wpq[0]);
+		if (ndd->flush_wpq[0]) {
+			idx = this_cpu_inc_return(flush_idx) & ndd->flush_mask;
+			writeq(1, ndd->flush_wpq[idx]);
+		}
 	}
 	wmb();
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
