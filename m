Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461F2319619
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115844; cv=none; b=o3ddArjG3yMOHcCUgRACKuJHCWnLiCfmjP3xp/UvC6MrcbP5XvjeXfsrIwsFd5zhUEcZ8PFsuvlCTaTSeFtHxa9c3U+Dkd9z/trw47CYhHlK+TfgSQFOPK27KAa1VjNLSzciaAmMeb1OYzAmB6Dz4GxHVha12cMK02n06tybYtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115844; c=relaxed/simple;
	bh=m+dlx95K5oRBB1Fo9JSKiyM7af1qhH+KR82XAaI2sP4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=iK4lBX3ytxdW+RdSIaEpwb02ufOB6al5kaAPnxhW+AJuyU3CsEIHGR37zVsYLBPHxGhdlIMI3YLzRiONbqRIfnLP4Eq9KirjR/H04TBzTnAtmFZsR3j3usT4s+VqrW7m+XBSMhnhnkXPlSa95j1ngo+MZ5IWmqri/cEHGPEHYaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oS9anHRY; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oS9anHRY"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917133040epoutp01f72665c8970921e2404aba2e2bca8976~mFQrIeERd2071320713epoutp01f
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917133040epoutp01f72665c8970921e2404aba2e2bca8976~mFQrIeERd2071320713epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115840;
	bh=ki1A0a36em7y8BY/guzR0gdUavTJy8xMVS6+k0q4n3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oS9anHRYwjfLSo925LQJd9LOEd6CQUO3/61M5acCT/8Trr7vnUZxEdu2SAXKNb7b9
	 f4Ep6FQdSt9EYZvfj6F9oRO6DrMawOtHXhUopypXs8WHzm9KDfzEujf3Xifjc0BXw2
	 eLVMx8SHhEeQ+LSWxiHAkhH2T2lUydrrMrequb2M=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250917133040epcas5p4daaba159edcc703e4c5c6c5264e881cf~mFQq2QIN81547815478epcas5p4E;
	Wed, 17 Sep 2025 13:30:40 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cRflz2VXJz3hhT8; Wed, 17 Sep
	2025 13:30:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250917133038epcas5p3b2766b0deb83a3496855cdd334b6ecc2~mFQpm5dXT0995409954epcas5p3C;
	Wed, 17 Sep 2025 13:30:38 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133037epsmtip112463ddd8bdd8ea62e7973e392f657d7~mFQoebX7j0522405224epsmtip1q;
	Wed, 17 Sep 2025 13:30:37 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 06/20] nvdimm/region_label: Add region label update
 support
Date: Wed, 17 Sep 2025 18:59:26 +0530
Message-Id: <20250917132940.1566437-7-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250917132940.1566437-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133038epcas5p3b2766b0deb83a3496855cdd334b6ecc2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133038epcas5p3b2766b0deb83a3496855cdd334b6ecc2
References: <20250917132940.1566437-1-s.neeraj@samsung.com>
	<CGME20250917133038epcas5p3b2766b0deb83a3496855cdd334b6ecc2@epcas5p3.samsung.com>

Modified __pmem_label_update() to update region labels into LSA

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 269 ++++++++++++++++++++++++++------
 drivers/nvdimm/label.h          |  15 ++
 drivers/nvdimm/namespace_devs.c |  12 ++
 drivers/nvdimm/nd.h             |  38 ++++-
 include/linux/libnvdimm.h       |   8 +
 5 files changed, 289 insertions(+), 53 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 182f8c9a01bf..209c73f6b7e7 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 	nsl_set_checksum(ndd, nd_label, sum);
 }
 
+static void region_label_calculate_checksum(struct nvdimm_drvdata *ndd,
+				   struct cxl_region_label *region_label)
+{
+	u64 sum;
+
+	region_label_set_checksum(region_label, 0);
+	sum = nd_fletcher64(region_label, sizeof_namespace_label(ndd), 1);
+	region_label_set_checksum(region_label, sum);
+}
+
 static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_namespace_label *nd_label, u32 slot)
 {
@@ -884,26 +894,20 @@ enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
 	return guid_to_nvdimm_cclass(&nd_label->efi.abstraction_guid);
 }
 
