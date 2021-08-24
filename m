Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5854C3FCC
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:07:26 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="196918160"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="196918160"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:02 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="575064061"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:02 -0700
Subject: [PATCH v3 07/28] libnvdimm/labels: Add type-guid helpers
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:02 -0700
Message-ID: <162982116208.1124374.13938280892226800953.stgit@dwillia2-desk3.amr.corp.intel.com>
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

In preparation for CXL label support, which does not have the type-guid
concept, wrap the existing users with nsl_set_type_guid, and
nsl_validate_type_guid. Recall that the type-guid is a value in the ACPI
NFIT table to indicate how the memory range is used / should be
presented to upper layers.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c          |   26 ++++++++++++++++++++++----
 drivers/nvdimm/namespace_devs.c |   19 ++++---------------
 drivers/nvdimm/nd.h             |    2 ++
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7188675c0955..294ffc3cb582 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -772,6 +772,26 @@ static void reap_victim(struct nd_mapping *nd_mapping,
 	victim->label = NULL;
 }
 
+static void nsl_set_type_guid(struct nvdimm_drvdata *ndd,
+			      struct nd_namespace_label *nd_label, guid_t *guid)
+{
+	if (namespace_label_has(ndd, type_guid))
+		guid_copy(&nd_label->type_guid, guid);
+}
+
+bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
+			    struct nd_namespace_label *nd_label, guid_t *guid)
+{
+	if (!namespace_label_has(ndd, type_guid))
+		return true;
+	if (!guid_equal(&nd_label->type_guid, guid)) {
+		dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n", guid,
+			&nd_label->type_guid);
+		return false;
+	}
+	return true;
+}
+
 static int __pmem_label_update(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
 		int pos, unsigned long flags)
@@ -822,8 +842,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
 	nsl_set_dpa(ndd, nd_label, res->start);
 	nsl_set_slot(ndd, nd_label, slot);
-	if (namespace_label_has(ndd, type_guid))
-		guid_copy(&nd_label->type_guid, &nd_set->type_guid);
+	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
 	if (namespace_label_has(ndd, abstraction_guid))
 		guid_copy(&nd_label->abstraction_guid,
 				to_abstraction_guid(ndns->claim_class,
@@ -1091,8 +1110,7 @@ static int __blk_label_update(struct nd_region *nd_region,
 		nsl_set_rawsize(ndd, nd_label, resource_size(res));
 		nsl_set_lbasize(ndd, nd_label, nsblk->lbasize);
 		nsl_set_slot(ndd, nd_label, slot);
-		if (namespace_label_has(ndd, type_guid))
-			guid_copy(&nd_label->type_guid, &nd_set->type_guid);
+		nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
 		if (namespace_label_has(ndd, abstraction_guid))
 			guid_copy(&nd_label->abstraction_guid,
 					to_abstraction_guid(ndns->claim_class,
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index fbd0c2fcea4a..af5a31dd3147 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1859,14 +1859,9 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
 			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
 				continue;
 
-			if (namespace_label_has(ndd, type_guid)
-					&& !guid_equal(&nd_set->type_guid,
-						&nd_label->type_guid)) {
-				dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
-						&nd_set->type_guid,
-						&nd_label->type_guid);
+			if (!nsl_validate_type_guid(ndd, nd_label,
+						    &nd_set->type_guid))
 				continue;
-			}
 
 			if (found_uuid) {
 				dev_dbg(ndd->dev, "duplicate entry for uuid\n");
@@ -2265,14 +2260,8 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
 	struct device *dev = NULL;
 	struct resource *res;
 
-	if (namespace_label_has(ndd, type_guid)) {
-		if (!guid_equal(&nd_set->type_guid, &nd_label->type_guid)) {
-			dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
-					&nd_set->type_guid,
-					&nd_label->type_guid);
-			return ERR_PTR(-EAGAIN);
-		}
-	}
+	if (!nsl_validate_type_guid(ndd, nd_label, &nd_set->type_guid))
+		return ERR_PTR(-EAGAIN);
 	if (!nsl_validate_blk_isetcookie(ndd, nd_label, nd_set->cookie2))
 		return ERR_PTR(-EAGAIN);
 
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 955c4395a8e3..a3e215f2d837 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -180,6 +180,8 @@ static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
 bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 u64 isetcookie);
+bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
+			    struct nd_namespace_label *nd_label, guid_t *guid);
 
 struct nd_region_data {
 	int ns_count;

