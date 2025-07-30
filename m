Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EAB299AA1
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877799; cv=none; b=ffAB19K2KP9jKWMpOpJb+2WtPs6L/0lfVjKKtzb3ZtQ+gcJwAFeLilNN3N+W4Ujd0uc38ATYqPkxjr+bpfNVs0RuqjgZMpotD4Ia1X5KPHbktmiEAK6VCZNwC8ousontDPOGCirDpLrHPef3AaUqM7FMUDIiPZ7IByJbSHG9RWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877799; c=relaxed/simple;
	bh=9chT/ZxNFIiOpneX1j/QmDo7spLBN2rNWAegILwLWyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=jhldwmGqVX3UcI/UN+hk3z1pOo9sCgE9uuX7yk4Kj20vyANU362uxkfmdkQprB3lo+xVG3cHBw5ZGi1zr/LBTDqDA5czb16VghXBJxV4Q9cviKjc18O+KuHKSxaipyMlEX8ZKWfMb/vlUa066RARerQQb8x6hqSJN8r1vsDNB7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=CovEVWkl; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CovEVWkl"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250730121635epoutp044ca33e74d53bd05bb1ee952529363b41~XBpAaXuJi1257912579epoutp04Q
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250730121635epoutp044ca33e74d53bd05bb1ee952529363b41~XBpAaXuJi1257912579epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877795;
	bh=3idzDzILEzwn8rTkAE53LSsmCgEzoTZmwgMKQ3ZYsXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CovEVWkl1UC2Hxt4E5MeOqB4/Amw5eAa8QjWQoM4+VMz4gMUHKt2lgzZkMvEO46MI
	 4GjXFIAoD8yq8P4PCfTrQ/c4zyWdVYTjhZfGd2IeYRfoQ7lmBh9YPsEQ9ZZaWv+tPe
	 JfSLKE/skKKZ2Uk69Jt6r5k+VEQFlAWOYZufAdFA=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250730121635epcas5p2b92a73ef5795460331248e6b73fe1fc0~XBo-40v5P2832328323epcas5p2I;
	Wed, 30 Jul 2025 12:16:35 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bsWR62lNGz2SSKh; Wed, 30 Jul
	2025 12:16:34 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d~XBlaHC_4n2430924309epcas5p4S;
	Wed, 30 Jul 2025 12:12:28 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121227epsmtip1733b1f82b704618305e1a65fee684a46~XBlZCUxZ90289802898epsmtip1T;
	Wed, 30 Jul 2025 12:12:27 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 05/20] nvdimm/region_label: Add region label updation
 routine
Date: Wed, 30 Jul 2025 17:41:54 +0530
Message-Id: <20250730121209.303202-6-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121228epcas5p411e5cc6d29fb9417178dbd07a1d8f02d@epcas5p4.samsung.com>

Added __pmem_region_label_update region label update routine to update
region label.

Also used guard(mutex)(&nd_mapping->lock) in place of mutex_lock() and
mutex_unlock()

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 171 +++++++++++++++++++++++++++++---
 drivers/nvdimm/label.h          |   2 +
 drivers/nvdimm/namespace_devs.c |  12 +++
 drivers/nvdimm/nd.h             |  20 ++++
 include/linux/libnvdimm.h       |   8 ++
 5 files changed, 198 insertions(+), 15 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 3f8a6bdb77c7..94f2d0ba7aca 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -381,6 +381,16 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 	nsl_set_checksum(ndd, nd_label, sum);
 }
 
