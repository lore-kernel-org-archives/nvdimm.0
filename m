Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DBCC21D49181
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:05:39 -0700 (PDT)
Subject: [PATCH] nfit, libnvdimm, region: export 'position' in mapping info
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 04 Aug 2017 18:01:28 -0700
Message-ID: <150189488800.17374.1861176412812578031.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

It is useful to be able to know the position of a DIMM in an
interleave-set. Consider the case where the order of the DIMMs changes
causing a namespace to be invalidated because the interleave-set cookie no
longer matches. If the before and after state of each DIMM position is
known this state debugged by the system owner.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/acpi/nfit/core.c     |   24 ++++++++++++++++++++++++
 drivers/nvdimm/nd.h          |    1 +
 drivers/nvdimm/region_devs.c |    6 ++++--
 include/linux/libnvdimm.h    |    1 +
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 19182d091587..be231a549eb0 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1835,6 +1835,30 @@ static int acpi_nfit_init_interleave_set(struct acpi_nfit_desc *acpi_desc,
 			cmp_map_compat, NULL);
 	nd_set->altcookie = nd_fletcher64(info, sizeof_nfit_set_info(nr), 0);
 
+	/* record the result of the sort for the mapping position */
+	for (i = 0; i < nr; i++) {
+		struct nfit_set_info_map2 *map2 = &info2->mapping[i];
+		int j;
+
+		for (j = 0; j < nr; j++) {
+			struct nd_mapping_desc *mapping = &ndr_desc->mapping[j];
+			struct nvdimm *nvdimm = mapping->nvdimm;
+			struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+
+			if (map2->serial_number
+				== nfit_mem->dcr->serial_number &&
+			    map2->vendor_id
+				== nfit_mem->dcr->vendor_id &&
+			    map2->manufacturing_date
+				== nfit_mem->dcr->manufacturing_date &&
+			    map2->manufacturing_location
+				== nfit_mem->dcr->manufacturing_location) {
+				mapping->position = i;
+				break;
+			}
+		}
+	}
+
 	ndr_desc->nd_set = nd_set;
 	devm_kfree(dev, info);
 	devm_kfree(dev, info2);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e9fa9e84b364..a08fc2e24fb3 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -134,6 +134,7 @@ struct nd_mapping {
 	struct nvdimm *nvdimm;
 	u64 start;
 	u64 size;
+	int position;
 	struct list_head labels;
 	struct mutex lock;
 	/*
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 5954cfbea3fc..829d760f651c 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -723,8 +723,9 @@ static ssize_t mappingN(struct device *dev, char *buf, int n)
 	nd_mapping = &nd_region->mapping[n];
 	nvdimm = nd_mapping->nvdimm;
 
-	return sprintf(buf, "%s,%llu,%llu\n", dev_name(&nvdimm->dev),
-			nd_mapping->start, nd_mapping->size);
+	return sprintf(buf, "%s,%llu,%llu,%d\n", dev_name(&nvdimm->dev),
+			nd_mapping->start, nd_mapping->size,
+			nd_mapping->position);
 }
 
 #define REGION_MAPPING(idx) \
@@ -965,6 +966,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
 		nd_region->mapping[i].nvdimm = nvdimm;
 		nd_region->mapping[i].start = mapping->start;
 		nd_region->mapping[i].size = mapping->size;
+		nd_region->mapping[i].position = mapping->position;
 		INIT_LIST_HEAD(&nd_region->mapping[i].labels);
 		mutex_init(&nd_region->mapping[i].lock);
 
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index f3d3e6af8838..9b8d81a7b80e 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -87,6 +87,7 @@ struct nd_mapping_desc {
 	struct nvdimm *nvdimm;
 	u64 start;
 	u64 size;
+	int position;
 };
 
 struct nd_region_desc {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
