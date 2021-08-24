Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFFC3FC0
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:06:36 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="214220820"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="214220820"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:08 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="526678411"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:07 -0700
Subject: [PATCH v3 08/28] libnvdimm/labels: Add claim class helpers
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:07 -0700
Message-ID: <162982116719.1124374.9917866609080940364.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In preparation for LIBNVDIMM to manage labels on CXL devices deploy
helpers that abstract the label type from the implementation. The CXL
label format is mostly similar to the EFI label format with concepts /
fields added, like dynamic region creation and label type guids, and
other concepts removed like BLK-mode and interleave-set-cookie ids.

CXL labels do have the concept of a claim class represented by an
"abstraction" identifier. It turns out both label implementations use
the same ids, but EFI encodes them as GUIDs and CXL labels encode them
as UUIDs. For now abstract out the claim class such that the UUID vs
GUID distinction can later be hidden in the helper.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c          |   31 ++++++++++++++++++++++---------
 drivers/nvdimm/label.h          |    1 -
 drivers/nvdimm/namespace_devs.c |   13 ++++---------
 drivers/nvdimm/nd.h             |    2 ++
 4 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 294ffc3cb582..7f473f9db300 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -724,7 +724,7 @@ static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
 		- (unsigned long) to_namespace_index(ndd, 0);
 }
 
-enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
+static enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
 {
 	if (guid_equal(guid, &nvdimm_btt_guid))
 		return NVDIMM_CCLASS_BTT;
@@ -792,6 +792,25 @@ bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 	return true;
 }
 
+static void nsl_set_claim_class(struct nvdimm_drvdata *ndd,
+				struct nd_namespace_label *nd_label,
+				enum nvdimm_claim_class claim_class)
+{
+	if (!namespace_label_has(ndd, abstraction_guid))
+		return;
+	guid_copy(&nd_label->abstraction_guid,
+		  to_abstraction_guid(claim_class,
+				      &nd_label->abstraction_guid));
+}
+
+enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
+					    struct nd_namespace_label *nd_label)
+{
+	if (!namespace_label_has(ndd, abstraction_guid))
+		return NVDIMM_CCLASS_NONE;
+	return to_nvdimm_cclass(&nd_label->abstraction_guid);
+}
+
 static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos, unsigned long flags)
@@ -843,10 +862,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_dpa(ndd, nd_label, res->start);
 	nsl_set_slot(ndd, nd_label, slot);
 	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
-	if (namespace_label_has(ndd, abstraction_guid))
-		guid_copy(&nd_label->abstraction_guid,
-				to_abstraction_guid(ndns->claim_class,
-					&nd_label->abstraction_guid));
+	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
 	nsl_calculate_checksum(ndd, nd_label);
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
 
@@ -1111,10 +1127,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nsl_set_lbasize(ndd, nd_label, nsblk->lbasize);
 		nsl_set_slot(ndd, nd_label, slot);
 		nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
-		if (namespace_label_has(ndd, abstraction_guid))
-			guid_copy(&nd_label->abstraction_guid,
-					to_abstraction_guid(ndns->claim_class,
-						&nd_label->abstraction_guid));
+		nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
 		nsl_calculate_checksum(ndd, nd_label);
 
 		/* update label */
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 956b6d1bd8cc..31f94fad7b92 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -135,7 +135,6 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
 u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
 bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
 u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
-enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid);
 struct nd_region;
 struct nd_namespace_pmem;
 struct nd_namespace_blk;
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index af5a31dd3147..58c76d74127a 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -2042,10 +2042,8 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 		nspm->uuid = kmemdup((void __force *) label0->uuid,
 				NSLABEL_UUID_LEN, GFP_KERNEL);
 		nspm->lbasize = nsl_get_lbasize(ndd, label0);
-		if (namespace_label_has(ndd, abstraction_guid))
-			nspm->nsio.common.claim_class
-				= to_nvdimm_cclass(&label0->abstraction_guid);
-
+		nspm->nsio.common.claim_class =
+			nsl_get_claim_class(ndd, label0);
 	}
 
 	if (!nspm->alt_name || !nspm->uuid) {
@@ -2273,11 +2271,8 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	dev->parent = &nd_region->dev;
 	nsblk->id = -1;
 	nsblk->lbasize = nsl_get_lbasize(ndd, nd_label);
-	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
-			GFP_KERNEL);
-	if (namespace_label_has(ndd, abstraction_guid))
-		nsblk->common.claim_class
-			= to_nvdimm_cclass(&nd_label->abstraction_guid);
+	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN, GFP_KERNEL);
+	nsblk->common.claim_class = nsl_get_claim_class(ndd, nd_label);
 	if (!nsblk->uuid)
 		goto blk_err;
 	nsl_get_name(ndd, nd_label, name);
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index a3e215f2d837..5467ebbb4a6b 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -182,6 +182,8 @@ bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				 u64 isetcookie);
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
+enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
+					    struct nd_namespace_label *nd_label);
 
 struct nd_region_data {
 	int ns_count;

