Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6E6D0F
	for <nvdimm@lists.linux.dev>; Mon,  9 Aug 2021 22:28:47 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300382493"
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="300382493"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:46 -0700
X-IronPort-AV: E=Sophos;i="5.84,308,1620716400"; 
   d="scan'208";a="638609705"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 15:28:46 -0700
Subject: [PATCH 11/23] libnvdimm/labels: Introduce CXL labels
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, ira.weiny@intel.com
Date: Mon, 09 Aug 2021 15:28:46 -0700
Message-ID: <162854812641.1980150.4928659819619856243.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that all of use sites of label data have been converted to nsl_*
helpers, introduce the CXL label format. The ->cxl flag in
nvdimm_drvdata indicates the label format the device expects. A
follow-on patch allows a bus provider to select the label style.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   48 +++++++++++-------
 drivers/nvdimm/label.h |   92 ++++++++++++++++++++++++----------
 drivers/nvdimm/nd.h    |  131 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 199 insertions(+), 72 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 99608e6aeaae..d51899a32dd7 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -22,6 +22,9 @@ static uuid_t nvdimm_btt2_uuid;
 static uuid_t nvdimm_pfn_uuid;
 static uuid_t nvdimm_dax_uuid;
 
+static uuid_t cxl_region_uuid;
+static uuid_t cxl_namespace_uuid;
+
 static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 
 static u32 best_seq(u32 a, u32 b)
