Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AF3298987
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753877787; cv=none; b=tjNVUP+2qAkxcf5mTvcBRY5c/bEV2a6RTbMwsw2WIeSAmDKTYJAlKHQAU+GSWq5EdqxBfW6U7BES0Y5Qt4gUc10NuofLQImXPFjm2UfzAHQS3mzgajwnEtg/JyBNozcmlSdsf5fVaVPMwW5QqBPH4KGAwpmQXCF5SfuydljlqPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753877787; c=relaxed/simple;
	bh=7ZceNhNT9pXPSfS2rFbeRmaeMJiGrrUXP1+tWesDAC4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=R2fMUHu0XPCJW7u8dt92lzPmWIONEULeYhmXurMtR2dZBxkscDvYg4Mt3bwB1+xnJCEuiRsIHqylOVT4IfYTIx1854RtN9RTL33m4wb0adb50PZAfApWaDOFrabGt8l93LDuNocpf5gckbb16N18e3Xgr3KbbWuTqJLx1WS6c2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JYifNdA5; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JYifNdA5"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250730121622epoutp04bfece5d9a01b28a82c0596e027a62478~XBozunGxg1258512585epoutp04w
	for <nvdimm@lists.linux.dev>; Wed, 30 Jul 2025 12:16:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250730121622epoutp04bfece5d9a01b28a82c0596e027a62478~XBozunGxg1258512585epoutp04w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753877782;
	bh=UPJkh+MR6+GFA27rS/b3tPgS5Byxo0eACLjOWFCLf0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYifNdA5cJIuUiDkgXwrSuUtMwsvSY1ASjzxupHpOZ7nPPn/MCI3srw0YQp4Wn7Fz
	 80uTUfKmBwLK+r8PRTuN7nsq5t82w8m1xS4YQLhsE3fu8hDO3zMsAR0wt9MC6hlCcp
	 HdqDRBwlHPg6PgyuBlJQzz7g/eWVufrs1AmJgG+g=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250730121621epcas5p31b6e5e5e17f259c2f4a6b3bb06a3c4fb~XBozXAB9g3063230632epcas5p3Q;
	Wed, 30 Jul 2025 12:16:21 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bsWQr6PlRz6B9m8; Wed, 30 Jul
	2025 12:16:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e~XBlWOgl9r2399523995epcas5p3g;
	Wed, 30 Jul 2025 12:12:24 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250730121223epsmtip15b6cad35c1f33e5a385c5fda08dcbaf9~XBlVKicbe0243702437epsmtip1j;
	Wed, 30 Jul 2025 12:12:23 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V2 02/20] nvdimm/label: Prep patch to accommodate cxl lsa
 2.1 support
Date: Wed, 30 Jul 2025 17:41:51 +0530
Message-Id: <20250730121209.303202-3-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250730121209.303202-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e
References: <20250730121209.303202-1-s.neeraj@samsung.com>
	<CGME20250730121224epcas5p3c3a6563ce186d2fdb9c3ff5f66e37f3e@epcas5p3.samsung.com>

LSA 2.1 format introduces region label, which can also reside
into LSA along with only namespace label as per v1.1 and v1.2

As both namespace and region labels are of same size of 256 bytes.
Thus renamed "struct nd_namespace_label" to "struct nd_lsa_label",
where both namespace label and region label can stay as union.