+static void rgl_calculate_checksum(struct nvdimm_drvdata *ndd,
+				   struct cxl_region_label *rg_label)
+{
+	u64 sum;
+
+	rgl_set_checksum(rg_label, 0);
+	sum = nd_fletcher64(rg_label, sizeof_namespace_label(ndd), 1);
+	rgl_set_checksum(rg_label, sum);
+}
+
 static bool slot_valid(struct nvdimm_drvdata *ndd,
 		struct nd_lsa_label *lsa_label, u32 slot)
 {
@@ -960,7 +970,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return rc;
 
 	/* Garbage collect the previous label */
-	mutex_lock(&nd_mapping->lock);
+	guard(mutex)(&nd_mapping->lock);
 	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
 		if (!label_ent->label)
 			continue;
@@ -972,20 +982,20 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	/* update index */
 	rc = nd_label_write_index(ndd, ndd->ns_next,
 			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
-	if (rc == 0) {
-		list_for_each_entry(label_ent, &nd_mapping->labels, list)
-			if (!label_ent->label) {
-				label_ent->label = lsa_label;
-				lsa_label = NULL;
-				break;
-			}
-		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
-				"failed to track label: %d\n",
-				to_slot(ndd, lsa_label));
-		if (lsa_label)
-			rc = -ENXIO;
-	}
-	mutex_unlock(&nd_mapping->lock);
+	if (rc)
+		return rc;
+
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
+		if (!label_ent->label) {
+			label_ent->label = lsa_label;
+			lsa_label = NULL;
+			break;
+		}
+	dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
+			"failed to track label: %d\n",
+			to_slot(ndd, lsa_label));
+	if (lsa_label)
+		rc = -ENXIO;
 
 	return rc;
 }
@@ -1127,6 +1137,137 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 	return 0;
 }
 