@@ -357,7 +360,7 @@ static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
 {
 	u64 sum, sum_save;
 
-	if (!namespace_label_has(ndd, checksum))
+	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
 		return true;
 
 	sum_save = nsl_get_checksum(ndd, nd_label);
@@ -372,7 +375,7 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 {
 	u64 sum;
 
-	if (!namespace_label_has(ndd, checksum))
+	if (!ndd->cxl && !efi_namespace_label_has(ndd, checksum))
 		return;
 	nsl_set_checksum(ndd, nd_label, 0);
 	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
@@ -785,7 +788,6 @@ static const guid_t *to_abstraction_guid(enum nvdimm_claim_class claim_class,
 }
 
 /* CXL labels store UUIDs instead of GUIDs for the same data */
-__maybe_unused
 static const uuid_t *to_abstraction_uuid(enum nvdimm_claim_class claim_class,
 					 uuid_t *target)
 {
@@ -821,18 +823,18 @@ static void reap_victim(struct nd_mapping *nd_mapping,
 static void nsl_set_type_guid(struct nvdimm_drvdata *ndd,
 			      struct nd_namespace_label *nd_label, guid_t *guid)
 {
-	if (namespace_label_has(ndd, type_guid))
-		guid_copy(&nd_label->type_guid, guid);
+	if (efi_namespace_label_has(ndd, type_guid))
+		guid_copy(&nd_label->efi.type_guid, guid);
 }
 
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid)
 {
-	if (!namespace_label_has(ndd, type_guid))
+	if (ndd->cxl || !efi_namespace_label_has(ndd, type_guid))
 		return true;
-	if (!guid_equal(&nd_label->type_guid, guid)) {
+	if (!guid_equal(&nd_label->efi.type_guid, guid)) {
 		dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n", guid,
-			&nd_label->type_guid);
+			&nd_label->efi.type_guid);
 		return false;
 	}
 	return true;
@@ -842,19 +844,28 @@ static void nsl_set_claim_class(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label,
 				enum nvdimm_claim_class claim_class)
 {
-	if (!namespace_label_has(ndd, abstraction_guid))
+	if (ndd->cxl) {
+		uuid_copy(&nd_label->cxl.abstraction_uuid,
+			  to_abstraction_uuid(claim_class,
+					      &nd_label->cxl.abstraction_uuid));
 		return;
-	guid_copy(&nd_label->abstraction_guid,
+	}
+
+	if (!efi_namespace_label_has(ndd, abstraction_guid))
+		return;
+	guid_copy(&nd_label->efi.abstraction_guid,
 		  to_abstraction_guid(claim_class,
-				      &nd_label->abstraction_guid));
+				      &nd_label->efi.abstraction_guid));
 }
 
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
 					    struct nd_namespace_label *nd_label)
 {
-	if (!namespace_label_has(ndd, abstraction_guid))
+	if (ndd->cxl)
+		return uuid_to_nvdimm_cclass(&nd_label->cxl.abstraction_uuid);
+	if (!efi_namespace_label_has(ndd, abstraction_guid))
 		return NVDIMM_CCLASS_NONE;
-	return guid_to_nvdimm_cclass(&nd_label->abstraction_guid);
+	return guid_to_nvdimm_cclass(&nd_label->efi.abstraction_guid);
 }
 
 static int __pmem_label_update(struct nd_region *nd_region,
@@ -986,7 +997,7 @@ static void nsl_set_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label,
 				   u64 isetcookie)
 {
-	if (namespace_label_has(ndd, type_guid)) {
+	if (efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_isetcookie(ndd, nd_label, isetcookie);
 		return;
 	}
@@ -997,7 +1008,7 @@ bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 u64 isetcookie)
 {
-	if (!namespace_label_has(ndd, type_guid))
+	if (!efi_namespace_label_has(ndd, type_guid))
 		return true;
 
 	if (nsl_get_isetcookie(ndd, nd_label) != isetcookie) {
@@ -1013,7 +1024,7 @@ static void nsl_set_blk_nlabel(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label, int nlabel,
 			       bool first)
 {
-	if (!namespace_label_has(ndd, type_guid)) {
+	if (!efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_nlabel(ndd, nd_label, 0); /* N/A */
 		return;
 	}
@@ -1024,7 +1035,7 @@ static void nsl_set_blk_position(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 bool first)
 {
-	if (!namespace_label_has(ndd, type_guid)) {
+	if (!efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_position(ndd, nd_label, 0);
 		return;
 	}
@@ -1439,5 +1450,8 @@ int __init nd_label_init(void)
 	WARN_ON(uuid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_uuid));
 	WARN_ON(uuid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_uuid));
 
+	WARN_ON(uuid_parse(CXL_REGION_UUID, &cxl_region_uuid));
+	WARN_ON(uuid_parse(CXL_NAMESPACE_UUID, &cxl_namespace_uuid));
+
 	return 0;
 }
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index e6e77691dbec..71ffde56fac0 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -64,40 +64,77 @@ struct nd_namespace_index {
 	u8 free[];
 };
 
-/**
- * struct nd_namespace_label - namespace superblock
- * @uuid: UUID per RFC 4122
- * @name: optional name (NULL-terminated)
- * @flags: see NSLABEL_FLAG_*
- * @nlabel: num labels to describe this ns
- * @position: labels position in set
- * @isetcookie: interleave set cookie
- * @lbasize: LBA size in bytes or 0 for pmem
- * @dpa: DPA of NVM range on this DIMM
- * @rawsize: size of namespace
- * @slot: slot of this label in label area
- * @unused: must be zero
- */
 struct nd_namespace_label {
+	union {
+		struct nvdimm_cxl_label {
+			uuid_t type;
+			uuid_t uuid;
+			u8 name[NSLABEL_NAME_LEN];
+			__le32 flags;
+			__le16 nlabel;
+			__le16 position;
+			__le64 dpa;
+			__le64 rawsize;
+			__le32 slot;
+			__le32 align;
+			uuid_t region_uuid;
+			uuid_t abstraction_uuid;
+			__le16 lbasize;
+			u8 reserved[0x56];
+			__le64 checksum;
+		} cxl;
+		/**
+		 * struct nvdimm_efi_label - namespace superblock
+		 * @uuid: UUID per RFC 4122
+		 * @name: optional name (NULL-terminated)
+		 * @flags: see NSLABEL_FLAG_*
+		 * @nlabel: num labels to describe this ns
+		 * @position: labels position in set
+		 * @isetcookie: interleave set cookie
+		 * @lbasize: LBA size in bytes or 0 for pmem
+		 * @dpa: DPA of NVM range on this DIMM
+		 * @rawsize: size of namespace
+		 * @slot: slot of this label in label area
+		 * @unused: must be zero
+		 */
+		struct nvdimm_efi_label {
+			uuid_t uuid;
+			u8 name[NSLABEL_NAME_LEN];
+			__le32 flags;
+			__le16 nlabel;
+			__le16 position;
+			__le64 isetcookie;
+			__le64 lbasize;
+			__le64 dpa;
+			__le64 rawsize;
+			__le32 slot;
+			/*
+			 * Accessing fields past this point should be
+			 * gated by a efi_namespace_label_has() check.
+			 */
+			u8 align;
+			u8 reserved[3];
+			guid_t type_guid;
+			guid_t abstraction_guid;
+			u8 reserved2[88];
+			__le64 checksum;
+		} efi;
+	};
+};
+
+struct cxl_region_label {
+	uuid_t type;
 	uuid_t uuid;
-	u8 name[NSLABEL_NAME_LEN];
 	__le32 flags;
 	__le16 nlabel;
 	__le16 position;
-	__le64 isetcookie;
-	__le64 lbasize;
 	__le64 dpa;
 	__le64 rawsize;
+	__le64 hpa;
 	__le32 slot;
-	/*
-	 * Accessing fields past this point should be gated by a
-	 * namespace_label_has() check.
-	 */
-	u8 align;
-	u8 reserved[3];
-	guid_t type_guid;
-	guid_t abstraction_guid;
-	u8 reserved2[88];
+	__le32 ig;
+	__le32 align;
+	u8 reserved[0xac];
 	__le64 checksum;
 };
 
@@ -106,6 +143,9 @@ struct nd_namespace_label {
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
 #define NVDIMM_DAX_GUID "97a86d9c-3cdd-4eda-986f-5068b4f80088"
 
+#define CXL_REGION_UUID "529d7c61-da07-47c4-a93f-ecdf2c06f444"
+#define CXL_NAMESPACE_UUID "68bb2c0a-5a77-4937-9f85-3caf41a0f93c"
+
 /**
  * struct nd_label_id - identifier string for dpa allocation
  * @id: "{blk|pmem}-<namespace uuid>"
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 132a8021e3ad..817790c53f98 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -30,6 +30,7 @@ struct nvdimm_drvdata {
 	int nslabel_size;
 	struct nd_cmd_get_config_size nsarea;
 	void *data;
+	bool cxl;
 	int ns_current, ns_next;
 	struct resource dpa;
 	struct kref kref;
@@ -38,13 +39,17 @@ struct nvdimm_drvdata {
 static inline const u8 *nsl_ref_name(struct nvdimm_drvdata *ndd,
 				     struct nd_namespace_label *nd_label)
 {
-	return nd_label->name;
+	if (ndd->cxl)
+		return nd_label->cxl.name;
+	return nd_label->efi.name;
 }
 
 static inline u8 *nsl_get_name(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label, u8 *name)
 {
-	return memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
+	if (ndd->cxl)
+		return memcpy(name, nd_label->cxl.name, NSLABEL_NAME_LEN);
+	return memcpy(name, nd_label->efi.name, NSLABEL_NAME_LEN);
 }
 
 static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
@@ -52,135 +57,195 @@ static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
 {
 	if (!name)
 		return name;
-	return memcpy(nd_label->name, name, NSLABEL_NAME_LEN);
+	if (ndd->cxl)
+		return memcpy(nd_label->cxl.name, name, NSLABEL_NAME_LEN);
+	return memcpy(nd_label->efi.name, name, NSLABEL_NAME_LEN);
 }
 
 static inline u32 nsl_get_slot(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label)
 {
-	return __le32_to_cpu(nd_label->slot);
+	if (ndd->cxl)
+		return __le32_to_cpu(nd_label->cxl.slot);
+	return __le32_to_cpu(nd_label->efi.slot);
 }
 
 static inline u64 nsl_get_checksum(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->checksum);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.checksum);
+	return __le64_to_cpu(nd_label->efi.checksum);
 }
 
 static inline u32 nsl_get_flags(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label)
 {
-	return __le32_to_cpu(nd_label->flags);
+	if (ndd->cxl)
+		return __le32_to_cpu(nd_label->cxl.flags);
+	return __le32_to_cpu(nd_label->efi.flags);
 }
 
 static inline u64 nsl_get_dpa(struct nvdimm_drvdata *ndd,
 			      struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->dpa);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.dpa);
+	return __le64_to_cpu(nd_label->efi.dpa);
 }
 
 static inline u64 nsl_get_rawsize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->rawsize);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.rawsize);
+	return __le64_to_cpu(nd_label->efi.rawsize);
 }
 
 static inline u64 nsl_get_isetcookie(struct nvdimm_drvdata *ndd,
 				     struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->isetcookie);
+	/* WARN future refactor attempts that break this assumption */
+	if (dev_WARN_ONCE(ndd->dev, ndd->cxl,
+			  "CXL labels do not use the isetcookie concept\n"))
+		return 0;
+	return __le64_to_cpu(nd_label->efi.isetcookie);
 }
 
 static inline bool nsl_validate_isetcookie(struct nvdimm_drvdata *ndd,
 					   struct nd_namespace_label *nd_label,
 					   u64 cookie)
 {
-	return cookie == __le64_to_cpu(nd_label->isetcookie);
+	/*
+	 * Let the EFI and CXL validation comingle, where fields that
+	 * don't matter to CXL always validate.
+	 */
+	if (ndd->cxl)
+		return true;
+	return cookie == __le64_to_cpu(nd_label->efi.isetcookie);
 }
 
 static inline u16 nsl_get_position(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label)
 {
-	return __le16_to_cpu(nd_label->position);
+	if (ndd->cxl)
+		return __le16_to_cpu(nd_label->cxl.position);
+	return __le16_to_cpu(nd_label->efi.position);
 }
 
 static inline u16 nsl_get_nlabel(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label)
 {
-	return __le16_to_cpu(nd_label->nlabel);
+	if (ndd->cxl)
+		return __le16_to_cpu(nd_label->cxl.nlabel);
+	return __le16_to_cpu(nd_label->efi.nlabel);
 }
 
 static inline u64 nsl_get_lbasize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->lbasize);
+	/*
+	 * Yes, for some reason the EFI labels convey a massive 64-bit
+	 * lbasize, that got fixed for CXL.
+	 */
+	if (ndd->cxl)
+		return __le16_to_cpu(nd_label->cxl.lbasize);
+	return __le64_to_cpu(nd_label->efi.lbasize);
 }
 
 static inline void nsl_set_slot(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label, u32 slot)
 {
-	nd_label->slot = __le32_to_cpu(slot);
+	if (ndd->cxl)
+		nd_label->cxl.slot = __le32_to_cpu(slot);
+	else
+		nd_label->efi.slot = __le32_to_cpu(slot);
 }
 
 static inline void nsl_set_checksum(struct nvdimm_drvdata *ndd,
 				    struct nd_namespace_label *nd_label,
 				    u64 checksum)
 {
-	nd_label->checksum = __cpu_to_le64(checksum);
+	if (ndd->cxl)
+		nd_label->cxl.checksum = __cpu_to_le64(checksum);
+	else
+		nd_label->efi.checksum = __cpu_to_le64(checksum);
 }
 
 static inline void nsl_set_flags(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label, u32 flags)
 {
-	nd_label->flags = __cpu_to_le32(flags);
+	if (ndd->cxl)
+		nd_label->cxl.flags = __cpu_to_le32(flags);
+	else
+		nd_label->efi.flags = __cpu_to_le32(flags);
 }
 
 static inline void nsl_set_dpa(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label, u64 dpa)
 {
-	nd_label->dpa = __cpu_to_le64(dpa);
+	if (ndd->cxl)
+		nd_label->cxl.dpa = __cpu_to_le64(dpa);
+	else
+		nd_label->efi.dpa = __cpu_to_le64(dpa);
 }
 
 static inline void nsl_set_rawsize(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label,
 				   u64 rawsize)
 {
-	nd_label->rawsize = __cpu_to_le64(rawsize);
+	if (ndd->cxl)
+		nd_label->cxl.rawsize = __cpu_to_le64(rawsize);
+	else
+		nd_label->efi.rawsize = __cpu_to_le64(rawsize);
 }
 
 static inline void nsl_set_isetcookie(struct nvdimm_drvdata *ndd,
 				      struct nd_namespace_label *nd_label,
 				      u64 isetcookie)
 {
-	nd_label->isetcookie = __cpu_to_le64(isetcookie);
+	if (!ndd->cxl)
+		nd_label->efi.isetcookie = __cpu_to_le64(isetcookie);
 }
 
 static inline void nsl_set_position(struct nvdimm_drvdata *ndd,
 				    struct nd_namespace_label *nd_label,
 				    u16 position)
 {
-	nd_label->position = __cpu_to_le16(position);
+	if (ndd->cxl)
+		nd_label->cxl.position = __cpu_to_le16(position);
+	else
+		nd_label->efi.position = __cpu_to_le16(position);
 }
 
 static inline void nsl_set_nlabel(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label,
 				  u16 nlabel)
 {
-	nd_label->nlabel = __cpu_to_le16(nlabel);
+	if (ndd->cxl)
+		nd_label->cxl.nlabel = __cpu_to_le16(nlabel);
+	else
+		nd_label->efi.nlabel = __cpu_to_le16(nlabel);
 }
 
 static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label,
 				   u64 lbasize)
 {
-	nd_label->lbasize = __cpu_to_le64(lbasize);
+	if (ndd->cxl)
+		nd_label->cxl.lbasize = __cpu_to_le16(lbasize);
+	else
+		nd_label->efi.lbasize = __cpu_to_le64(lbasize);
 }
 
 static inline const uuid_t *nsl_get_uuid(struct nvdimm_drvdata *ndd,
 					 struct nd_namespace_label *nd_label,
 					 uuid_t *uuid)
 {
-	uuid_copy(uuid, &nd_label->uuid);
+	if (ndd->cxl)
+		uuid_copy(uuid, &nd_label->cxl.uuid);
+	else
+		uuid_copy(uuid, &nd_label->efi.uuid);
 	return uuid;
 }
 
@@ -188,21 +253,29 @@ static inline const uuid_t *nsl_set_uuid(struct nvdimm_drvdata *ndd,
 					 struct nd_namespace_label *nd_label,
 					 const uuid_t *uuid)
 {
-	uuid_copy(&nd_label->uuid, uuid);
-	return &nd_label->uuid;
+	if (ndd->cxl) {
+		uuid_copy(&nd_label->cxl.uuid, uuid);
+		return &nd_label->cxl.uuid;
+	}
+	uuid_copy(&nd_label->efi.uuid, uuid);
+	return &nd_label->efi.uuid;
 }
 
 static inline bool nsl_validate_uuid(struct nvdimm_drvdata *ndd,
 				     struct nd_namespace_label *nd_label,
 				     const uuid_t *uuid)
 {
-	return uuid_equal(&nd_label->uuid, uuid);
+	if (ndd->cxl)
+		return uuid_equal(&nd_label->cxl.uuid, uuid);
+	return uuid_equal(&nd_label->efi.uuid, uuid);
 }
 
 static inline const uuid_t *nsl_ref_uuid(struct nvdimm_drvdata *ndd,
 					 struct nd_namespace_label *nd_label)
 {
-	return &nd_label->uuid;
+	if (ndd->cxl)
+		return &nd_label->cxl.uuid;
+	return &nd_label->efi.uuid;
 }
 
 bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
@@ -261,8 +334,8 @@ static inline struct nd_namespace_index *to_next_namespace_index(
 
 unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 
-#define namespace_label_has(ndd, field) \
-	(offsetof(struct nd_namespace_label, field) \
+#define efi_namespace_label_has(ndd, field) \
+	(!ndd->cxl && offsetof(struct nvdimm_efi_label, field) \
 		< sizeof_namespace_label(ndd))
 
 #define nd_dbg_dpa(r, d, res, fmt, arg...) \