-static int __pmem_label_update(struct nd_region *nd_region,
-		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
-		int pos, unsigned long flags)
+static int namespace_label_update(struct nd_region *nd_region,
+				  struct nd_mapping *nd_mapping,
+				  struct nd_namespace_pmem *nspm,
+				  int pos, u64 flags,
+				  struct nd_namespace_label *ns_label,
+				  struct nd_namespace_index *nsindex,
+				  u32 slot)
 {
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
-	struct nd_namespace_label *nd_label;
-	struct nd_namespace_index *nsindex;
-	struct nd_label_ent *label_ent;
 	struct nd_label_id label_id;
 	struct resource *res;
-	unsigned long *free;
-	u32 nslot, slot;
-	size_t offset;
 	u64 cookie;
-	int rc;
-
-	if (!preamble_next(ndd, &nsindex, &free, &nslot))
-		return -ENXIO;
 
 	cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
 	nd_label_gen_id(&label_id, nspm->uuid, 0);
@@ -916,36 +920,131 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return -ENXIO;
 	}
 
+	nsl_set_type(ndd, ns_label);
+	nsl_set_uuid(ndd, ns_label, nspm->uuid);
+	nsl_set_name(ndd, ns_label, nspm->alt_name);
+	nsl_set_flags(ndd, ns_label, flags);
+	nsl_set_nlabel(ndd, ns_label, nd_region->ndr_mappings);
+	nsl_set_nrange(ndd, ns_label, 1);
+	nsl_set_position(ndd, ns_label, pos);
+	nsl_set_isetcookie(ndd, ns_label, cookie);
+	nsl_set_rawsize(ndd, ns_label, resource_size(res));
+	nsl_set_lbasize(ndd, ns_label, nspm->lbasize);
+	nsl_set_dpa(ndd, ns_label, res->start);
+	nsl_set_slot(ndd, ns_label, slot);
+	nsl_set_alignment(ndd, ns_label, 0);
+	nsl_set_type_guid(ndd, ns_label, &nd_set->type_guid);
+	nsl_set_region_uuid(ndd, ns_label, &nd_set->uuid);
+	nsl_set_claim_class(ndd, ns_label, ndns->claim_class);
+	nsl_calculate_checksum(ndd, ns_label);
+	nd_dbg_dpa(nd_region, ndd, res, "\n");
+
+	return 0;
+}
+
+static void region_label_update(struct nd_region *nd_region,
+				struct cxl_region_label *region_label,
+				struct nd_mapping *nd_mapping,
+				int pos, u64 flags, u32 slot)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+	/* Set Region Label Format identification UUID */
+	uuid_parse(CXL_REGION_UUID, (uuid_t *) region_label->type);
+
+	/* Set Current Region Label UUID */
+	export_uuid(region_label->uuid, &nd_set->uuid);
+
+	region_label->flags = __cpu_to_le32(flags);
+	region_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
+	region_label->position = __cpu_to_le16(pos);
+	region_label->dpa = __cpu_to_le64(nd_mapping->start);
+	region_label->rawsize = __cpu_to_le64(nd_mapping->size);
+	region_label->hpa = __cpu_to_le64(nd_set->res->start);
+	region_label->slot = __cpu_to_le32(slot);
+	region_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
+	region_label->align = __cpu_to_le32(0);
+
+	/* Update fletcher64 Checksum */
+	region_label_calculate_checksum(ndd, region_label);
+}
+
+static bool is_label_reapable(struct nd_interleave_set *nd_set,
+			       struct nd_namespace_pmem *nspm,
+			       struct nvdimm_drvdata *ndd,
+			       union nd_lsa_label *label,
+			       enum label_type ltype,
+			       unsigned long *flags)
+{
+	switch (ltype) {
+	case NS_LABEL_TYPE:
+		if (test_and_clear_bit(ND_LABEL_REAP, flags) ||
+		    nsl_uuid_equal(ndd, &label->ns_label, nspm->uuid))
+			return true;
+
+		break;
+	case RG_LABEL_TYPE:
+		if (region_label_uuid_equal(&label->region_label,
+		    &nd_set->uuid))
+			return true;
+
+		break;
+	}
+
+	return false;
+}
+
+static int __pmem_label_update(struct nd_region *nd_region,
+			       struct nd_mapping *nd_mapping,
+			       struct nd_namespace_pmem *nspm,
+			       int pos, unsigned long flags,
+			       enum label_type ltype)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
+	union nd_lsa_label *lsa_label;
+	unsigned long *free;
+	struct device *dev;
+	u32 nslot, slot;
+	size_t offset;
+	int rc;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
 	/* allocate and write the label to the staging (next) index */
 	slot = nd_label_alloc_slot(ndd);
 	if (slot == UINT_MAX)
 		return -ENXIO;
 	dev_dbg(ndd->dev, "allocated: %d\n", slot);
 
