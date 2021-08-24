Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845383FCC
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 16:08:54 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="215501970"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="215501970"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:42 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="685419952"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:06:41 -0700
Subject: [PATCH v3 14/28] libnvdimm/labels: Introduce CXL labels
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, vishal.l.verma@intel.com,
 alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Jonathan.Cameron@huawei.com, ira.weiny@intel.com, ben.widawsky@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com
Date: Tue, 24 Aug 2021 09:06:41 -0700
Message-ID: <162982120115.1124374.30709335221651520.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Now that all of use sites of label data have been converted to nsl_*
helpers, introduce the CXL label format. The ->cxl flag in
nvdimm_drvdata indicates the label format the device expects. A
follow-on patch allows a bus provider to select the label style.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/label.c |   54 +++++++++++++------
 drivers/nvdimm/label.h |  108 ++++++++++++++++++++++++++------------
 drivers/nvdimm/nd.h    |  135 +++++++++++++++++++++++++++++++++++++-----------
 3 files changed, 216 insertions(+), 81 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7abeb1233404..5ec9a4023df9 100644
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
@@ -842,19 +844,34 @@ static void nsl_set_claim_class(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label,
 				enum nvdimm_claim_class claim_class)
 {
-	if (!namespace_label_has(ndd, abstraction_guid))
+	if (ndd->cxl) {
+		uuid_t uuid;
+
+		import_uuid(&uuid, nd_label->cxl.abstraction_uuid);
+		export_uuid(nd_label->cxl.abstraction_uuid,
+			    to_abstraction_uuid(claim_class, &uuid));
+		return;
+	}
+
+	if (!efi_namespace_label_has(ndd, abstraction_guid))
 		return;
-	guid_copy(&nd_label->abstraction_guid,
+	guid_copy(&nd_label->efi.abstraction_guid,
 		  to_abstraction_guid(claim_class,
-				      &nd_label->abstraction_guid));
+				      &nd_label->efi.abstraction_guid));
 }
 
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
 					    struct nd_namespace_label *nd_label)
 {
-	if (!namespace_label_has(ndd, abstraction_guid))
+	if (ndd->cxl) {
+		uuid_t uuid;
+
+		import_uuid(&uuid, nd_label->cxl.abstraction_uuid);
+		return uuid_to_nvdimm_cclass(&uuid);
+	}
+	if (!efi_namespace_label_has(ndd, abstraction_guid))
 		return NVDIMM_CCLASS_NONE;
-	return guid_to_nvdimm_cclass(&nd_label->abstraction_guid);
+	return guid_to_nvdimm_cclass(&nd_label->efi.abstraction_guid);
 }
 
 static int __pmem_label_update(struct nd_region *nd_region,
@@ -987,7 +1004,7 @@ static void nsl_set_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label,
 				   u64 isetcookie)
 {
-	if (namespace_label_has(ndd, type_guid)) {
+	if (efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_isetcookie(ndd, nd_label, isetcookie);
 		return;
 	}
@@ -998,7 +1015,7 @@ bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 u64 isetcookie)
 {
-	if (!namespace_label_has(ndd, type_guid))
+	if (!efi_namespace_label_has(ndd, type_guid))
 		return true;
 
 	if (nsl_get_isetcookie(ndd, nd_label) != isetcookie) {
@@ -1014,7 +1031,7 @@ static void nsl_set_blk_nlabel(struct nvdimm_drvdata *ndd,
 			       struct nd_namespace_label *nd_label, int nlabel,
 			       bool first)
 {
-	if (!namespace_label_has(ndd, type_guid)) {
+	if (!efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_nlabel(ndd, nd_label, 0); /* N/A */
 		return;
 	}
@@ -1025,7 +1042,7 @@ static void nsl_set_blk_position(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label,
 				 bool first)
 {
-	if (!namespace_label_has(ndd, type_guid)) {
+	if (!efi_namespace_label_has(ndd, type_guid)) {
 		nsl_set_position(ndd, nd_label, 0);
 		return;
 	}
@@ -1440,5 +1457,8 @@ int __init nd_label_init(void)
 	WARN_ON(uuid_parse(NVDIMM_PFN_GUID, &nvdimm_pfn_uuid));
 	WARN_ON(uuid_parse(NVDIMM_DAX_GUID, &nvdimm_dax_uuid));
 
+	WARN_ON(uuid_parse(CXL_REGION_UUID, &cxl_region_uuid));
+	WARN_ON(uuid_parse(CXL_NAMESPACE_UUID, &cxl_namespace_uuid));
+
 	return 0;
 }
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 76ecd0347dc2..0ef2e20fce57 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -95,41 +95,78 @@ struct cxl_region_label {
 	__le64 checksum;
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
-	u8 uuid[NSLABEL_UUID_LEN];
-	u8 name[NSLABEL_NAME_LEN];
-	__le32 flags;
-	__le16 nlabel;
-	__le16 position;
-	__le64 isetcookie;
-	__le64 lbasize;
-	__le64 dpa;
-	__le64 rawsize;
-	__le32 slot;
-	/*
-	 * Accessing fields past this point should be gated by a
-	 * namespace_label_has() check.
-	 */
-	u8 align;
-	u8 reserved[3];
-	guid_t type_guid;
-	guid_t abstraction_guid;
-	u8 reserved2[88];
-	__le64 checksum;
+	union {
+		/**
+		 * struct nvdimm_cxl_label - CXL 2.0 Table 212
+		 * @type: uuid identifying this label format (namespace)
+		 * @uuid: uuid for the namespace this label describes
+		 * @name: friendly name for the namespace
+		 * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
+		 * @nrange: discontiguous namespace support
+		 * @position: this label's position in the set
+		 * @dpa: start address in device-local capacity for this label
+		 * @rawsize: size of this label's contribution to namespace
+		 * @slot: slot id of this label in label area
+		 * @align: alignment in SZ_256M blocks
+		 * @region_uuid: host interleave set identifier
+		 * @abstraction_uuid: personality driver for this namespace
+		 * @lbasize: address geometry for disk-like personalities
+		 * @checksum: fletcher64 sum of this label
+		 */
+		struct nvdimm_cxl_label {
+			u8 type[NSLABEL_UUID_LEN];
+			u8 uuid[NSLABEL_UUID_LEN];
+			u8 name[NSLABEL_NAME_LEN];
+			__le32 flags;
+			__le16 nrange;
+			__le16 position;
+			__le64 dpa;
+			__le64 rawsize;
+			__le32 slot;
+			__le32 align;
+			u8 region_uuid[16];
+			u8 abstraction_uuid[16];
+			__le16 lbasize;
+			u8 reserved[0x56];
+			__le64 checksum;
+		} cxl;
+		/**
+		 * struct nvdimm_efi_label - namespace superblock
+		 * @uuid: UUID per RFC 4122
+		 * @name: optional name (NULL-terminated)
+		 * @flags: see NSLABEL_FLAG_*
+		 * @nlabel: interleave set width
+		 * @position: this label's position in the set
+		 * @isetcookie: interleave set cookie
+		 * @lbasize: address geometry for disk-like personalities
+		 * @dpa: start address in device-local capacity for this label
+		 * @rawsize: size of namespace
+		 * @slot: slot id of this label in label area
+		 */
+		struct nvdimm_efi_label {
+			u8 uuid[NSLABEL_UUID_LEN];
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
 };
 
 #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
@@ -137,6 +174,9 @@ struct nd_namespace_label {
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
 #define NVDIMM_DAX_GUID "97a86d9c-3cdd-4eda-986f-5068b4f80088"
 
+#define CXL_REGION_UUID "529d7c61-da07-47c4-a93f-ecdf2c06f444"
+#define CXL_NAMESPACE_UUID "68bb2c0a-5a77-4937-9f85-3caf41a0f93c"
+
 /**
  * struct nd_label_id - identifier string for dpa allocation
  * @id: "{blk|pmem}-<namespace uuid>"
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index d57f95a48fe1..6f8ce114032d 100644
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
@@ -52,122 +57,168 @@ static inline u8 *nsl_set_name(struct nvdimm_drvdata *ndd,
 {
 	if (!name)
 		return NULL;
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
 
 static inline void nsl_set_slot(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label, u32 slot)
 {
-	nd_label->slot = __cpu_to_le32(slot);
+	if (ndd->cxl)
+		nd_label->cxl.slot = __cpu_to_le32(slot);
+	else
+		nd_label->efi.slot = __cpu_to_le32(slot);
 }
 
 static inline u64 nsl_get_checksum(struct nvdimm_drvdata *ndd,
 				   struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->checksum);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.checksum);
+	return __le64_to_cpu(nd_label->efi.checksum);
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
 
 static inline u32 nsl_get_flags(struct nvdimm_drvdata *ndd,
 				struct nd_namespace_label *nd_label)
 {
-	return __le32_to_cpu(nd_label->flags);
+	if (ndd->cxl)
+		return __le32_to_cpu(nd_label->cxl.flags);
+	return __le32_to_cpu(nd_label->efi.flags);
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
 
 static inline u64 nsl_get_dpa(struct nvdimm_drvdata *ndd,
 			      struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->dpa);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.dpa);
+	return __le64_to_cpu(nd_label->efi.dpa);
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
 
 static inline u64 nsl_get_rawsize(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label)
 {
-	return __le64_to_cpu(nd_label->rawsize);
+	if (ndd->cxl)
+		return __le64_to_cpu(nd_label->cxl.rawsize);
+	return __le64_to_cpu(nd_label->efi.rawsize);
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
 
 static inline void nsl_set_isetcookie(struct nvdimm_drvdata *ndd,
 				      struct nd_namespace_label *nd_label,
 				      u64 isetcookie)
 {
-	nd_label->isetcookie = __cpu_to_le64(isetcookie);
+	if (!ndd->cxl)
+		nd_label->efi.isetcookie = __cpu_to_le64(isetcookie);
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
 
-
 static inline u16 nsl_get_nlabel(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label)
 {
-	return __le16_to_cpu(nd_label->nlabel);
+	if (ndd->cxl)
+		return 0;
+	return __le16_to_cpu(nd_label->efi.nlabel);
 }
 
 static inline void nsl_set_nlabel(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label,
 				  u16 nlabel)
 {
-	nd_label->nlabel = __cpu_to_le16(nlabel);
+	if (!ndd->cxl)
+		nd_label->efi.nlabel = __cpu_to_le16(nlabel);
 }
 
 static inline u16 nsl_get_nrange(struct nvdimm_drvdata *ndd,
 				 struct nd_namespace_label *nd_label)
 {
-	/* EFI labels do not have an nrange field */
+	if (ndd->cxl)
+		return __le16_to_cpu(nd_label->cxl.nrange);
 	return 1;
 }
 
@@ -175,26 +226,40 @@ static inline void nsl_set_nrange(struct nvdimm_drvdata *ndd,
 				  struct nd_namespace_label *nd_label,
 				  u16 nrange)
 {
+	if (ndd->cxl)
+		nd_label->cxl.nrange = __cpu_to_le16(nrange);
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
-	import_uuid(uuid, nd_label->uuid);
+	if (ndd->cxl)
+		import_uuid(uuid, nd_label->cxl.uuid);
+	else
+		import_uuid(uuid, nd_label->efi.uuid);
 	return uuid;
 }
 
@@ -202,7 +267,10 @@ static inline const uuid_t *nsl_set_uuid(struct nvdimm_drvdata *ndd,
 					 struct nd_namespace_label *nd_label,
 					 const uuid_t *uuid)
 {
-	export_uuid(nd_label->uuid, uuid);
+	if (ndd->cxl)
+		export_uuid(nd_label->cxl.uuid, uuid);
+	else
+		export_uuid(nd_label->efi.uuid, uuid);
 	return uuid;
 }
 
@@ -212,14 +280,19 @@ static inline bool nsl_uuid_equal(struct nvdimm_drvdata *ndd,
 {
 	uuid_t tmp;
 
-	import_uuid(&tmp, nd_label->uuid);
+	if (ndd->cxl)
+		import_uuid(&tmp, nd_label->cxl.uuid);
+	else
+		import_uuid(&tmp, nd_label->efi.uuid);
 	return uuid_equal(&tmp, uuid);
 }
 
 static inline const u8 *nsl_uuid_raw(struct nvdimm_drvdata *ndd,
 				     struct nd_namespace_label *nd_label)
 {
-	return nd_label->uuid;
+	if (ndd->cxl)
+		return nd_label->cxl.uuid;
+	return nd_label->efi.uuid;
 }
 
 bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
@@ -278,8 +351,8 @@ static inline struct nd_namespace_index *to_next_namespace_index(
 
 unsigned sizeof_namespace_label(struct nvdimm_drvdata *ndd);
 
-#define namespace_label_has(ndd, field) \
-	(offsetof(struct nd_namespace_label, field) \
+#define efi_namespace_label_has(ndd, field) \
+	(!ndd->cxl && offsetof(struct nvdimm_efi_label, field) \
 		< sizeof_namespace_label(ndd))
 
 #define nd_dbg_dpa(r, d, res, fmt, arg...) \
@@ -359,6 +432,8 @@ static inline bool nsl_validate_nlabel(struct nd_region *nd_region,
 				       struct nvdimm_drvdata *ndd,
 				       struct nd_namespace_label *nd_label)
 {
+	if (ndd->cxl)
+		return true;
 	return nsl_get_nlabel(ndd, nd_label) == nd_region->ndr_mappings;
 }
 

