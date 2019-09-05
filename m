From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH v9 6/7] libnvdimm: Use PAGE_SIZE instead of SZ_4K for align
 check
Date: Thu,  5 Sep 2019 21:16:02 +0530
Message-ID: <20190905154603.10349-7-aneesh.kumar@linux.ibm.com>
References: <20190905154603.10349-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190905154603.10349-1-aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

Architectures have different page size than 4K. Use the PAGE_SIZE
to make sure ranges are correctly aligned.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 drivers/nvdimm/namespace_devs.c | 6 +++---
 drivers/nvdimm/region_devs.c    | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3be81f7b9ed3..43401325c874 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1006,10 +1006,10 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 		return -ENXIO;
 	}
 
-	div_u64_rem(val, SZ_4K * nd_region->ndr_mappings, &remainder);
+	div_u64_rem(val, PAGE_SIZE * nd_region->ndr_mappings, &remainder);
 	if (remainder) {
-		dev_dbg(dev, "%llu is not %dK aligned\n", val,
-				(SZ_4K * nd_region->ndr_mappings) / SZ_1K);
+		dev_dbg(dev, "%llu is not %ldK aligned\n", val,
+				(PAGE_SIZE * nd_region->ndr_mappings) / SZ_1K);
 		return -EINVAL;
 	}
 
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 57de49b79d7d..9550202aa7be 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -944,10 +944,10 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
 		struct nvdimm *nvdimm = mapping->nvdimm;
 
-		if ((mapping->start | mapping->size) % SZ_4K) {
-			dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
-					caller, dev_name(&nvdimm->dev), i);
-
+		if ((mapping->start | mapping->size) % PAGE_SIZE) {
+			dev_err(&nvdimm_bus->dev,
+				"%s: %s mapping%d is not %ld aligned\n",
+				caller, dev_name(&nvdimm->dev), i, PAGE_SIZE);
 			return NULL;
 		}
 
-- 
2.21.0