+static int __pmem_region_label_update(struct nd_region *nd_region,
+		struct nd_mapping *nd_mapping, int pos, unsigned long flags)
+{
+	struct nd_interleave_set *nd_set = nd_region->nd_set;
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_lsa_label *nd_label;
+	struct cxl_region_label *rg_label;
+	struct nd_namespace_index *nsindex;
+	struct nd_label_ent *label_ent;
+	unsigned long *free;
+	u32 nslot, slot;
+	size_t offset;
+	int rc;
+	uuid_t tmp;
+
+	if (!preamble_next(ndd, &nsindex, &free, &nslot))
+		return -ENXIO;
+
+	/* allocate and write the label to the staging (next) index */
+	slot = nd_label_alloc_slot(ndd);
+	if (slot == UINT_MAX)
+		return -ENXIO;
+	dev_dbg(ndd->dev, "allocated: %d\n", slot);
+
+	nd_label = to_label(ndd, slot);
+
+	memset(nd_label, 0, sizeof_namespace_label(ndd));
+	rg_label = &nd_label->rg_label;
+
+	/* Set Region Label Format identification UUID */
+	uuid_parse(CXL_REGION_UUID, &tmp);
+	export_uuid(nd_label->rg_label.type, &tmp);
+
+	/* Set Current Region Label UUID */
+	export_uuid(nd_label->rg_label.uuid, &nd_set->uuid);
+
+	rg_label->flags = __cpu_to_le32(flags);
+	rg_label->nlabel = __cpu_to_le16(nd_region->ndr_mappings);
+	rg_label->position = __cpu_to_le16(pos);
+	rg_label->dpa = __cpu_to_le64(nd_mapping->start);
+	rg_label->rawsize = __cpu_to_le64(nd_mapping->size);
+	rg_label->hpa = __cpu_to_le64(nd_set->res->start);
+	rg_label->slot = __cpu_to_le32(slot);
+	rg_label->ig = __cpu_to_le32(nd_set->interleave_granularity);
+	rg_label->align = __cpu_to_le16(0);
+
+	/* Update fletcher64 Checksum */
+	rgl_calculate_checksum(ndd, rg_label);
+
+	/* update label */
+	offset = nd_label_offset(ndd, nd_label);
+	rc = nvdimm_set_config_data(ndd, offset, nd_label,
+			sizeof_namespace_label(ndd));
+	if (rc < 0) {
+		nd_label_free_slot(ndd, slot);
+		return rc;
+	}
+
+	/* Garbage collect the previous label */
+	guard(mutex)(&nd_mapping->lock);
+	list_for_each_entry(label_ent, &nd_mapping->labels, list) {
+		if (!label_ent->label)
+			continue;
+		if (rgl_uuid_equal(&label_ent->label->rg_label, &nd_set->uuid))
+			reap_victim(nd_mapping, label_ent);
+	}
+
+	/* update index */
+	rc = nd_label_write_index(ndd, ndd->ns_next,
+			nd_inc_seq(__le32_to_cpu(nsindex->seq)), 0);
+	if (rc)
+		return rc;
+
+	list_for_each_entry(label_ent, &nd_mapping->labels, list)
+		if (!label_ent->label) {
+			label_ent->label = nd_label;
+			nd_label = NULL;
+			break;
+		}
+	dev_WARN_ONCE(&nd_region->dev, nd_label,
+			"failed to track label: %d\n",
+			to_slot(ndd, nd_label));
+	if (nd_label)
+		rc = -ENXIO;
+
+	return rc;
+}
+
+int nd_pmem_region_label_update(struct nd_region *nd_region)
+{
+	int i, rc;
+
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			continue;
+
+		/* Init labels to include region label */
+		rc = init_labels(nd_mapping, 1);
+
+		if (rc < 0)
+			return rc;
+
+		rc = __pmem_region_label_update(nd_region, nd_mapping, i,
+					NSLABEL_FLAG_UPDATING);
+
+		if (rc)
+			return rc;
+	}
+
+	/* Clear the UPDATING flag per UEFI 2.7 expectations */
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* No need to update region label for non cxl format */
+		if (!ndd->cxl)
+			continue;
+
+		rc = __pmem_region_label_update(nd_region, nd_mapping, i, 0);
+
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
 int __init nd_label_init(void)
 {
 	WARN_ON(guid_parse(NVDIMM_BTT_GUID, &nvdimm_btt_guid));
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 4883b3a1320f..0f428695017d 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -190,6 +190,7 @@ struct nd_namespace_label {
 struct nd_lsa_label {
 	union {
 		struct nd_namespace_label ns_label;
+		struct cxl_region_label rg_label;
 	};
 };
 
@@ -233,4 +234,5 @@ struct nd_region;
 struct nd_namespace_pmem;
 int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		struct nd_namespace_pmem *nspm, resource_size_t size);
+int nd_pmem_region_label_update(struct nd_region *nd_region);
 #endif /* __LABEL_H__ */
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 5b73119dc8fd..02ae8162566c 100644
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
index 651847f1bbf9..15d94e3937f0 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -322,6 +322,26 @@ static inline void nsl_set_region_uuid(struct nvdimm_drvdata *ndd,
 		export_uuid(ns_label->cxl.region_uuid, uuid);
 }
 
+static inline bool rgl_uuid_equal(struct cxl_region_label *rg_label,
+				  const uuid_t *uuid)
+{
+	uuid_t tmp;
+
+	import_uuid(&tmp, rg_label->uuid);
+	return uuid_equal(&tmp, uuid);
+}
+
+static inline u64 rgl_get_checksum(struct cxl_region_label *rg_label)
+{
+	return __le64_to_cpu(rg_label->checksum);
+}
+
+static inline void rgl_set_checksum(struct cxl_region_label *rg_label,
+				    u64 checksum)
+{
+	rg_label->checksum = __cpu_to_le64(checksum);
+}
+
 bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
 			    struct nd_namespace_label *nd_label, guid_t *guid);
 enum nvdimm_claim_class nsl_get_claim_class(struct nvdimm_drvdata *ndd,
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 0a55900842c8..b06bd45373f4 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -115,6 +115,13 @@ struct nd_interleave_set {
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
@@ -302,6 +309,7 @@ int nvdimm_has_flush(struct nd_region *nd_region);
 int nvdimm_has_cache(struct nd_region *nd_region);
 int nvdimm_in_overwrite(struct nvdimm *nvdimm);
 bool is_nvdimm_sync(struct nd_region *nd_region);
+int nd_region_label_update(struct nd_region *nd_region);
 
 static inline int nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd, void *buf,
 		unsigned int buf_len, int *cmd_rc)
-- 
2.34.1