-	nd_label = to_label(ndd, slot);
-	memset(nd_label, 0, sizeof_namespace_label(ndd));
-	nsl_set_type(ndd, nd_label);
-	nsl_set_uuid(ndd, nd_label, nspm->uuid);
-	nsl_set_name(ndd, nd_label, nspm->alt_name);
-	nsl_set_flags(ndd, nd_label, flags);
-	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
-	nsl_set_nrange(ndd, nd_label, 1);
-	nsl_set_position(ndd, nd_label, pos);
-	nsl_set_isetcookie(ndd, nd_label, cookie);
-	nsl_set_rawsize(ndd, nd_label, resource_size(res));
-	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
-	nsl_set_dpa(ndd, nd_label, res->start);
-	nsl_set_slot(ndd, nd_label, slot);
-	nsl_set_alignment(ndd, nd_label, 0);
-	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
-	nsl_set_region_uuid(ndd, nd_label, NULL);
-	nsl_set_claim_class(ndd, nd_label, ndns->claim_class);
-	nsl_calculate_checksum(ndd, nd_label);
-	nd_dbg_dpa(nd_region, ndd, res, "\n");
+	lsa_label = (union nd_lsa_label *) to_label(ndd, slot);
+	memset(lsa_label, 0, sizeof_namespace_label(ndd));
+
+	switch (ltype) {
+	case NS_LABEL_TYPE:
+		dev = &nspm->nsio.common.dev;
+		rc = namespace_label_update(nd_region, nd_mapping,
+				nspm, pos, flags, &lsa_label->ns_label,
+				nsindex, slot);
+		if (rc)
+			return rc;
+
+		break;
+	case RG_LABEL_TYPE:
+		dev = &nd_region->dev;
+		region_label_update(nd_region, &lsa_label->region_label,
+				    nd_mapping, pos, flags, slot);
+
+		break;
+	}
 
 	/* update label */
-	offset = nd_label_offset(ndd, nd_label);
-	rc = nvdimm_set_config_data(ndd, offset, nd_label,
+	offset = nd_label_offset(ndd, &lsa_label->ns_label);
+	rc = nvdimm_set_config_data(ndd, offset, lsa_label,
 			sizeof_namespace_label(ndd));
 	if (rc < 0)
 		return rc;
@@ -955,8 +1054,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
-		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
-		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
+
+		if (is_label_reapable(nd_set, nspm, ndd,
+				      (union nd_lsa_label *) label_ent->label,
+				      ltype, &label_ent->flags))
 			reap_victim(nd_mapping, label_ent);
 	}
 
@@ -966,19 +1067,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	if (rc)
 		return rc;
 
-	list_for_each_entry(label_ent, &nd_mapping->labels, list)
-		if (!label_ent->label) {
-			label_ent->label = nd_label;
-			nd_label = NULL;
-			break;
-		}
-	dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
-			"failed to track label: %d\n",
-			to_slot(ndd, nd_label));
-	if (nd_label)
-		rc = -ENXIO;
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		if (label_ent->label)
+			continue;
 
-	return rc;
+		label_ent->label = &lsa_label->ns_label;
+		lsa_label = NULL;
+		break;
+	}
+	dev_WARN_ONCE(dev, lsa_label, "failed to track label: %d\n",
+		      to_slot(ndd, &lsa_label->ns_label));
+	if (lsa_label)
+		return -ENXIO;
+
+	return 0;
 }
 
 static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
@@ -1068,6 +1170,21 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
 }
 
+static int find_region_label_count(struct nvdimm_drvdata *ndd,
+				   struct nd_mapping *nd_mapping)
+{
+	struct nd_label_ent *label_ent;
+	int region_label_cnt = 0;
+
+	guard(mutex)(&nd_mapping->lock);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
+		if (is_region_label(ndd,
+		    (union nd_lsa_label *) label_ent->label))
+			region_label_cnt++;
+
+	return region_label_cnt;
+}
+
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size)
 {
@@ -1076,6 +1193,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		int region_label_cnt = 0;
 		struct resource *res;
 		int count = 0;
 
@@ -1091,12 +1209,19 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 				count++;
 		WARN_ON_ONCE(!count);
 
-		rc = init_labels(nd_mapping, count);
+		region_label_cnt = find_region_label_count(ndd, nd_mapping);
+		/*
+		 * init_labels() scan labels and allocate new label based
+		 * on its second parameter (num_labels). Therefore to
+		 * allocate new namespace label also include previously
+		 * added region label
+		 */
+		rc = init_labels(nd_mapping, count + region_label_cnt);
 		if (rc < 0)
 			return rc;
 
 		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i,
-				NSLABEL_FLAG_UPDATING);
+				NSLABEL_FLAG_UPDATING, NS_LABEL_TYPE);
 		if (rc)
 			return rc;
 	}