No functional change introduced.

Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/nvdimm/label.c          | 58 +++++++++++++++++++--------------
 drivers/nvdimm/label.h          | 12 ++++++-
 drivers/nvdimm/namespace_devs.c | 33 +++++++++++++------
 drivers/nvdimm/nd.h             |  2 +-
 4 files changed, 68 insertions(+), 37 deletions(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 7a011ee02d79..75bc11da4c11 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -271,7 +271,7 @@ static void nd_label_copy(struct nvdimm_drvdata *ndd,
 	memcpy(dst, src, sizeof_namespace_index(ndd));
 }
 
-static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
+static struct nd_lsa_label *nd_label_base(struct nvdimm_drvdata *ndd)
 {
 	void *base = to_namespace_index(ndd, 0);
 
@@ -279,7 +279,7 @@ static struct nd_namespace_label *nd_label_base(struct nvdimm_drvdata *ndd)
 }
 
 static int to_slot(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		struct nd_lsa_label *nd_label)
 {
 	unsigned long label, base;
 
@@ -289,14 +289,14 @@ static int to_slot(struct nvdimm_drvdata *ndd,
 	return (label - base) / sizeof_namespace_label(ndd);
 }
 
-static struct nd_namespace_label *to_label(struct nvdimm_drvdata *ndd, int slot)
+static struct nd_lsa_label *to_label(struct nvdimm_drvdata *ndd, int slot)
 {
 	unsigned long label, base;
 
 	base = (unsigned long) nd_label_base(ndd);
 	label = base + sizeof_namespace_label(ndd) * slot;
 
-	return (struct nd_namespace_label *) label;
+	return (struct nd_lsa_label *) label;
 }
 
 #define for_each_clear_bit_le(bit, addr, size) \
@@ -382,9 +382,10 @@ static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
 }
 
 static bool slot_valid(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label, u32 slot)
+		struct nd_lsa_label *lsa_label, u32 slot)
 {
 	bool valid;
+	struct nd_namespace_label *nd_label = &lsa_label->ns_label;
 
 	/* check that we are written where we expect to be written */
 	if (slot != nsl_get_slot(ndd, nd_label))
@@ -405,6 +406,7 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		return 0; /* no label, nothing to reserve */
 
 	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_lsa_label *lsa_label;
 		struct nd_namespace_label *nd_label;
 		struct nd_region *nd_region = NULL;
 		struct nd_label_id label_id;
@@ -412,9 +414,10 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
 		uuid_t label_uuid;
 		u32 flags;
 
-		nd_label = to_label(ndd, slot);
+		lsa_label = to_label(ndd, slot);
+		nd_label = &lsa_label->ns_label;
 
-		if (!slot_valid(ndd, nd_label, slot))
+		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
 		nsl_get_uuid(ndd, nd_label, &label_uuid);
@@ -565,11 +568,13 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 		return 0;
 
 	for_each_clear_bit_le(slot, free, nslot) {
+		struct nd_lsa_label *lsa_label;
 		struct nd_namespace_label *nd_label;
 
-		nd_label = to_label(ndd, slot);
+		lsa_label = to_label(ndd, slot);
+		nd_label = &lsa_label->ns_label;
 
-		if (!slot_valid(ndd, nd_label, slot)) {
+		if (!slot_valid(ndd, lsa_label, slot)) {
 			u32 label_slot = nsl_get_slot(ndd, nd_label);
 			u64 size = nsl_get_rawsize(ndd, nd_label);
 			u64 dpa = nsl_get_dpa(ndd, nd_label);
@@ -584,7 +589,7 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
 	return count;
 }
 
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
+struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 {
 	struct nd_namespace_index *nsindex;
 	unsigned long *free;
@@ -594,10 +599,10 @@ struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n)
 		return NULL;
 
 	for_each_clear_bit_le(slot, free, nslot) {
-		struct nd_namespace_label *nd_label;
+		struct nd_lsa_label *lsa_label;
 
-		nd_label = to_label(ndd, slot);
-		if (!slot_valid(ndd, nd_label, slot))
+		lsa_label = to_label(ndd, slot);
+		if (!slot_valid(ndd, lsa_label, slot))
 			continue;
 
 		if (n-- == 0)
@@ -738,7 +743,7 @@ static int nd_label_write_index(struct nvdimm_drvdata *ndd, int index, u32 seq,
 }
 
 static unsigned long nd_label_offset(struct nvdimm_drvdata *ndd,
-		struct nd_namespace_label *nd_label)
+		struct nd_lsa_label *nd_label)
 {
 	return (unsigned long) nd_label
 		- (unsigned long) to_namespace_index(ndd, 0);
@@ -892,6 +897,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	struct nd_namespace_common *ndns = &nspm->nsio.common;
 	struct nd_interleave_set *nd_set = nd_region->nd_set;
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	struct nd_lsa_label *lsa_label;
 	struct nd_namespace_label *nd_label;
 	struct nd_namespace_index *nsindex;
 	struct nd_label_ent *label_ent;
@@ -923,8 +929,10 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		return -ENXIO;
 	dev_dbg(ndd->dev, "allocated: %d\n", slot);
 
-	nd_label = to_label(ndd, slot);
-	memset(nd_label, 0, sizeof_namespace_label(ndd));
+	lsa_label = to_label(ndd, slot);
+	memset(lsa_label, 0, sizeof_namespace_label(ndd));
+
+	nd_label = &lsa_label->ns_label;
 	nsl_set_uuid(ndd, nd_label, nspm->uuid);
 	nsl_set_name(ndd, nd_label, nspm->alt_name);
 	nsl_set_flags(ndd, nd_label, flags);
@@ -942,7 +950,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	nd_dbg_dpa(nd_region, ndd, res, "\n");
 
 	/* update label */
-	offset = nd_label_offset(ndd, nd_label);
+	offset = nd_label_offset(ndd, lsa_label);
 	rc = nvdimm_set_config_data(ndd, offset, nd_label,
 			sizeof_namespace_label(ndd));
 	if (rc < 0)
@@ -954,7 +962,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
 		if (!label_ent->label)
 			continue;
 		if (test_and_clear_bit(ND_LABEL_REAP, &label_ent->flags) ||
-		    nsl_uuid_equal(ndd, label_ent->label, nspm->uuid))
+		    nsl_uuid_equal(ndd, &label_ent->label->ns_label, nspm->uuid))
 			reap_victim(nd_mapping, label_ent);
 	}
 
@@ -964,14 +972,14 @@ static int __pmem_label_update(struct nd_region *nd_region,
 	if (rc == 0) {
 		list_for_each_entry(label_ent, &nd_mapping->labels, list)
 			if (!label_ent->label) {
-				label_ent->label = nd_label;
-				nd_label = NULL;
+				label_ent->label = lsa_label;
+				lsa_label = NULL;
 				break;
 			}
-		dev_WARN_ONCE(&nspm->nsio.common.dev, nd_label,
+		dev_WARN_ONCE(&nspm->nsio.common.dev, lsa_label,
 				"failed to track label: %d\n",
-				to_slot(ndd, nd_label));
-		if (nd_label)
+				to_slot(ndd, lsa_label));
+		if (lsa_label)
 			rc = -ENXIO;
 	}
 	mutex_unlock(&nd_mapping->lock);
@@ -1042,12 +1050,12 @@ static int del_labels(struct nd_mapping *nd_mapping, uuid_t *uuid)
 
 	mutex_lock(&nd_mapping->lock);
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
+		struct nd_lsa_label *nd_label = label_ent->label;
 
 		if (!nd_label)
 			continue;
 		active++;
-		if (!nsl_uuid_equal(ndd, nd_label, uuid))
+		if (!nsl_uuid_equal(ndd, &nd_label->ns_label, uuid))
 			continue;
 		active--;
 		slot = to_slot(ndd, nd_label);
diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
index 0650fb4b9821..4883b3a1320f 100644
--- a/drivers/nvdimm/label.h
+++ b/drivers/nvdimm/label.h
@@ -183,6 +183,16 @@ struct nd_namespace_label {
 	};
 };
 
+/*
+ * LSA 2.1 format introduces region label, which can also reside
+ * into LSA along with only namespace label as per v1.1 and v1.2
+ */
+struct nd_lsa_label {
+	union {
+		struct nd_namespace_label ns_label;
+	};
+};
+
 #define NVDIMM_BTT_GUID "8aed63a2-29a2-4c66-8b12-f05d15d3922a"
 #define NVDIMM_BTT2_GUID "18633bfc-1735-4217-8ac9-17239282d3f8"
 #define NVDIMM_PFN_GUID "266400ba-fb9f-4677-bcb0-968f11d0d225"
@@ -215,7 +225,7 @@ struct nvdimm_drvdata;
 int nd_label_data_init(struct nvdimm_drvdata *ndd);
 size_t sizeof_namespace_index(struct nvdimm_drvdata *ndd);
 int nd_label_active_count(struct nvdimm_drvdata *ndd);
-struct nd_namespace_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
+struct nd_lsa_label *nd_label_active(struct nvdimm_drvdata *ndd, int n);
 u32 nd_label_alloc_slot(struct nvdimm_drvdata *ndd);
 bool nd_label_free_slot(struct nvdimm_drvdata *ndd, u32 slot);
 u32 nd_label_nfree(struct nvdimm_drvdata *ndd);
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 55cfbf1e0a95..bdf1ed6f23d8 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1009,10 +1009,11 @@ static int namespace_update_uuid(struct nd_region *nd_region,
 
 		mutex_lock(&nd_mapping->lock);
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_namespace_label *nd_label;
 			struct nd_label_id label_id;
 			uuid_t uuid;
 
+			nd_label = &label_ent->label->ns_label;
 			if (!nd_label)
 				continue;
 			nsl_get_uuid(ndd, nd_label, &uuid);
@@ -1573,11 +1574,14 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, const uuid_t *uuid,
 		bool found_uuid = false;
 
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			struct nd_namespace_label *nd_label = label_ent->label;
+			struct nd_lsa_label *lsa_label = label_ent->label;
+			struct nd_namespace_label *nd_label;
 			u16 position;
 
-			if (!nd_label)
+			if (!lsa_label)
 				continue;
+
+			nd_label = &lsa_label->ns_label;
 			position = nsl_get_position(ndd, nd_label);
 
 			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
@@ -1615,17 +1619,21 @@ static int select_pmem_id(struct nd_region *nd_region, const uuid_t *pmem_id)
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
 		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
 		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+		struct nd_lsa_label *lsa_label = NULL;
 		struct nd_namespace_label *nd_label = NULL;
 		u64 hw_start, hw_end, pmem_start, pmem_end;
 		struct nd_label_ent *label_ent;
 
 		lockdep_assert_held(&nd_mapping->lock);
 		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
-			nd_label = label_ent->label;
-			if (!nd_label)
+			lsa_label = label_ent->label;
+			if (!lsa_label)
 				continue;
+
+			nd_label = &lsa_label->ns_label;
 			if (nsl_uuid_equal(ndd, nd_label, pmem_id))
 				break;
+			lsa_label = NULL;
 			nd_label = NULL;
 		}
 
@@ -1746,19 +1754,21 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
 
 	/* Calculate total size and populate namespace properties from label0 */
 	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_lsa_label *lsa_label;
 		struct nd_namespace_label *label0;
 		struct nvdimm_drvdata *ndd;
 
 		nd_mapping = &nd_region->mapping[i];
 		label_ent = list_first_entry_or_null(&nd_mapping->labels,
 				typeof(*label_ent), list);
-		label0 = label_ent ? label_ent->label : NULL;
+		lsa_label = label_ent ? label_ent->label : NULL;
 
-		if (!label0) {
+		if (!lsa_label) {
 			WARN_ON(1);
 			continue;
 		}
 
+		label0 = &lsa_label->ns_label;
 		ndd = to_ndd(nd_mapping);
 		size += nsl_get_rawsize(ndd, label0);
 		if (nsl_get_position(ndd, label0) != 0)
@@ -1943,12 +1953,15 @@ static struct device **scan_labels(struct nd_region *nd_region)
 
 	/* "safe" because create_namespace_pmem() might list_move() label_ent */
 	list_for_each_entry_safe(label_ent, e, &nd_mapping->labels, list) {
-		struct nd_namespace_label *nd_label = label_ent->label;
+		struct nd_lsa_label *lsa_label = label_ent->label;
+		struct nd_namespace_label *nd_label;
 		struct device **__devs;
 
-		if (!nd_label)
+		if (!lsa_label)
 			continue;
 
+		nd_label = &lsa_label->ns_label;
+
 		/* skip labels that describe extents outside of the region */
 		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
 		    nsl_get_dpa(ndd, nd_label) > map_end)
@@ -2122,7 +2135,7 @@ static int init_active_labels(struct nd_region *nd_region)
 		if (!count)
 			continue;
 		for (j = 0; j < count; j++) {
-			struct nd_namespace_label *label;
+			struct nd_lsa_label *label;
 
 			label_ent = kzalloc(sizeof(*label_ent), GFP_KERNEL);
 			if (!label_ent)
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index 1cc06cc58d14..61348dee687d 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -376,7 +376,7 @@ enum nd_label_flags {
 struct nd_label_ent {
 	struct list_head list;
 	unsigned long flags;
-	struct nd_namespace_label *label;
+	struct nd_lsa_label *label;
 };
 
 enum nd_mapping_lock_class {
-- 
2.34.1

