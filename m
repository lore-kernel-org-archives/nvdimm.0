Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E22B6D00
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 22:28:36 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="278543815"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="278543815"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="444726830"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:35 -0700
Subject: [PATCH 09/23] libnvdimm/labels: Add address-abstraction uuid
 definitions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, ira.weiny@intel.com
Date: Mon, 09 Aug 2021 15:28:35 -0700
Message-ID: <162854811511.1980150.3921515741758120378.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The EFI definition of the labels represents the Linux "claim class" with
a GUID. The CXL definition of the labels stores the same identifier in
UUID byte order. In preparation for adding CXL label support, enable the
claim class to optionally handle uuids.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7f473f9db300..2ba31b883b28 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -17,6 +17,11 @@ static guid_t nvdimm_btt2_guid;
 static guid_t nvdimm_pfn_guid;
 static guid_t nvdimm_dax_guid;
 
+static uuid_t nvdimm_btt_uuid;
+static uuid_t nvdimm_btt2_uuid;
+static uuid_t nvdimm_pfn_uuid;
+static uuid_t nvdimm_dax_uuid;
+
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 
 static u32 best_seq(u32 a, u32 b)
@@ -724,7 +729,7 @@ static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
 		- (unsigned long) to_namespace_index(ndd, 0);
 }
 
-static enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
+static enum nvdimm_claim_class guid_to_nvdimm_cclass(guid_t *guid)
 {
 	if (guid_equal(guid, &nvdimm_btt_guid))
 		return NVDIMM_CCLASS_BTT;
@@ -740,6 +745,23 @@ static enum nvdimm_claim_class to_nvdimm_cclass(guid_t *guid)
 	return NVDIMM_CCLASS_UNKNOWN;
 }
 
+/* CXL labels store UUIDs instead of GUIDs for the same data */
+enum nvdimm_claim_class uuid_to_nvdimm_cclass(uuid_t *uuid)
+{
+	if (uuid_equal(uuid, &nvdimm_btt_uuid))
+		return NVDIMM_CCLASS_BTT;
+	else if (uuid_equal(uuid, &nvdimm_btt2_uuid))
+		return NVDIMM_CCLASS_BTT2;
+	else if (uuid_equal(uuid, &nvdimm_pfn_uuid))
+		return NVDIMM_CCLASS_PFN;
+	else if (uuid_equal(uuid, &nvdimm_dax_uuid))
+		return NVDIMM_CCLASS_DAX;
+	else if (uuid_equal(uuid, &uuid_null))
+		return NVDIMM_CCLASS_NONE;
+
+	return NVDIMM_CCLASS_UNKNOWN;
+}
+
 static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 	guid_t *target)
 {
@@ -761,6 +783,29 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 		return &guid_null;
 }
 
+/* CXL labels store UUIDs instead of GUIDs for the same data */
+__maybe_unused
+static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
+					 uuid_t *target)
+{
+	if (claim_class == NVDIMM_CCLASS_BTT)
+		return &nvdimm_btt_uuid;
+	else if (claim_class == NVDIMM_CCLASS_BTT2)
+		return &nvdimm_btt2_uuid;
+	else if (claim_class == NVDIMM_CCLASS_PFN)
+		return &nvdimm_pfn_uuid;
+	else if (claim_class == NVDIMM_CCLASS_DAX)
+		return &nvdimm_dax_uuid;
+	else if (claim_class == NVDIMM_CCLASS_UNKNOWN) {
+		/*
+		 * If we're modifying a namespace for which we don't
+		 * know the claim_class, don't touch the existing uuid.
+		 */
+		return target;
+	} else
+		return &uuid_null;
+}
+
 static void reap_victim(struct nd_mapping *nd_mapping,
 		struct nd_label_ent *victim)
 {
@@ -808,7 +853,7 @@ enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
 {
 	if (!namespace_label_has(ndd, abstraction_guid))
 		return NVDIMM_CCLASS_NONE;
-	return to_nvdimm_cclass(&nd_label->abstraction_guid);
+	return guid_to_nvdimm_cclass(&nd_label->abstraction_guid);
 }
 
 static int __pmem_label_update(struct nd_region *nd_region,
@@ -1395,5 +1440,10 @@ int __init nd_label_init(void)
 	WARN_ON(guid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_guid));
 	WARN_ON(guid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_guid));
 
+	WARN_ON(uuid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_uuid));
+	WARN_ON(uuid_parse(NVDIMM_BTT2_GUID, &nvdimm_btt2_uuid));
+	WARN_ON(uuid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_uuid));
+	WARN_ON(uuid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_uuid));
+
 	return 0;
 }