@@ -1108,7 +1233,47 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 
-		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0);
+		rc = __pmem_label_update(nd_region, nd_mapping, nspm, i, 0,
+				NS_LABEL_TYPE);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+int nd_pmem_region_label_update(struct nd_region *nd_region)
+{
+	int i, rc;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		int region_label_cnt = 0;
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			return 0;
+
+		region_label_cnt = find_region_label_count(ndd, nd_mapping);
+		rc = init_labels(nd_mapping, region_label_cnt + 1);
+		if (rc < 0)
+			return rc;
+
+		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i,
+				NSLABEL_FLAG_UPDATING, RG_LABEL_TYPE);
+		if (rc)
+			return rc;
+	}
+
+	/* Clear the UPDATING flag per UEFI 2.7 expectations */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		WARN_ON_ONCE(!ndd->cxl);
+		rc = __pmem_label_update(nd_region, nd_mapping, NULL, i, 0,
+				RG_LABEL_TYPE);
 		if (rc)
 			return rc;
 	}
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 0650fb4b9821..284e2a763b49 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -30,6 +30,11 @@ enum {
 	ND_NSINDEX_INIT = 0x1,
 };
 
+enum label_type {
+	RG_LABEL_TYPE,
+	NS_LABEL_TYPE,
+};
+
 /**
  * struct nd_namespace_index - label set superblock
  * @sig: NAMESPACE_INDEX\0
@@ -183,6 +188,15 @@ struct nd_namespace_label {
 	};
 };
 
+/*
+ * LSA 2.1 format introduces region label, which can also reside
+ * into LSA along with only namespace label as per v1.1 and v1.2
+ */
+union nd_lsa_label {
+	struct nd_namespace_label ns_label;
+	struct cxl_region_label region_label;
+};
+
 #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
 #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
@@ -223,4 +237,5 @@ struct nd_region;
 struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
+int nd_pmem_region_label_update(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 3271b1c8569a..559f822ef24f 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -232,6 +232,18 @@ static ssize_t __alt_name_store(struct device *dev, const char *buf,
 	return rc;
 }
 
+int nd_region_label_update(struct nd_region *nd_region)
+{
+	int rc;
+
+	nvdimm_bus_lock(&nd_region->dev);
+	rc = nd_pmem_region_label_update(nd_region);
+	nvdimm_bus_unlock(&nd_region->dev);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(nd_region_label_update);
+
 static int nd_namespace_label_update(struct nd_region *nd_region,
 		struct device *dev)
 {
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index e362611d82cc..f04c042dcfa9 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -318,6 +318,39 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
 		export_uuid(ns_label->cxl.region_uuid, uuid);
 }
 
+static inline bool is_region_label(struct nvdimm_drvdata *ndd,
+				   union nd_lsa_label *nd_label)
+{
+	uuid_t region_type, *ns_type;
+
+	if (!ndd->cxl || !nd_label)
+		return false;
+
+	uuid_parse(CXL_REGION_UUID, &region_type);
+	ns_type = (uuid_t *) nd_label->ns_label.cxl.type;
+	return uuid_equal(&region_type, ns_type);
+}
+
+static inline bool
+region_label_uuid_equal(struct cxl_region_label *region_label,
+			const uuid_t *uuid)
+{
+	return uuid_equal((uuid_t *) region_label->uuid, uuid);
+}
+
+static inline u64
+region_label_get_checksum(struct cxl_region_label *region_label)
+{
+	return __le64_to_cpu(region_label->checksum);
+}
+
+static inline void
+region_label_set_checksum(struct cxl_region_label *region_label,
+			  u64 checksum)
+{
+	region_label->checksum = __cpu_to_le64(checksum);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
@@ -399,7 +432,10 @@ enum nd_label_flags {
 struct nd_label_ent {
 	struct list_head list;
 	unsigned long flags;
-	struct nd_namespace_label *label;
+	union {
+		struct nd_namespace_label *label;
+		struct cxl_region_label *region_label;
+	};
 };
 
 enum nd_mapping_lock_class {
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 5696715c33bb..2c213b9dac66 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -117,6 +117,13 @@ struct nd_interleave_set {
 	u64 altcookie;
 
 	guid_t type_guid;
+
+	/* v2.1 region label info */
+	uuid_t uuid;
+	int interleave_ways;
+	int interleave_granularity;
+	struct resource *res;
+	int nr_targets;
 };
 
 struct nd_mapping_desc {
@@ -307,6 +314,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
+int nd_region_label_update(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

